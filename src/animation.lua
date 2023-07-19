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

function M.moveBoxes(box1, box2, box3)
  -- Move and animate box1 (from left)
  transition.to(box1, { delay = 500, time = 1000, x = box1.iX, xScale = .5, yScale = .5, transition = easing.outQuad })
  transition.to(box1, { delay = 1500, time = 500, alpha = 0.7, xScale = 1.2, yScale = 1.2, transition = easing.outQuad })
  transition.to(box1, { delay = 2000, time = 500, alpha = 1, xScale = 1, yScale = 1, transition = easing.outQuad })

  -- Move and animate box2 (from top)
  transition.to(box2, { delay = 500, time = 1000, y = box2.iY, xScale = .5, yScale = .5, transition = easing.outQuad })
  transition.to(box2, { delay = 1500, time = 500, alpha = 0.7, xScale = 1.2, yScale = 1.2, transition = easing.outQuad })
  transition.to(box2, { delay = 2000, time = 500, alpha = 1, xScale = 1, yScale = 1, transition = easing.outQuad })

  -- Move and animate box3 (from right)
  transition.to(box3, { delay = 500, time = 1000, x = box3.iX, xScale = .5, yScale = .5, transition = easing.outQuad })
  transition.to(box3, { delay = 1500, time = 500, alpha = 0.7, xScale = 1.2, yScale = 1.2, transition = easing.outQuad })
  transition.to(box3, { delay = 2000, time = 500, alpha = 1, xScale = 1, yScale = 1, transition = easing.outQuad })
end

function M.animateScale(obj)
  transition.scaleTo(obj, { xScale = 0.5, yScale = 0.5, time = 200, transition = easing.outQuad })
  transition.scaleTo(obj, { delay = 200, xScale = 1, yScale = 1, time = 1000, transition = easing.outElastic })
end

-- Function to animate an object with shaking effect
function M.animateShake(obj)
  local startX, startY = obj.x, obj.y

  -- Define the shake range and duration
  local shakeRange = 10
  local shakeDuration = 500

  -- Define the number of iterations and easing
  local numIterations = 5
  local easingType = easing.outQuad

  -- Define the shake transition options
  local shakeTransitionOptions = {
    iterations = numIterations,
    yoyo = true,
    time = shakeDuration,
    x = startX,
    y = startY,
    transition = easingType
  }

  -- Apply the shake transition to the object
  transition.to(obj, shakeTransitionOptions)
end

function M.animateFlip(obj)
  -- Define the flip transition options
  local flipTransitionOptions = {
    time = 500,
    transition = easing.outSine,
    onStart = function()
      obj.isVisible = false
    end,
    onComplete = function()
      obj.isVisible = true
    end
  }

  -- Apply the flip transition to the object
  transition.to(obj, {
    rotationY = 90,
    onComplete = function()
      transition.to(obj, { rotationY = 0 })
    end
  })
  transition.to(obj, flipTransitionOptions)
end

-- Call the function to animate the object
return M
