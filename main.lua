local composer = require("composer")
local abc = require("src.data.ABC")


-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed(os.time())


-- Go to the menu screen
-- composer.gotoScene("src.screens.menu")
local lesson = {
  title = "vongcong",
  index = 3,
  content = abc.lessons[3],
  path = "ABC"
}
composer.gotoScene("src.screens.lesson2", { params = lesson })
