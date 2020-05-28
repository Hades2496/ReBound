WINDOW_WIDTH = 1400
WINDOW_HEIGHT = 800

function love.load()
    math.randomseed(os.time())

    Class = require "class"
    suit = require "suit"

    require "Map"
    require "Player"
    require "Enemy"
    require "Bullet"
    require "Barriers"
    require "UI/MainUI"
    require "UI/SettingsTab"

    ui = UI()

    ability = false
    posCounter = 0

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    YSBG = love.audio.newSource("Sound/YouSeeBIGGIRL.mkv", "stream")
    -- YSBG:play()

    soundSlider = { value = 5, min = 0, max = 10 }
    musicSlider = { value = 5, min = 0, max = 10 }

    inSettings = false
    paused = false
end

function love.update(dt)
    if inSettings then
        set:update(dt)
    end

    if not inSettings then
        ui:update(dt)
    end

    if ui.Constructor then
        player = Player()
        map = Map(360)

        Enemies = {}
        
        for i = 1, 6 do
            table.insert(Enemies, Enemy())
        end
        ui.Constructor = false
    end

    if not paused then
        if ui.GameStarted then
            player:update(dt)
            map:update(dt)
            
            for i, v in ipairs(Enemies) do
                v:update(dt)
            end 
        end
    end
end 

function love.draw()
    if inSettings then
        set:draw()
    end

    if not inSettings then
        ui:draw()
    end

    if ui.GameStarted then
        map:draw()
        player:draw()

        for i, v in ipairs(Enemies) do
            v:draw()
        end 
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if ui.GameStarted then
        player:setAngleWithWASD(key)

        if key == 'g' and ability == false and player.spec == false then
            ability = true
        end

        if key == 'r' and ability == false and player.spec == false then
            if SlowMo < 1 then
                SlowMo = 1
            else
                Slowmo = 0.1
            end
        end
    end
end

function love.mousepressed(x, y, button, isTouch)
    if ui.GameStarted then
        if ability and posCounter < 6 then
            if x < (player.Rad * 2) + 1 then
                x = (player.Rad * 2) + 1
            elseif x > WINDOW_WIDTH - (player.Rad * 2) - 1 then
                x = WINDOW_WIDTH - (player.Rad * 2) - 1
            end

            if y < (player.Rad * 2) + 1 then
                y = (player.Rad * 2) + 1
            elseif y > WINDOW_HEIGHT - (player.Rad * 2) - 1 then
                y = WINDOW_HEIGHT - (player.Rad * 2) - 1
            end

            table.insert(player.abilityPos, { x, y })
            posCounter = posCounter + 1 
        end

        if posCounter >= 6 then
            posCounter = 0
            ability = false
        end

        if button == 2 then
            player.followMouse = true
        end
    end
end

function love.mousereleased(x, y, button, isTouch)
    if button == 2 then
        player.followMouse = false
    end
end