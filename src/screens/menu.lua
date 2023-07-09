local composer  = require("composer")
local const     = require("src.const")

local scene     = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local centerX   = display.contentCenterX
local startY    = display.contentHeight - 50
local lessonGap = 80

local function lessonTapped(event)
  local lesson = event.target.lesson
  print("Selected lesson:", lesson.title)
  -- Implement the logic to navigate to the corresponding lesson here
  composer.gotoScene("src.screens.lesson")
end

local function createLessonTrack()
  local group = display.newGroup()

  for i = 1, 10 do
    local y = startY - ((i - 1) * lessonGap)

    local lesson = {
      title = "Lesson " .. i,
      description = "Description for Lesson " .. i
    }

    local lessonCircle = display.newCircle(group, centerX, y, 20)
    lessonCircle:setFillColor(0.8, 0.8, 0.8)
    lessonCircle.lesson = lesson
    lessonCircle:addEventListener("tap", lessonTapped)

    local lessonText = display.newText({
      parent = group,
      text = lesson.title,
      x = centerX + 50,
      y = y,
      fontSize = 14
    })
    lessonText.anchorX = 0
    lessonText:setFillColor(0)
  end

  return group
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

  local lessonTrack = createLessonTrack()

  local scrollView = display.newGroup()
  scrollView:insert(lessonTrack)
  sceneGroup:insert(scrollView)


  local function scrollListener(event1)
    local phase = event1.phase
    local y = event1.y

    if phase == "began" then
      scrollView.yStart = y
    elseif phase == "moved" then
      local dy = y - scrollView.yStart
      scrollView.y = scrollView.y + dy
      scrollView.yStart = y
    end

    return true
  end

  scrollView:addEventListener("touch", scrollListener)
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