--[[
    PauseState Class

    Author: Joe Raad

    The PauseState is the state used to handle and display game pausing.

]]
PauseState = Class {__includes = BaseState}

function PauseState:init()
end

function PauseState:update(dt)
    if love.keyboard.wasPressed("p") then
        gStateMachine:change(
            "play",
            {
                bird = self.bird,
                pipePairs = self.pipePairs,
                score = self.score
            }
        )
    end
end

function PauseState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print("Score: " .. tostring(self.score), 8, 8)

    self.bird:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf("||", 0, 120, VIRTUAL_WIDTH, "center")
end

--[[
    Called when this state is transitioned to from another state.
]]
function PauseState:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.score = params.score

    scrolling = false

    sounds["pause"]:play()
    sounds["music"]:pause()
    Bird.togglePause()
    Pipe.togglePause()
end

--[[
    Called when this state changes to another state.
]]
function PauseState:exit()
    scrolling = true
    sounds["pause"]:play()
    sounds["music"]:play()
    Bird.togglePause()
    Pipe.togglePause()
end
