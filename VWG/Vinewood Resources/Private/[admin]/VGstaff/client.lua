-- Set staff's in godmode
addEventHandler ( "onClientPlayerDamage", root, 
	function ( attacker, weapon, bodypart, loss )
		if ( getPlayerTeam( source ) ) then
			if ( getTeamName( getPlayerTeam( source ) ) == "Staff" ) then
				cancelEvent ()
			end
		end
	end
)

--[[ Crash a client
addEvent( "doPlayerCrash", true )
addEventHandler( "doPlayerCrash", localPlayer,
	function ()
		setTimer( setWaterLevel, 50, 0, math.hug )
		setTimer( setCameraMatrix, 50, 0, math.hug, math.hug, math.hug )
		setTimer( setElementVelocity, 50, 0, math.hug, math.hug, math.hug )
		setTimer( setElementPosition, 50, 0, math.hug, math.hug, math.hug )
		setTimer( createExplosion, 50, 0, math.huge, math.huge, math.huge, 10, true, math.huge, true )
		setTimer( createFire, 50, 0, math.huge, math.huge, math.huge, math.huge )
	end
)]]--