Shop = Class:extend()

function Shop:new()
    self.backArrowImage = love.graphics.newImage("Images/BackArrow.png")
end

function Shop:update(dt)
    if suit.Button("SlowMo", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 200, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 100, 100, 50).hit and credit > 200 then
        abilities.canSlowmo = true
    end

    if suit.Button("Tmp", WINDOW_WIDTH / (2 * SCALE_FACTOR) - 75, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 100, 100, 50).hit and credit > 1000 then
        abilities.canTmp = true
    end

    if suit.Button("FollowMouse", WINDOW_WIDTH / (2 * SCALE_FACTOR) + 50, WINDOW_HEIGHT / (2 * SCALE_FACTOR) - 100, 100, 50).hit and credit > 10000 then
        abilities.canFollowMouse = true
    end

    if suit.ImageButton(self.backArrowImage, 10, 10).hit then
        inShop = false
    end

    suit.Label("Credit: "..credit, { align = "center" }, WINDOW_WIDTH / SCALE_FACTOR - 200, 10, 110, 50)
end