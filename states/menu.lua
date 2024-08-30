local menu = {}

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
