local M = {}

M.height = 570
M.ballRadius = 30
M.boxSize = 100
M.error = 5
M.fontSize = 50
M.boxGap = 5
M.boxPositionX = 55
M.ballYPosition = display.contentHeight - M.error
M.ballXPosition = display.contentCenterX
M.platformWidth = 50
M.i = 1



M.ballText = { "A", "B", "C" }
M.ballWord = { "", "Apple", "Ball", "Cat" }

M.lesson2 = {
  ballText = { "D", "E", "F" },
  ballWord = { "", "Doll", "Eagle", "Food" },

  getTargetWord = function(i)
    return M.lesson2.ballWord[i]
  end
  ,
  getTargetText = function(i)
    return M.lesson2.ballText[i]
  end,
}

M.lesson = {}


return M
