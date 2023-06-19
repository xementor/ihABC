local const = require("src.const")

local M = {}

function M.createPlatform()
    local platform = display.newRect(0, 0, display.contentWidth, const.platformWidth)
    platform.myName = "platform"
    platform:setFillColor(0, 1, 0)
    platform.x = display.contentCenterX
    platform.y = display.contentHeight + const.ballRadius
    return platform
end

function M.createLeftBoundary()
    local leftBoundary = display.newRect(
        display.contentCenterX - (display.contentWidth / 2), display.contentCenterY, 0, display.contentHeight
    )
    leftBoundary.myName = "platform"

    return leftBoundary
end

function M.createRightBoundary()
    local rightBoundary = display.newRect(
        display.contentCenterX + (display.contentWidth / 2), display.contentCenterY, 0, display.contentHeight
    )
    rightBoundary.myName = "platform"
    return rightBoundary
end

return M
