local M = {}
local l = require "src.data.lessons"

M.lessons = {
  l.generatorLesson({ "A", "B", "C" }, { "", "Apple", "Ball", "Cat" }, "ABC"),
  l.generatorLesson({ "D", "E", "F" }, { "", "Dog", "Egg", "Frog" }, "DEF"),
  l.generatorLesson({ "G", "H", "I" }, { "", "Google", "Hen", "Ice" }, "GHI"),
  l.generatorLesson({ "J", "K", "L" }, { "", "Jam", "Kite", "Lemon" }, "JKL"),
  l.generatorLesson({ "M", "N", "O" }, { "", "Moon", "Net", "Orange" }, "MNO"),
  l.generatorLesson({ "P", "Q", "R" }, { "", "Pet", "Queen", "Rat" }, "PQR"),
  l.generatorLesson({ "R", "S", "T" }, { "", "Rat", "Sun", "Tree" }, "RST"),
  l.generatorLesson({ "U", "V", "W" }, { "", "Umbrella", "Vite", "Wood" }, "UVW"),
  l.generatorLesson({ "X", "Y", "Z" }, { "", "Xo", "Yellow", "Zonaid" }, "XYZ")
}

return M
