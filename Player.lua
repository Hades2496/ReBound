Player = Class:extend()

function Player:new()
    self.Image = love.graphics.newImage("Images/PlayerImage.png")
    self.ArrowImage = love.graphics.newImage("Images/arrow.jpg")

    self.ArrowRotation = math.rad(math.random(360))
    self.Rad = self.Image:getWidth() / 2

    self.width = self.Image:getWidth()
    self.height = self.Image:getHeight()
    
    self.x = 500
    self.y = 250

    self.cos = math.cos(self.ArrowRotation)
    self.sin = math.sin(self.ArrowRotation)

    self.angCos = self.cos
    self.angSin = self.sin

    self.OriginX = self.ArrowImage:getWidth() / 2
    self.OriginY = self.ArrowImage:getHeight() / 2

    self.speed = 300
    self.turnRate = 0.025
    self.OSpeed = 0

    self.health = 1

    self.SpeedIncRate = 1.1  
    self.SpeedDecRate = 0.7

    self.abilityPos = {}
    self.spec = false
    self.posCounter = 1
    i = 1

    Par = love.graphics.newImage("Images/DestroyedEnemy.png")

    self.psystem = love.graphics.newParticleSystem(Par, 200)
    self.psystem:setParticleLifetime(0.8, 1)
    self.psystem:setEmissionRate(15)
    self.psystem:setSizeVariation(1)
    self.psystem:setLinearAcceleration(-400, -400, 400, 400)
    self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)

    PSTimer = 0.3
    killed = false

    self.followMouse = false

    self.canBoost = false
end

function Player:update(dt)
    if self.speed > 1000 then
        self.speed = 1000
    elseif self.speed < 300 then
        self.canBoost = true
    else
        self.canBoost = false
    end

    if self.followMouse-- and self:IsInRange(love.mouse.getY() * SCALE_FACTOR, love.mouse.getX() * SCALE_FACTOR, 50) 
    then
        self.ArrowRotation = math.atan2(love.mouse.getY() * SCALE_FACTOR - self.y, love.mouse.getX() * SCALE_FACTOR - self.x)
        self.angCos = math.cos(self.ArrowRotation)
        self.angSin = math.sin(self.ArrowRotation)
    end

    if killed then
        PSTimer = PSTimer - dt
    end

    if PSTimer < 0 then
        self.psystem:stop()
        PSTimer = 0.3
        killed = false
        self.psystem = love.graphics.newParticleSystem(Par, 200)
        self.psystem:setParticleLifetime(0.8, 1)
        self.psystem:setEmissionRate(15)
        self.psystem:setSizeVariation(1)
        self.psystem:setLinearAcceleration(-400, -400, 400, 400)
        self.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    end

    if ability then
        GameSpeed = 0.1
    else
        GameSpeed = 1
    end

    if #self.abilityPos >= 6 then
        self.spec = true
    end

    if not self.spec and not self.followMouse then
        self.x = self.x + self.speed * self.angCos * dt * GameSpeed * SlowMo
        self.y = self.y + self.speed * self.angSin * dt * GameSpeed * SlowMo
    elseif self.followMouse then
        self.x = self.x + 1000 * self.cos * dt
        self.y = self.y + 1000 * self.sin * dt
    end

    if self.spec then
        if self:IsInRange(self.abilityPos[i][1], self.abilityPos[i][2], 10) then
            i = i + 1
        end

        if i > #self.abilityPos then
            self.spec = false
            self.abilityPos = {}
            i = 1
        end

        if #self.abilityPos >= 6 then
            self:MoveTo(self.abilityPos[i][1], self.abilityPos[i][2], dt, 2000)
        else
            self:Collided()
        end
    end

    if love.keyboard.isDown("q") then
        self.ArrowRotation = self.ArrowRotation - self.turnRate
    elseif love.keyboard.isDown('e') then
        self.ArrowRotation = self.ArrowRotation + self.turnRate
    elseif love.keyboard.isDown("lshift") then

    elseif love.keyboard.isDown('lalt') then
        
    end

    self.cos = math.cos(self.ArrowRotation)
    self.sin = math.sin(self.ArrowRotation)

    for j = 1, #Enemies do

        for i, v in ipairs(Enemies[j].Bullets) do
            if self:BeginOverlap(v) then
                table.remove(Enemies[j].Bullets, i)
                self.health = self.health - 1
            end
        end
    end

    for i, v in ipairs(Enemies) do
        if self:BeginOverlap(v) then
            table.remove(Enemies, i)
            x = v.x
            y = v.y
            killed = true
            self:Collided()
        end
    end 

    for i, v in ipairs(map.Barriers) do
        self:OverlapWithBarrier(v)
    end

    self:CollisionWithWall()
    self.psystem:update(dt)
