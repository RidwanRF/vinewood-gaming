--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Table with the mutes in it
local mutes = {}

-- Function for when the resource start
addEventHandler( "onResourceStart", resourceRoot,
	function()
		local tbl = exports.VGcache:getTemporaryData( "mutesTable" )
		if ( tbl ) then mutes = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function()
		exports.VGcache:setTemporaryData( "mutesTable", mutes )
	end
)

-- Function when a player quits
addEventHandler( "onPlayerQuit", root,
	function()
		if ( mutes[ source ] ) then
			local arr = mutes[ source ]
			exec( "mtasa", "UPDATE mutes SET mutetime = ?, mutetype = ? WHERE userid = ?", arr.mutetime, arr.mutetype, getPlayerAccountID( source ) )
			mutes[ source ] = nil
		end
	end
)

-- Function to mute a player
function mutePlayer ( player, time, mType )
	if ( isElement( player ) ) and ( time ) and ( mType ) then
		if ( mType == "Global" ) or ( mType == "Main" ) or ( mType == "Support" ) then
			if ( isPlayerMuted( player ) ) then
				mutes[ player ].time = mutes[ player ].time + time
				exec( "mtasa", "UPDATE mutes SET mutetime = ? WHERE userid = ?", mutes[ player ].time, getPlayerAccountID( player ) )
				return true
			else
				mutes[ player ] = { time = time, mType = mType }
				exec( "mtasa", "INSERT INTO mutes SET mutetime = ?, mutetype = ? WHERE userid = ?", time, mType, getPlayerAccountID( player ) )
				return true
			end
		end
	end

	return false
end

-- Function to unmute a player
function unmutePlayer ( player )
	if ( isElement( player ) ) and ( mutes[ player ] ) then
		mutes[ player ] = nil
		return exec( "mtasa", "DELETE FROM mutes WHERE userid = ?", getPlayerAccountID( source ) )
	end
	
	return false
end

-- Function to check if a player is muted and the kind of mute
function isPlayerMuted ( player )
	if ( isElement( player ) ) and ( mutes[ player ] ) then
		return true, mutes[ player ]
	end

	return false
end

-- Function that loops thru the table with the mutes
setTimer( 
	function ()
		for player, mute in pairs( mutes ) do
			if ( mute ) and ( isElement( player ) ) then
				if ( mutes[ 1 ] <= 0 ) then
					unmutePlayer( player )
				end

				mutes[ player ].mutetime = mutes[ player ].mutetime - 1
			end
		end
	end, 1000, 0 
)

-- Show mute window
addEvent( "onServerShowMuteWindow", true )
addEventHandler( "onServerShowMuteWindow", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then			
			triggerClientEvent( client, "onClientShowMutesWindow", client, exports.VGpunish:isPlayerMuted( thePlayer ) )
		end
	end
)

-- Mute event
addEvent( "onServerPlayerMute", true )
addEventHandler( "onServerPlayerMute", root,
	function ( thePlayer, theTime, theReason, theType )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			exports.VGpunish:mutePlayer( thePlayer, theTime, theType )
			if ( theType == "Global" ) then theType = "globally muted" elseif ( theType == "Support" ) then theType = "support chat muted" elseif ( theType == "Main" ) then theType = "main chat muted" end
			outputChatBox( getPlayerName( client ) .. " " .. theType .. " " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )			
			exports.VGlogging:log( "admin", client, getPlayerName( client ) .. " has " .. theType .. " " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
		end
	end
)

-- Unmute event
addEvent( "onServerPlayerUnmute", true )
addEventHandler( "onServerPlayerUnmute", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then			
			if ( exports.VGpunish:isPlayerMuted( thePlayer ) ) then
				exports.VGpunish:unmutePlayer( thePlayer, client )
				exports.VGlogging:log( "admin", client, getPlayerName( client ) .. " has unmuted " .. getPlayerName( thePlayer ) .. "" )
			else
				showMessageDX( client, "This player is not muted", 225, 0, 0 )
			end
		end
	end
)