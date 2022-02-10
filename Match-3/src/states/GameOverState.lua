--[[
    GD50
    Match-3 Remake

    Author: Joe Raad

    - GameOverState Class-

    State that simply shows us our score when we finally lose.
    
    Credit for base code:
    Colton Ogden
]]
GameOverState = Class {__includes = BaseState}

function GameOverState:init()
end

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        gStateMachine:change("start")
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts["large"])

    love.graphics.setColor(1, 1, 1, 128 / 255)

    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 64, 64, 128, 136, 4)

    love.graphics.setColor(99 / 255, 155 / 255, 1, 1)

    love.graphics.printf("GAME OVER", VIRTUAL_WIDTH / 2 - 64, 64, 128, "center")

    love.graphics.setFont(gFonts["medium"])
    love.graphics.printf("Your Score: " .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, "center")
    love.graphics.printf("Press Enter", VIRTUAL_WIDTH / 2 - 64, 180, 128, "center")
end
