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

require 'code/lib/misc'
require 'code/src/game'
require 'code/src/player'
require 'code/src/coin'
require 'code/src/container'
require 'code/src/director'
require 'code/lib/anal'

function love.load()
    -- canvas
    nativeWindowWidth = 1280
    nativeWindowHeight = 720

    nativeCanvasWidth = 1280
    nativeCanvasHeight = 720

    canvas = love.graphics.newCanvas(nativeCanvasWidth, nativeCanvasHeight)
    canvas:setFilter('linear', 'linear', 2) 
 
    -- assets
    -- fonts
    fonts = {}
    fonts.huge = love.graphics.newFont('assets/fonts/Gamer.ttf', 256)
    fonts.large = love.graphics.newFont('assets/fonts/Gamer.ttf', 128)

    -- images
    love.graphics.setDefaultFilter('nearest', 'nearest', 1)

    images = {}
    images.ground = love.graphics.newImage('assets/images/ground.png')
    images.coin = love.graphics.newImage('assets/images/coin.png')

    -- animations
    animations = {}
    animations.player = {}
    local frameTime = 0.15
    animations.player.up = newAnimation(love.graphics.newImage('assets/images/player/up.png'), 128, 128, frameTime, 4)
    animations.player.down = newAnimation(love.graphics.newImage('assets/images/player/down.png'), 128, 128, frameTime, 4)
    animations.player.left = newAnimation(love.graphics.newImage('assets/images/player/left.png'), 128, 128, frameTime, 4)
    animations.player.right = newAnimation(love.graphics.newImage('assets/images/player/right.png'), 128, 128, frameTime, 4)

    -- music
    music = {}
    music.main = love.audio.newSource('assets/music/music.wav', 'stream')
    music.main:setVolume(0.25)
    music.main:setLooping(true)

    -- sounds
    sounds = {}
    sounds.footstep = love.audio.newSource('assets/sounds/footstep.wav', 'static')
    sounds.footstep:setVolume(0.25)
    sounds.coin = love.audio.newSource('assets/sounds/coin.ogg', 'static')
    sounds.clapping = love.audio.newSource('assets/sounds/clapping.wav', 'static')

    -- seed random function
    math.randomseed(os.time())

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
    love.graphics.draw(canvas, windowOffsetX, windowOffsetY, 0, windowScale, windowScale)

    -- letterboxing
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', windowWidth - windowOffsetX, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', 0, 0, windowWidth, windowOffsetY)
    love.graphics.rectangle('fill', 0, windowHeight - windowOffsetY, windowWidth, windowOffsetY)
end