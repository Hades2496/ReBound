Enemy = Class:extend()

function Enemy:new(X, Y)
    self.image = love.graphics.newImage("Images/Enemy.png")

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = X
    self.y = Y    

    self.DelayBetweenShots = math.random(1, 2)

    self.Bullets = {}

    self.canShoot = true--math.random(2) == 1 and true or false
end

function Enemy:update(dt)
    if self.canShoot then
        self.DelayBetweenShots = self.DelayBetweenShots - dt * GameSpeed
    else
        self.DelayBetweenShots = math.random(1, 2)
    end

    if self.DelayBetweenShots < 0 then
        self:Shoot()     
        self.DelayBetweenShots = math.random(1, 2)
    end

    for i, v in ipairs(self.Bullets) do
        v:update(dt)
        
        if v:CollisionWithWall() then
            table.remove(self.Bullets, i)
        end
    end

    for i, v in ipairs(self.Bullets) do
        for j, k in ipairs(map.Barriers) do
            if v:Collision(k) then
                table.remove(self.Bullets, i)
            end
        end
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y)

    for i, v in ipairs(self.Bullets) do
        v:draw()
    end 
end

function Enemy:Shoot()
    table.insert(self.Bullets, Bullet(self.x + self.width / 2, self.y + self.height / 2, player.x + player.Rad, player.y + player.Rad))
end

