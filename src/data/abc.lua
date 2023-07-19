local M = {}
local l = require "src.data.lessons"

M.lessons = {
  l.generatorLesson({ "A", "B", "C" }, { "", "Apple", "Ball", "Cat" }, "ABC"),
  l.generatorLesson({ "D", "E", "F" }, { "", "Dog", "Elephant", "Fox" }, "DEF"),
  l.generatorLesson({ "G", "H", "I" }, { "", "Grape", "Horse", "Ice_cream" }, "GHI"),
  l.generatorLesson({ "J", "K", "L" }, { "", "Juice", "Kangaroo", "Lion" }, "JKL"),
  l.generatorLesson({ "M", "N", "O" }, { "", "Monkey", "Nest", "Orange" }, "MNO"),
  l.generatorLesson({ "P", "Q", "R" }, { "", "Penguin", "Queen", "Rabbit" }, "PQR"),
  l.generatorLesson({ "R", "S", "T" }, { "", "Rat", "Snake", "Turtle" }, "RST"),
  l.generatorLesson({ "U", "V", "W" }, { "", "Umbrella", "Violin", "Whale" }, "UVW"),
  l.generatorLesson({ "X", "Y", "Z" }, { "", "Xylophone", "Yogurt", "Zebra" }, "XYZ")
}

return M
