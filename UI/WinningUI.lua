WinUI = Class:extend()

function WinUI:new()

end

function WinUI:update(dt)
    suit.Label("YouWon!", { align = "center "}, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 50, 50)
end

function WinUI:draw()
    suit.draw()
end