-- libraries
anim8 = require 'libs.anim8'

wf = require('libs.windfield')
sti = require('libs.sti')
Camera = require("libs.Camera")
Dialove = require('Dialove')
local moonshine = require 'libs.moonshine'


W,H= love.graphics.getDimensions()


CollidersList = {}

World = wf.newWorld(0, 10, true)

function setCollisionClass(world,classeName)
    for i,v in ipairs(classeName) do
        world:addCollisionClass(v)
    end
end

TitleFont = love.graphics.newFont('font/Cardinal.ttf', 36)

-- files
require('player')
require('bot')
require('mapInit')

local backgroundMenu = love.graphics.newImage('imgs/menu.png')

local backgroundMenu2 = love.graphics.newImage('imgs/menu2.png')

gameState = 'menu'

local p1 = {x = W/2, y = H/2,img=love.graphics.newImage('imgs/boneca_corda.png'),sinal1=1,sinal2=-1}

local p2 = {x = W/2, y = H/2,img=love.graphics.newImage('imgs/boneco_corda.png'),sinal1=1,sinal2=-1}

local rect1 = {x = 0, y = 0, w = W, h = H/2}

local rect2 = {x = 0, y = H/2, w = W, h = H/2}

Audios = {
    bach = love.audio.newSource('music/bach.mp3','stream'),
    tcha = love.audio.newSource('music/tcha.mp3','stream'),
    fanta = love.audio.newSource('music/fanta.mp3','stream'),
    creepy = love.audio.newSource('music/creepy.mp3','stream'),
}

