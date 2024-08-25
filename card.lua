local Card = {}
Card.__index = Card

setmetatable(Card, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

-- creates a copy of the Card table with all the methods
-- that have been added to the Card table
-- color is a table of color values {1, 1, 1, 1} ({r, g, b, a})
function Card.new(color)
    local self = setmetatable({}, Card)
    self.color = color
    self.isActive = false
    return self
end

-- when the set_value of a copy of the Card table is called, it accesses
-- the local variable self and sets the value
function Card:draw(xPos, yPos, width)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', xPos, yPos, width, width)
end

local mymodule = {}
mymodule.Card = Card
return mymodule
