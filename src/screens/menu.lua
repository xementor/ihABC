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
      someKey = "someValue",
      someOtherKey = 10,
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
  local background = display.newImageRect(sceneGroup, "background.png", 360, const.height)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local box = display.newRect(sceneGroup, 100, 100, const.boxSize, const.boxSize)
  box.myName = const.path1Name
  box:addEventListener("tap", lessonTapped)

  local box2 = display.newRect(sceneGroup, 100 + 20 + 100, 100 + 100 + 20, const.boxSize, const.boxSize)
  box2.myName = const.path2Name
  box2:addEventListener("tap", lessonTapped)
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
