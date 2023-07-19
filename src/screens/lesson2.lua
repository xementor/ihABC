local composer  = require("composer")
local const     = require("src.const")
local boxes     = require("src.boxes")
local state     = require("src.data.state")
local animation = require("src.animation")

local scene     = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Set up constants
local lessonAlphabets = {};
local i = 1
local oldI = 1
local alphaCount
local speakButton, grid, backButton
local path, lessonNo
local gameLoopTimer
local isRunning = false
local buttonSize = 100
local levelData

local function generateAlphabetCount(lessonAlphabets)
  return {
    [lessonAlphabets[1]] = 0,
    [lessonAlphabets[2]] = 0,
    [lessonAlphabets[3]] = 0,
  }
end


local function getFocusAlhabets()
  if i > 3 then return end
  local focusAlphaCount = alphaCount[lessonAlphabets[i]]
  if focusAlphaCount < 1 then i = i + 1 end
  local focused = lessonAlphabets[i]
  if focused then return focused end
end

local tapRunning = false
local function alphabetTapped(event)
  if tapRunning then return true end
  tapRunning = true
  local alphabet = event.target.alphabet
  local focuesAlphabet = getFocusAlhabets()
  local el = event.target

  if alphabet == focuesAlphabet then
    alphaCount[alphabet] = alphaCount[alphabet] - 1
    -- remove the box
    audio.play(audio.loadSound("sounds/correct.mp3"))
    transition.to(el, {
      time = 500,
      xScale = 2,
      yScale = 2,
      alpha = 0,
      transition = easing.outQuad,
      onComplete = function()
        -- Remove the box from display after the animation completes
        tapRunning = false
        display.remove(el)
      end
    })
  else
    -- say outloudn that select the alpha
    -- this alpha na focus alpha select koro
    transition.to(el, {
      time = 100,
      rotation = 20,
      transition = easing.outQuad,
      onComplete = function()
        transition.to(el, {
          time = 100,
          rotation = -20,
          transition = easing.outQuad,
          onComplete = function()
            transition.to(el, { time = 100, rotation = 0, transition = easing.outQuad })
            if not focuesAlphabet then return true end
            audio.play(audio.loadSound("sounds/hit.wav"))
            audio.play(audio.loadSound("sounds/" .. focuesAlphabet .. ".mp3"))
            tapRunning = false
          end
        })
      end
    })
  end
end

local function generateGrid(content)
  local group = display.newGroup()
  local gridSize = 3
  local boxSize = 200
  local gapSize = 20 -- Adjust this value to control the gap between boxes
  local distant = boxSize + gapSize
  local startX = display.contentCenterX - 2 * distant
  local startY = display.contentCenterY - 2 * distant


  for row = 1, gridSize do
    local y = startY + row * distant
    for column = 1, gridSize do
      local alphabet = content[math.random(1, #content)]

      if alphaCount[alphabet] then
        alphaCount[alphabet] = alphaCount[alphabet] + 1
      else
        alphaCount[alphabet] = 1
      end

      local x = startX + column * distant
      local box = boxes.createBox(x, y, alphabet)
      local boxGroup = box.boxGroup
      boxGroup.alphabet = alphabet

      boxGroup:addEventListener("tap", alphabetTapped)
      group:insert(boxGroup)
    end
  end


  return group
end

local function makeCommand(event)
  if (i > 3) then return true end

  local focues = getFocusAlhabets()
  if not focues then
    return true
  end

  local function rest()
    audio.play(audio.loadSound("sounds/" .. focues .. ".mp3"))
  end

  if not event then
    rest()
    return true
  end

  animation.buttonAnimation(event.target, rest)
end

-- Navigation
local function gotoLessonPath(haveUpdate)
  local options = {
    effect = "slideLeft",
    time = 500,
    params = {
      extraData = { path = path, haveUpdate = haveUpdate }
    }
  }
  isRunning = false
  -- display.remove(ball1)
  composer.removeScene("src.screens.lesson2")
  composer.gotoScene("src.screens.lessonPath", options)
end



local function gameLoop()
  -- auto increment index and change page
  getFocusAlhabets()

  if (oldI ~= i and i <= 3) then
    makeCommand()
    oldI = i
  end
  if (i > 3) then
    state.updateLevel(path, lessonNo)
    if not isRunning then
      isRunning = true
      gotoLessonPath(true)
    end
  end
end

local function createButton(sceneGroup, x, y, icon)
  if not icon then icon = "crossIcon" end
  local button = display.newImage(sceneGroup, "images/" .. icon .. ".png")
  button.x = x
  button.y = y
  button.width = buttonSize
  button.height = buttonSize
  return button
end

local function onBackButtonPressed(event)
  animation.buttonAnimation(event.target, function()
    gotoLessonPath(false)
  end)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
  local sceneGroup = self.view


  local lesson = event.params
  lessonAlphabets = lesson.content.ballText
  path = lesson.path
  lessonNo = lesson.index
  alphaCount = generateAlphabetCount(lessonAlphabets);
  levelData = state.getData(path)

  grid = generateGrid(lessonAlphabets)

  local x = display.contentCenterX
  local y = display.contentHeight
  speakButton = createButton(sceneGroup, x, y, "volume")
  speakButton:addEventListener("tap", makeCommand)


  x = buttonSize * .5
  y = display.screenOriginY + x
  backButton = createButton(sceneGroup, x, y)
  backButton:addEventListener("tap", onBackButtonPressed)


  sceneGroup:insert(grid)
end

-- show()
function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == "will") then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif (phase == "did") then
    -- Code here runs when the scene is entirely on screen
    makeCommand()
    gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
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
  display.remove(grid)
  display.remove(speakButton)
  display.remove(backButton)
  timer.cancel(gameLoopTimer)
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
