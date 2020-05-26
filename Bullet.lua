Bullet = Class:extend()

function Bullet:new(X, Y, XVelocity, YVelocity)   
    self.image = love.graphics.newImage("Images/Bullet.png")

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = X - self.width / 2
    self.y = Y

    self.XV = XVelocity - self.x
    self.YV = YVelocity - self.y

    self.angle = math.atan2(player.y - self.y, player.x - self.x)
end

function Bullet:update(dt)
    self.x = self.x + self.XV * dt * GameSpeed * SlowMo
    self.y = self.y + self.YV * dt * GameSpeed * SlowMo
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle + 80)
end

function Bullet:CollisionWithWall()
    if self.x < 0 or self.x + self.width >= WINDOW_WIDTH then
        return true
    elseif self.y < 0 or self.y + self.height >= WINDOW_HEIGHT then
        return true
    end

    return false
end

function Bullet:Collision(other)
    if self.x + self.width > other.x and
        self.x < other.x + other.width and
        self.y + self.height > other.y and
        self.y < other.y + other.height then
            return true
        else
            return false
    end
end