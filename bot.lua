Bot = {}

function Bot:new(x,y,w,h,world,imgPath,sinal)
    local bot = {}
    bot.x = x
    bot.y = y
    bot.width = w
    bot.height = h
    bot.world = world
    bot.collider = bot.world:newRectangleCollider(bot.x,bot.y,bot.width,bot.height)
    table.insert(CollidersList,bot.collider)
    bot.collider:setCollisionClass('Bot')
    bot.collider:setType('dynamic')
    bot.collider:setObject(bot)
    bot.collider:setFixedRotation(true)
    bot.img = love.graphics.newImage(imgPath)
    bot.sinal = sinal or 1
    if bot.collider:exit('MagnetEffect') then
        -- set the force to 0
        bot.collider:setLinearVelocity(0,0)
    end
    -- bot.collider:setRestitution(0.5)
    -- bot.collider:setFriction(0.5)
    -- bot.collider:setMass(10)


    bot.collider:setPreSolve(function(c1,c2,contact)
        if c2.collision_class == 'Magnet' then
            contact:setEnabled(false)
        end
    end)

    self.objects = self.objects or {}
    table.insert(self.objects,bot)
    return bot
end

function Bot:update(dt)
    local cx,cy = 0,0
    for i,bot in ipairs(self.objects) do
        bot.x,bot.y = bot.collider:getPosition()
        cx = cx + bot.x
        cy = cy + bot.y
    end
    return cx/#self.objects,cy/#self.objects
end


function Bot:draw()
    for i,bot in ipairs(self.objects) do
        love.graphics.draw(bot.img,bot.x,bot.y,0,1,1,bot.width/2,bot.height/2)
    end
end