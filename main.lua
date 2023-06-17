-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require( "physics" )
physics.start()


local height = 570

local background = display.newImageRect( "background.png", 360, height )
background.x = display.contentCenterX
background.y = display.contentCenterY


-- Four Box
local boxPositionX = 55
local boxGap = 5
local boxSize = 100
local fontSize = 50


local box1Group = display.newGroup()
local box1 = display.newRect(box1Group, boxPositionX, 10, boxSize, boxSize)
local box1Alphabet = display.newText({
    parent = box1Group,
    text = "A",
    x = box1.x,
    y = box1.y+boxSize/2-fontSize/2,
    width = box1.width,
    height = box1.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
box1Alphabet:setTextColor(1, 0, 0)

local box2Group = display.newGroup()
local box2 = display.newRect(box2Group, boxPositionX + boxSize + boxGap, 10, boxSize, boxSize)
local box2Alphabet = display.newText({
    parent = box2Group,
    text = "B",
    x = box2.x,
    y = box1.y+boxSize/2-fontSize/2,
    width = box2.width,
    height = box2.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
box2Alphabet:setTextColor(0, 1, 0)

local box3Group = display.newGroup()
local box3 = display.newRect(box3Group, boxPositionX + boxSize + 2 * boxGap + boxSize, 10, boxSize, boxSize)
local box3Alphabet = display.newText({
    parent = box3Group,
    text = "C",
    x = box3.x,
    y = box3.y + boxSize/2 - fontSize/2,
    width = box3.width,
    height = box3.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
box3Alphabet:setTextColor(0, 0, 1)



-- Place Ball
local ballGroup = display.newGroup()
local error = 5
local radius = 50
local ballYPosition = display.contentHeight - error - 500

local ball = display.newCircle(ballGroup, display.contentCenterX, ballYPosition, radius )
local ballAlphabet = display.newText({
    parent = ballGroup,
    text = "C",
    x = ball.x,
    y = ball.y + boxSize/2 - fontSize/2,
    width = ball.width,
    height = ball.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
ballAlphabet:setTextColor(0, 0, 1)


local startX, startY

local function onTouch(event)
    local phase = event.phase

    if phase == "began" then
        startX = event.x
        startY = event.y
        -- Handle initial touch event
        display.getCurrentStage():setFocus(ballGroup)
        ballGroup.isFocus = true

        -- Set any additional behavior for the touch start, if needed

    elseif ballGroup.isFocus then
        if phase == "moved" then
            local deltaX = event.x - startX
            local deltaY = event.y - startY

            local velocityX = deltaX * 0.9 -- Adjust the scaling factor as needed
            local velocityY = deltaY * 0.9 -- Adjust the scaling factor as needed

            ballGroup:setLinearVelocity(velocityX, velocityY)

        elseif phase == "ended" or phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            ballGroup.isFocus = false

        end
    end

    return true -- To prevent propagation of the touch event to underlying objects
end

ballGroup:addEventListener("touch", onTouch)

--  Platform
local platformWidth = 50

local platform = display.newImageRect("platform.png", 360, platformWidth )
platform.x = display.contentCenterX
platform.y = display.contentHeight + radius

-- Boundary
local boundarygroup = display.newGroup()
display.newRect(boundarygroup, 0, display.contentCenterY, 10, height  )
display.newRect(boundarygroup, display.contentWidth, display.contentCenterY, 10, height  )


-- Adding physic

physics.addBody( platform, "static" )
-- physics.addBody( boundarygroup, "static" )
physics.addBody( ballGroup, "dynamic", { radius=radius/2, bounce=0.2 } )