end

function Player:draw()
    for i, v in ipairs(self.abilityPos) do
        love.graphics.circle('fill', v[1], v[2], 10)

        if self.spec and i < #self.abilityPos then
            love.graphics.line(v[1], v[2], self.abilityPos[i + 1][1], self.abilityPos[i + 1][2])
        end
    end

    if #self.abilityPos > 0 then
        love.graphics.line(self.x + self.Rad, self.y + self.Rad, self.abilityPos[1][1], self.abilityPos[1][2])
    end

    if killed then
        love.graphics.draw(self.psystem, x, y)
    end

    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.print(self.health, WINDOW_WIDTH - 50, 10)
    love.graphics.setFont(love.graphics.newFont(12))

    love.graphics.draw(self.Image, self.x, self.y)
    love.graphics.draw(self.ArrowImage, self.x + self.cos * 20 + self.Rad, self.y + self.sin * 20 + self.Rad, self.ArrowRotation, 1, 1, self.OriginX, self.OriginY)
    -- love.graphics.draw(self.ArrowImage, self.x + self.Rad, self.y + self.Rad, self.ArrowRotation, 1, 1, self.OriginX, self.OriginY)
end


function Player:setAngleWithWASD(key)
    if key == 'w' then
        self.ArrowRotation = math.rad(271)
    elseif key == 'a' then
        self.ArrowRotation = math.rad(181)
    elseif key == 's' then
        self.ArrowRotation = math.rad(91)
    elseif key == 'd' then 
        self.ArrowRotation = math.rad(1)
    end
end

function Player:MoveTo(x, y, dt, speed)
    local angle = math.atan2(y - self.y, x - self.x)
    local cos = math.cos(angle)
    local sin = math.sin(angle)

    self.x = self.x + speed * cos * dt
    self.y = self.y + speed * sin * dt

    self.ArrowRotation = angle
end

function Player:IsInRange(x, y, Range)
    if math.sqrt((self.x - x) ^ 2 + (self.y - y) ^ 2) < Range then
        return true
    else
        return false
    end
end

function Player:keypressed(key)
    if ui.GameStarted then
        player:setAngleWithWASD(key)

        if key == 'g' and ability == false and player.spec == false and SlowMo >= 1 and abilities.canTmp then
            ability = true

        elseif key == 'r' and ability == false and player.spec == false and abilities.canSlowmo then
            if SlowMo < 1 then
                SlowMo = 1
            else
                SlowMo = 0.1
            end
        elseif key == 'space' then
            self.speed = self.speed + 175
        end
    end
end

function Player:mousepressed(X, Y, button, isTouch)
    if ui.GameStarted then
        if ability and posCounter < 6 then
            table.insert(player.abilityPos, { X * SCALE_FACTOR, Y * SCALE_FACTOR })
            posCounter = posCounter + 1 
        end

        if posCounter >= 6 then
            posCounter = 0
            ability = false
        end

        if button == 2 and abilities.canFollowMouse then
            player.followMouse = true
        end
    end
end

function Player:Collided()
    self.angCos = self.cos
    self.angSin = self.sin
end

function Player:BeginOverlap(other)
    if self.x + self.width > other.x and
    self.x < other.x + other.width and
    self.y + self.height > other.y and
    self.y < other.y + other.height then
        return true
    end
    
    return false
end

