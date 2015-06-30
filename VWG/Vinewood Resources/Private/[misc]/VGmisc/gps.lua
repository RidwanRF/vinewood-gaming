-- Screen position
local screenX, screenY = guiGetScreenSize ()
local markTable = {}

-- GPS function
addEventHandler( "onClientRender", root,
	function ()
		-- If the map is visable show a text with some info
		if ( isPlayerMapVisible( ) ) then
			dxDrawText( "Hold 'RMB' to show the cursor.\nDouble click on the map to mark the position.\nDouble click again to remove the mark!", screenX / 2, screenY - 100, screenX / 2, screenY - 100, tocolor( 255, 255, 255, 255 ), 1.0, "default", "center" )
		end
		
		-- Put the name of the area under it
		if ( isPlayerMapVisible( ) ) then
			local x, y = getCursorMapWorldPosition( )
			if ( x ) then x = getZoneName( x, y, 0 ) else x = "Nothing selected!" end
			dxDrawText( "Area: "..x, screenX / 2, screenY - 50, screenX / 2, screenY - 100, tocolor( 255, 255, 255, 255 ), 1.0, "default-bold", "center" )
			
			-- Show text os housing blips
			dxDrawText( "Press 'H' to show house blips", screenX / 2, screenY - 30, screenX / 2, screenY - 100, tocolor( 255, 255, 255, 255 ), 1.0, "default-bold", "center" )
		end
		
		-- Check if the player is near the mark
		if ( markTable[ "Blib" ] ) and ( isElement( markTable[ "Blib" ] ) ) then
			local x1, y1 = getElementPosition( localPlayer )
			local x2, y2 = getElementPosition( markTable[ "Blib" ] )
			if ( getDistanceBetweenPoints2D ( x1, y1, x2, y2 ) <= 12 ) then
				destroyElement( markTable[ "Blib" ] )
				markTable[ "Blib" ] = false
			end
		end
	end
)

-- When an user presses the H key
addEventHandler( "onClientKey", root, 
	function( button, press ) 
		if ( button == "h" ) and ( press ) and ( isPlayerMapVisible( ) ) then
			triggerServerEvent( "showHousingBlips", localPlayer )
		end
	end
)

-- When the user double clicks
addEventHandler( "onClientDoubleClick", root, 
	function ()
		if ( isPlayerMapVisible( ) ) then
			if ( markTable[ "Blib" ] ) and ( isElement( markTable[ "Blib" ] ) ) then
				destroyElement( markTable[ "Blib" ] )
				markTable[ "Blib" ] = false
			else
				local x, y = getCursorMapWorldPosition( )
				if ( x ) then
					markTable[ "Blib" ] = createBlip ( x, y, 0, 41 )
				end
			end
		end
	end
)

-- Enable they key
bindKey ( "mouse2", "both", 
	function ( _, state )
		if ( isPlayerMapVisible( ) ) then
			if ( state == "down" ) then
				showCursor( true )
			elseif ( state == "up" ) then
				showCursor( false )
			end
		end
	end
)