Magnet = {objects = {}}
local cos45 = math.cos(math.rad(45))

function Magnet:new(x,y,width,height,world,type,dir,sinal)
    dir = dir or 1
    sinal = sinal or 1
    local o = {}
    o.x = x
    o.y = y
    if sinal == -1 then
        o.img = love.graphics.newImage('imgs/mag1.png')
    else
        o.img = love.graphics.newImage('imgs/mag2.png')
    end
    -- create animation for effect of magnet
    o.spriteSheet = love.graphics.newImage('imgs/effect.png')
    o.g = anim8.newGrid(100, 100, o.spriteSheet:getWidth(), o.spriteSheet:getHeight())
    o.animation = anim8.newAnimation(o.g('1-4',1), 0.06)
        
    o.spriteSheet_inv = love.graphics.newImage('imgs/effect_inv.png')
    o.g_inv = anim8.newGrid(100, 100, o.spriteSheet_inv:getWidth(), o.spriteSheet_inv:getHeight())
    o.animation_inv = anim8.newAnimation(o.g_inv('1-4',1), 0.06)
    o.isAnimation = false
    o.width = width
    o.height = height
    o.world = world
    o.type = type
    o.collider = o.world:newRectangleCollider(o.x,o.y,o.width,o.height)
    o.collider:setType('Dynamic')
    o.collider:setCollisionClass('Magnet')
    table.insert(CollidersList,o.collider)
    o.speed = 175
    o.magnetLen = 100
    o.magnet = o.world:newPolygonCollider({o.magnetLen/2,0,0,o.magnetLen,o.magnetLen,o.magnetLen})
    o.magnet:setType('kinematic')
    o.magnet:setCollisionClass('MagnetEffect')
    table.insert(CollidersList,o.magnet)
    o.magnet:setPreSolve(function (c1,c2,contact)
        local fx,fy = 0,0
        -- get x, y by c1.object
        local x2,y2 = c2.object.x,c2.object.y
        x2 = x2 + c2.object.width/2
        local x1,y1 = o.x,o.y
        if o.dir == -1 then
            x1 = x1 - o.width/2
        else
            x1 = x1 + o.width/2
        end
        -- local d = math.sqrt((x2-x1)^2+(y2-y1)^2)
        local f = 1
        local force = 1
        fx = f*(x2-x1)*force
        fy = f*(y2-y1)*force
        if fy < -60 then
            fy = -60
        end
        if fy > 65 then
            fy = 65
        end
        if fx < -10 then
            fx = -10
        end
        fx = math.abs(fx)
        -- if fx > 10 then
        --     fx = 10
        -- end


        if c1.collision_class == 'MagnetEffect' then
            contact:setEnabled(false)
        end
        if c2.collision_class == 'Bot' then
            o.animationSinal = c2.object.sinal
            o.isAnimation = true
            if x2 < x1 then
                fx = fx
            elseif x2 > x1 then
                fx = -fx
            end
            if o.sinal ~= c2.object.sinal then
                fx = -fx
            end
            if o.sinal*c2.object.sinal == 1 then
                c2:applyForce(fx,-fy)
            else
                c2:applyForce(fx,fy)
            end
        end
    end)
    table.insert(self.objects,o)
    o.collider:setObject(o)
    o.magnet:setObject(o)
    o.dir = dir
    o.sinal = sinal
    return o
end

function Magnet:update(dt)
    -- if type == 1 control with keys
    for index, value in ipairs(self.objects) do
        if value.type == 1 then
            Magnet:moveKeys(dt,value)
        elseif value.type == 2 then
            Magnet:moveWASD(dt,value)
        end
    end

    for index, value in ipairs(self.objects) do
        if value.isAnimation then
            value.animation:update(dt)
            value.animation_inv:update(dt)
        end
    end
end

