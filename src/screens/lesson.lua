local composer         = require("composer")
local const            = require("src.const")

local scene            = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics          = require("physics")
local backgroundModule = require("src.background")
local boxesModule      = require("src.boxes")
local const            = require("src.const")
local ball             = require("src.ball")
local barrier          = require("src.barrier")
local collisionHandler = require("src.collisionHandler")

physics.start()

-- Navigation
local function gotoMenu(event)
  composer.gotoScene("src.screens.menu")
end

-- Sound
local function readAlphabet(ch)
  if ch == nill then return end
  local text = string.lower(ch)
  local explosionSound = audio.loadSound("sounds/" .. text .. ".mp3")
  audio.play(explosionSound)
end

local function readCommand(text)
  if text == nill then return end
  local eta = audio.loadSound("sounds/ball.m4a")
  audio.play(eta)
  timer.performWithDelay(500, function()
    readAlphabet(text)
  end
  )

  timer.performWithDelay(1000, function()
    audio.play(audio.loadSound("sounds/kick.m4a"))
  end
  )
end


function animateText(ballText)
  if not ballText.isTouchable then return end


  local function vong(event)
    local ch = const.getTargetText(const.i)
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

    firstDuartion = 500
    second = 2000
    thirdDuration = second
    transition.scaleTo(ballText, { xScale = 2.5, yScale = 2.5, time = firstDuartion })
    transition.scaleTo(ballText, { delay = firstDuartion, xScale = 2.4, yScale = 2.4, time = second })
    transition.scaleTo(ballText, { delay = second, xScale = .5, yScale = .5 })

    transition.to(ballText,
      {
        delay = thirdDuration,
        time  = 500,
        x     = display.contentWidth / 2,
        y     = display.contentHeight + const.platformWidth / 2,
      }
    )
  end
  return vong
end

local function gameLoop(group)
  if (const.i > 3) then
    -- local gameEnd = display.newText(group, "Game End", display.contentCenterX, display.contentCenterY)
    -- group.removed(gameEnd)
    -- gameEnd.fontSize = 100
    const.i = 1
    gotoMenu()
  elseif (Ball1.x < -10 or
        Ball1.x > display.contentWidth + 10 or
        Ball1.y < -10 or
        Ball1.y > display.contentHeight + 10)
  then
    ball.startingPhaseBall(Ball1)
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
  local sceneGroup = self.view

  -- Code here runs when the scene is first created but has not yet appeared on screen
  physics.pause()


  local box1 = boxesModule.createBox(
    const.boxPositionX, 10, const.ballText[1], { 1, 0, 0 }
  )


  local box2 = boxesModule.createBox(
    const.boxPositionX + const.boxSize + const.boxGap,
    10, const.ballText[2],
    { 0, 1, 0 }
  )

  local box3 = boxesModule.createBox(
    const.boxPositionX + const.boxSize + 2 * const.boxGap + const.boxSize,
    10,
    const.ballText[3],
    { 0, 0, 1 }
  )

  local platform = barrier.createPlatform()
  Ball1 = ball.createBall()
  BallText = ball.createBallAlphabet(const.getTargetText(const.i))
  local leftBoundary = barrier.createLeftBoundary()
  local rightBoundary = barrier.createRightBoundary()

  -- Add to screengroup
  sceneGroup:insert(box1.boxGroup)
  sceneGroup:insert(box2.boxGroup)
  sceneGroup:insert(box3.boxGroup)

  sceneGroup:insert(platform)
  sceneGroup:insert(Ball1)
  sceneGroup:insert(BallText)
  sceneGroup:insert(leftBoundary)
  sceneGroup:insert(rightBoundary)

  -- Collision and EventListener
  Ball1:addEventListener("touch", ball.createOnTouch(Ball1))
  BallText:addEventListener("touch", animateText(BallText))


  physics.addBody(platform, "static")
  physics.addBody(leftBoundary, "static")
  physics.addBody(rightBoundary, "static")
  physics.addBody(box1.box, "static")
  physics.addBody(box2.box, "static")
  physics.addBody(box3.box, "static")
  physics.addBody(Ball1, "dynamic", { bounce = 0.3 })
end

-- show()
function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == "will") then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif (phase == "did") then
    animateText(BallText)()
    -- Code here runs when the scene is entirely on screen
    physics.start()
    Runtime:addEventListener("collision", collisionHandler.onCollision)

    local function gameLoopP()
      return gameLoop(self.view)
    end
    gameLoopTimer = timer.performWithDelay(500, gameLoopP, 0)
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
