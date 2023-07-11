local M = {}
local lessonGenerate = require "src.data.lessons"

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



M.lesson1 = lessonGenerate.generatorLesson({ "A", "B", "C" }
, { "", "Apple", "Ball", "Cat" })

M.lesson2 = lessonGenerate.generatorLesson({ "D", "E", "F" }, { "", "Dog", "Eagle", "Frog" })
M.lesson = {}


return M
