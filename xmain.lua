-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require("physics")
physics.start()
-- physics.setDrawMode( "debug" )


local height = 570
local ballRadius = 30

local background = display.newImageRect("background.png", 360, height)
background.x = display.contentCenterX
background.y = display.contentCenterY


-- Four Box
local boxPositionX = 55
local boxGap = 5
local boxSize = 100
local fontSize = 50


local box1Group = display.newGroup()

local box1Text = "A"
local box1 = display.newRect(box1Group, boxPositionX, 10, boxSize, boxSize)
box1.myName = box1Text
local box1Alphabet = display.newText({
    parent = box1Group,
    text = box1Text,
    x = box1.x,
    y = box1.y + boxSize / 2 - fontSize / 2,
    width = box1.width,
    height = box1.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
box1Alphabet:setTextColor(1, 0, 0)

local box2Group = display.newGroup()
local box2Text = "B"
local box2 = display.newRect(box2Group, boxPositionX + boxSize + boxGap, 10, boxSize, boxSize)
box2.myName = box2Text
local box2Alphabet = display.newText({
    parent = box2Group,
    text = box2Text,
    x = box2.x,
    y = box1.y + boxSize / 2 - fontSize / 2,
    width = box2.width,
    height = box2.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
box2Alphabet:setTextColor(0, 1, 0)

local box3Group = display.newGroup()
local box3Text = "C"
local box3 = display.newRect(box3Group, boxPositionX + boxSize + 2 * boxGap + boxSize, 10, boxSize, boxSize)
box3.myName = box3Text
local box3Alphabet = display.newText({
    parent = box3Group,
    text = box3Text,
    x = box3.x,
    y = box3.y + boxSize / 2 - fontSize / 2,
    width = box3.width,
    height = box3.height,
    font = native.systemFont,
    fontSize = fontSize,
    align = "center"
})
box3Alphabet:setTextColor(0, 0, 1)

--  Platform
local platformWidth = 50

local platform = display.newRect(0, 0, display.contentWidth, platformWidth)
platform.myName = "platform"
platform:setFillColor(0, 1, 0)
platform.x = display.contentCenterX
platform.y = display.contentHeight + ballRadius

-- Boundary
local leftBoundary = display.newRect(
    display.contentCenterX - (display.contentWidth / 2), display.contentCenterY, 0, display.contentHeight
)
leftBoundary.myName = "platform"

local rightBounary = display.newRect(
    display.contentCenterX + (display.contentWidth / 2), display.contentCenterY, 0, display.contentHeight
)
rightBounary.myName = "platform"



-- Place Ball
local ballGroup = display.newGroup()
local error = 5
local ballYPosition = display.contentHeight - error

local ball = display.newCircle(ballGroup, display.contentCenterX, ballYPosition, ballRadius)
ball.isBullet = true
ball.myName = "ball"

local ballAlphabet = display.newText({
    parent = ballGroup,
    text = "C",
    x = display.contentWidth/2,
    y = display.contentHeight + platformWidth,
    width = ball.width,
    height = ball.height,
    font = native.systemFont,
    fontSize = (ballRadius),
    align = "center"
})
ballAlphabet:setTextColor(0, 0, 1)


local startX, startY

local function onTouch(event)
    local phase = event.phase
    local ballGroup = ball

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

            local velocityX = deltaX * .9  -- Adjust the scaling factor as needed
            local velocityY = deltaY * 1.9 -- Adjust the scaling factor as needed

            ballGroup:setLinearVelocity(velocityX, velocityY)
        elseif phase == "ended" or phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            ballGroup.isFocus = false
        end
    end

    return true -- To prevent propagation of the touch event to underlying objects
end

ball:addEventListener("touch", onTouch)



-- Adding physic


physics.addBody(platform, "static")
physics.addBody(leftBoundary, "static")
physics.addBody(rightBounary, "static")
physics.addBody(box1, "static")
physics.addBody(box2, "static")
physics.addBody(box3, "static")
physics.addBody(ball, "dynamic", { bounce = 0.3 })
-- physics.addBody( ballAlphabet, "dynamic", { bounce=0.3 } )






-- Collision

local function onCollision(event)
    if (event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2
        print(".................")
        print(obj1.myName)
        print(obj2.myName)

        if ((
                    obj1.myName == box1Text or
                    obj1.myName == box2Text or
                    obj1.myName == box3Text
                ) and
                (obj2.myName == "ball")
            )
        then
            -- Remove both the laser and asteroid
            display.remove(obj1)
        end
    end
end


Runtime:addEventListener("collision", onCollision)



-- Game Loop
local function gameLoop()
    if (ball.x < -10 or
            ball.x > display.contentWidth + 10 or
            ball.y < -10 or
            ball.y > display.contentHeight + 10)
    then
        ball.x = display.contentCenterX
        ball.y =  ballYPosition
        ball:setLinearVelocity(velocityX, velocityY)
        ball.alpha = 0

        transition.to( ball, { alpha=1, time=4000,} )
    end
end
gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )