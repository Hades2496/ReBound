Map = Class:extend()

function Map:new(R)
    self.R = R

    GameSpeed = 1
    SlowMo = 1

    self.Barriers = {}

    -- table.insert(self.Barriers, Barrier(100, 100))
    -- table.insert(self.Barriers, Barrier(400, 350))
    -- table.insert(self.Barriers, Barrier(700, 200))
    -- table.insert(self.Barriers, Barrier(1100, 150))
end

function Map:update(dt)

end

function Map:draw()
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)
    love.graphics.circle('line', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, self.R)
    self:DisplayFPS(10, WINDOW_HEIGHT - 30)

    for i, v in ipairs(map.Barriers) do
        v:draw()
    end
end

function Map:DisplayFPS(X, Y)
    love.graphics.setColor(20 / 255, 120 / 255, 20 / 255)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), X, Y)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.setColor(1, 1, 1)
end