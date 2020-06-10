Map = Class:extend()

function Map:new()
    self.pauseImage = love.graphics.newImage("Images/Pause.png")

    self.Barriers = {}

    player = Player()
end

function Map:update(dt)
    if suit.Button("Pause", 10, 10, 100, 50).hit then
        set = Settings()
        inSettings = true
        paused = true
        startTimer = 3
    end 

    player:update(dt)
    
end

function Map:draw()
    love.graphics.setBackgroundColor(40 / 255, 45 / 255, 52 / 255, 1)
    self:DisplayFPS(10, WINDOW_HEIGHT - 30)

    for i, v in ipairs(map.Barriers) do
        v:draw()
    end

    player:draw()
end

function Map:DisplayFPS(X, Y)
    love.graphics.setColor(20 / 255, 120 / 255, 20 / 255)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), X, Y)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.setColor(1, 1, 1)
end