local M = {}
local l = require "src.data.lessons"

M.lessons = {
  l.generatorLesson({ "R", "S", "T" }, { "", "Xo", "Yellow", "Zonaid" }),
  l.generatorLesson({ "U", "V", "W" }, { "", "Xo", "Yellow", "Zonaid" }),
  l.generatorLesson({ "X", "Y", "Z" }, { "", "Xo", "Yellow", "Zonaid" })
}

return M
