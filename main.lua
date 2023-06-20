local physics          = require("physics")
local backgroundModule = require("src.background")
local boxesModule      = require("src.boxes")
local const            = require("src.const")
local ball             = require("src.ball")
local barrier          = require("src.barrier")
local collisionHandler = require("src.collisionHandler")
local animation        = require("plugin.animation")

physics.start()


local background = backgroundModule.createBackground()

local box1 = boxesModule.createBox(const.boxPositionX, 10, "A", { 1, 0, 0 })
local box2 = boxesModule.createBox(const.boxPositionX + const.boxSize + const.boxGap, 10, "B", { 0, 1, 0 })
local box3 = boxesModule.createBox(const.boxPositionX + const.boxSize + 2 * const.boxGap + const.boxSize, 10, "C",
  { 0, 0, 1 })

local platform = barrier.createPlatform()
local ball1 = ball.createBall()
local ballText = ball.createBallAlphabet(const.ballText)
local leftBoundary = barrier.createLeftBoundary()
local rightBoundary = barrier.createRightBoundary()



local function animateText(ball)
  local function vong(event)
    transition.to(ball,
      {
        x = display.contentCenterX,
        y = display.contentCenterY,
      }
    )

    transition.scaleTo(ball, { xScale = 2.5, yScale = 2.5, time = 500 })
    transition.scaleTo(ball, { delay = 500, xScale = 2.0, yScale = 2, time = 100 })
    transition.scaleTo(ball, { delay = 500, xScale = .5, yScale = .5 })

    transition.to(ball,
      {
        delay = 600,
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
  if (ball1.x < -10 or
        ball1.x > display.contentWidth + 10 or
        ball1.y < -10 or
        ball1.y > display.contentHeight + 10)
  then
    ball1.x = display.contentCenterX
    ball1.y = const.ballYPosition
    ball1:setLinearVelocity(0, 0)
    ball1.alpha = 0

    transition.to(ball1, { alpha = 1, time = 4000, })
  end
end


gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
