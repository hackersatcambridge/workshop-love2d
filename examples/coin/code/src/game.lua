--[[
Copyright (c) 2017 George Prosser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local class = require 'code/lib/middleclass'
local stateful = require 'code/lib/stateful'

Game = class('Game')
Game:include(stateful)

function Game:initialize(state)
    self:gotoState(state)
end

Menu = Game:addState('Menu')
Play = Game:addState('Play')
GameOver = Game:addState('GameOver')

-- Menu

function Menu:update(dt)
    -- start the game when the player presses a key
    if love.keyboard.isDown('space', 'return', 'up', 'down', 'left', 'right', 'w', 's', 'a', 'd') then
        self:gotoState('Play')
        return
    end
end

function Menu:draw()
    -- draw ground
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    -- draw title
    love.graphics.setFont(fonts.huge)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('CÖIN', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 200, 1000, 'center')

    -- press start
    if math.cos(2 * math.pi * love.timer.getTime()) > 0 then
        love.graphics.setFont(fonts.large)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf('PRESS START', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 + 50, 1000, 'center')
    end
end

-- Play

function Play:enteredState()
    -- music
    music.main:play()

    self.player = Player:new()
    self.director = Director:new()
    self.coins = Container:new()

    -- score
    self.score = 0

    -- timer
    self.timeLeft = 30
end

function Play:update(dt)
    self.player:update(dt)
    self.director:update(dt)
    self.coins:update(dt)

    -- update timer
    self.timeLeft = self.timeLeft - dt
    if self.timeLeft < 0 then
        self:gotoState('GameOver')
        return
    end

    -- back to menu
    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
        return
    end
end

function Play:draw()
    -- draw ground
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    self.coins:draw()
    self.player:draw()

    -- print score
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(self.score, nativeCanvasWidth - 1000 - 20, 0, 1000, 'right')

    -- print timer
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(255, 255, 255)
    local seconds = round(self.timeLeft)
    if seconds < 10 then
        if math.cos(self.timeLeft * 12) > 0 then
            love.graphics.printf('0:0' .. seconds, 20, 0, 1000, 'left')
        end
    else
        love.graphics.printf('0:' .. seconds, 20, 0, 1000, 'left')
    end
end

function Play:exitedState()
    -- music
    music.main:stop()
end

-- GameOver

function GameOver:enteredState()
    -- sound effect
    sounds.clapping:play()

    -- timer
    self.initTime = love.timer.getTime()
end

function GameOver:update(dt)
    -- go back to menu after 10 seconds
    if love.timer.getTime() - self.initTime > 10 then
        self:gotoState('Menu')
        return
    end

    -- back to menu
    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
        return
    end
end

function GameOver:draw()
    -- draw ground
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    -- print score
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('You scored ' .. self.score .. '!', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 100, 1000, 'center')
end

function GameOver:exitedState()
    -- sound effect
    sounds.clapping:stop()
end
