
local tostring = tostring
local tonumber = tonumber
local unpack = unpack
local loadstring = loadstring

-- Get the cursor visable
local isShowing = false

function getCursorWorldModelID( )
	-- Check if the player cursor is showing else return false
	if not ( isCursorShowing ( ) ) then
		return false, "Cursor not showing"
	end
	
	-- Get the positions from the world
	local camX, camY, camZ = getCameraMatrix( )
	local cursorX, cursorY, endX, endY, endZ = getCursorPosition( )
	
	-- Use processLineOfSight to get the objectID
	local surfaceFound, targetX, targetY, targetZ, targetElement, nx, ny, nz, material, lighting, piece, objectID, xc, yc, zc, ux, uy, uz, worldLODModelID
	= processLineOfSight( camX, camY, camZ, endX, endY, endZ, true, true, true, true, true, true, false, true, localPlayer, true )
	
	-- If we've got the building ID return it false otherwise
	if ( objectID ) then
		return objectID
	else
		return false, "ObjectID not found"
	end
end

function getCursorWorldLODModelID( )
	-- Check if the player cursor is showing else return false
	if not ( isCursorShowing ( ) ) then
		return false, "Cursor not showing"
	end
	
	-- Get the positions from the world
	local camX, camY, camZ = getCameraMatrix( )
	local cursorX, cursorY, endX, endY, endZ = getCursorPosition( )
	
	-- Use processLineOfSight to get the LODID
	local surfaceFound, targetX, targetY, targetZ, targetElement, nx, ny, nz, material, lighting, piece, objectID, xc, yc, zc, ux, uy, uz, worldLODModelID
	= processLineOfSight( camX, camY, camZ, endX, endY, endZ, true, true, true, true, true, true, false, true, localPlayer, true )
	
	-- If we've got the LODID return it false otherwise
	if ( worldLODModelID ) then
		return worldLODModelID
	else
		return false, "LODID not found"
	end
end

function getCursorWaterHit( )
	-- Check if the player cursor is showing else return false
	if not ( isCursorShowing ( ) ) then
		return false, "Cursor not showing"
	end
	
	-- Get the positions from the world
	local camX, camY, camZ = getCameraMatrix( )
	local cursorX, cursorY, endX, endY, endZ = getCursorPosition( )
	
	-- Use testLineAgainstWater to get if we hit water
	local waterHit, x, y, z = testLineAgainstWater ( camX, camY, camZ, endX, endY, endZ )
	
	-- If we've hitted water return a bool
	if ( waterHit ) then
		return true, "Water hit"
	else
		return false, "No water hit"
	end
end

function getCursorMapWorldPosition( )
	-- Check if the map is visable
	if not ( isPlayerMapVisible( ) ) then
		return false, "Map not showing"
	end
	
	-- Check if the player cursor is showing else return false
	if not ( isCursorShowing ( ) ) then
		return false, "Cursor not showing"
	end
	
	local screenX, screenY = guiGetScreenSize ()
	local cursorX, cursorY = getCursorPosition( )
	local cursorsX, corsorsY = ( cursorX * screenX ), ( cursorY * screenY )
	local minMapX, minMapY, maxMapX, maxMapY = getPlayerMapBoundingBox( )
	
	-- Check if the player clicked outside the map
	if ( cursorsX < minMapX ) or ( cursorsX > maxMapX ) or ( corsorsY < minMapY ) or ( corsorsY > maxMapY ) then
		return false, "Clicked outside map"
	end
	
	local mapSizeX, mapSizeY = maxMapX - minMapX, maxMapY - minMapY
	local posX = ( ( ( ( cursorsX - minMapX ) / mapSizeX ) * 6000 ) - 3000 )
	local posY = ( 3000 - ( ( ( corsorsY - minMapY ) / mapSizeY ) * 6000 ) )
	
	-- Return the position
	return posX, posY
end

-- Run the client function call
addEvent( "onServerCallsClientFunction", true )
addEventHandler( "onServerCallsClientFunction", resourceRoot,
	function ( funcname, ... )
		local arg = { ... }
		if ( arg[ 1 ] ) then
			for key, value in next, arg do arg[ key ] = tonumber( value ) or value end
		end
		
		loadstring( "return "..funcname ) () ( unpack( arg ) )
	end
)

-- High ping thing
local isLagging = false

setTimer(
	function ()
		if ( getPlayerPing( localPlayer ) > 1200 ) then
			outputChatBox( "Your ping is too high, all your controls are disabled untill your ping lowers!", 225, 0, 0 )
			toggleAllControls ( localPlayer, false ) isLagging = true
		else
			if ( isLagging ) then toggleAllControls ( localPlayer, true ) isLagging = false end
		end
	end, 60000,1
)

-- Command to get the LOD and Object ID
addCommandHandler( "getmodel",
	function ()
		if ( isCursorShowing ( ) ) then
			isShowing = false
			showCursor( false )
		else
			isShowing = true
			showCursor( true )
		end
	end
)

-- When the client clicks
addEventHandler ( "onClientClick", root,
	function ( button, state )
		if ( isShowing ) and ( button == "left" ) and ( state == "down" ) then
			outputChatBox( "Object: " .. tostring( getCursorWorldModelID( ) ) .. " - LOD: ".. tostring( getCursorWorldLODModelID( ) ), 0, 225, 0 )
		end
	end
)

---------------------
setAmbientSoundEnabled( "gunfire", false )
