Level1 = Map:extend()

function Level1:new()
    self.super:new()

    MeleeBoss = Melee()
    
    Enemies = {}
    
    for i = 1, 6 do
        table.insert(Enemies, Enemy(math.random(0, WINDOW_WIDTH), math.random(0, WINDOW_HEIGHT)))
    end
end

function Level1:update(dt)
    self.super:update(dt)

    MeleeBoss:update(dt)
    
    for i, v in ipairs(Enemies) do
        v:update(dt)
    end 
end

function Level1:draw()
    self.super:draw()

    MeleeBoss:draw()
    
    for i, v in ipairs(Enemies) do
        v:draw()
    end 
end