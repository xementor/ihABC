local M = {}

function M.onCollision(event)
  local box1Text = "A"
  local box2Text = "B"
  local box3Text = "C"
  local obj1 = event.object1
  local obj2 = event.object2

  if (event.phase == "began") then
    if ((
            obj1.myName == box1Text or
            obj1.myName == box2Text or
            obj1.myName == box3Text
          ) and
          (obj2.myName == "ball")
        ) then
      -- Remove both the laser and asteroid
      display.remove(obj1)
    end
  end
end

return M
