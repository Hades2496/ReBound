UI = Class:extend()

function UI:new()
    self.Constructor = false
    self.GameStarted = false

    self.SettingsImage = love.graphics.newImage("Images/SettingsImage.png")
end

function UI:update(dt)
    if suit.Button("Shop", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 50, WINDOW_HEIGHT / (2 * SCALE_FACTOR) + 25, 100, 50).hit then
        shop = Shop()
        inShop = true
    end

    if suit.Button("Levels", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 50, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 50, 100, 50).hit then
        mapui = MapUI()
        inMapUI = true
    end
    
    if suit.ImageButton(self.SettingsImage, 10, 10).hit then
        set = Settings()
        inSettings = true
    end
end
