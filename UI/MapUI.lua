MapUI = Class:extend()

function MapUI:new()
    self.backArrowImage = love.graphics.newImage("Images/BackArrow.png")
end

function MapUI:update(dt)
    if suit.Button("Level 1", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 200, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 100, 100, 50).hit and credit > 200 then
        map = Level1()
        inMapUI = false
        ui.Constructor = true
        ui.GameStarted = true
    end

    if suit.Button("Melee Boss Level", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 75, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 100, 100, 50).hit and credit > 1000 then
        map = MeleeDudeMap()
        ui.Constructor = true
        ui.GameStarted = true
        inMapUI = false
    end

    if suit.Button("Level 3", WINDOW_WIDTH / (2 * SCALE_FACTOR) + 50, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 100, 100, 50).hit and credit > 10000 then
        -- TODO
    end

    if suit.ImageButton(self.backArrowImage, 10, 10).hit then
        inMapUI = false
    end
end