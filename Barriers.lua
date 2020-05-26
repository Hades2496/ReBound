Barrier = Class:extend()

function Barrier:new(x, y)
    self.Image = love.graphics.newImage("Images/Barrier.png")

    self.width = self.Image:getWidth()
    self.height = self.Image:getHeight()

    self.x = x
    self.y = y
end

function Barrier:update(dt)

end

function Barrier:draw()
    love.graphics.draw(self.Image, self.x, self.y)
end