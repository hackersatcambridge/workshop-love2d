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

Player = class('Player')

function Player:initialize()
    self.x = nativeCanvasWidth/2
    self.y = nativeCanvasHeight/2

    self.radius = 32

    self.direction = 'right'
    self.lastFootstepTime = 0
end

function Player:update(dt)
    -- movement
    local speed = 400
    local walking = true

    if love.keyboard.isDown('up', 'w') then
        self.y = self.y - speed * dt
        self.direction = 'up'
        animations.player.up:update(dt)
        animations.player.down:reset()
        animations.player.left:reset()
        animations.player.right:reset()
    elseif love.keyboard.isDown('down', 's') then
        self.y = self.y + speed * dt
        self.direction = 'down'
        animations.player.up:reset()
        animations.player.down:update(dt)
        animations.player.left:reset()
        animations.player.right:reset()
    elseif love.keyboard.isDown('left', 'a') then
        self.x = self.x - speed * dt
        self.direction = 'left'
        animations.player.up:reset()
        animations.player.down:reset()
        animations.player.left:update(dt)
        animations.player.right:reset()
    elseif love.keyboard.isDown('right', 'd') then
        self.x = self.x + speed * dt
        self.direction = 'right'
        animations.player.up:reset()
        animations.player.down:reset()
        animations.player.left:reset()
        animations.player.right:update(dt)
    else
        walking = false
        animations.player.up:reset()
        animations.player.down:reset()
        animations.player.left:reset()
        animations.player.right:reset()
    end

    -- keep player on screen
    self.x = clamp(self.x, 0 + self.radius, nativeCanvasWidth - self.radius)
    self.y = clamp(self.y, 0 + self.radius, nativeCanvasHeight - self.radius)

    -- footstep sfx
    if walking then
        local currentTime = love.timer.getTime()
        if currentTime - self.lastFootstepTime > 0.3 then
            sounds.footstep:setPitch(1.17 ^ (2 * math.random() - 1))
            sounds.footstep:stop()
            sounds.footstep:play()
            self.lastFootstepTime = currentTime
        end
    end
end

function Player:draw()
    -- set the right animation to use for the player
    local anim
    if self.direction == 'up' then
        anim = animations.player.up
    elseif self.direction == 'down' then
        anim = animations.player.down
    elseif self.direction == 'left' then
        anim = animations.player.left
    elseif self.direction == 'right' then
        anim = animations.player.right
    end

    -- draw the player
    love.graphics.setColor(255, 255, 255)
    anim:draw(self.x, self.y, 0, 1, 1, 64, 64)
end
