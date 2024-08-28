Card = {}
Card.__index = Card

setmetatable(Card, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

Card.WIDTH = 64
Card.SIZE_TABLE = { 48, 36, 16 }

---creates a copy of the Card table with all the methods
---that have been added to the Card table
---@param color table a table of color values {255, 255, 255, 255} ({r, g, b, a})
---@return table
function Card.new(color, turnsLeft)
    local self = setmetatable({}, Card)
    self.color = color
    self.turnsLeft = turnsLeft
    self.isActive = true
    if self.turnsLeft > 0 then
        self.isActive = false
    end
    return self
end

-- when the set_value of a copy of the Card table is called, it accesses
-- the local variable self and sets the value
function Card:draw(xPos, yPos)
    local size = Card.SIZE_TABLE[self.turnsLeft + 1]
    local topX = xPos - size / 2
    local topY = yPos - size / 2

    if self.turnsLeft == 0 then
        love.graphics.setColor({ 1, 1, 1, 0.5 })
        love.graphics.rectangle('line', topX - 4, topY - 4, size + 8, size + 8)
    end

    love.graphics.setColor(love.math.colorFromBytes(
        self.color.r,
        self.color.g,
        self.color.b
    ))
    love.graphics.rectangle('fill', topX, topY, size, size)
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

---TODO: replace '3' with a constant
function Card:countdown()
    self.turnsLeft = (self.turnsLeft + 3 - 1) % 3
    if self.turnsLeft == 0 then self.isActive = true end
end

return Card
