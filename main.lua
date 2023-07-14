local composer = require("composer")
local const    = require("src.const")

-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed(os.time())


-- Go to the menu screen
local abc     = require "src.data.ABC"
local options = {
  effect = "fade",
  time = 500,

  params = {
    lesson = { content = abc.lessons[3] }
  }
}
composer.gotoScene("src.screens.menu", options)
