



-- Event that gets triggers from the client
addEvent ( "onServerRespawnPlayer", true )
addEventHandler ( "onServerRespawnPlayer", root,
	function ( hx, hy, hz, rotation, mx, my, mz, lx, ly, lz, hospitalName )
		removePedFromVehicle( source )
		fadeCamera( source, false, 1.0, 0, 0, 0 )
		setTimer( setCameraMatrix, 1000, 1, source, mx, my, mz, lx, ly, lz )
		setTimer( fadeCamera, 2000, 1, source, true, 1.0, 0, 0, 0 )
		setTimer( respawnPlayer, 6000, 1, source, hx, hy, hz, rotation )
	end
)

-- Function that respawns the player
function respawnPlayer ( thePlayer, hx, hy, hz, rotation )
	if ( isElement( thePlayer ) ) then
		fadeCamera( thePlayer, true)
		setCameraTarget( thePlayer, thePlayer )
		spawnPlayer( thePlayer, hx + math.random ( 0.1, 2 ), hy + math.random ( 0.1, 2 ), hz, rotation, getElementModel( thePlayer ), 0, 0 )
		exports.VGweaponsync:restorePlayerWeapons( thePlayer )
	end
end