require 'code/lib/misc'
require 'code/src/game'
require 'code/src/player'
require 'code/src/zombie'
require 'code/src/container'
require 'code/src/director'
require 'code/src/bullet'

function love.load()
    -- canvas
    nativeWindowWidth = 640
    nativeWindowHeight = 360

    nativeCanvasWidth = 640
    nativeCanvasHeight = 360

    canvas = love.graphics.newCanvas(nativeCanvasWidth, nativeCanvasHeight)
    canvas:setFilter('nearest', 'nearest', 1)

    -- assets
    -- fonts
    fonts = {}
    fonts.large = love.graphics.newFont('assets/fonts/Gamer.ttf', 96)
    fonts.medium = love.graphics.newFont('assets/fonts/Gamer.ttf', 64)
    fonts.small = love.graphics.newFont('assets/fonts/Gamer.ttf', 32)

    -- images
    images = {}
    love.graphics.setDefaultFilter('nearest', 'nearest', 1)

    images.ground = love.graphics.newImage('assets/images/ground.png')
    images.player = love.graphics.newImage('assets/images/player.png')
    images.zombie = love.graphics.newImage('assets/images/zombie.png')
    images.blood = love.graphics.newImage('assets/images/blood.png')
    images.bullet = love.graphics.newImage('assets/images/bullet.png')

    -- music
    music = {}
    music.menu = love.audio.newSource('assets/music/menu.wav', 'stream')
    music.menu:setVolume(0.5)
    music.menu:setLooping(true)

    music.main = love.audio.newSource('assets/music/clearside.wav', 'stream')
    music.main:setVolume(0.35)
    music.main:setLooping(true)

    -- sounds
    sounds = {}
    sounds.footstep = love.audio.newSource('assets/sounds/footstep.wav', 'static')
    sounds.footstep:setVolume(0.1)

    sounds.gunshot = love.audio.newSource('assets/sounds/gunshot.wav', 'static')
    sounds.punch = love.audio.newSource('assets/sounds/punch.wav', 'static')
    sounds.kill = love.audio.newSource('assets/sounds/kill.wav', 'static')
    sounds.die = love.audio.newSource('assets/sounds/die.wav', 'static')

    -- shaders
    moonshine = require 'code/lib/moonshine'
    shaders = moonshine(moonshine.effects.filmgrain).chain(moonshine.effects.vignette)
    shaders.filmgrain.size = 4
    shaders.filmgrain.opacity = 0.1
    shaders.vignette.radius = 1.1
    shaders.vignette.opacity = 0.6

    -- seed random function
    math.randomseed(os.time())

    -- hide mouse
    love.mouse.setVisible(false)

    -- game
    game = Game:new('Menu')
end


function love.update(dt)
    -- determine window scale and offset
    windowScaleX = love.graphics.getWidth() / nativeWindowWidth
    windowScaleY = love.graphics.getHeight() / nativeWindowHeight
    windowScale = math.min(windowScaleX, windowScaleY)
    windowOffsetX = round((windowScaleX - windowScale) * (nativeWindowWidth * 0.5))
    windowOffsetY = round((windowScaleY - windowScale) * (nativeWindowHeight * 0.5))

    -- update game
    game:update(dt)
end


function love.draw()
    -- draw everything to canvas of native size, then upscale and offset
    love.graphics.setCanvas(canvas)
    game:draw()
    love.graphics.setCanvas()
    love.graphics.setColor(255, 255, 255)
    shaders.draw(function () love.graphics.draw(canvas, windowOffsetX, windowOffsetY, 0, windowScale, windowScale) end)

    -- letterboxing
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', windowWidth - windowOffsetX, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', 0, 0, windowWidth, windowOffsetY)
    love.graphics.rectangle('fill', 0, windowHeight - windowOffsetY, windowWidth, windowOffsetY)
end