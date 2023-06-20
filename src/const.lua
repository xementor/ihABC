local M = {}

M.height = 570
M.ballRadius = 30
M.boxSize = 100
M.error = 5
M.fontSize = 50
M.boxGap = 5
M.boxPositionX = 55
M.ballYPosition = display.contentHeight - M.error
M.platformWidth = 50
M.ballText = { "A", "B", "C" }
M.selectedAlpha = {}
M.i = 1

function M.getTargetText(i)
  return M.ballText[i]
end

return M
