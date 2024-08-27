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

--
-- Copyright (c) 2006-2009 Hampton Catlin, Natalie Weizenbaum, and Chris Eppstein
-- http://sass-lang.com
--
-- first and second are tables representing the colors from cards
-- colors are in bit (0 - 255)
function MixHue(first, second, strength)
    if strength == nil then strength = 0.5 end

    local alpha_distance = first.a - second.a
    local gen_weight = strength * 2 - 1
    local weight_by_distance = gen_weight * alpha_distance

    local weight1 = (gen_weight + 1) / 2

    if not weight_by_distance == -1 then
        weight1 = (((gen_weight + alpha_distance) / (1 + weight_by_distance)) + 1) / 2
    end

    local weight2 = 1 - weight1

    return {
        r = first.r * weight1 + second.r * weight2,
        g = first.g * weight1 + second.g * weight2,
        b = first.b * weight1 + second.b * weight2,
        a = first.a * strength + second.a * (1 - strength)
    }
end

-- currently, strength is always 0.5
function SplitHue(source, strength)
    if strength == nil then strength = 0.5 end

    local first = {
        r = math.random(math.max(0, (source.r * 2) - 255), math.min(2 * source.r, 255)),
        g = math.random(math.max(0, (source.g * 2) - 255), math.min(2 * source.g, 255)),
        b = math.random(math.max(0, (source.b * 2) - 255), math.min(2 * source.b, 255)),
        a = 1
    }

    local weight1 = strength
    local weight2 = 1 - strength

    local second = {
        r = (source.r - (first.r * weight1)) / weight2,
        g = (source.g - (first.g * weight1)) / weight2,
        b = (source.b - (first.b * weight1)) / weight2,
        a = 1
    }

    return { first, second }
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

    SideBarX = CardWidth * MaxBoardColCount + BoardOffsetX * 2
    SideBarCenterX = SideBarX + (ArenaWidth - SideBarX) / 2
    SideBarCenterY = ArenaHeight / 2

    MixWeight = 0.5

    GoalBoxColor = GetRandomGoal()
    GoalBoxX = BoardOffsetX + (CardWidth * MaxBoardColCount) + (BoardOffsetX * 2)
    GoalBoxY = BoardOffsetY
    GoalBoxWidth = 64

    local splitcolors = SplitHue(GoalBoxColor, MixWeight)

    MixBoxColor = splitcolors[1]
    MixBoxWidth = 128
    MixBoxX = SideBarCenterX - MixBoxWidth / 2
    MixBoxY = SideBarCenterY - MixBoxWidth / 2

    InitColor = splitcolors[2]

    Board = {
        card_module.Card.new(splitcolors[2]),
        -- card_module.Card.new({ 192, 64, 0, 1 }),
        -- card_module.Card.new({ 192, 128, 0, 1 }),
        -- card_module.Card.new({ 128, 192, 0, 1 }),
        -- card_module.Card.new({ 64, 192, 0, 1 }),
        -- card_module.Card.new({ 0, 192, 64, 1 }),
        -- card_module.Card.new({ 0, 192, 128, 1 }),
        -- card_module.Card.new({ 0, 128, 192, 1 }),
        -- card_module.Card.new({ 0, 64, 192, 1 }),
    }
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

    -- TODO: delete these
    ----------------------
    -- love.graphics.setColor({ 1, 1, 1, 1 })
    -- love.graphics.print(table.concat({
    --     'r: ' .. GoalBoxColor.r,
    --     ' g: ' .. GoalBoxColor.g,
    --     ' b: ' .. GoalBoxColor.b,
    --     ' a: ' .. GoalBoxColor.a
    -- }), 0, 0)

    -- love.graphics.setColor({ 1, 1, 1, 1 })
    -- love.graphics.print(table.concat({
    --     'r: ' .. MixBoxColor.r,
    --     ' g: ' .. MixBoxColor.g,
    --     ' b: ' .. MixBoxColor.b,
    --     ' a: ' .. MixBoxColor.a
    -- }), 0, 32)

    -- love.graphics.print(table.concat({
    --     'r: ' .. InitColor.r,
    --     ' g: ' .. InitColor.g,
    --     ' b: ' .. InitColor.b,
    --     ' a: ' .. InitColor.a
    -- }), 0, 64)

    -- local goalback = MixHue(MixBoxColor, InitColor, MixWeight)
    -- love.graphics.print(table.concat({
    --     'r: ' .. goalback.r,
    --     ' g: ' .. goalback.g,
    --     ' b: ' .. goalback.b,
    --     ' a: ' .. goalback.a
    -- }), 0, 96)
end
