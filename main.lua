dofile("./card.lua")
dofile("./utils.lua")
dofile("./goal.lua")

function GameOver()

end

function love.load()
    local font = love.graphics.newFont(64, "mono")
    font:setFilter("nearest")
    love.graphics.setFont(font)

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

    Score = 0
    PlayerHP = 3

    MixWeight = 0.5

    GoalBoxColor = GetRandomGoal()

    GoalBox = Goal.new(
        GoalBoxColor,
        BoardOffsetX + (Card.WIDTH * MaxBoardColCount) + (BoardOffsetX * 2),
        BoardOffsetY,
        64,
        10
    )

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

    function StartGame()
        GoalBox:set_active()
    end

    function ResetGoal()
        local newColor = GetRandomGoal()
        GoalBox:reset(newColor)
    end

    StartGame()
end

function love.mousereleased(x, y, button, _, _)
    if button == 1 then
        local cardIdx = MousePosToCardIdx(x, y)

        if cardIdx > 0 then
            local card = Board[cardIdx]
            if card.isActive then
                MixBoxColor = MixHue(MixBoxColor, card.color)
                GoalBox:check_mix(MixBoxColor)
            end
        end

        ---TODO: set a flag for the love.update then move the 'countdown' to update
        for cardIdx, card in ipairs(Board) do
            card:countdown()
        end
    end
end

function love.update(dt)
    if GoalBox.hasMatch then
        Score = Score + 10
        ResetGoal()
    end

    GoalBox:countdown(dt)

    if GoalBox.timeLeft <= 0 then
        PlayerHP = PlayerHP - 1
        if PlayerHP <= 0 then
            GameOver()
        end
        ResetGoal()
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
    GoalBox:draw()

    ---draw timer
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(math.ceil(GoalBox.timeLeft), ArenaWidth - BoardOffsetX - 64, BoardOffsetY)
end
