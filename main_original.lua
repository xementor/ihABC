local physics          = require("physics")
local backgroundModule = require("src.background")
local boxesModule      = require("src.boxes")
local const            = require("src.const")
local ball             = require("src.ball")
local barrier          = require("src.barrier")
local collisionHandler = require("src.collisionHandler")

physics.start()

backgroundModule.createBackground()

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
ball1 = ball.createBall()
ballText = ball.createBallAlphabet(const.getTargetText(const.i))
local leftBoundary = barrier.createLeftBoundary()
local rightBoundary = barrier.createRightBoundary()

-- Sound
local function readAlphabet(ch)
  if ch == nil then return end
  local text = string.lower(ch)
  local explosionSound = audio.loadSound("sounds/" .. text .. ".mp3")
  audio.play(explosionSound)
end

local function readCommand(text)
  if text == nil then return end
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

animateText(ballText)()


physics.addBody(platform, "static")
physics.addBody(leftBoundary, "static")
physics.addBody(rightBoundary, "static")
physics.addBody(box1.box, "static")
physics.addBody(box2.box, "static")
physics.addBody(box3.box, "static")
physics.addBody(ball1, "dynamic", { bounce = 0.3 })

-- Collision and EventListener
ball1:addEventListener("touch", ball.createOnTouch(ball1))
ballText:addEventListener("touch", animateText(ballText))
Runtime:addEventListener("collision", collisionHandler.onCollision)



local function gameLoop()
  if (const.i > 3) then
    local gameEnd    = display.newText("Game End", display.contentCenterX, display.contentCenterY)
    gameEnd.fontSize = 100
    display.remove(ball1)
    ball1 = nil
  elseif (ball1.x < -10 or
        ball1.x > display.contentWidth + 10 or
        ball1.y < -10 or
        ball1.y > display.contentHeight + 10)
  then
    ball.startingPhaseBall(ball1)
  end
end


gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
