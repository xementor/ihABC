local const = require "src.const"
local M = {}

function M.createBall()
  local error = 5
  local ballYPosition = display.contentHeight - error

  local ball = display.newCircle(display.contentCenterX, ballYPosition, const.ballRadius)
  ball.isBullet = true
  ball.myName = "ball"
  ball.platformTouched = false
  return ball
end

function M.createBallAlphabet(text)
  local ballAlphabet = display.newText({
    text = text,
    x = display.contentCenterX,
    y = display.contentCenterY,
    font = native.systemFont,
    fontSize = 50,
    align = "center"
  })
  ballAlphabet:setTextColor(1)
  return ballAlphabet
end

function M.createOnTouch(ball2)
  local startX, startY

  local function onTouch(event)
    local phase = event.phase
    if phase == "began" then
      startX = event.x
      startY = event.y
      -- Handle initial touch event
      display.getCurrentStage():setFocus(ball2)
      ball2.isFocus = true

      -- Set any additional behavior for the touch start, if needed
    elseif ball2.isFocus then
      if phase == "moved" then
        local deltaX = event.x - startX
        local deltaY = event.y - startY

        local velocityX = deltaX * .9  -- Adjust the scaling factor as needed
        local velocityY = deltaY * 1.9 -- Adjust the scaling factor as needed

        ball2:setLinearVelocity(velocityX, velocityY)
      elseif phase == "ended" or phase == "cancelled" then
        display.getCurrentStage():setFocus(nil)
        ball2.isFocus = false
      end
    end

    return true -- To prevent propagation of the touch event to underlying objects
  end

  return onTouch
end

function M.startingPhaseBall(ball)
  ball.x = display.contentCenterX
  ball.y = const.ballYPosition
  ball:setLinearVelocity(0, 0)
  ball.alpha = 0

  transition.to(ball, { alpha = 1, time = 4000, })
end

return M
