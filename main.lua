local card_module = require "card"

-- generates a random color based on params?
-- ----------------------------------------
-- will be called each time the player has a successful match or
-- time runs out
function GetRandomGoal()
    math.randomseed(os.time())
    return {
        r = math.random(0, 255),
        g = math.random(0, 255),
        b = math.random(0, 255),
        a = 1
    }
end

function GetInitialMix(color)
    return {
        r = math.random(0, 255),
        g = math.random(0, 255),
        b = math.random(0, 255),
        a = 1
    }
end

-- first and second are tables representing the colors from cards
-- colors are in bit (0 - 255)
function MixHue(first, second, strength)
    if strength == nil then strength = 0.5 end

    return {
        r = first.r * (1 - strength) + second.r * strength,
        g = first.g * (1 - strength) + second.g * strength,
        b = first.b * (1 - strength) + second.b * strength,
        a = first.a * (1 - strength) + second.a * strength,
    }
end

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
        card_module.Card.new({ 192, 0, 0, 1 }),
        card_module.Card.new({ 192, 64, 0, 1 }),
        card_module.Card.new({ 192, 128, 0, 1 }),
        card_module.Card.new({ 128, 192, 0, 1 }),
        card_module.Card.new({ 64, 192, 0, 1 }),
        card_module.Card.new({ 0, 192, 64, 1 }),
        card_module.Card.new({ 0, 192, 128, 1 }),
        card_module.Card.new({ 0, 128, 192, 1 }),
        card_module.Card.new({ 0, 64, 192, 1 }),
    }

    SideBarX = CardWidth * MaxBoardColCount + BoardOffsetX * 2
    SideBarCenterX = SideBarX + (ArenaWidth - SideBarX) / 2
    SideBarCenterY = ArenaHeight / 2

    GoalBoxColor = GetRandomGoal()
    GoalBoxX = BoardOffsetX + (CardWidth * MaxBoardColCount) + (BoardOffsetX * 2)
    GoalBoxY = BoardOffsetY
    GoalBoxWidth = 64

    MixBoxColor = GetInitialMix(GoalBoxColor)
    MixBoxWidth = 128
    MixBoxX = SideBarCenterX - MixBoxWidth / 2
    MixBoxY = SideBarCenterY - MixBoxWidth / 2
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

function love.mousereleased(x, y, button, _, _)
    if button == 1 then
        local cardIdx = mousePosToCardIdx(x, y)

        if cardIdx > 0 then
            local card = Board[cardIdx]
            if card.isActive then
                MixBoxColor = card.color
            end
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
    love.graphics.setColor(love.math.colorFromBytes(MixBoxColor.r, MixBoxColor.g, MixBoxColor.b))
    love.graphics.rectangle('fill', MixBoxX, MixBoxY, MixBoxWidth, MixBoxWidth)

    -- draw goal box
    love.graphics.setColor(love.math.colorFromBytes(GoalBoxColor.r, GoalBoxColor.g, GoalBoxColor.b))
    love.graphics.rectangle('fill', GoalBoxX, GoalBoxY, GoalBoxWidth, GoalBoxWidth)
end
