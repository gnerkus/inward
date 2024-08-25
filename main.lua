local card = require "card"

local instance = card.Card.new(5)
print(instance:get_value())
instance:set_value(6)
print(instance:get_value())
