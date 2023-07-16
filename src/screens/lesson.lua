local composer    = require("composer")
local state       = require("src.data.state")
local scene       = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics     = require("physics")
local boxesModule = require("src.boxes")
local const       = require("src.const")
local ball        = require("src.ball")
local barrier     = require("src.barrier")

physics.start()

-- global variable
local gameLoopTimer
local lessonNo
local path
local isRunning = false
local platform, leftBoundary, rightBoundary, box1, box2, box3, ball1, ballText, backButton, background
local word
local explosionSound, eta, kickSound

-- Navigation
local function gotoLessonPath(event)
  local options = {
    params = {
      extraData = { path = path }
    }
  }
  isRunning = false
  -- display.remove(ball1)
  composer.removeScene("src.screens.lesson")
  composer.gotoScene("src.screens.lessonPath", options)
end

-- Sound
local function readAlphabet(ch)
  if ch == nil then return end
  local text = string.lower(ch)
  audio.play(audio.loadSound("sounds/" .. text .. ".mp3"))
end

local function readCommand(text)
  if text == nil then return end
  audio.play(audio.loadSound("sounds/ball.m4a"))
  timer.performWithDelay(500, function()
    readAlphabet(text)
  end
  )

  timer.performWithDelay(1000, function()
    audio.play(audio.loadSound("sounds/kick.m4a"))
  end
  )
end


local function animateText(ballText)
  local function vong(event)
    if event.phase == "ended" and ballText.isTouchable then
      ballText.isTouchable = false
      local ch = const.lesson.getTargetText(const.i)
      readAlphabet(ch)
      timer.performWithDelay(1000, function()
        readCommand(ch)
      end
      )
      transition.to(ballText,
        {
          x = display.contentCenterX,
          y = display.contentCenterY,
        }
      )

      local firstDuartion = 500
      local second = 2000
      local thirdDuration = second
      transition.scaleTo(ballText, { xScale = 2.5, yScale = 2.5, time = firstDuartion })
      transition.scaleTo(ballText, { delay = firstDuartion, xScale = 2.4, yScale = 2.4, time = second })
      transition.scaleTo(ballText, { delay = second, xScale = .5, yScale = .5 })

      transition.to(ballText,
        {
          delay      = thirdDuration,
          time       = 500,
          x          = display.contentWidth / 2,
          y          = display.contentHeight + const.platformWidth / 2,
          onComplete = function()
            ballText.isTouchable = true -- Reset flag when animation is complete
          end
        }
      )
    end
  end
  -- ballText.isTouchable = true
  return vong
end

local function gameLoop()
  if (const.i > 3) then
    -- local gameEnd = display.newText(group, "Game End", display.contentCenterX, display.contentCenterY)
    -- group.removed(gameEnd)
    -- gameEnd.fontSize = 100
    state.updateLevel(path, lessonNo)
    ball1.alpha = 0

    if not isRunning then
      isRunning = true
      timer.performWithDelay(3000, function() gotoLessonPath() end)
    end
  elseif ball1.x then
    if (ball1.x < -10 or
          ball1.x > display.contentWidth + 10 or
          ball1.y < -10 or
          ball1.y > display.contentHeight + 10)
    then
      ball.startingPhaseBall(ball1)
    end
  end
end


