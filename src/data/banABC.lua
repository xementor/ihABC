local M = {}
local l = require "src.data.lessons"

M.lessons = {
  l.generatorLesson({ "A", "B", "C" }, { "", "Apple", "Ball", "Cat" }),
  l.generatorLesson({ "D", "E", "F" }, { "", "Dog", "Egg", "Frog" }),
  l.generatorLesson({ "G", "H", "I" }, { "", "Google", "Hen", "Ice" }),
  l.generatorLesson({ "J", "K", "L" }, { "", "Jam", "Kite", "Lemon" }),
  l.generatorLesson({ "M", "N", "O" }, { "", "Moon", "Net", "Orange" }),
  l.generatorLesson({ "P", "Q", "R" }, { "", "Pet", "Queen", "Rat" }),
  l.generatorLesson({ "R", "S", "T" }, { "", "Rat", "Sun", "Tree" }),
  l.generatorLesson({ "U", "V", "W" }, { "", "Umbrella", "Vite", "Wood" }),
  l.generatorLesson({ "X", "Y", "Z" }, { "", "Xo", "Yellow", "Zonaid" })
}

return M