function love.load()
    -- collision classes
    setCollisionClass(World, {"Platform", "Magnet",'Bot','Special','Enemy','Final','MagnetEffect','F'})
    -- -- floor
    -- floor = World:newRectangleCollider(0, H-80, W, 100, {collision_class = "Platform"})
    -- floor:setType('stream')

    -- -- Bot

    -- Bot:new(100,100,24,24,World,'imgs/boneca_corda.png',-1)
    -- Bot:new(200,100,24,24,World,'imgs/boneco_corda.png',1)

    -- -- Magnet
    -- Magnet:new(200,H-50,24,24,World,1)

    -- -- map
    mapInit:load(World)

    -- canvas
    canvas = love.graphics.newCanvas(W,H)

    zoom = math.min(love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
    diff = love.graphics.getWidth() - canvas:getWidth() * zoom
    diff = diff/2

    -- camera
    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowStyle('TOPDOWN')
    cx,cy = H/2,W/2
    camera:follow(cx,cy)

    love.graphics.setDefaultFilter('nearest', 'nearest')

     -- inicia o sistema de diálogos vazio
     dialogManager = Dialove.init({
        --font = love.graphics.newFont('fonts/comic-neue/ComicNeue-Bold.ttf', 20),
        font = love.graphics.newFont('fonts/press-start-2p/PressStart2P-Regular.ttf',16),
        --font = love.graphics.newFont('fonts/seagram/Seagram tfb.ttf', 16),
        -- font = love.graphics.newFont('fonts/proggy-tiny/ProggyTiny.ttf', 60),
        -- font = love.graphics.newFont('fonts/Carnevalee Freakshow/Carnevalee Freakshow.ttf', 28),
        padding = 10,
        --typingVolume = 0.1,
        numberOfLines = 4,
        -- optionsSeparation = 10,
        viewportW = canvas:getWidth(),
        viewportH = canvas:getHeight(),
    })

    Audios.tcha:setLooping(true)
    Audios.tcha:play()

    -- shaders

    effect = moonshine(moonshine.effects.vignette)

    effect2 = moonshine(moonshine.effects.crt)

    

end

local function introAdd()
    inDialog = true
    Audios.tcha:stop()
    Audios.creepy:setLooping(true)
    Audios.creepy:play()
    -- Intro do jogo, sequência de falas
       local credits_dialog = {
         title = 'Oh no!',
         text = 'Uma magia corrompeu a caixinha de musica, os dancarinos estao perdidos!',
         options ={
              {'Pressione enter',function ()
                local credits_dialog1 = {
                    title = 'Tutorial',
                    text = 'Durante os dialogos, pressione enter para confirmar, espaco para acelerar, F para pular a fala atual e esc para sair',
                  }
            
                  dialogManager:show(credits_dialog1)
             
                   local credits_dialog2 = {
                     title = 'Tutorial',
                     text = 'Use as WASD e as setas para movimentar, este jogo pode ser jogado solo ou cooperativo.'
                   }
             
                   dialogManager:push(credits_dialog2)

                    local credits_dialog3 = {
                    title = 'Tutorial',
                    text = 'Eles precisam sair desse local assustador, se precisar reinicie o nivel apertando backspace.'
                    }

                    dialogManager:push(credits_dialog3)

             
                   local credits_dialog4 = {
                     title = 'Intro',
                     text = 'Qual sera o destino dos nossos dancarinos? Sera que a magia os levara para um lugar seguro? Ou para um lugar sombrio?',
                   }
             
                   dialogManager:push(credits_dialog4)
             
                --    local credits_dialog4 = {
                --      title = 'Intro',
                --      text = 'Nascido do ressentimento e codificado com rancor, voce assume o comando de um virus. Uma criatura digital, forjada nas entranhas da Protasio: Solucoes em tecnologia financeira.'
                --    }
             
                --    dialogManager:push(credits_dialog4)
             
                --    local credits_dialog5 = {
                --      title = 'Intro',
                --      text = 'Sua missao e clara: adentrar o sistema de seguranca da empresa. Um fantasma nas maquinas, um codigo que se infiltra e corrompe. Voce e o soldado, e ele a arma nesta jornada.'
                --    }
             
                --    dialogManager:push(credits_dialog5)
             
                --    local credits_dialog6 = {
                --      title = 'Intro',
                --      text = "Mas este virus e mais do que apenas um programa. E um enigma, um labirinto de 0's e 1's que esconde suas reais intencoes."
                --    }
             
                --    dialogManager:push(credits_dialog6)
             
              
                --    local credits_dialog7 = {
                --     title = 'Intro',
                --     text = "Apenas voce, o programador escolhido, pode desvendar seus segredos e conduzi-lo ao seu destino final."
                --    }
             
                --    dialogManager:push(credits_dialog7)
             
                --    local credits_dialog8 = {
                --     title = 'Intro',
                --     text = 'Em meio a acaloradas batalhas contra firewalls, decifrando entradas criptografadas e derrubando antivirus, uma pergunta paira no ar: qual a verdadeira raiz do virus? Qual o objetivo final dessa criatura digital?'
                --    }
             
                --    dialogManager:push(credits_dialog8)
             
                   local credits_dialog9 = {
                    title = 'Intro',
                    text = 'Somente o tempo respondera essas perguntas. Mas uma coisa e certa: a musica nunca mais sera a mesma.',
                     options = {{'Inicio',function ()
                        first_init = false
                        inDialog = false
                        gameState = 'game'
                        Audios.creepy:stop()
                        Audios.fanta:setLooping(true)
                        Audios.fanta:play()
                       end}}
                   }
             
                   dialogManager:push(credits_dialog9)
                   
              end}
         }
       }
 
       dialogManager:show(credits_dialog)

  
end


function finalDiag()
    inDialog = true
    Audios.fanta:stop()
    Audios.tcha:setLooping(true)
    Audios.tcha:play()
    -- Intro do jogo, sequência de falas
       local credits_dialog = {
         title = 'E com o poder da ciencia',
         text = 'Os dancarinos foram salvos!',
         options ={
              {'Pressione enter',function ()
                local credits_dialog1 = {
                    title = 'Final',
                    text = 'Agora eles podem voltar a dancar e girar, rir e divertir as pessoas!',
                  }
            
                  dialogManager:show(credits_dialog1)
             
                   local credits_dialog2 = {
                     title = 'Final',
                     text = 'Espero que tenha gostado!',
                   }
             
                   dialogManager:push(credits_dialog2)
             
                   local credits_dialog3 = {
                     title = 'Ate a proxima!',
                     text = 'Jogo desenvolvido por Emanuel Bissiatti',
                     options = {{'Sair',function ()
                        love.event.quit(0)
                       end}}
                   }
             
                   dialogManager:push(credits_dialog3)
              end}
         }
       }
 
       dialogManager:show(credits_dialog)
end


function love.update(dt)
    if gameState == 'menu' then
        p1.x = p1.x + math.sin(dt)*p1.sinal1*math.sin(dt)*(math.sin(dt)+math.random(1,10))
        p1.y = p1.y + dt*p1.sinal2*math.random(1,80)
        p2.x = p2.x + 2*math.cos(dt)^2*p2.sinal1
        p2.y = p2.y + 10*dt^2*p2.sinal2*math.random(1,30)
        if math.random() < 0.001 then
            p1.sinal1 = -p1.sinal1
        end
        if math.random() < 0.01 then
            p1.sinal2 = -p1.sinal2
        end
        if p1.x > W/2+240 then
            p1.sinal1 = -1
        end
        if p1.x < W/2-120 then
            p1.sinal1 = 1
        end
        if p1.y > H/2+25 then
            p1.sinal2 = -1
        end
        if p1.y < H/2-100 then
            p1.sinal2 = 1
        end
        if p2.x > W/2+240 then
            p2.sinal1 = -1
        end
        if p2.x < W/2-120 then
            p2.sinal1 = 1
        end
        if p2.y > H/2+25 then
            p2.sinal2 = -1
        end
        if p2.y < H/2-100 then
            p2.sinal2 = 1
        end
        if love.keyboard.isDown('return') then
            gameState = 'anim'
        end
    elseif gameState == 'intro' then
        dialogManager:update(dt)
    elseif gameState == 'final' then
        dialogManager:update(dt)
    else
        World:update(dt)
        Magnet:update(dt)
        local cx,cy = Bot:update(dt)
        -- check if cx,cy passou do limite do mapa
        -- if cx < W/4 then
        --     cx = W/4
        -- end
        -- if cx > mapInit.mapLimit.x - W/4 then
        --     cx = mapInit.mapLimit.x - W/4 
        -- end
        -- if cy < H/4 then
        --     cy = H/4
        -- end
        -- if cy > mapInit.mapLimit.y - H/4 then
        --     cy = mapInit.mapLimit.y - H/4
        -- end
        mapInit:update(dt)
        Doors:update()
        if mapInit.cam then
            if tostring(cy) == 'nan' or tostring(cx) == 'nan' then
                camera:follow(W/2,H/2)
                camera:update(dt)
                return
            else
                camera:follow(cx,cy)
                camera:update(dt)
            end
        else
            camera:follow(W/2,H/2)
            camera:update(dt)
        end
    end
end

function math.mean(numbers,...)
    local sum = numbers
    local arg = {...}
    for i,v in ipairs(arg) do
        sum = sum + v
    end
    return sum/(#arg+1)
end

function love.draw()
    if gameState == 'menu' then
        love.graphics.setCanvas(canvas)
            love.graphics.clear()
            effect(function ()
                
            love.graphics.draw(backgroundMenu,0,0)
            love.graphics.setDefaultFilter('nearest', 'nearest')
            local title = love.graphics.newText(TitleFont,'Magheart')
            love.graphics.draw(title,W/2+10,H/2-3*title:getHeight())
            love.graphics.draw(p1.img,p1.x,p1.y,0,2,2,p1.img:getWidth()/2,p1.img:getHeight()/2)
            love.graphics.draw(p2.img,p2.x,p2.y,0,2,2,p2.img:getWidth()/2,p2.img:getHeight()/2)
            end)
        love.graphics.setCanvas()
        love.graphics.setDefaultFilter('nearest', 'nearest')

        zoom = math.min(love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
        diff = love.graphics.getWidth() - canvas:getWidth() * zoom
        diff = diff/2

        love.graphics.clear()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        love.graphics.draw(canvas, 0, 0, 0, zoom,zoom)

    elseif gameState == 'anim' then
        love.graphics.setCanvas(canvas)
            love.graphics.clear()
            effect(function ()
            love.graphics.setDefaultFilter('nearest', 'nearest')
            love.graphics.draw(backgroundMenu2,0,0)
            love.graphics.setColor(0,0,0,1)
            love.graphics.rectangle('fill',rect1.x,rect1.y,rect1.w,rect1.h)
            love.graphics.rectangle('fill',rect2.x,rect2.y,rect2.w,rect2.h)
            end)
        love.graphics.setCanvas()
        love.graphics.setDefaultFilter('nearest', 'nearest')

        zoom = math.min(love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
        diff = love.graphics.getWidth() - canvas:getWidth() * zoom
        diff = diff/2

        love.graphics.clear()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        love.graphics.draw(canvas, 0, 0, 0, zoom,zoom)

        if rect1.y > -H/2 then
            rect1.y = rect1.y - 2
        else
            gameState = 'intro'
            introAdd()
        end

        if rect2.y < H then
            rect2.y = rect2.y + 2
        end

    elseif gameState == 'intro' then
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        effect(function ()
        love.graphics.setDefaultFilter('nearest', 'nearest')
        love.graphics.draw(backgroundMenu2,0,0)
        end)
    love.graphics.setCanvas()

    zoom = math.min(love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
    diff = love.graphics.getWidth() - canvas:getWidth() * zoom
    diff = diff/2

    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.graphics.draw(canvas, 0, 0, 0, zoom,zoom)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setCanvas{canvas, stencil = true}
        love.graphics.clear()
        love.graphics.setColor(1,1,1)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        dialogManager:draw()
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, zoom,zoom)
    elseif gameState == 'final' then
    love.graphics.setCanvas{canvas, stencil = true}
        love.graphics.clear()
        love.graphics.setColor(1,1,1)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        dialogManager:draw()
    love.graphics.setCanvas()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    zoom = math.min(love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
    diff = love.graphics.getWidth() - canvas:getWidth() * zoom
    diff = diff/2

    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.draw(canvas, 0, 0, 0, zoom,zoom)
    else
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        effect2(function()
            love.graphics.setDefaultFilter('nearest', 'nearest')
            camera:attach()
                love.graphics.setColor(1, 1, 1)
                mapInit:drawDown()
                Doors:draw()
                -- World:draw()
                Bot:draw()
                Magnet:draw()
                love.graphics.translate(diff, 0)
            camera:detach()
        end)
        love.graphics.setCanvas() 
        -- zoom 
        zoom = math.min(love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
        diff = love.graphics.getWidth() - canvas:getWidth() * zoom
        diff = diff/2

        love.graphics.clear()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        love.graphics.draw(canvas, 0, 0, 0, zoom,zoom)
    end
end


function love.keypressed(k)
    if gameState=='intro' or gameState=='final' or gameState == 'cred' then
        if k == 'return' then
            dialogManager:pop()
        elseif k == 'f' then
            dialogManager:complete()
        elseif k == 'space' then
            dialogManager:faster()
        elseif k == 'w' then
            dialogManager:changeOption(1) -- next one
        elseif k == 's' then
            dialogManager:changeOption(-1) -- previous one
        end
        if k == 'escape' then
            dialogManager = Dialove.init({
                font = love.graphics.newFont('fonts/press-start-2p/PressStart2P-Regular.ttf',16),
                padding = 10,
                numberOfLines = 7,
                viewportW = canvas:getWidth(),
                viewportH = canvas:getHeight(),
            })
            if gameState == 'intro' then
                gameState = 'game'
                inDialog = false
                Audios.creepy:stop()
                Audios.fanta:setLooping(true)
                Audios.fanta:play()
            end
        end
    end

    -- fullscreen toggle (F11)
    if k == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

end