local function onCollision(event)
  local obj1 = event.object1
  local obj2 = event.object2


  if (event.phase == "began") then
    if not ball1.onPlatform and ball1.platformTouched then
      local bounceSound = audio.loadSound("sounds/bounce.m4a")
      audio.reserveChannels(1)
      audio.setVolume(0.2, { channel = 1 })
      audio.play(bounceSound, { channel = 1 })
    end
    if (obj1.myName == const.lesson.getTargetText(const.i)
          and
          obj2.myName == "ball" and ball1.platformTouched
        ) and ballText.isTouchable then
      -- correct sound
      audio.play(audio.loadSound("sounds/correct.mp3"))

      -- change charecter
      const.i       = const.i + 1
      ballText.text = const.lesson.getTargetText(const.i)

      -- remove the box
      display.remove(obj1)

      -- Ball
      ball1.platformTouched = false
      -- display.remove(Ball1)
      ball1.alpha = 0

      -- Additional screen for A for Apple
      word = display.newText({
        text = const.lesson.getTargetWord(const.i),
        x = display.contentCenterX,
        y = display.contentCenterX,
        font = native.systemFont,
        fontSize = const.fontSize,
        align = "center"
      })

      timer.performWithDelay(1000, function()
        display.remove(word)
      end
      )
      if const.i < 4 then
        timer.performWithDelay(2000, function()
          animateText(ballText)({ phase = "ended" })
        end)
        timer.performWithDelay(4000, function()
          ball.startingPhaseBall(ball1)
        end)
      end
    elseif (obj1.myName == "platform" and obj2.myName == "ball") then
      ball1.platformTouched = true
      ball1.onPlatform = false
    else
      audio.play(audio.loadSound("sounds/hit.wav"))
      -- can add animation
      -- obj1:setFillColor(0, 1, 0)
    end
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
  local sceneGroup = self.view

  local lesson = event.params.lesson
  local content = lesson.content
  lessonNo = lesson.index
  path = lesson.path
  -- Code here runs when the scene is first created but has not yet appeared on screen
  physics.pause()


  -- resetting index
  const.i = 1
  const.lesson = content

  -- UI
  background = display.newImageRect(sceneGroup, "images/back.jpg", display.contentWidth,
    display.contentHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  box1 = boxesModule.createBox(
    const.boxPositionX, const.boxPositionY, const.lesson.ballText[1], { 1, 0, 0 }
  )


  box2 = boxesModule.createBox(
    const.boxPositionX + const.boxSize + const.boxGap,
    const.boxPositionY, const.lesson.ballText[2],
    { 0, 1, 0 }
  )

  box3 = boxesModule.createBox(
    const.boxPositionX + const.boxSize + 2 * const.boxGap + const.boxSize,
    const.boxPositionY,
    const.lesson.ballText[3],
    { 0, 0, 1 }
  )

  platform = barrier.createPlatform()
  ball1 = ball.createBall()
  ball1.alpha = 0
  ballText = ball.createBallAlphabet(const.lesson.getTargetText(const.i))
  leftBoundary = barrier.createLeftBoundary()
  rightBoundary = barrier.createRightBoundary()


  -- navigations icon
  backButton = display.newImage(sceneGroup, "images/crossIcon.png")
  local buttonSize = 100
  local horizontalGap = 50
  local verticalGap = 10
  backButton.x = (buttonSize * .5)
  backButton.y = verticalGap + display.screenOriginY + (buttonSize * .5)
  backButton.width = buttonSize
  backButton.height = buttonSize
  backButton:addEventListener("tap", gotoLessonPath)

  -- backButton:addEventListener("touch", onBackButtonPressed)

  -- Add to screengroup
  sceneGroup:insert(box1.boxGroup)
  sceneGroup:insert(box2.boxGroup)
  sceneGroup:insert(box3.boxGroup)

  sceneGroup:insert(platform)
  sceneGroup:insert(ball1)
  sceneGroup:insert(ballText)
  sceneGroup:insert(leftBoundary)
  sceneGroup:insert(rightBoundary)

  -- Collision and EventListener
  ball1:addEventListener("tap", ball.createOnTouch(ball1))
  ballText:addEventListener("tap", animateText(ballText))


  physics.addBody(platform, "static")
  physics.addBody(leftBoundary, "static")
  physics.addBody(rightBoundary, "static")
  physics.addBody(box1.box, "static")
  physics.addBody(box2.box, "static")
  physics.addBody(box3.box, "static")
  physics.addBody(ball1, "dynamic", { bounce = 0.3 })
end

-- show()
function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == "will") then
    timer.performWithDelay(2000, function()
      transition.to(ball1, { time = 1000, alpha = 1, })
    end)
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif (phase == "did") then
    animateText(ballText)({ phase = "ended" })
    -- Code here runs when the scene is entirely on screen
    physics.start()
    Runtime:addEventListener("collision", onCollision)
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

  print("destroy called")

  timer.cancel(gameLoopTimer)
  const.i = 1

  Runtime:removeEventListener("collision", onCollision)

  -- physics.removeBody(platform)
  -- physics.removeBody(leftBoundary)
  -- physics.removeBody(rightBoundary)

  timer.cancelAll()

  physics.pause()
  physics.stop()

  audio.stop()


  if word then display.remove(word) end

  display.remove(box1.box)
  display.remove(box2.box)
  display.remove(box3.box)
  display.remove(ball1)
  display.remove(ballText)
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
