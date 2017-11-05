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