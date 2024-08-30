Gamestates = require "gamestates"

---TODO: enable music
-- music = love.audio.newSource("sounds/music/S31-Night Prowler.ogg")
-- music:setLooping(true)

function love.load()
    local love_window_width = 1024
    local love_window_height = 640
    love.window.setMode(love_window_width,
        love_window_height,
        { fullscreen = false })
    Gamestates.set_state("states/menu")
end

function love.update(dt)
    Gamestates.state_event("update", dt)
end

function love.draw()
    Gamestates.state_event("draw")
end

function love.keyreleased(key, code)
    Gamestates.state_event("keyreleased", key, code)
end

function love.mousereleased(x, y, button, istouch)
    Gamestates.state_event("mousereleased", x, y, button, istouch)
end

function love.quit()
    print("Thanks for playing! Come back soon!")
end
