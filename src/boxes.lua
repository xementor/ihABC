local const = require("src.const")

local M = {}

function M.createBox(x, y, text, color)
    local boxGroup = display.newGroup()
    local box = display.newRect(boxGroup, x, y, const.boxSize, const.boxSize)
    box.myName = text
    box:setFillColor(255 / 255, 98 / 255, 10 / 255, .8)

    local boxAlphabet = display.newText({
        parent = boxGroup,
        text = text,
        x = box.x,
        y = box.y + const.boxSize / 2 - const.fontSize / 2,
        width = box.width,
        height = box.height,
        font = native.systemFontBold,
        fontSize = const.fontSize,
        align = "center"
    })

    return { box = box, boxAlphabet = boxAlphabet, boxGroup = boxGroup };
end

return M
