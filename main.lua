dofile("utils.lua")
Gamestates = require "gamestates"
Urutora = require("libs/urutora")
UI = Urutora:new()

local bg = love.graphics.newImage('img/bg4.png')
local bgColor = { 0.1, 0.1, 0.2 }

local uiStyle = {
    outline = false,
    cornerRadius = 0.5
}


---TODO: enable music
-- music = love.audio.newSource("sounds/music/S31-Night Prowler.ogg")
-- music:setLooping(true)

function love.load()
    Gamestates.set_state("states/menu")
    UI:setStyle(uiStyle)
    BGCanvas = love.graphics.newCanvas(1024, 640)
    BGCanvas:setFilter('nearest', 'nearest')
    local proggyTiny = love.graphics.newFont("fonts/proggy/ProggyTiny.ttf", 32)
    UI.utils.default_font = proggyTiny
end

function love.update(dt)
    Gamestates.state_event("update", dt)
    UI:update(dt)
end

function love.draw()
    love.graphics.setCanvas({ canvas = BGCanvas, stencil = true })
    love.graphics.clear(bgColor)
    love.graphics.setColor(1, 1, 1)
    ---draw background
    love.graphics.draw(
        bg,
        BGCanvas:getWidth() / 2,
        BGCanvas:getHeight() / 2,
        0,
        BGCanvas:getWidth() / bg:getWidth() * 3,
        BGCanvas:getHeight() / bg:getHeight() * 3,
        bg:getWidth() / 2,
        bg:getHeight() / 2
    )
    UI:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
    Gamestates.state_event("draw")
end

function love.keyreleased(key, code)
    Gamestates.state_event("keyreleased", key, code)
end

function love.mousereleased(x, y, button, istouch)
    Gamestates.state_event("mousereleased", x, y, button, istouch)
    UI:released(x, y, button)
end

function love.mousepressed(x, y, button)
    UI:pressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    UI:moved(x, y, dx, dy)
end

function love.textinput(text)
    UI:textinput(text)
end

function love.keypressed(k, scancode, isrepeat)
    UI:keypressed(k, scancode, isrepeat)
end

function love.wheelmoved(x, y)
    UI:wheelmoved(x, y)
end

function love.quit()
    print("Thanks for playing! Come back soon!")
end
