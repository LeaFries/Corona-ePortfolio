-----------------------------------------------------------------------------------------
-- main.lua
-----------------------------------------------------------------------------------------

local background = display.newImageRect( "../pictures/background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local platform = display.newImageRect( "../pictures/platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight

local balloon = display.newImageRect( "../pictures/balloon.png", 112, 112 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8