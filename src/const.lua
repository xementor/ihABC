local M              = {}
local lessonGenerate = require "src.data.lessons"
local abc            = require "src.data.abc"
local banABC         = require "src.data.banABC"

-- box
M.height             = 570
M.boxGap             = 50
M.boxSize            = (display.contentWidth - 2 * M.boxGap) / 3
M.fontSize           = 100
M.boxPositionX       = M.boxSize / 2
M.boxPositionY       = 0

-- ball
M.ballRadius         = 50
M.error              = 5
M.ballYPosition      = display.contentHeight --display.contentHeight - M.error
M.ballXPosition      = display.contentCenterX
M.platformWidth      = 100


M.i = 1


-- pathName
M.path1Name = "ABC"
M.path2Name = "BAN"

M.lesson = {}

function M.getPath(pathString)
  if pathString == M.path1Name then
    return abc
  end
  if pathString == M.path2Name then
    return banABC
  end
end

return M
