local class = require 'code/lib/middleclass'

Zombie = class('Zombie')

function Zombie:initialize(x, y, v)
    self.x = x
    self.y = y
    self.radius = 22
    self.angle = 0
    self.speed = v
    self.hp = 3
end

function Zombie:update(dt)
    -- update angle to player
    local player_dx = game.player.x - self.x
    local player_dy = game.player.y - self.y
    self.angle = math.atan2(player_dy, player_dx)

    -- movement
    local vx = self.speed * math.cos(self.angle)
    local vy = self.speed * math.sin(self.angle)

    local d = math.sqrt(player_dx^2 + player_dy^2)
    if d > 10 then
        self.x = self.x + vx * dt
        self.y = self.y + vy * dt
    end

    -- bullets
    for i=1, #game.bullets.contents do
        local bullet = game.bullets.contents[i]
        local bullet_dx = bullet.x - self.x
        local bullet_dy = bullet.y - self.y
        local d = math.sqrt(bullet_dx^2 + bullet_dy^2)

        if d < self.radius + bullet.radius then
            self.hp = self.hp - 1
            bullet.to_delete = true

            -- sfx
            sounds.punch:setPitch(1.17^(2*math.random() - 1))
            sounds.punch:stop()
            sounds.punch:play()
        end
    end

    -- health
    if self.hp <= 0 then
        -- score
        game.score = game.score + 1

        -- sfx
        sounds.kill:setPitch(1.17^(1*math.random() - 0.5))
        sounds.kill:stop()
        sounds.kill:play()

        -- blood
        table.insert(game.blood, {x=self.x, y=self.y, angle=math.random() * 2 * math.pi})

        self.to_delete = true
    end
end

function Zombie:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.zombie, self.x, self.y, self.angle, 1, 1, 16, 22)
end
