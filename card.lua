Card = {}
Card.__index = Card

setmetatable(Card, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

Card.WIDTH = 64

---creates a copy of the Card table with all the methods
---that have been added to the Card table
---@param color table a table of color values {255, 255, 255, 255} ({r, g, b, a})
---@return table
function Card.new(color, isActive)
    local self = setmetatable({}, Card)
    self.color = color
    self.isActive = isActive or false
    return self
end

-- when the set_value of a copy of the Card table is called, it accesses
-- the local variable self and sets the value
function Card:draw(xPos, yPos)
    love.graphics.setColor(love.math.colorFromBytes(
        self.color.r,
        self.color.g,
        self.color.b
    ))
    love.graphics.rectangle('fill', xPos, yPos, Card.WIDTH, Card.WIDTH)
end

function Card:get_color_bytes()
    return self.color
end

function Card:get_color()
    return love.math.colorFromBytes(
        self.color.r,
        self.color.g,
        self.color.b
    )
end

return Card
