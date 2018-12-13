-----------------------------------------------------------------------------------------
-- 
-- main.lua
-- 
-----------------------------------------------------------------------------------------

-- variable for counting the taps
local tapCount = 0

-- initialize background
local background = display.newImageRect( "../pictures/background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- initialize text for counting the taps
local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )
tapText:setFillColor( 0, 0, 0 )

-- initialize platform
local platform = display.newImageRect( "../pictures/platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight

-- initialize balloon
local balloon = display.newImageRect( "../pictures/balloon.png", 112, 112 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8 -- transparency of balloon

-- include physics engine
local physics = require( "physics" )
physics.start()

-- add physics engine to platform & balloon
physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius=50, bounce=0.3 } )

-- function for tapping on balloon
local function pushBalloon()
    balloon:applyLinearImpulse( 0, -0.75, balloon.x, balloon.y )
    tapCount = tapCount + 1
    tapText.text = tapCount
end

-- set eventListener on background for pushing the balloon
background:addEventListener( "tap", pushBalloon )