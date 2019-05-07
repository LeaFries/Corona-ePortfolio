-----------------------------------------------------------------------------------------
-- 
-- menu.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game" )
end

local function gotoHighScores()
	composer.gotoScene( "highscores" )
end