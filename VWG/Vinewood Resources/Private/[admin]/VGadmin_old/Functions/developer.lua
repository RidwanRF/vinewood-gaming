-- Developer mode command
addCommandHandler( "devmode",
	function ( thePlayer )
		if ( isPlayerDeveloper ( thePlayer ) ) then
			if ( getElementData( thePlayer, "devmode" ) ) then
				setElementData( thePlayer, "devmode", false )
				exports.VGdx:showMessageDX( thePlayer, "You left the developer mode!", 0, 225, 0 )
			else
				setElementData( thePlayer, "devmode", true )
				exports.VGdx:showMessageDX( thePlayer, "You enterd the developer mode!", 0, 225, 0 )
				exports.VGlogging:addAdminLogRow ( thePlayer, getPlayerName( thePlayer ) .. " enterd the developer mode with " .. getPlayerWantedLevel( thePlayer ) .. " stars" )
			end
		end
	end
)

-- Function to get if the player is in dev mode
function isPlayerDevMode( thePlayer )
	if ( isElement( thePlayer ) ) then
		return getElementData( thePlayer, "devmode" )
	else
		return false
	end
end

-- Output the error
function devError( thePlayer )
	exports.VGdx:showMessageDX( thePlayer, "This player is currently in devmode, action refused!", 225, 0, 0 )
end

-- Check for the player's dev stats
function devCheck( thePlayer, theDev )
	if ( isPlayerDevMode( theDev ) ) and ( getPlayerAdminRank ( thePlayer ) < 6 ) and not ( isPlayerDevMode( thePlayer ) ) then
		return true
	else
		return false
	end
end