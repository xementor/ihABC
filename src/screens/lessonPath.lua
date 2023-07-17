local composer        = require("composer")
local const           = require("src.const")
local state           = require("src.data.state")
local scene           = composer.newScene()

local animation       = require "src.animation"

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local startY          = display.contentHeight - 100
local containerHeight = 250
local lessonGap       = containerHeight + 50

local levelData
local numLesson




local isScrolling = false -- Variable to track scrolling state

local function lessonTapped(event)
  if isScrolling then return true end

  local lesson = event.target.lesson
  if lesson.index > levelData.currentLevel then return end

  -- Implement the logic to navigate to the corresponding lesson here
  local options = {
    effect = "fade",
    time = 500,
    params = {
      lesson = lesson
    }
  }

  local function rest()
    composer.removeScene("src.screens.lessonPath")
    composer.gotoScene("src.screens.lesson", options)
  end

  animation.buttonAnimation(event.target, rest)

  return true
end



local function onBackButtonPressed(event)
  local function extra()
    composer.removeScene("src.screens.lessonPath")
    composer.gotoScene("src.screens.menu", {
      effect = "slideRight",
      time = 500,
    })
  end
  local button = event.target
  animation.buttonAnimation(button, extra)
end




local function createLessonTrack(pathString)
  local group = display.newGroup()
  local path = const.getPath(pathString)
  numLesson = #(path.lessons)

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

  local function makeLessons(y, i, variant)
    local lesson = {
      title = addExtraSpace(path.lessons[i].lessonPreview),
      index = i,
      content = path.lessons[i],
      path = pathString
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
    group:addEventListener("tap", lessonTapped)
    group.lesson = lesson
    return group
  end

  for i = 1, numLesson do
    local y = startY - ((i - 1) * lessonGap)
    local lesson

    local containerY = y
    if i > levelData.currentLevel then
      containerY = startY - (i - levelData.currentLevel) * lessonGap
    elseif i < levelData.currentLevel then
      containerY = startY + (levelData.currentLevel - i) * lessonGap
    else
      containerY = startY
    end

    if i < levelData.currentLevel then
      lesson = makeLessons(containerY, i, 2)
    elseif i == levelData.currentLevel then
      lesson = makeLessons(containerY, i)
    else
      lesson = makeLessons(containerY, i, 3)
    end
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

  levelData = state.getData(path)

  -- init ui
  local background = display.newImageRect(sceneGroup, "images/back.jpg", display.pixelWidth, display.pixelHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY


  local lessonTrack = createLessonTrack(path)


  local scrollView = display.newGroup()
  scrollView:insert(lessonTrack)
  sceneGroup:insert(scrollView)

  -- navigations icon
  local backButton = display.newImage(sceneGroup, "images/backIcon.png")
  local buttonSize = 100
  local horizontalGap = 50
  local verticalGap = 10
  backButton.x = horizontalGap + (buttonSize * .5)
  backButton.y = verticalGap + display.screenOriginY + (buttonSize * .5)
  backButton.width = buttonSize
  backButton.height = buttonSize

  backButton:addEventListener("tap", onBackButtonPressed)






  local function scrollListener(event)
    local phase = event.phase

    local utils = require "src.utils"

    local index = levelData.currentLevel
    local startY = 0 - ((index - 1) * lessonGap)

    local endY = (numLesson - index - 2) * lessonGap


    if phase == "began" then
      display.currentStage:setFocus(event.target)
      scrollView.isFocus = true
      print("scrollView y", scrollView.y, startY)

      -- Store initial position
      scrollView.startY = event.y
    elseif scrollView.isFocus then
      if phase == "moved" then
        -- Calculate the distance moved only along the Y-axis
        local deltaY = event.y - scrollView.startY


        if scrollView.y <= startY then
          scrollView.y = startY
        end


        if scrollView.y > endY then
          scrollView.y = endY
        end

        scrollView.y = scrollView.y + deltaY


        -- Update the initial position for the next move event
        scrollView.startY = event.y
      elseif phase == "ended" or phase == "cancelled" then
        display.currentStage:setFocus(nil)
        scrollView.isFocus = false
      end
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
