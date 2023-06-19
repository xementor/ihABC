local const = require("src.const")

local M = {}

function M.createBackground()
    local background = display.newImageRect("background.png", 360, const.height)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    return background
end

return M
