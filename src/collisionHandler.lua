local const = require "src.const"
local ball  = require "src.ball"
local M     = {}

function M.onCollision(event)
  local obj1 = event.object1
  local obj2 = event.object2


  if (event.phase == "began") then
    if (obj1.myName == const.getTargetText(const.i)
          and
          obj2.myName == "ball" and Ball1.platformTouched
        ) then
      Ball1.platformTouched = false
      const.i = const.i + 1
      BallText.text = const.getTargetText(const.i)
      animateText(BallText)()
      display.remove(obj1)
      ball.startingPhaseBall(Ball1)
    elseif (obj1.myName == "platform" and obj2.myName == "ball") then
      Ball1.platformTouched = true
    end
  end
end

return M