function Player:CollisionWithWall()
    if self.x <= 0 then
        if self.cos < 0 and self.cos > -1.1 then 
            self.speed = self.speed * self.SpeedDecRate
            self.ArrowRotation = math.rad(0)
        else
            self.speed = self.speed * self.SpeedIncRate
            if self.sin < 0 then
                self.sin = self.sin + 0.1
            else
                self.sin = self.sin - 0.1
            end 
        end

        self.x = 2.5
        self:Collided()
    end

    if self.x >= WINDOW_WIDTH - self.Rad * 2  then
        if self.cos > 0 and self.cos < 2 then
            self.speed = self.speed * self.SpeedDecRate
            self.ArrowRotation = math.rad(180)
        else
            self.speed = self.speed * self.SpeedIncRate
            if self.sin > 0 then
                self.sin = self.sin - 0.1
            else 
                self.sin = self.sin + 0.1
            end
        end

        self.x = (WINDOW_WIDTH - (self.Rad * 2)) - 2.5
        self:Collided()
    end

    if self.y <= 0 then
        if self.sin < 0 then
            self.speed = self.speed * self.SpeedDecRate
            self.ArrowRotation = math.rad(90)
        else
            self.speed = self.speed * self.SpeedIncRate
            if self.cos > 0 then
                self.cos = self.cos - 0.1
            else
                self.cos = self.cos + 0.1
            end
        end

        self.y = 2.5
        self:Collided()
    end
    
    if self.y >= WINDOW_HEIGHT - self.Rad * 2  then
        if self.sin > 0 and self.sin < self.SpeedIncRate then
            self.speed = self.speed * self.SpeedDecRate
            self.ArrowRotation = math.rad(270)
        else
            if self.cos > 0 then
                self.cos = self.cos - 0.1
            else
                self.cos = self.cos + 0.1
            end
            self.speed = self.speed * self.SpeedIncRate
        end

        self.y = (WINDOW_HEIGHT - (self.Rad * 2)) - 2.5
        self:Collided()
    end
end

function Player:OverlapWithBarrier(other)
    if self:BeginOverlap(other) then
        if self.x + self.width > other.x and self.x + self.width < other.x + (other.width * 0.5) then
            if self.cos > 0 then
                self.ArrowRotation = math.rad(180)
                self.speed = self.speed * self.SpeedDecRate
            else
                if self.sin < 0 then
                    self.sin = self.sin + 0.1
                else
                    self.sin = self.sin - 0.1
                end
                self.speed = self.speed * self.SpeedIncRate
            end
            self.x = self.x - 2.5
            self:Collided()

        elseif self.x < other.x + other.width and self.x > other.x + (other.width * 0.5) then
            if self.cos < 0 then
                self.ArrowRotation = math.rad(0)
                self.speed = self.speed * self.SpeedDecRate
            else
                if self.sin > 0 then
                    self.sin = self.sin + 0.1
                else
                    self.sin = self.sin - 0.1
                end
                self.speed = self.speed * self.SpeedIncRate
            end
            self.x = self.x + 2.5
            self:Collided()

        elseif self.y + self.height > other.y and self.y + self.height < other.y + (other.height * 0.5) then
            if self.sin > 0 then
                self.ArrowRotation = math.rad(270)
                self.speed = self.speed * self.SpeedDecRate
            else
                if self.cos < 0 then
                    self.cos = self.cos + 0.1
                else
                    self.cos = self.cos - 0.1
                end
                self.speed = self.speed * self.SpeedIncRate
            end
            self.y = self.y - 2.5
            self:Collided()

        elseif self.y < other.y + other.height and self.y > other.y + (other.height * 0.5) then
            if self.sin < 0 then
                self.ArrowRotation = math.rad(0)
                self.speed = self.speed * self.SpeedDecRate
            else
                if self.cos > 0 then
                    self.cos = self.cos + 0.1
                else
                    self.cos = self.cos - 0.1
                end
                self.speed = self.speed * self.SpeedIncRate
                self.speed = self.speed * self.SpeedIncRate
            end
            self.y = self.y + 2.5
            self:Collided()

        end
    end
end