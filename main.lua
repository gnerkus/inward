local card_module = require "card"

function love.load()
    ArenaWidth = 1024
    ArenaHeight = 640

    MaxBoardColCount = 9

    CardWidth = 64

    BoardOffsetX = 32
    BoardOffsetY = 32
    BoardOriginX = BoardOffsetX + (CardWidth * MaxBoardColCount / 2)
    BoardOriginY = BoardOffsetY + (CardWidth * MaxBoardColCount / 2)
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

    SideBarX = CardWidth * MaxBoardColCount + BoardOffsetX * 2
    SideBarCenterX = SideBarX + (ArenaWidth - SideBarX) / 2
    SideBarCenterY = ArenaHeight / 2

    MixBoxColor = { 1, 1, 1, 1 }
    MixBoxWidth = 128
    MixBoxX = SideBarCenterX - MixBoxWidth / 2
    MixBoxY = SideBarCenterY - MixBoxWidth / 2

    GoalBoxColor = { 1, 1, 1, 1 }
    GoalBoxX = BoardOffsetX + (CardWidth * MaxBoardColCount) + (BoardOffsetX * 2)
    GoalBoxY = BoardOffsetY
    GoalBoxWidth = 64
end

-- return -1 if no card else card index
function mousePosToCardIdx(posX, posY)
    local outsideX = posX < BoardTopX or posX > BoardTopX + (BoardSize * CardWidth)
    local outsideY = posY < BoardTopY or posY > BoardTopY + (BoardSize * CardWidth)

    if outsideX or outsideY then
        return 0
    else
        local column = math.ceil((posX - BoardTopX) / CardWidth)
        local row = math.ceil((posY - BoardTopY) / CardWidth)

        return (row - 1) * BoardSize + column
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        local cardIdx = mousePosToCardIdx(x, y)

        if cardIdx > 0 then
            local card = Board[cardIdx]
            MixBoxColor = card.color
        end
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

    -- draw mix box
    love.graphics.setColor(MixBoxColor)
    love.graphics.rectangle('fill', MixBoxX, MixBoxY, MixBoxWidth, MixBoxWidth)

    -- draw goal box
    love.graphics.setColor(GoalBoxColor)
    love.graphics.rectangle('fill', GoalBoxX, GoalBoxY, GoalBoxWidth, GoalBoxWidth)
end
