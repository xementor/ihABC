local const = require "src.const"
local M = {}

function M.onCollision(event)
  local obj1 = event.object1
  local obj2 = event.object2

  print(obj1.myName, obj2.myName)

  if (event.phase == "began") then
    if (obj1.myName == const.ballText
          and
          obj2.myName == "ball"
        ) then
      display.remove(obj1)
    end
  end
end

return M
