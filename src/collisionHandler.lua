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
    if (obj1.myName == const.lesson.getTargetText(const.i)
          and
          obj2.myName == "ball" and Ball1.platformTouched
        ) and BallText.isTouchable then
      -- correct sound
      audio.play(audio.loadSound("sounds/correct.mp3"))

      -- change charecter
      const.i       = const.i + 1
      BallText.text = const.lesson.getTargetText(const.i)

      -- remove the box
      display.remove(obj1)

      -- Ball
      Ball1.platformTouched = false
      Ball1.alpha = 0

      -- Additional screen for A for Apple
      local text = display.newText({
        text = const.lesson.getTargetWord(const.i),
        x = display.contentCenterX,
        y = display.contentCenterX,
        font = native.systemFont,
        fontSize = const.fontSize,
        align = "center"
      })

      timer.performWithDelay(1000, function()
        display.remove(text)
      end
      )

      timer.performWithDelay(2000, function()
        animateText(BallText)({ phase = "ended" })
      end)
      timer.performWithDelay(4000, function()
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
