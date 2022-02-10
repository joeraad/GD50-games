--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Joe Raad

    LevelMaker Class Handles the creation of Tiles and their behaviour for TileMaps.

    Credit for base code:
    Colton Ogden    
]]
LevelMaker = Class {}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    local keySpawned = false
    local lockSpawned = false
    local keyAndLockColor = math.random(1, 4)
    local lockBlock
    local flagHeight = 6
    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and x > 1 and (x < width - 2) then
            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                -- chance to generate bushes
                blockHeight = 2
                if x == width - 1 then
                    flagHeight = 4
                end
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(
                        objects,
                        GameObject {
                            texture = "bushes",
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            elseif math.random(8) == 1 then
                table.insert(
                    objects,
                    GameObject {
                        texture = "bushes",
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(
                    objects,
                    -- jump block
                    GameObject {
                        texture = "jump-blocks",
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,
                        -- collision function takes itself
                        onCollide = function(obj)
                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then
                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then
                                    -- maintain reference so we can set it to nil
                                    local gem =
                                        GameObject {
                                        texture = "gems",
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,
                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds["pickup"]:play()
                                            player.score = player.score + 100
                                        end
                                    }

                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(
                                        0.1,
                                        {
                                            [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                        }
                                    )
                                    gSounds["powerup-reveal"]:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds["empty-block"]:play()
                        end
                    }
                )
            end

            if math.random(20) == 1 and not lockSpawned then
                lockSpawned = true
                lockBlock =
                    GameObject {
                    texture = "keys-locks",
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    -- make it a random variant
                    frame = keyAndLockColor + 4,
                    collidable = true,
                    hit = false,
                    solid = true,
                    -- collision function takes itself
                    onCollide = function(obj)
                        -- spawn a gem if we haven't already hit the block
                        if not obj.hit then
                            obj.hit = true
                        end

                        gSounds["empty-block"]:play()
                    end,
                    onConsume = function(player, object)
                        gSounds["unlock-lock"]:play()
                        -- lockBlock.solid = false
                        -- lockBlock.consumable = true
                        player.score = player.score + 200

                        table.insert(
                            objects,
                            Flag {
                                texture = math.random(1, 4),
                                x = (width - 2) * TILE_SIZE,
                                y = ((flagHeight - 1) * TILE_SIZE) - (48 - TILE_SIZE),
                                width = 16,
                                height = 48,
                                -- make it a random variant
                                frame = 1,
                                collidable = true,
                                -- hit = false,
                                solid = false,
                                consumable = true,
                                -- collision function takes itself

                                onConsume = function(player, object)
                                    gSounds["pickup-flag"]:play()
                                    player.score = player.score + 300
                                    gStateMachine:change("play", player)
                                end
                            }
                        )
                    end
                }
                table.insert(objects, lockBlock)
            end
            if math.random(20) == 1 and lockSpawned and not keySpawned then
                keySpawned = true
                table.insert(
                    objects,
                    -- jump block
                    GameObject {
                        texture = "keys-locks",
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        -- make it a random variant
                        frame = keyAndLockColor,
                        collidable = true,
                        -- hit = false,
                        solid = false,
                        consumable = true,
                        -- collision function takes itself

                        onConsume = function(player, object)
                            gSounds["pickup-key"]:play()
                            lockBlock.solid = false
                            lockBlock.consumable = true
                        end
                    }
                )
            end
        end
    end
    if not lockSpawned then
        lockSpawned = true
        lockBlock =
            GameObject {
            texture = "keys-locks",
            x = (width - 2) * TILE_SIZE,
            y = (4 - 1) * TILE_SIZE,
            width = 16,
            height = 16,
            -- make it a random variant
            frame = keyAndLockColor + 4,
            collidable = true,
            hit = false,
            solid = true,
            -- collision function takes itself
            onCollide = function(obj)
                -- spawn a gem if we haven't already hit the block
                if not obj.hit then
                    obj.hit = true
                end

                gSounds["empty-block"]:play()
            end,
            onConsume = function(player, object)
                gSounds["unlock-lock"]:play()
                -- lockBlock.solid = false
                -- lockBlock.consumable = true
                player.score = player.score + 100
                table.insert(
                    objects,
                    Flag {
                        texture = math.random(1, 4),
                        x = (width - 2) * TILE_SIZE,
                        y = ((flagHeight - 1) * TILE_SIZE) - (48 - TILE_SIZE),
                        width = 16,
                        height = 48,
                        -- make it a random variant
                        frame = 1,
                        collidable = true,
                        -- hit = false,
                        solid = false,
                        consumable = true,
                        -- collision function takes itself

                        onConsume = function(player, object)
                            gSounds["pickup-flag"]:play()
                            player.score = player.score + 300
                            gStateMachine:change("play", player)
                        end
                    }
                )
            end
        }
        table.insert(objects, lockBlock)
    end
    if lockSpawned and not keySpawned then
        keySpawned = true
        table.insert(
            objects,
            -- jump block
            GameObject {
                texture = "keys-locks",
                x = (width - 5) * TILE_SIZE,
                y = (4 - 1) * TILE_SIZE,
                width = 16,
                height = 16,
                -- make it a random variant
                frame = keyAndLockColor,
                collidable = true,
                -- hit = false,
                solid = false,
                consumable = true,
                -- collision function takes itself

                onConsume = function(player, object)
                    gSounds["pickup-key"]:play()
                    lockBlock.solid = false
                    lockBlock.consumable = true
                end
            }
        )
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end
