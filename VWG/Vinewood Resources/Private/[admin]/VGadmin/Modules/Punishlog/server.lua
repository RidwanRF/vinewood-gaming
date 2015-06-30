--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Get the latest punishments for an account
addEvent( "onServerRequestPlayerPunishments", true )
addEventHandler( "onServerRequestPlayerPunishments", root,
	function ( player )
		if ( isElement( player ) ) and ( checkPlayerACL ( client ) ) then
			getPlayerPunishments( client, player )
		end
	end
)

-- Get the punishments of a player
function getPlayerPunishments( admin, player )
    if ( isElement( player ) ) then
        query( "logging",
            function ( result, data ) 
            	triggerClientEvent( data[2], "onClientAdminReceivePunishments", data[2], result, data[1] )
            end, { player, admin }, "SELECT * FROM logs_punishments WHERE account = ? OR serial = ? ORDER BY timestamp DESC", getPlayerAccountName( player ), getPlayerSerial( player )
        )
    end
end