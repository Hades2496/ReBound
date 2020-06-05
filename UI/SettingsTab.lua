Settings = Class:extend()

function Settings:new()
    self.soundImage = love.graphics.newImage("Images/Sound.png")
    self.musicImage = love.graphics.newImage("Images/Music.jpg")
    self.backArrow = love.graphics.newImage("Images/BackArrow.png")
end

function Settings:update(dt)
    suit.Slider(soundSlider, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 80, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 30, 150, 20)
    suit.Slider(musicSlider, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 80, WINDOW_HEIGHT / (2 * SCALE_FACTOR), 150, 20)

    if suit.ImageButton(self.backArrow, 10, 10).hit and paused then
        inSettings = false
        paused = false
    elseif suit.ImageButton(self.backArrow, 10, 10).hit then
        inSettings = false
        paused = false
    end

    if ui.GameStarted then
        if suit.Button("Quit Game", WINDOW_WIDTH / SCALE_FACTOR - 110, 10, 100, 50).hit then
            resetGame()
        end
    end
end 

function Settings:draw()
    love.graphics.draw(self.soundImage, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 120, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 30)
    love.graphics.draw(self.musicImage, WINDOW_WIDTH / (2 * SCALE_FACTOR) - 120, WINDOW_HEIGHT / (2 * SCALE_FACTOR))

    love.graphics.print(math.floor(soundSlider.value), WINDOW_WIDTH / (2 * SCALE_FACTOR) + 80, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 28)
    love.graphics.print(math.floor(musicSlider.value), WINDOW_WIDTH / (2 * SCALE_FACTOR) + 80, WINDOW_HEIGHT / (2 * SCALE_FACTOR) + 2)
end