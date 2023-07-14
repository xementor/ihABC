local composer = require("composer")
local const = require "src.const"

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function lessonTapped(event)
  local pathName = event.target.myName

  local options = {
    effect = "fade",
    time = 500,
    params = {
      extraData = { path = pathName }
    }
  }
  composer.gotoScene("src.screens.lessonPath", options)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  local background = display.newImageRect(sceneGroup, "images/back.jpg", display.pixelWidth, display.pixelHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY


  local y = display.contentCenterY
  local boxSize = 400
  local x = (display.contentCenterX)

  local function boxMaker(x, y, boxSize, boxName)
    do
      local fontSize = 100
      local boxGroup = display.newGroup()
      local box = display.newRect(boxGroup, x, y, boxSize, boxSize)
      box.cornerRadius = 20
      local lap = 10
      local boxCover = display.newRect(boxGroup, x - lap, y - lap, boxSize + lap, boxSize + lap)
      local text = display.newText({
        parent = boxGroup,
        text = "ABC",
        x = box.x,
        y = box.y,
        font = native.systemFontBold,
        fontSize = fontSize,
        align = "center"
      })
      text.y = text.y + text.height / 2 - (fontSize / 2)
      box:setFillColor(117 / 255, 160 / 255, 200 / 255)
      boxCover:setFillColor(33 / 255, 25 / 255, 25 / 255)
      boxCover:toBack()
      boxGroup.myName = boxName
      sceneGroup:insert(boxGroup)
      boxGroup:addEventListener("tap", lessonTapped)
      return boxGroup
    end
  end
  local box = boxMaker(x, y, boxSize, const.path1Name)
end

-- show()
function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == "will") then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif (phase == "did") then
    -- Code here runs when the scene is entirely on screen
  end
end

-- hide()
function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == "will") then
    -- Code here runs when the scene is on screen (but is about to go off screen)
  elseif (phase == "did") then
    -- Code here runs immediately after the scene goes entirely off screen
  end
end

-- destroy()
function scene:destroy(event)
  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
