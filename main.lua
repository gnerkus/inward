local card_module = require "card"

function love.load()
    CardWidth = 64
    Board = {
        card_module.Card.new({ 1, 0, 0, 1 }),
        card_module.Card.new({ 0, 1, 0, 1 }),
        card_module.Card.new({ 0, 0, 1, 1 }),
        card_module.Card.new({ 1, 1, 0, 1 }),
        card_module.Card.new({ 1, 0, 1, 1 }),
        card_module.Card.new({ 0, 1, 1, 1 }),
        card_module.Card.new({ 1, 1, 1, 1 }),
        card_module.Card.new({ 0, 0, 0, 1 }),
        card_module.Card.new({ 1, 0, 0, 1 }),
    }
    BoardX = 64
    BoardY = 64
    BoardSize = 3
end

function love.draw()
    love.graphics.origin()

    for cardIdx, card in ipairs(Board) do
        card:draw(
            BoardX + ((cardIdx - 1) % BoardSize) * CardWidth,
            BoardY + math.floor((cardIdx - 1) / BoardSize) * CardWidth,
            CardWidth
        )
    end
end
