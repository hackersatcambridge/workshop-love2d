local class = require 'code/lib/middleclass'

Bullet = class('Bullet')

function Bullet:initialize(x, y, a, v)
    self.x = x
    self.y = y
    self.angle = a
    self.vx = v * math.cos(a)
    self.vy = v * math.sin(a)
    self.radius = 3
    self.startTime = love.timer.getTime()
end

function Bullet:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if love.timer.getTime() - self.startTime > 3 then
        self.to_delete = true
    end
end

function Bullet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.bullet, self.x, self.y, self.angle, 1, 1, 8, 8)
end
