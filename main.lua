local card_module = require "card"

function love.load()
    ArenaWidth = 1024
    ArenaHeight = 640

    CardWidth = 64

    BoardOffsetX = 32
    BoardOffsetY = 32
    BoardOriginX = BoardOffsetX + (CardWidth * 9 / 2)
    BoardOriginY = BoardOffsetY + (CardWidth * 9 / 2)
    BoardSize = 3
    BoardTopX = BoardOriginX - (BoardSize / 2 * CardWidth)
    BoardTopY = BoardOriginY - (BoardSize / 2 * CardWidth)

    Board = {
        card_module.Card.new({ 0.75, 0, 0, 1 }),
        card_module.Card.new({ 0.75, 0.25, 0, 1 }),
        card_module.Card.new({ 0.75, 0.5, 0, 1 }),
        card_module.Card.new({ 0.5, 0.75, 0, 1 }),
        card_module.Card.new({ 0.25, 0.75, 0, 1 }),
        card_module.Card.new({ 0, 0.75, 0.25, 1 }),
        card_module.Card.new({ 0, 0.75, 0.5, 1 }),
        card_module.Card.new({ 0, 0.5, 0.75, 1 }),
        card_module.Card.new({ 0, 0.25, 0.75, 1 }),
    }

    whichCell = -1
end

-- return -1 if no card else card index
function mousePosToCardIdx(posX, posY)
    local outsideX = posX < BoardTopX or posX > BoardTopX + (BoardSize * CardWidth)
    local outsideY = posY < BoardTopY or posY > BoardTopY + (BoardSize * CardWidth)

    if outsideX or outsideY then
        return -1
    else
        local column = math.ceil((posX - BoardTopX) / CardWidth)
        local row = math.ceil((posY - BoardTopY) / CardWidth)

        return (row - 1) * BoardSize + column
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        whichCell = mousePosToCardIdx(x, y)
    end
end

function love.draw()
    love.graphics.origin()

    for cardIdx, card in ipairs(Board) do
        card:draw(
            BoardTopX + ((cardIdx - 1) % BoardSize) * CardWidth,
            BoardTopY + math.floor((cardIdx - 1) / BoardSize) * CardWidth,
            CardWidth
        )
    end

    love.graphics.print(whichCell, 0, 0)
end
