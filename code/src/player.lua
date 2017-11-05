local class = require 'code/lib/middleclass'

Player = class('Player')

function Player:initialize()
    self.x = nativeCanvasWidth/2
    self.y = nativeCanvasHeight/2

    self.radius = 10

    self.angle = 0

    self.triggerReleased = false
    self.lastShotTime = 0

    self.lastFootstepTime = 0

    self.alive = true
end

function Player:update(dt)
    -- movement
    local speed = 200

    local vx = 0
    local vy = 0

    -- get input
    if love.keyboard.isDown('up', 'w') then
        vy = -speed
    elseif love.keyboard.isDown('down', 's') then
        vy = speed
    end

    if love.keyboard.isDown('left', 'a') then
        vx = -speed
    elseif love.keyboard.isDown('right', 'd') then
        vx = speed
    end

    -- calculate speed
    local v = math.sqrt(vx^2 + vy^2)
    if v > speed then
        vx = speed * vx / v
        vy = speed * vy / v
    end

    -- update position
    self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
    self.y = clamp(self.y + vy * dt, 0 + self.radius, nativeCanvasHeight - self.radius)

    local walking = v > 0

    if walking then
        -- set angle
        self.angle = math.atan2(vy, vx)

        -- footstep sfx
        local currentTime = love.timer.getTime()
        if currentTime - self.lastFootstepTime > 0.25 then
            sounds.footstep:setPitch(1.17^(math.random() - 0.5))
            sounds.footstep:stop()
            sounds.footstep:play()
            self.lastFootstepTime = currentTime
        end
    end

    -- shooting
    if love.keyboard.isDown('space', 'return') then
        if self.triggerReleased and love.timer.getTime() - self.lastShotTime > 0.15 then
            local gun_x = self.x + 32 * math.cos(self.angle) - 10 * math.sin(self.angle)
            local gun_y = self.y + 32 * math.sin(self.angle) + 10 * math.cos(self.angle)
            local angle = self.angle + math.random() * 0.2 - 0.1
            game.bullets:add(Bullet:new(gun_x, gun_y, angle, 1200))
            self.lastShotTime = love.timer.getTime()

            -- sfx
            sounds.gunshot:setPitch(1.17^(2*math.random() - 1))
            sounds.gunshot:stop()
            sounds.gunshot:play()

            -- recoil
            local recoil = 2
            self.x = self.x - recoil * math.cos(self.angle)
            self.y = self.y - recoil * math.sin(self.angle)
        end
        self.triggerReleased = false
    else
        self.triggerReleased = true
    end

    -- zombies
    for i=1, #game.zombies.contents do
        local zombie = game.zombies.contents[i]
        local zombie_dx = zombie.x - self.x
        local zombie_dy = zombie.y - self.y
        local d = math.sqrt(zombie_dx^2 + zombie_dy^2)

        if d < self.radius + zombie.radius then
            self.alive = false

            -- blood
            for i=1, 5 do
                table.insert(game.blood, {x=self.x+math.random(-20, 20), y=self.y+math.random(-20, 20), angle=math.random() * 2 * math.pi})
            end

            -- sfx
            sounds.die:play()
        end
    end
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)

    if love.timer.getTime() - self.lastShotTime < 1/60 then
        local gun_x = self.x + 40 * math.cos(self.angle) - 10 * math.sin(self.angle)
        local gun_y = self.y + 40 * math.sin(self.angle) + 10 * math.cos(self.angle)
        local r = 10 + math.random(20)
        love.graphics.circle('fill', gun_x, gun_y, r)
    end

    love.graphics.draw(images.player, self.x, self.y, self.angle, 1, 1, 16, 22)
end
