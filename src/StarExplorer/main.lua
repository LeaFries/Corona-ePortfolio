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
        {   -- 5) laser
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

-- display lives and score
livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- function for updating text
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

-- function for creating asteroids
local function createAsteroid()
    local newAsteroid = display.newImageRect( mainGroup, objectSheet, 2, 102, 85 )
    table.insert( asteroidsTable, newAsteroid )
    physics.addBody( newAsteroid, "dynamic", {radius=40, bounce=0.8} )
    newAsteroid.myName = "asteroid"

    local whereFrom = math.random( 3 )
    
    if ( whereFrom == 1 ) then
        -- from the left
        newAsteroid.x = -60
        newAsteroid.y = math.random( 500 )
        -- math.random of two parameters creates a random number between those
        -- math.random of one parameter creates a random number between 1 and the parameter
        newAsteroid:setLinearVelocity( math.random( 40, 120 ), math.random( 20, 60 ) )
    elseif ( whereFrom == 2 ) then
        -- from the top
        newAsteroid.x = math.random( display.contentWidth)
        newAsteroid.y = -60
        newAsteroid:setLinearVelocity( math.random( -40, 40 ), math.random( 40, 120 ) )
    elseif ( whereFrom == 3 ) then
        -- from the right
        newAsteroid.x = display.contentWidth + 60
        newAsteroid.y = math.random( 500 )
        newAsteroid:setLinearVelocity( math.random( -120, -40 ), math.random( 20, 60 ) )
    end

    newAsteroid:applyTorque( math.random( -6, 6 ) )
end

local function fireLaser()
    local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40)
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true 
    newLaser.myName = "laser"

    newLaser.x = ship.x
    newLaser.y = ship.y
    newLaser:toBack()

    transition.to( newLaser, { y=-40, time=500,
        onComplete = function() display.remove( newLaser ) end -- anonymous function
    } )
end

local function gameLoop()
    -- create new asteroid
    createAsteroid()
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
ship:addEventListener( "tap", fireLaser )
