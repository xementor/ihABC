local M = {}

function M.animateObject(object)
  local originalWidth = object.width
  local originalHeight = object.height
  local scalingFactor = 0.8 -- The factor by which the object will shrink and grow

  -- Shrink animation
  transition.to(object, {
    time = 100,
    width = originalWidth * scalingFactor,
    height = originalHeight * scalingFactor,
    transition = easing.outQuad,
    onComplete = function()
      -- Grow animation
      transition.to(object, {
        time = 100,
        width = originalWidth,
        height = originalHeight,
        transition = easing.inQuad,
        onComplete = function()
          -- Return to original position
          transition.to(object, {
            time = 500,
            x = object.x,
            y = object.y,
            transition = easing.outQuad
          })
        end
      })
    end
  })
end

function M.buttonAnimation(button, func)
  transition.cancel(button) -- Cancel any ongoing transitions on the button
  transition.to(button, {
    time = 100,
    xScale = 0.9,
    yScale = 0.9,
    transition = easing.outQuad,
    onComplete = function()
      transition.to(button, {
        time = 100,
        xScale = 1,
        yScale = 1,
        transition = easing.outQuad,
        onComplete = func
      })
    end
  })
end

function M.animateColor(obj, currentColor, targetColor)
  local transitionTime = 500                  -- Transition duration in milliseconds
  local steps = 10                            -- Number of steps in the animation
  local stepDuration = transitionTime / steps -- Duration of each step in milliseconds
  local colorStep = {}
  for i = 1, 3 do
    colorStep[i] = (targetColor[i] - currentColor[i]) / steps
  end

  local step = 0
  local function updateColor()
    step = step + 1

    for i = 1, 3 do
      currentColor[i] = currentColor[i] + colorStep[i]
    end

    obj:setFillColor(unpack(currentColor))

    if step < steps then
      timer.performWithDelay(stepDuration, updateColor)
    end
  end
  updateColor()
end

function M.scaleObject(ob, func)
  transition.to(ob, {
    time = 500,
    xScale = 1.5,
    yScale = 1.5,
    onComplete = function()
      transition.to(ob, { time = 500, xScale = 1, yScale = 1, onComplete = func })
    end
  })
end

-- Call the function to animate the object
return M
