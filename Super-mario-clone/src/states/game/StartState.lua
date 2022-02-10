--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Joe Raad

    StartState Class is the state that is loaded when the game first starts or after the player dies.

    Credit for base code:
    Colton Ogden
]]
StartState = Class {__includes = BaseState}

function StartState:init()
    self.map = LevelMaker.generate(100, 10)
    self.background = math.random(3)
end

function StartState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("play")
    end
end

function StartState:render()
    love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)
    love.graphics.draw(
        gTextures["backgrounds"],
        gFrames["backgrounds"][self.background],
        0,
        gTextures["backgrounds"]:getHeight() / 3 * 2,
        0,
        1,
        -1
    )
    self.map:render()

    love.graphics.setFont(gFonts["title"])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf("Super 50 Bros.", 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("Super 50 Bros.", 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(gFonts["medium"])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf("Press Enter", 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, "center")
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("Press Enter", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, "center")
end

function drawFlag(variant, x, y)
    love.graphics.draw(gTextures["flags"], gFrames["flags"][variant], x, y - 48)
    love.graphics.draw(gTextures["flag_cloths"], gFrames["flag_cloths"][(variant) * 2], x + 6, y - 43)
end
