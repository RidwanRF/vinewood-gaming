--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--




-- Disable staff killing
addEventHandler ( "onClientPlayerDamage", root, 
	function ( attacker, weapon, bodypart )
		if ( getPlayerTeam( source ) ) then
			-- Cancel damage for staff and dev's in devmode
			if ( getTeamName( getPlayerTeam( source ) ) == "Staff" ) or ( getElementData( source, "devmode" ) ) then
				cancelEvent()
			end
			
			-- Output a message when a player is in the devmode
			if ( getElementData( source, "devmode" ) ) and ( attacker == localPlayer ) and not ( isPlayerAdmin( localPlayer ) ) then
				exports.VGdx:showMessageDX( "This developer is currently in devmode, you can't damage them!", 225, 0, 0 )
			end
		end
	end
)

-- Function to get if a player is on duty
function isAdminOnDuty( thePlayer )
	if ( isElement( thePlayer ) ) and ( getPlayerTeam( thePlayer ) ) then
		if ( getTeamName( getPlayerTeam( thePlayer ) ) == "Staff" ) then
			return true
		else
			return false
		end
	else
		return false
	end
end