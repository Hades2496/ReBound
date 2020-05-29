UI = Class:extend()

function UI:new()
    self.Constructor = false
    self.GameStarted = false

    self.SettingsImage = love.graphics.newImage("Images/SettingsImage.png")
end

function UI:update(dt)
    if suit.Button("PressToPlay", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 - 50, 100, 50).hit then
        self.Constructor = true
        self.GameStarted = true
    end

    if suit.Button("Shop", WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 + 25, 100, 50).hit then
    
    end
    
    if suit.ImageButton(self.SettingsImage, 10, 10).hit then
        set = Settings()
        inSettings = true
    end
end

function UI:draw()
    suit.draw()
end