local composer        = require("composer")
local const           = require("src.const")

local scene           = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local centerX         = display.contentCenterX - (display.contentWidth / 4)
local startY          = display.contentHeight - 50
local containerHeight = 250
local lessonGap       = containerHeight + 50

local function lessonTapped(event)
  local lesson = event.target.lesson
  print("Selected lesson:", lesson.title)
  -- Implement the logic to navigate to the corresponding lesson here
  local options = {
    effect = "fade",
    time = 500,
    params = {
      lesson = { content = lesson.content }
    }
  }
  composer.gotoScene("src.screens.lesson", options)
end

local function createLessonTrack(pathString)
  local group = display.newGroup()
  local path = const.getPath(pathString)
  print(pathString)
  local numLesson = #(path.lessons)

  local function addExtraSpace(str)
    local modifiedStr = ""
    for i = 1, #str do
      modifiedStr = modifiedStr .. str:sub(i, i)
      if i < #str then
        modifiedStr = modifiedStr .. "  "
      end
    end
    return modifiedStr
  end

  for i = 1, numLesson do
    local y = startY - ((i - 1) * lessonGap)

    local function makeLessons(y, variant)
      local lesson = {
        title = addExtraSpace(pathString),
        index = i,
        content = path.lessons[i]
      }
      local group = display.newGroup();
      local container = display.newRoundedRect(group, display.contentCenterX, y, display.contentWidth - 100,
        containerHeight, 25)

      if (variant == 2) then
        container:setFillColor(255 / 255, 98 / 255, 10 / 255)
      elseif (variant == 3) then
        container:setFillColor(37 / 255, 37 / 255, 37 / 255)
      else
        container:setFillColor(117 / 255, 160 / 255, 200 / 255)
      end



      local fontSize = 120
      local lessonText = display.newText({
        parent   = group,
        text     = lesson.title,
        x        = container.x,
        y        = container.y,
        width    = container.width,
        height   = container.height,
        font     = native.systemFontBold,
        fontSize = fontSize,
        align    = "center",
      })
      lessonText.y = lessonText.y + lessonText.height / 2 - (fontSize / 2)
      group:addEventListener("touch", lessonTapped)
      return group
    end

    local lesson = makeLessons(y, 3)
    group:insert(lesson)
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

  -- extraData
  local path = event.params.extraData.path

  -- init ui
  local background = display.newImageRect(sceneGroup, "images/back.jpg", display.pixelWidth, display.pixelHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local lessonTrack = createLessonTrack(path)

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
