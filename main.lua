WINDOW_WIDTH = 1400
WINDOW_HEIGHT = 800

function love.load()
    math.randomseed(os.time())

    Class = require "class"
    suit = require "SUIT"

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

    GameSpeed = 1
    SlowMo = 1

    soundSlider = { value = 5, min = 0, max = 10 }
    musicSlider = { value = 2, min = 0, max = 10 }

    startTimer = 0
    
    inSettings = false
    paused = false

    didWin = false
    didLose = false

    YSBG = love.audio.newSource("Sound/YouSeeBIGGIRL.mp3", "stream")

    YSBG:play()
end

function love.update(dt)
    YSBG:setVolume(musicSlider.value / 10)

    if ui.GameStarted and #Enemies <= 0 then
        didWin = true
    elseif ui.GameStarted and player.health <= 0 then
        didLose = true
    end

    if didWin then
        suit.Label("YouWin!!", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 - 75, 100, 50)
        if suit.Button("Click here to restart the game", { align = "center" }, WINDOW_WIDTH / 2 - 100, WINDOW_HEIGHT / 2 - 25, 200, 50).hit then
            restartGame()
        elseif suit.Button("Click here to reset the game", { align = "center" }, WINDOW_WIDTH / 2 - 100, WINDOW_HEIGHT / 2 + 30, 200, 50).hit then
            resetGame()
        end
    elseif didLose then
        suit.Label("YouLost....", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 - 75, 100, 50)
        if suit.Button("Click here to restart the game", { align = "center" }, WINDOW_WIDTH / 2 - 100, WINDOW_HEIGHT / 2 - 25, 200, 50).hit then
            restartGame()
        elseif suit.Button("Click here to reset the game", { align = "center" }, WINDOW_WIDTH / 2 - 100, WINDOW_HEIGHT / 2 + 30, 200, 50).hit then
            resetGame()
        end
    end

    if ui.GameStarted and startTimer > 1 and not paused then
        startTimer = startTimer - dt
    end

    if inSettings then
        set:update(dt)
    end

    if not inSettings and not ui.GameStarted then
        ui:update(dt)
        suit.Label("No sound effects yet OBV", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 + 100, 100, 50)
    end

    if ui.Constructor and not inSettings then
        player = Player()
        map = Map(360)

        Enemies = {}
        
        table.insert(Enemies, Enemy(150, 150))
        -- table.insert(Enemies, Enemy(235, 300))
        -- table.insert(Enemies, Enemy(589, 221))
        -- table.insert(Enemies, Enemy(454, 632))
        -- table.insert(Enemies, Enemy(930, 432))
        -- table.insert(Enemies, Enemy(877, 150))
        ui.Constructor = false
    end

    if not paused then
        if ui.GameStarted and startTimer <= 1 and didWin == false and didLose == false then
            player:update(dt)
            map:update(dt)
            
            for i, v in ipairs(Enemies) do
                v:update(dt)
            end 
        end
    end
end 

function love.draw()
    suit.draw()
    if inSettings then
        set:draw()
    end

    if not inSettings then
        ui:draw()
    end

    if ui.GameStarted then
        if not inSettings and didLose == false and didWin == false then
            map:draw()
            player:draw()
            
            for i, v in ipairs(Enemies) do
                v:draw()
            end 
        end
    end

    love.graphics.print("here", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT, 25)

    if not inSettings and startTimer > 1 and ui.GameStarted then
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.print(math.floor(startTimer), WINDOW_WIDTH / 2 - 20, WINDOW_HEIGHT / 2 - 6)
        love.graphics.setFont(love.graphics.newFont(12))
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
                SlowMo = 0.1
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
            -- player.OSpeed = player.speed
        end
    end
end

function love.mousereleased(x, y, button, isTouch)
    if button == 2 then
        player.followMouse = false
        -- player.speed = player.OSpeed
    end
end

function resetGame()
    ui = UI()
    ui.Constructor = false
    ui.GameStarted = false

    startTimer = 3

    inSettings = false
    paused = false

    didWin = false
    didLose = false
end

function restartGame()
    startTimer = 3

    ui.Constructor = true

    inSettings = false
    paused = false

    didWin = false
    didLose = false
end