function Magnet:moveKeys(dt,obj)
    local vx,vy = 0,0
    if love.keyboard.isDown('left') and love.keyboard.isDown('up') then
        vx = -obj.speed*cos45
        vy = -obj.speed*cos45
        obj.angule = 135
    elseif love.keyboard.isDown('left') and love.keyboard.isDown('down') then
        vx = -obj.speed*cos45
        vy = obj.speed*cos45
        obj.angule = 225
    elseif love.keyboard.isDown('right') and love.keyboard.isDown('up') then
        vx = obj.speed*cos45
        vy = -obj.speed*cos45
        obj.angule = 45
    elseif love.keyboard.isDown('right') and love.keyboard.isDown('down') then
        vx = obj.speed*cos45
        vy = obj.speed*cos45
        obj.angule = 315
    elseif love.keyboard.isDown('left') then
        vx = -obj.speed
        obj.angule = 180
    elseif love.keyboard.isDown('right') then
        vx = obj.speed
        obj.angule = 0
    elseif love.keyboard.isDown('up') then
        vy = -obj.speed
        obj.angule = 270
        obj.dir = -1
    elseif love.keyboard.isDown('down') then
        vy = obj.speed
        obj.angule = 90
        obj.dir = 1
    end

    -- if vy < 0 then
    --     vy = vy + obj.speed*0.3
    --     obj.collider:setLinearDamping(10)
    -- end


    if obj.collider then
        obj.collider:setLinearVelocity(vx, vy)
        obj.x, obj.y = obj.collider:getPosition()
    
        if obj.dir == 1 then
            obj.magnet:setPosition(obj.x-obj.magnetLen/2,obj.y+obj.height-20)
            obj.magnet:setAngle(math.rad(0))
        elseif obj.dir == -1 then
            obj.magnet:setPosition(obj.x+obj.magnetLen/2,obj.y-obj.height+20)
            -- set the angle of the magnet to 120
            obj.magnet:setAngle(math.rad(180))
        end
      
    end

end

function Magnet:moveWASD(dt,obj)
    local vx,vy = 0,0
    if love.keyboard.isDown('a') and love.keyboard.isDown('w') then
        vx = -obj.speed*cos45
        vy = -obj.speed*cos45
        obj.angule = 135
    elseif love.keyboard.isDown('a') and love.keyboard.isDown('s') then
        vx = -obj.speed*cos45
        vy = obj.speed*cos45
        obj.angule = 225
    elseif love.keyboard.isDown('d') and love.keyboard.isDown('w') then
        vx = obj.speed*cos45
        vy = -obj.speed*cos45
        obj.angule = 45
    elseif love.keyboard.isDown('d') and love.keyboard.isDown('s') then
        vx = obj.speed*cos45
        vy = obj.speed*cos45
        obj.angule = 315
    elseif love.keyboard.isDown('a') then
        vx = -obj.speed
        obj.angule = 180
    elseif love.keyboard.isDown('d') then
        vx = obj.speed
        obj.angule = 0
    elseif love.keyboard.isDown('w') then
        vy = -obj.speed
        obj.angule = 270
        obj.dir = -1
    elseif love.keyboard.isDown('s') then
        vy = obj.speed
        obj.angule = 90
        obj.dir = 1
    end

    obj.collider:setLinearVelocity(vx, vy)
    obj.x, obj.y = obj.collider:getPosition()

    if obj.dir == 1 then
        obj.magnet:setPosition(obj.x-obj.magnetLen/2,obj.y+obj.height-20)
        obj.magnet:setAngle(math.rad(0))
    elseif obj.dir == -1 then
        obj.magnet:setPosition(obj.x+obj.magnetLen/2,obj.y-obj.height+20)
        -- set the angle of the magnet to 120
        obj.magnet:setAngle(math.rad(180))
    end
    
end

function Magnet:draw()
    for index, value in ipairs(self.objects) do
        if value.dir == -1 then
            love.graphics.draw(value.img,value.x,value.y,0,1,1,value.width/2,value.height/2) 
            if value.isAnimation then
                -- value.animation:draw(value.spriteSheet,value.x-value.magnetLen/2+5,value.y-value.magnetLen-10,0)
                if value.animationSinal == -1 then
                    value.animation:draw(value.spriteSheet,value.x-value.magnetLen/2+5,value.y-value.magnetLen-10,0)
                else
                    value.animation_inv:draw(value.spriteSheet,value.x-value.magnetLen/2+5,value.y-value.magnetLen-10,0)
                end
            end
        else
            love.graphics.draw(value.img,value.x,value.y,math.pi,1,1,value.width/2,value.height/2) 
            if value.isAnimation then
                if value.animationSinal == -1 then
                    value.animation:draw(value.spriteSheet,value.x+value.magnetLen/2+5,value.y+value.magnetLen+10,math.pi)
                else
                    value.animation_inv:draw(value.spriteSheet,value.x+value.magnetLen/2+5,value.y+value.magnetLen+10,math.pi)
                end
            end
        end
        value.isAnimation = false
    end
end