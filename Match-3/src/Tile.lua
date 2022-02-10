--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Joe Raad
    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.

    Credit for base code:
    Colton Ogden
]]
Tile = Class {}

function Tile:init(x, y, color, variety)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    if math.random() <= 0.05 then
        self.shiny = true
    else
        self.shiny = false
    end
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    -- love.graphics.draw(gTextures["main"], gFrames["tiles"][self.color][self.variety], self.x + x + 2, self.y + y + 2)
    love.graphics.draw(
        gTextures["main"],
        gFrames["simpleTiles"][self.color][self.variety],
        self.x + x + 2,
        self.y + y + 2
    )

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    -- love.graphics.draw(gTextures["main"], gFrames["tiles"][self.color][self.variety], self.x + x, self.y + y)
    love.graphics.draw(gTextures["main"], gFrames["simpleTiles"][self.color][self.variety], self.x + x, self.y + y)

    if self.shiny then
        love.graphics.setColor(255, 215, 0, 100 / 255)
        love.graphics.rectangle("fill", self.x + x + 12, self.y + y + 1, 8, 30, 10)
        love.graphics.rectangle("fill", self.x + x + 1, self.y + y + 12, 30, 8, 10)
        love.graphics.setColor(255, 255, 255, 255)
    end
end
