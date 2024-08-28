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

    if weight_by_distance ~= -1 then
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

---Adapted from https://github.com/less/less.js/blob/master/packages/less/src/less/tree/color.js
---@param sourceRGB table the RGB colour in bits (0 - 255)
function RGBtoHSL(sourceRGB)
    local red = sourceRGB.r / 255
    local green = sourceRGB.g / 255
    local blue = sourceRGB.b / 255

    local max = math.max(red, green, blue)
    local min = math.min(red, green, blue)

    local hue = 0
    local sat = 0
    local lum = (max + min) / 2
    local diff = max - min

    if max ~= min then
        sat = lum > 0.5 and diff / (2 - max - min) or diff / (max + min)

        if max == red then
            hue = (green - blue) / diff + (green < blue and 6 or 0)
        end

        if max == green then
            hue = (blue - red) / diff + 2
        end

        if max == blue then
            hue = (red - green) / diff + 4
        end

        hue = hue / 6
    end

    return {
        h = hue * 360,
        s = sat,
        l = lum,
        a = sourceRGB.a
    }
end

function GetNeighbourColors(source, deviation)

end

-- return -1 if no card else card index
function MousePosToCardIdx(posX, posY)
    local outsideX = posX < BoardTopX or posX > BoardTopX + (BoardSize * Card.WIDTH)
    local outsideY = posY < BoardTopY or posY > BoardTopY + (BoardSize * Card.WIDTH)

    if outsideX or outsideY then
        return 0
    else
        local column = math.ceil((posX - BoardTopX) / Card.WIDTH)
        local row = math.ceil((posY - BoardTopY) / Card.WIDTH)

        return (row - 1) * BoardSize + column
    end
end
