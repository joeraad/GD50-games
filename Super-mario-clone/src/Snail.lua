--[[
    GD50
    Super Mario Bros. Remake

    -- Snail Class --

    Author: Joe Raad
    
    Snail Class is a subclass of Entity. It is used to represent the snail enemy.
    It is used to draw the snail.

    Credit for base code:
    Colton Ogden
]]
Snail = Class {__includes = Entity}

function Snail:init(def)
    Entity.init(self, def)
end

function Snail:render()
    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8,
        math.floor(self.y) + 8,
        0,
        self.direction == "left" and 1 or -1,
        1,
        8,
        10
    )
end
