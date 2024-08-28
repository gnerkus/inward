dofile("./card.lua")
dofile("./utils.lua")

function love.load()
    ArenaWidth = 1024
    ArenaHeight = 640

    MaxBoardColCount = 9

    BoardOffsetX = 32
    BoardOffsetY = 32
    BoardOriginX = BoardOffsetX + (Card.WIDTH * MaxBoardColCount / 2)
    BoardOriginY = BoardOffsetY + (Card.WIDTH * MaxBoardColCount / 2)
    BoardSize = 3
    BoardTopX = BoardOriginX - (BoardSize / 2 * Card.WIDTH)
    BoardTopY = BoardOriginY - (BoardSize / 2 * Card.WIDTH)

    SideBarX = Card.WIDTH * MaxBoardColCount + BoardOffsetX * 2
    SideBarCenterX = SideBarX + (ArenaWidth - SideBarX) / 2
    SideBarCenterY = ArenaHeight / 2

    MixWeight = 0.5

    GoalBoxColor = GetRandomGoal()
    GoalBoxX = BoardOffsetX + (Card.WIDTH * MaxBoardColCount) + (BoardOffsetX * 2)
    GoalBoxY = BoardOffsetY
    GoalBoxWidth = 64

    local splitcolors = SplitHue(GoalBoxColor, MixWeight)

    MixBoxColor = splitcolors[1]
    MixBoxWidth = 128
    MixBoxX = SideBarCenterX - MixBoxWidth / 2
    MixBoxY = SideBarCenterY - MixBoxWidth / 2

    ActiveCount = 4

    InitColor = splitcolors[2]

    Board = {
        Card.new(InitColor, 0),
    }

    local neighbours = GetNeighbourColors(InitColor, 15)

    local turnsPool = { 0, 0, 0, 1, 1, 2, 2, 2 }

    for index, value in ipairs(neighbours) do
        local turnsLeft = table.remove(turnsPool, math.random(#turnsPool))

        table.insert(Board, Card.new(value, turnsLeft))
    end
end

function love.mousereleased(x, y, button, _, _)
    if button == 1 then
        local cardIdx = MousePosToCardIdx(x, y)

        if cardIdx > 0 then
            local card = Board[cardIdx]
            if card.isActive then
                MixBoxColor = card.color
            end
        end

        for cardIdx, card in ipairs(Board) do
            card:countdown()
        end
    end
end

function love.draw()
    love.graphics.origin()

    for cardIdx, card in ipairs(Board) do
        card:draw(
            BoardTopX + ((cardIdx - 1) % BoardSize) * Card.WIDTH + math.floor(Card.WIDTH / 2),
            BoardTopY + math.floor((cardIdx - 1) / BoardSize) * Card.WIDTH + Card.WIDTH / 2
        )
    end

    -- draw mix box
    love.graphics.setColor(love.math.colorFromBytes(MixBoxColor.r, MixBoxColor.g, MixBoxColor.b))
    love.graphics.rectangle('fill', MixBoxX, MixBoxY, MixBoxWidth, MixBoxWidth)

    -- draw goal box
    love.graphics.setColor(love.math.colorFromBytes(GoalBoxColor.r, GoalBoxColor.g, GoalBoxColor.b))
    love.graphics.rectangle('fill', GoalBoxX, GoalBoxY, GoalBoxWidth, GoalBoxWidth)
end
