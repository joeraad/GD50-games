--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Joe Raad

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.

    Credit for base code:
    Colton Ogden
]]
PlayState = Class {__includes = BaseState}

-- Global lists to track our powerups and balls
gPowerUps = {}
gBalls = {}

-- Variables to track when a key powerup should spawn and if the player has aquired a key.

local keyTimer = 0
local keyTimerLimit = 5
gHasKey = false

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    -- Transfer over recovery points required from previous level
    if params.recoverPoints == nil then
        self.recoverPoints = 5000
    else
        self.recoverPoints = params.recoverPoints
    end

    -- Give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    -- Reset balls and powerups tables for each level
    gBalls = {}
    gPowerUps = {}

    -- Add ball from serve state to the balls table
    table.insert(gBalls, self.ball)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed("space") then
            self.paused = false
            gSounds["pause"]:play()
        else
            return
        end
    elseif love.keyboard.wasPressed("space") then
        self.paused = true
        gSounds["pause"]:play()
        return
    end

    self.paddle:update(dt)

    for k, ball in pairs(gBalls) do
        ball:update(dt)
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --
            -- if we hit the paddle on its left side while moving left...

            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                -- else if we hit the paddle on its right side while moving right...
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds["paddle-hit"]:play()
        end
    end

    for k, brick in pairs(self.bricks) do
        -- only check collision if we're in play
        if brick.inPlay then
            for j, ball in pairs(gBalls) do
                if ball:collides(brick) then
                    -- Add to score
                    -- Locked bricks always give out same points
                    if (brick.locked and gHasKey) then
                        self.score = self.score + 5000
                        gLockedBricksCounter = gLockedBricksCounter - 1
                    else
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    end

                    -- trigger the brick's hit function
                    brick:hit()

                    -- if we have enough points, recover a point of health and increase paddle size
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)

                        -- cannot go above size 4 paddle
                        self.paddle.size = math.min(4, self.paddle.size + 1)
                        self.paddle.width = self.paddle.size * 32

                        -- increase recover points by a random factor between 0.1 and 2
                        self.recoverPoints =
                            self.recoverPoints + math.min(100000, self.recoverPoints * math.random(0.1, 2))

                        -- play recover sound effect
                        gSounds["recover"]:play()
                    end

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds["victory"]:play()

                        gStateMachine:change(
                            "victory",
                            {
                                level = self.level,
                                paddle = self.paddle,
                                health = self.health,
                                score = self.score,
                                highScores = self.highScores,
                                ball = self.ball,
                                recoverPoints = self.recoverPoints
                            }
                        )
                    end

                    --
                    -- collision code for bricks
                    --
                    -- we check to see if the opposite side of our velocity is outside of the brick;
                    -- if it is, we trigger a collision on that side. else we're within the X + width of
                    -- the brick and should check to see if the top or bottom edge is outside of the brick,
                    -- colliding on the top or bottom accordingly
                    --

                    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    if ball.x + 2 < brick.x and ball.dx > 0 then
                        -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                        -- so that flush corner hits register as Y flips, not X flips
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x - 8
                    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                        -- top edge if no X collisions, always check
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x + 32
                    elseif ball.y < brick.y then
                        -- bottom edge if no X collisions or top collision, last possibility
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y - 8
                    else
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y + 16
                    end

                    -- slightly scale the y velocity to speed up the game, capping at +- 150
                    if math.abs(ball.dy) < 150 then
                        ball.dy = ball.dy * 1.02
                    end

                    -- only allow colliding with one brick, for corners
                    break
                end
            end
        end
    end

    -- if a ball goes below bounds, remove it from play
    for k, ball in pairs(gBalls) do
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(gBalls, k)
        end
    end

    -- check if there are no more balls in play and if so, reduce player health and paddle size
    if table.empty(gBalls) then
        self.health = self.health - 1

        -- cannot go below size 1 paddle
        self.paddle.size = math.max(1, self.paddle.size - 1)
        self.paddle.width = self.paddle.size * 32

        gSounds["hurt"]:play()

        -- if we have no health left, transition to the game over state
        -- else transition to the serve state
        if self.health == 0 then
            gStateMachine:change(
                "game-over",
                {
                    score = self.score,
                    highScores = self.highScores
                }
            )
        else
            gStateMachine:change(
                "serve",
                {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints
                }
            )
        end
    end

    -- update all powerups
    for k, powerUp in pairs(gPowerUps) do
        powerUp:update(dt)
        -- remove powerup if it's off screen
        if powerUp.y >= VIRTUAL_HEIGHT then
            powerUp.inPlay = false
        end
        -- powerup collides with paddle
        if powerUp:collides(self.paddle) then
            if powerUp.inPlay then
                powerUp.inPlay = false
                powerUp.y = powerUp.y - 8
                if (powerUp.skin == 10) then
                    gHasKey = true
                    gSounds["powerup-key"]:stop()
                    gSounds["powerup-key"]:play()
                else
                    table.insert(
                        gBalls,
                        Ball(powerUp.x, self.paddle.y - 8, math.random(-200, 200), -math.random(50, 100))
                    )
                    gSounds["powerup"]:stop()
                    gSounds["powerup"]:play()
                end
            end
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed("escape") then
        love.event.quit()
    end

    if not gHasKey and gLockedBricksCounter > 0 then
        keyTimer = keyTimer + dt
        if keyTimer >= keyTimerLimit then
            keyTimer = 0
            keyTimerLimit = math.random(4, 7)
            Powerup:spawnKey()
        end
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    for k, ball in pairs(gBalls) do
        ball:render()
    end

    for k, powerUp in pairs(gPowerUps) do
        powerUp:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    renderKey()

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts["large"])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, "center")
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end
