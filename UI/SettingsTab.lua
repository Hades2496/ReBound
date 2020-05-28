Settings = Class:extend()

function Settings:new()
    self.soundImage = love.graphics.newImage("Images/Sound.png")
    self.musicImage = love.graphics.newImage("Images/Music.jpg")
    self.backArrow = love.graphics.newImage("Images/BackArrow.png")

    tmp = false
end

function Settings:update(dt)
    suit.Slider(soundSlider, WINDOW_WIDTH / 2 - 80, WINDOW_HEIGHT / 2 - 30, 150, 20)
    suit.Slider(musicSlider, WINDOW_WIDTH / 2 - 80, WINDOW_HEIGHT / 2, 150, 20)

    if suit.ImageButton(self.backArrow, 10, 10).hit then
        inSettings = false
    end
end 

function Settings:draw()
    suit.draw()
    love.graphics.draw(self.soundImage, WINDOW_WIDTH / 2 - 120, WINDOW_HEIGHT / 2 - 30)
    love.graphics.draw(self.musicImage, WINDOW_WIDTH / 2 - 120, WINDOW_HEIGHT / 2)

    love.graphics.print(math.floor(soundSlider.value), WINDOW_WIDTH / 2 + 80, WINDOW_HEIGHT / 2 - 28)
    love.graphics.print(math.floor(musicSlider.value), WINDOW_WIDTH / 2 + 80, WINDOW_HEIGHT / 2 + 2)
end