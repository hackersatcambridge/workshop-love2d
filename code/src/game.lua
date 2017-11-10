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

function Menu:enteredState()
    music.menu:play()
end

function Menu:update(dt)
    -- start the game when the player presses space
    if love.keyboard.isDown('space', 'return', 'up', 'down', 'left', 'right', 'w', 'a', 's', 'd') then
        self:gotoState('Play')
        return
    end
end

function Menu:draw()
    -- draw background
    love.graphics.setColor(40, 40, 50)
    love.graphics.rectangle('fill', 0, 0, nativeCanvasWidth, nativeCanvasHeight)

    -- draw title
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(20, 20, 25)
    love.graphics.printf('ZÖMBIE', nativeCanvasWidth/2 - 500 + 5, nativeCanvasHeight/2 - 70 + 5, 1000, 'center')
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('ZÖMBIE', nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 - 70, 1000, 'center')

    -- insert coin
    if math.cos(2*math.pi*love.timer.getTime()) > 0 then
        love.graphics.setFont(fonts.small)
        love.graphics.setColor(20, 20, 25)
        love.graphics.printf('insert coin', nativeCanvasWidth/2 - 500 + 5, nativeCanvasHeight/2 + 50 + 5, 1000, 'center')
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf('insert coin', nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 + 50, 1000, 'center')
    end
end

function Menu:exitedState()
    music.menu:stop()
end


-- Play

function Play:enteredState()
    music.main:play()

    self.player = Player:new()
    self.bullets = Container:new()
    self.zombies = Container:new()
    self.director = Director:new()

    self.blood = {}

    self.score = 0

    self.playTime = love.timer.getTime()
end

function Play:update(dt)
    self.player:update(dt)
    self.bullets:update(dt)
    self.zombies:update(dt)
    self.director:update(dt)

    if self.player.alive == false then
        self:gotoState('GameOver')
    end

    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
    end
end

function Play:draw()
    -- draw ground
    love.graphics.setColor(255, 255, 255)

    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x=0, nativeCanvasWidth, w do
        for y=0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    for i=1, #self.blood do
        love.graphics.draw(images.blood, self.blood[i].x, self.blood[i].y, self.blood[i].angle, 1, 1, 32, 32)
    end

    self.player:draw()
    self.bullets:draw()
    self.zombies:draw()

    -- initial overlay
    local alpha = 0
    local t = love.timer.getTime() - self.playTime
    if t < 2 then
        alpha = 255 * (1 - t/2)
        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.rectangle('fill', 0, 0, nativeCanvasWidth, nativeCanvasHeight)
    end
end

function Play:exitedState()
    music.main:stop()
end


-- GameOver

function GameOver:enteredState()
    self.gameOverTime = love.timer.getTime()
end

function GameOver:update(dt)
    self.bullets:update(dt)
    self.zombies:update(dt)

    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
    end
end

function GameOver:draw()
    -- draw ground
    love.graphics.setColor(255, 255, 255)

    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x=0, nativeCanvasWidth, w do
        for y=0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    for i=1, #self.blood do
        love.graphics.draw(images.blood, self.blood[i].x, self.blood[i].y, self.blood[i].angle, 1, 1, 32, 32)
    end

    self.zombies:draw()

    -- overlay
    local alpha = 0
    local t = love.timer.getTime() - self.gameOverTime
    if t > 1 then
        if t < 3 then
            alpha = 200 * (t-1)/(3-1)
        else
            alpha = 200
        end
    end

    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.rectangle('fill', 0, 0, nativeCanvasWidth, nativeCanvasHeight)

    -- score
    if t > 3 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(fonts.medium)
        love.graphics.printf('you scored', nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 - 100, 1000, 'center')
        love.graphics.setFont(fonts.large)
        love.graphics.printf(self.score, nativeCanvasWidth/2 - 500, nativeCanvasHeight/2 - 50, 1000, 'center')
    end

    if t > 10 then
        self:gotoState('Menu')
    end
end

function GameOver:exitedState()
end