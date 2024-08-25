local Card = {}
Card.__index = Card

setmetatable(Card, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
})

-- creates a copy of the Card table with all the methods
-- that have been added to the Card table
function Card.new(init)
    local self = setmetatable({}, Card)
    self.value = init
    return self
end

-- when the set_value of a copy of the Card table is called, it accesses
-- the local variable self and sets the value
function Card:set_value(newval)
    self.value = newval
end

function Card:get_value()
    return self.value
end

local mymodule = {}
mymodule.Card = Card
return mymodule
