local M = {}
local l = require "src.data.lessons"

M.lessons = {
  l.generatorLesson({ "a", "b", "c" }, { "", "apple", "banana", "cat" }, "abc"),
  l.generatorLesson({ "d", "e", "f" }, { "", "dog", "elephant", "fox" }, "def"),
  l.generatorLesson({ "g", "h", "i" }, { "", "grape", "horse", "ice cream" }, "ghi"),
  l.generatorLesson({ "j", "k", "l" }, { "", "juice", "kangaroo", "lion" }, "jkl"),
  l.generatorLesson({ "m", "n", "o" }, { "", "monkey", "nest", "orange" }, "mno"),
  l.generatorLesson({ "p", "q", "r" }, { "", "penguin", "queen", "rabbit" }, "pqr"),
  l.generatorLesson({ "r", "s", "t" }, { "", "rat", "snake", "turtle" }, "rst"),
  l.generatorLesson({ "u", "v", "w" }, { "", "umbrella", "violin", "whale" }, "uvw"),
  l.generatorLesson({ "x", "y", "z" }, { "", "xylophone", "yogurt", "zebra" }, "xyz")
}

return M
