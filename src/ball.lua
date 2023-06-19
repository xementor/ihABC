local const = require "src.const"
local M = {}

function M.createBall()
  local ballGroup = display.newGroup()
  local error = 5
  local ballYPosition = display.contentHeight - error

  local ball = display.newCircle(ballGroup, display.contentCenterX, ballYPosition, const.ballRadius)
  ball.isBullet = true
  ball.myName = "ball"

  local ballAlphabet = display.newText({
    parent = ballGroup,
    text = "C",
    x = display.contentWidth / 2,
    y = display.contentHeight + const.platformWidth,
    width = ball.width,
    height = ball.height,
    font = native.systemFont,
    fontSize = const.ballRadius,
    align = "center"
  })
  ballAlphabet:setTextColor(0, 0, 1)


  return ball
end

function M.createOnTouch(ball2)
  local startX, startY

  local function onTouch(event)
    local phase = event.phase
    if phase == "began" then
      startX = event.x
      startY = event.y
      print(startX)
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

return M
