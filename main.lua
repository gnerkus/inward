Gamestates = require "gamestates"
Urutora = require("libs/urutora")
UI = Urutora:new()

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
end

function love.update(dt)
    Gamestates.state_event("update", dt)
    UI:update(dt)
end

function love.draw()
    UI:draw()
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
