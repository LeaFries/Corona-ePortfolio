-----------------------------------------------------------------------------------------
-- 
-- main.lua
-- 
-----------------------------------------------------------------------------------------

-- include physics engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- random number generator
math.randomseed( os.time() )

-- configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85, 
            width = 90, 
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        }, 
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}
local objectSheet = graphics.newImageSheet( "pictures/gameObjects.png", sheetOptions )

-- initialize variables
local lives = 3
local score = 0
local died = false

local asteroidsTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText

-- set up display groups
local backGroup = display.newGroup() -- display group for the background image
local mainGroup = display.newGroup() -- display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()   -- display group for UI objects like the score

-- load background
local background = display.newImageRect( backGroup, "pictures/background.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- newImageRect( <display group>, <table of image sheet, frame number, width, height )
ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true } )
ship.myName = "ship"