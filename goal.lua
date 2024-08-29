dofile("utils.lua")

Goal = {}
Goal.__index = Goal

setmetatable(Goal, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

function Goal.new(color, x, y, width, timeLeft)
    local self = setmetatable({}, Goal)
    self.color = color
    self.x = x
    self.y = y
    self.width = width
    self.maxTimeLeft = timeLeft
    self.timeLeft = timeLeft
    self.isActive = false
    return self
end

function Goal:draw()
    love.graphics.origin()
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.width)
end

function Goal:set_active()
    self.isActive = true
end

function Goal:set_inactive()
    self.isActive = false
end

function Goal:set_color(color)
    self.color = color
end

function Goal:reset_timer()
    self.timeLeft = self.maxTimeLeft
end

function Goal:countdown(dt)
    if self.isActive then
        self.timeLeft = self.timeLeft - dt
    end
end

return Goal
