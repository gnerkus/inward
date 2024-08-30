local menu = {}

function menu.load()
    local clickMe = UI.button({
        text = 'Click me!',
        x = 10,
        y = 10,
        w = 200,
    })

    local num = 0
    clickMe:action(function(e)
        num = num + 1
        e.target.text = 'You clicked me ' .. num .. ' times!'
    end)

    UI:add(clickMe)
end

function menu.keyreleased(key, code)
    if key == "return" then
        Gamestates.set_state("states/game", { current_level = 1 })
    elseif key == 'escape' then
        love.event.quit()
    end
end

function menu.update(dt)

end

function menu.draw()

end

return menu
