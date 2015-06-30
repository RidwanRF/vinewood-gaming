-- Some variables
local healTick = false
local lastAttacks = {}

-- Even for player damage
addEventHandler( "onClientPlayerDamage", root,
	function ( attacker, weapon, body, loss )
		-- Some variables
		local attackerTeam = false
		
		-- Is the attacker is a vehicle get the driver
		if ( isElement( attacker ) ) and ( getElementType( attacker ) == "vehicle" ) then
			attacker = getVehicleController( attacker ) or attacker
		end
		
		-- Get the attacker teamname
		if ( isElement( attacker ) ) and ( getElementType( attacker ) == "player" ) then
			local team = getPlayerTeam( attacker )
			if ( team ) then
				attackerTeam = getTeamName( team )
			end
		end
		
		-- Reduce calculations by ending here for all players uninvolved
		if ( source ~= localPlayer ) and ( attacker ~= localPlayer ) then
			return
		end
					
		-- Dimension check
		if ( attacker ) and ( getElementDimension( attacker ) ~= getElementDimension( source ) ) then
			cancelEvent()
			return
		end
				
		-- Disable damage for staff
		if ( getTeamName( getPlayerTeam( source ) ) == "Staff" ) then
			cancelEvent()
			return
		end
		
		-- Medic healing check
		if ( attacker ) and ( getElementType( attacker ) == "player" ) and ( weapon == 41 ) then
			if ( attackerTeam ) and ( attackerTeam == "Emergency Services" ) and ( source == localPlayer ) then
				if not ( healTick ) or ( getTickCount() - healTick > 1000 ) then
					healTick = getTickCount()
					local legit = checkForRecentAttack ( attacker, source, 30000 )
					triggerServerEvent( "onServerMedicHeal", localPlayer, attacker, weapon, body, loss, legit )
				end
				cancelEvent()
				return
			end
		end
		
		-- Add the last players attacked in a list
		if ( attacker ) and ( attacker ~= source ) then
			if not ( lastAttacks[ attacker ] ) then lastAttacks[ attacker ] = {} end
			lastAttacks[ attacker ][ source ] = getTickCount()
		end
	end
)

-- Check if the player recently attacked the given player
function checkForRecentAttack ( attacker, thePlayer, theTime )
	if ( attacker ) and ( lastAttacks[ attacker ] ) and ( lastAttacks[ attacker ][ thePlayer ] ) then
		if ( getTickCount() - lastAttacks[ attacker ][ thePlayer ] < theTime ) then
			return true
		else
			return false
		end
	else
		return false
	end
end

-- Disable stealth kill
addEventHandler( "onClientPlayerStealthKill", root,
	function ()
		cancelEvent()
	end
)