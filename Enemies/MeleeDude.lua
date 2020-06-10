Melee = Boss:extend()

function Melee:new()
    self.super:new(200, 100, 750, "Images/meleeboss.png")   

    x, y = 200, 200
end

function Melee:update(dt)
    if not self:isInRange(x, y, 25) then
        self:moveto(x, y, dt)
    else
        x = player.x + math.random(-100, 100)
        y = player.y + math.random(-100, 100)
    end
end

function Melee:draw()
    self.super:draw()
end

function Melee:moveto(x, y, dt)
    local angle = math.atan2(y - self.y, x - self.x)
    local cos = math.cos(angle)
    local sin = math.sin(angle)

    self.super.x = self.super.x + self.super.speed * cos * dt * GameSpeed * SlowMo
    self.super.y = self.super.y + self.super.speed * sin * dt * GameSpeed * SlowMo
end

function Melee:isInRange(x, y, Range)
    if math.sqrt((self.x - x) ^ 2 + (self.y - y) ^ 2) < Range then
        return true
    else
        return false
    end
end