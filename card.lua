local Card = {}
Card.__index = Card

setmetatable(Card, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

-- creates a copy of the Card table with all the methods
-- that have been added to the Card table
-- color is a table of color values {255, 255, 255, 255} ({r, g, b, a})
function Card.new(color)
    local self = setmetatable({}, Card)
    self.color = color
    self.isActive = false
    return self
end

-- when the set_value of a copy of the Card table is called, it accesses
-- the local variable self and sets the value
function Card:draw(xPos, yPos, width)
    love.graphics.setColor(love.math.colorFromBytes(
        self.color.r,
        self.color.g,
        self.color.b
    ))
    love.graphics.rectangle('fill', xPos, yPos, width, width)
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

local mymodule = {}
mymodule.Card = Card
return mymodule
