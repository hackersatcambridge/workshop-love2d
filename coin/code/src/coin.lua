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

Coin = class('Coin')

function Coin:initialize(x, y)
    self.x = x
    self.y = y

    self.radius = 28

    self.timeToLive = 6.5
end

function Coin:update(dt)
    -- check if player is touching
    local dx = game.player.x - self.x
    local dy = game.player.y - self.y
    local d = math.sqrt(dx ^ 2 + dy ^ 2)
    if d < self.radius + game.player.radius then
        -- score
        game.score = game.score + 1

        -- sfx
        sounds.coin:stop()
        sounds.coin:play()

        self.to_delete = true
    end

    self.timeToLive = self.timeToLive - dt

    -- check for timeout
    if self.timeToLive < 0 then
        self.to_delete = true
    end
end

function Coin:draw()
    -- make coin flash when it's about to disappear
    if self.timeToLive > 1.5 or math.sin(5 * self.timeToLive * 2 * math.pi) > 0 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.coin, self.x, self.y, 0, 1, 1, 28, 28)
    end
end
