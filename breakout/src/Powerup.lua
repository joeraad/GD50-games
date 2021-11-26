--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Joe Raad

    Represents a powerup which will slowly move down the screen
    until it hits the paddle and give the corresponding powerup.
    If it reaches the bottom of the screen, it will be destroyed.
]]
Powerup = Class {}

function Powerup:init(skin, x, y)
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 32
    --
    self.x = x
    self.y = y

    self.dy = 50

    self.inPlay = true

    -- this will effectively be the type of Powerup, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
    if (self.inPlay) then
        self.y = self.y + self.dy * dt
    end
end

function Powerup:render()
    -- gTexture is our global texture for all blocks
    -- gFrames["PowerUps"] is a table of quads mapping to each individual powerup skin in the texture
    if (self.inPlay) then
        love.graphics.draw(gTextures["main"], gFrames["PowerUps"][self.skin], self.x, self.y)
    end
end

function Powerup:spawn(x, y)
    table.insert(gPowerUps, Powerup(9, x, y))
end
function Powerup:spawnKey()
    table.insert(gPowerUps, Powerup(10, math.random(10, VIRTUAL_WIDTH - 10), 0))
end
