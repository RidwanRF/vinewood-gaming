--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--



-- Ban event
addEvent( "onServerPlayerBan", true )
addEventHandler( "onServerPlayerBan", root,
	function ( thePlayer, theTime, theReason, banType )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) )  then
			if ( theTime == 0 ) then banTime = 0 else banTime = getRealTime().timestamp + theTime end

			exports.VGlogging:log( "admin", client, getPlayerName( client ) .. " has banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
			outputChatBox( getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )
			timeexports.VGpunish:addBan ( theReason, banTime, getPlayerAccountName( thePlayer ), getPlayerSerial( thePlayer ), false, getPlayerName( client ), thePlayer )
		end
	end
)