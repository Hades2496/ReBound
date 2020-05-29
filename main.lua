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
    require "UI/WinningUI"

    ui = UI()

    ability = false
    posCounter = 0

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    soundSlider = { value = 5, min = 0, max = 10 }
    musicSlider = { value = 5, min = 0, max = 10 }

    startTimer = 0

    inSettings = false
    paused = false

    didWin = false
    didLose = false

    constructEndUI = 0

    enemyCount = 6
end

function love.update(dt)
    if enemyCount <= 1 then
        didWin = true
        constructEndUI = 1
    elseif ui.GameStarted then
        if player.health <= 0 then
            didLose = true
            constructEndUI = 2
        end
    end

    if constructEndUI == 1 then
        winUI = WinUI()
        -- constructEndUI = 0
        player.health = 1
        enemyCount = 1
    elseif constructEndUI == 2 then
        loseUI = LoseUI()
        -- constructEndUI = 0
        player.health = 1
        enemyCount = 1
    end

    if didWin then
        winUI = WinUI()
    elseif didLose then
        loseUI = LoseUI()
    end

    if ui.GameStarted and startTimer > 1 and not paused then
        startTimer = startTimer - dt
    end

    if inSettings then
        set:update(dt)
    end

    if not inSettings and not ui.GameStarted then
        ui:update(dt)
    end

    if ui.Constructor and not inSettings then
        player = Player()
        map = Map(360)

        Enemies = {}
        
        for i = 1, enemyCount do
            table.insert(Enemies, Enemy())
        end
        ui.Constructor = false
    end

    if not paused then
        if ui.GameStarted and startTimer <= 1 then
            player:update(dt)
            map:update(dt)
            
            for i, v in ipairs(Enemies) do
                v:update(dt)
            end 
        end
    end
end 

function love.draw()
    if didWin then
        winUI:draw()
    elseif didLose then
        loseUI:draw()
    end

    if inSettings then
        set:draw()
    end

    if not inSettings then
        ui:draw()
    end

    if ui.GameStarted then
        if not inSettings then
            map:draw()
            player:draw()
            
            for i, v in ipairs(Enemies) do
                v:draw()
            end 
        end
    end
    love.graphics.print(enemyCount, 10, 10)
    love.graphics.print(tostring(didWin), 10, 30)
    love.graphics.print(tostring(didLose), 10, 50)
    love.graphics.print(constructEndUI, 10, 70)
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