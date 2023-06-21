local const = require "src.const"
local ball  = require "src.ball"
local M     = {}

function M.onCollision(event)
  local obj1 = event.object1
  local obj2 = event.object2


  if (event.phase == "began") then
    if not Ball1.onPlatform and Ball1.platformTouched then
      local bounceSound = audio.loadSound("sounds/bounce.m4a")
      audio.reserveChannels(1)
      audio.setVolume(0.2, { channel = 1 })
      audio.play(bounceSound, { channel = 1 })
    end
    if (obj1.myName == const.getTargetText(const.i)
          and
          obj2.myName == "ball" and Ball1.platformTouched
        ) then
      audio.play(audio.loadSound("sounds/correct.mp3"))
      Ball1.platformTouched = false
      const.i               = const.i + 1
      BallText.text         = const.getTargetText(const.i)
      display.remove(obj1)
      Ball1.alpha = 0
      timer.performWithDelay(1000, function()
        animateText(BallText)()
        ball.startingPhaseBall(Ball1)
      end)
    elseif (obj1.myName == "platform" and obj2.myName == "ball") then
      Ball1.platformTouched = true
      Ball1.onPlatform = false
    else
      audio.play(audio.loadSound("sounds/hit.wav"))
      -- can add animation
      -- obj1:setFillColor(0, 1, 0)
    end
  end
end

return M
