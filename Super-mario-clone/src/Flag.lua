--[[
    GD50
    Super Mario Bros. Remake

    -- Flag Class --

    Flag Class is a subclass of GameObject. It is used to represent the flag at the end of the level.
    It is used to draw and update the flag pole and animated flag cloth.

    Author: Joe Raad
]]
Flag = Class {__includes = GameObject}

function Flag:init(def)
    GameObject.init(self, def)
    self.animation =
        Animation {
        frames = {(self.texture * 2) - 1, self.texture * 2},
        interval = 0.2
    }
    self.currentAnimation = self.animation
end

function Flag:update(dt)
    GameObject.update(self, dt)
    self.currentAnimation:update(dt)
end

function Flag:render()
    love.graphics.draw(gTextures["flags"], gFrames["flags"][self.texture], self.x, self.y)
    love.graphics.draw(
        gTextures["flag_cloths"],
        gFrames["flag_cloths"][(self.currentAnimation:getCurrentFrame())],
        self.x + 6,
        self.y + 5
    )
end
