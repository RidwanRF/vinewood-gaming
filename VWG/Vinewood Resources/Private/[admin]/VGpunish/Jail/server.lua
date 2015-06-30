




-- Table with the jailed players in it
local jailsTable = {}

-- Function for when the resource start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "jailTable" )
		if ( tbl ) then jailsTable = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "jailTable", jailsTable )
	end
)

-- Event from client to server
addEvent( "requestPlayerJailTime", true )
addEventHandler( "requestPlayerJailTime", root,
	function ( )
		if ( jailsTable[ source ] ) then
			triggerClientEvent( source, "onSetPlayerJailed", source, jailsTable [ source ][ 1 ] )
		end
	end
)

-- Function when a player quits
addEventHandler( "onPlayerQuit", root,
	function ( )
		if ( jailsTable[ source ] ) then
			local aTable = jailsTable[ source ]
			exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE jails SET jailtime=?, jailplace=? WHERE userid=?", aTable[ 1 ], aTable[ 2 ], exports.VGaccounts:getPlayerAccountID( source ) )
			jailsTable[ source ] = nil
		end
	end
)

-- Function to jail a player
function jailPlayer ( thePlayer, time, place, skip )
	if ( isElement( thePlayer ) ) and ( time ) then
		if not ( place ) then place = "LS1" end
		if ( isPlayerJailed( thePlayer ) ) then
			jails[ thePlayer ] = { jailsTable [ thePlayer ][ 1 ] + time, place }
			exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE jails SET jailtime=?, jailplace=? WHERE userid=?", jailsTable [ thePlayer ][ 1 ] + time, place, exports.VGaccounts:getPlayerAccountID( thePlayer ) )
			triggerClientEvent( thePlayer, "onSetPlayerJailed", thePlayer, jailsTable [ thePlayer ][ 1 ] )
			return true
		else
			jailsTable [ thePlayer ] = { time, place }
			local wantedLevel = exports.VGplayers:getPlayerWantedPoints( thePlayer ) or 0
			if not ( skip ) then exports.VGmysql:exec( "GEW783UH230WEGE978GW", "INSERT INTO jails SET userid=?, jailtime=?, jailplace=?", exports.VGaccounts:getPlayerAccountID( thePlayer ), ( wantedLevel * 100 / 26 ) + time, place ) end
			removePedFromVehicle( thePlayer )
			togglePlayerControls ( thePlayer, false )
			triggerClientEvent( thePlayer, "onSetPlayerJailed", thePlayer, jailsTable [ thePlayer ][ 1 ] )
			return true
		end
	else
		return false
	end
end

-- Function to unjail a player
function unjailPlayer ( thePlayer )
	if ( jailsTable[ thePlayer ] ) and ( isPlayerJailed ( thePlayer ) ) then
		local tbl = jailPoints[ jailsTable[ thePlayer ][ 2 ] ]
		local x, y, z = tbl[ 1 ], tbl[ 2 ], tbl[ 3 ]
		setElementPosition( thePlayer, x, y, z )
		setElementDimension( thePlayer, 0 ) setElementInterior( thePlayer, 0 )
		exports.VGmysql:exec( "GEW783UH230WEGE978GW", "DELETE FROM jails WHERE userid=?", exports.VGaccounts:getPlayerAccountID( thePlayer ) )
		togglePlayerControls ( thePlayer, true )
		jailsTable[ thePlayer ] = nil
		triggerClientEvent( thePlayer, "onSetPlayerJailed", thePlayer, false )
	end
end

-- Function to check if a player is jailed and the kind of jail
function isPlayerJailed ( thePlayer )
	if ( isElement( thePlayer ) ) and ( jailsTable[ thePlayer ] ) then
		return true, jailsTable[ thePlayer ][ 1 ]
	else
		return false
	end
end

-- Disabled or enable the controls
function togglePlayerControls ( thePlayer, state )
	if ( thePlayer ) then
		toggleControl ( thePlayer, "fire", state )
		toggleControl ( thePlayer, "next_weapon", state )
		toggleControl ( thePlayer, "previous_weapon", state )
		toggleControl ( thePlayer, "aim_weapon", state )
	end
end

-- Function that loops thru the table with the jails
setTimer( 
	function ()
		for thePlayer, jailsTable in pairs ( jailsTable ) do
			if ( jailsTable ) and ( isElement( thePlayer ) ) then
				if ( jailsTable[ 1 ] <= 0 ) then
					unjailPlayer( thePlayer )
				else
					jailsTable[ 1 ] = jailsTable[ 1 ] - 1
				end
			end
		end
	end, 1000, 0 
)