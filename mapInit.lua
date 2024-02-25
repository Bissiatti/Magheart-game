mapInit = {}
local sti = require("libs.sti")

Doors = {}

function Doors:new(img,x,y,w,h,next)
    local door = {}
    door.img = img
    door.x = x
    door.y = y
    door.width = w
    door.height = h
    door.next = next
    table.insert(Doors,door)
end

function Doors:draw()
    for door in ipairs(self) do
        local x = math.mean(self[door].x,self[door].x+self[door].width)
        local y = math.mean(self[door].y,self[door].y+self[door].height)
        local img_w = self[door].img:getWidth()
        local img_h = self[door].img:getHeight()
        love.graphics.draw(self[door].img,x,y,0,1,1,img_w/2,img_h/2)
    end
end

function Doors:update()
    if #Doors > 0 then
        for door in ipairs(Doors) do
            if mapInit.resetMap then
                return
            end
            if #Magnet.objects == 0 then
                return
            end
            if #Bot.objects == 0 then
                return
            end

            local x = math.mean(Doors[door].x,Doors[door].x+Doors[door].width)
            local y = math.mean(Doors[door].y,Doors[door].y+Doors[door].height)
            for i,obj in ipairs(Bot.objects) do
                if not (obj.x > Doors[door].x and obj.x < Doors[door].x+Doors[door].width and obj.y > Doors[door].y and obj.y < Doors[door].y+Doors[door].height) then
                    return
                end
            end
            local path = 'maps/tiled_maps/'..Doors[door].next..'.lua'
            if Doors[door].next == 'final' then
                gameState = 'final'
                finalDiag()
                return
            end
            mapInit:load(World,path)
            Magnet.objects = {}
            Bot.objects = {}
            for i,obj in ipairs(CollidersList) do
                obj:destroy()
            end
            for i,obj in ipairs(Doors) do
                table.remove(Doors,i)
            end
            CollidersList = {}
        end
    end
    
end

function mapInit:restart()
    Magnet.objects = {}
    Bot.objects = {}
    for i,obj in ipairs(CollidersList) do
        obj:destroy()
    end
    CollidersList = {}
    mapInit.resetMap = true
end

function mapInit:load(World,path)
    local path = path or 'maps/tiled_maps/map4.lua'
    mapInit.resetMap = false
    mapInit.timer = 1
    mapInit.path = path
    mapInit.map = sti(path)
    mapInit.cam = false
    mapInit.mapLimit = {x = mapInit.map.width*mapInit.map.tilewidth, y = mapInit.map.height*mapInit.map.tileheight}
    if mapInit.map.layers['cam'] then
        for i, obj in pairs(mapInit.map.layers['cam'].objects) do
            if obj.name == 'true' then
                mapInit.cam = true
                break
            end
        end
    end
    if mapInit.map.layers['block'] then
        for i, obj in pairs(mapInit.map.layers['block'].objects) do
            local floor = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height, {collision_class = "Platform"})
            floor:setType('static')
            table.insert(CollidersList,floor)
        end
    end 
    if mapInit.map.layers['mag'] then
        for i, obj in pairs(mapInit.map.layers['mag'].objects) do
            if obj.name == '1' then
                Magnet:new(obj.x, obj.y, obj.width, obj.height, World, 1,1,1)
            end
            if obj.name == '2' then
                Magnet:new(obj.x, obj.y, obj.width, obj.height, World, 2,1,-1)
            end
        end
    end

    if mapInit.map.layers['bot'] then
        for i, obj in pairs(mapInit.map.layers['bot'].objects) do
            if obj.name == 'she' then
                Bot:new(obj.x, obj.y, 16, 24, World, 'imgs/boneca_corda.png',-1)
            end
            if obj.name == 'he' then
                Bot:new(obj.x, obj.y, 16, 24, World, 'imgs/boneco_corda.png',1)
            end
        end
    end
    if mapInit.map.layers['door'] then
        for i, obj in pairs(mapInit.map.layers['door'].objects) do
            local name
            if obj.name == '' then
                name = 'map1'
            else
                name = obj.name
            end
            local img = love.graphics.newImage('imgs/door.png')
            Doors:new(img,obj.x,obj.y,obj.width,obj.height,name)
        end
    end

    if mapInit.map.layers['f'] then
        for i, obj in pairs(mapInit.map.layers['f'].objects) do
            local f = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            f:setType('kinematic')
            f:setCollisionClass('F')
            table.insert(CollidersList,f)
            f:setPreSolve(function(c1,c2,contact)
                if c2.collision_class == 'Bot' then
                    mapInit:restart()
                end
            end)
        end
    end

end


function mapInit:update(dt)
    mapInit.map:update(dt)
    if mapInit.resetMap then
        mapInit.timer = mapInit.timer - dt
        if mapInit.timer <= 0 then
            mapInit:load(World,mapInit.path)
        end
    end
    if love.keyboard.isDown('backspace') then
        mapInit:restart()
    end
end

function mapInit:drawDown()
    if mapInit.resetMap then
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle('fill',0,0,W,H)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print('Restarting...',W/2,H/2)
    else
        love.graphics.setColor(1,1,1,1)
        mapInit.map:drawLayer(mapInit.map.layers['Camada de Blocos 1'])
        if mapInit.map.layers['Camada de Blocos 2'] then
            mapInit.map:drawLayer(mapInit.map.layers['Camada de Blocos 2'])
        end
    end
end

-- function mapInit:drawnUp()
--     mapInit.map:drawLayer(mapInit.map.layers['tree'])
-- end