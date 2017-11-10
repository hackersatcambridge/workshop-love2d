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

Director = class('Director')

function Director:initialize()
    self.time = 0
    self.nextSpawnTime = 0
end

function Director:update(dt)
    self.time = self.time + dt

    -- add a new zombie
    if self.time > self.nextSpawnTime then
        local angle = math.random() * 2 * math.pi
        local x = nativeCanvasWidth/2 + (nativeCanvasWidth + 30) * math.cos(angle)
        local y = nativeCanvasHeight/2 + (nativeCanvasHeight + 30) * math.sin(angle)
        local v = 25 + math.random(0, 30)

        game.zombies:add(Zombie:new(x, y, v))

        -- the magic formula! (increase difficulty over time, with some randomness)
        self.nextSpawnTime = self.time + 2.4*math.exp(-0.024 * self.time) + 0.4 + math.random()*0.7
    end
end