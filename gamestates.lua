dofile("utils.lua")

local gamestates = {}

local loaded = {}
local current_state = nil

function gamestates.set_state(state_name, ...)
    gamestates.state_event('exit')
    local old_state_name = GetKeyForValue(loaded, current_state)
    current_state = loaded[state_name]
    if not current_state then
        current_state = require(state_name)
        loaded[state_name] = current_state
        gamestates.state_event('load', old_state_name, ...)
    end
    gamestates.state_event('enter', old_state_name, ...)
end

function gamestates.state_event(function_name, ...)
    if current_state and type(current_state[function_name]) == 'function' then
        current_state[function_name](...)
    end
end

return gamestates
