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

-- Call the function to animate the object
return M
