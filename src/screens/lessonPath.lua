local composer        = require("composer")
local const           = require("src.const")
local state           = require("src.data.state")

local scene           = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local startY          = display.contentHeight - 50
local containerHeight = 250
local lessonGap       = containerHeight + 50

local levelData



local function lessonTapped(event)
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
  composer.gotoScene("src.screens.lesson", options)
end

local function createLessonTrack(pathString)
  local group = display.newGroup()
  local path = const.getPath(pathString)
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
    group:addEventListener("touch", lessonTapped)
    group.lesson = lesson
    return group
  end

  for i = 1, numLesson do
    local y = startY - ((i - 1) * lessonGap)
    local lesson
    if i < levelData.currentLevel then
      lesson = makeLessons(y, i, 2)
    elseif i == levelData.currentLevel then
      lesson = makeLessons(y, i)
    else
      lesson = makeLessons(y, i, 3)
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
  print("levelData")
  print(levelData)

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
