Boss = Class:extend()

function Boss:new(x, y, Speed, Image)
    self.image = love.graphics.newImage(Image)

    self.x = x
    self.y = y

    self.speed = Speed

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Boss:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Boss:collision(obj, target)
    if obj.x + obj.width > other.x and
    obj.x < other.x + other.width and
    obj.y + obj.height > other.y and
    obj.y < other.y + other.height then
        return true
    end

    return false
end