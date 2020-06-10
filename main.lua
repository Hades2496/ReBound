SCALE_FACTOR = 2

WINDOW_WIDTH = 1280 * SCALE_FACTOR
WINDOW_HEIGHT = 720 * SCALE_FACTOR

function love.load()
    math.randomseed(os.time())

    Class = require "class"
    suit = require "SUIT"

    require "Player"
    require "Enemies/Boss"
    require "Enemies/Enemy"
    require "Enemies/MeleeDude"
    require "Bullet"
    require "Barriers"
    require "Camera"
    require "UI/MainUI"
    require "UI/SettingsTab"
    require "UI/Shop"
    require "UI/MapUI"
    require "Levels/Map"
    require "Levels/Level1"

    ui = UI()

    ability = false
    posCounter = 0

    love.window.setMode(WINDOW_WIDTH / SCALE_FACTOR, WINDOW_HEIGHT / SCALE_FACTOR, {
        fullscreen = falsee,
        vsync = true,
        resizable = false
    })

    GameSpeed = 1
    SlowMo = 1

    soundSlider = { value = 5, min = 0, max = 10 }
    musicSlider = { value = 0.75, min = 0, max = 10 }

    startTimer = 3
    
    inMapUI = false
    inShop = false
    inSettings = false
    paused = false

    didWin = false
    didLose = false

    credit = 10000
    abilities = { canSlowmo = false, canTmp = false, canFollowMouse = true }

    YSBG = love.audio.newSource("Sound/YouSeeBIGGIRL.mp3", "stream")

    YSBG:play()
end

function love.update(dt)
    YSBG:setVolume(musicSlider.value / 10)

    if ui.GameStarted and not didWin and not didLose and not inSettings then
       if player.x > love.graphics.getWidth() / 2 then
            camera.x = player.x - love.graphics.getWidth() / 2
       end

       if player.y > love.graphics.getHeight() / 2 then
            camera.y = player.y - love.graphics.getHeight() / 2
       end
    end

    if ui.GameStarted and #Enemies <= 0 then
        didWin = true
    elseif ui.GameStarted and player.health <= 0 then
        didLose = true
    end

    if didWin then
        camera.x = 0
        camera.y = 0
        suit.Label("YouWin!!", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 50, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 75, 100, 50)
        if suit.Button("Restart", { align = "center" }, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 100, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 25, 200, 50).hit then
            restartGame()
        elseif suit.Button("Main Menu", { align = "center" }, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 100, WINDOW_HEIGHT / (2 * SCALE_FACTOR) + 30, 200, 50).hit then
            resetGame()
        end
    elseif didLose then
        camera.x = 0
        camera.y = 0
        suit.Label("YouLost....", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 50, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 75, 100, 50)
        if suit.Button("Restart", { align = "center" }, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 100, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 25, 200, 50).hit then
            restartGame()
        elseif suit.Button("Main Menu", { align = "center" }, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 100, WINDOW_HEIGHT / (2 * SCALE_FACTOR) + 30, 200, 50).hit then
            resetGame()
        end
    end

    if ui.GameStarted and startTimer > 1 and not paused then
        startTimer = startTimer - dt
    end

    if inSettings then
        set:update(dt)
        camera.x = 0
        camera.y = 0
    end

    if inMapUI then
        mapui:update(dt)
    end

    if inShop then
        shop:update(dt)
    end
    
    if not inSettings and not ui.GameStarted and not inShop and not inMapUI then
        ui:update(dt)
    end
    
    if not paused then
        if ui.GameStarted and startTimer <= 1 and didWin == false and didLose == false then
            map:update(dt)
        end
    end
end 

function love.draw()
    camera:set()

    suit.draw()
    
    if inSettings then
        set:draw()
    end
    
    if ui.GameStarted then
        if not inSettings and didLose == false and didWin == false then
            map:draw()
        end
    end
    
    if not inSettings and startTimer > 1 and ui.GameStarted then
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.print(math.floor(startTimer), WINDOW_WIDTH / (2 * SCALE_FACTOR) - 20, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 6)
        love.graphics.setFont(love.graphics.newFont(12))
    end
    
    -- love.graphics.print("GS: "..tostring(ui.GameStarted).. "  IS: "..tostring(inSettings).. "  dl: ".. tostring(didLose).. "  dW: ".. tostring(didWin), 100, 100)

    camera:unset()
end

function love.keypressed(key)
    if key == 'escape' then
        if ui.GameStarted then
            set = Settings()
            inSettings = true
            paused = true
        else
            love.event.quit()
        end
    end

    if ui.GameStarted and startTimer < 1 then
        player:keypressed(key)
    end
end

function love.mousepressed(x, y, button, isTouch)
    if ui.GameStarted and startTimer < 1 then
        player:mousepressed(x, y, button, isTouch)
    end
end

function love.mousereleased(x, y, button, isTouch)
    if button == 2 then
        player.followMouse = false
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