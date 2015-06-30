--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Table with the release points
local jailPoints = {
	["LS1"] = { 1535.93, -1670.89, 13 },
	["LS2"] = { 638.95, -571.69, 15.81 },
	["LS3"] = { -2166.05, -2390.38, 30.04 },
	["SF1"] = { -1606.34, 724.44, 11.53 },
	["SF2"] = { -1402.04, 2637.7, 55.25 },
	["LV1"] = { 2290.46, 2416.55, 10.3 },
	["LV2"] = { -208.63, 978.9, 18.73 }
}

-- Table with the jailed players in it
local jails = {}

-- Function for when the resource start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "jailTable" )
		if ( tbl ) then jails = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "jailTable", jails )
	end
)

-- Event from client to server
addEvent( "requestPlayerJailTime", true )
addEventHandler( "requestPlayerJailTime", root,
	function ( )
		if ( jails[ source ] ) then
			triggerClientEvent( source, "onSetPlayerJailed", source, jails[ source ].time )
		end
	end
)

-- Function when a player quits
addEventHandler( "onPlayerQuit", root,
	function ( )
		if ( jails[ source ] ) then
			local arr = jails[ source ]
			exec( "mtasa", "UPDATE jails SET jailtime = ?, jailplace = ? WHERE userid = ?", arr.time, arr.place, getPlayerAccountID( source ) )
			jails[ source ] = nil
		end
	end
)

-- Function to jail a player
function jailPlayer ( player, time, place )
	if ( isElement( player ) ) and ( time ) then
		if ( isPlayerJailed( player ) ) then
			jails[ player ].time = jails[ player ].time + time
			exec( "mtasa", "UPDATE jails SET jailtime = ? WHERE userid = ?", jails[ player ].time, getPlayerAccountID( player ) )
			triggerClientEvent( player, "onSetPlayerJailed", player, jails[ player ].time )
			return true
		else
			jails[ player ] = { time = ( time + ( getPlayerWantedLevel( player ) * 100 / 26 ) ), place = place or "LS1" }
			exec( "mtasa", "INSERT INTO jails SET userid=?, jailtime=?, jailplace=? WHERE userid = ?", getPlayerAccountID( player ), jails[ player ].time, place )
			removePedFromVehicle( player )
			togglePlayerControls ( player, false )
			triggerClientEvent( player, "onSetPlayerJailed", player, jails[ player ].time )
			return true
		end
	else
		return false
	end
end

-- Function to unjail a player
function unjailPlayer ( player )
	if ( jails[ player ] ) and ( isPlayerJailed ( player ) ) then
		setElementPosition( player, unpack( jailPoints[ jails[ player ].place ] ) )
		setElementDimension( player, 0 ) setElementInterior( player, 0 )
		exec( "mtasa", "DELETE FROM jails WHERE userid = ?", getPlayerAccountID( player ) )
		togglePlayerControls( player, true )
		jails[ player ] = nil
		triggerClientEvent( player, "onSetPlayerJailed", player, false )
		return true
	end

	return false
end

-- Function to check if a player is jailed and the kind of jail
function isPlayerJailed ( player )
	if ( isElement( thePlayer ) ) and ( jails[ thePlayer ] ) then
		return true, jails[ thePlayer ][ 1 ]
	end

	return false
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

-- Show jail window
addEvent( "onServerShowJailWindow", true )
addEventHandler( "onServerShowJailWindow", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then			
			triggerClientEvent( client, "onClientShowJailWindow", client, exports.VGpunish:isPlayerJailed( thePlayer ) )
		end
	end
)

-- Jail event
addEvent( "onServerPlayerJail", true )
addEventHandler( "onServerPlayerJail", root,
	function ( thePlayer, theTime, theReason )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) )  then
			exports.VGpunish:jailPlayer( thePlayer, theTime )
			outputChatBox( getPlayerName( client ) .. " jailed " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )			
			exports.VGlogging:log( "admin", client, getPlayerName( client ) .. " has jailed " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
		end
	end
)

-- Unjail the player
addEvent( "onServerPlayerUnjail", true )
addEventHandler( "onServerPlayerUnjail", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) )  then
			if ( exports.VGpunish:isPlayerJailed( thePlayer ) ) then
				exports.VGpunish:unjailPlayer( thePlayer )
				exports.VGlogging:log( "admin", client, getPlayerName( client ) .. " has unjailed " .. getPlayerName( thePlayer ) .. "" )
				showMessageDX( thePlayer, "You have been unjailed by: " .. getPlayerName( client ) .. "", 0, 225, 0 )
			else
				showMessageDX( client, "This player is not jailed!", 225, 0, 0 )
			end
		end
	end
)

-- Function that loops thru the table with the jails
setTimer( 
	function ()
		for player, jail in pairs ( jails ) do
			if ( jail ) and ( isElement( player ) ) then
				if ( jail.time <= 0 ) then
					unjailPlayer( player )
					return
				end

				jails[ player ].time = jails[ player ].time - 1
			end
		end
	end, 1000, 0 
)
