Goal = {}
Goal.__index = Goal

setmetatable(Goal, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

function Goal.new(color, x, y, width, timeLeft, epsilon)
    local self = setmetatable({}, Goal)
    self.color = color
    self.x = x
    self.y = y
    self.width = width
    self.maxTimeLeft = timeLeft
    self.epsilon = epsilon
    self.timeLeft = timeLeft
    self.isActive = false
    self.hasMatch = false
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

function Goal:reset(newColor)
    self.set_color(self, newColor)
    self.timeLeft = self.maxTimeLeft
    self.hasMatch = false
end

function Goal:countdown(dt)
    if self.isActive then
        self.timeLeft = self.timeLeft - dt
    end
end

function Goal:set_epsilon(epsilon)
    self.epsilon = epsilon
end

---@param mix table mix of the selected color and color in mixbox
function Goal:check_mix(mix)
    local isRedMatch = math.abs(mix.r - self.color.r) <= self.epsilon
    local isGreenMatch = math.abs(mix.g - self.color.g) <= self.epsilon
    local isBlueMatch = math.abs(mix.b - self.color.b) <= self.epsilon

    if isRedMatch and isGreenMatch and isBlueMatch then
        self.hasMatch = true
    end
end

return Goal
