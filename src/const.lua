local M              = {}
local lessonGenerate = require "src.data.lessons"
local abc            = require "src.data.abc"
local banABC         = require "src.data.banABC"

M.height             = 570
M.ballRadius         = 30
M.boxSize            = 100
M.error              = 5
M.fontSize           = 50
M.boxGap             = 5
M.boxPositionX       = 55
M.ballYPosition      = display.contentHeight - M.error
M.ballXPosition      = display.contentCenterX
M.platformWidth      = 50
M.i                  = 1


M.path1Name = "ABC"
M.path2Name = "BAN"


M.lesson1 = lessonGenerate.generatorLesson({ "A", "B", "C" }
, { "", "Apple", "Ball", "Cat" })

M.lesson2 = lessonGenerate.generatorLesson({ "D", "E", "F" }, { "", "Dog", "Eagle", "Frog" })
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
