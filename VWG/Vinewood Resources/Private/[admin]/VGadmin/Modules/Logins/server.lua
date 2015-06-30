--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Get the latest punishments for an account
addEvent( "onServerRequestPlayerLogins", true )
addEventHandler( "onServerRequestPlayerLogins", root,
	function ( player )
		if ( isElement( player ) ) and ( checkPlayerACL ( client ) ) then
			getPlayerLogins( client, player )
		end
	end
)

-- Get the punishments of a player
function getPlayerLogins( admin, player )
    if ( isElement( player ) ) then
        query( "logging",
            function ( result, data ) 
            	triggerClientEvent( data[2], "onClientAdminReceiveLogins", data[2], result, data[1] )
            end, { player, admin }, "SELECT * FROM logs_logins WHERE account = ? OR serial = ? ORDER BY timestamp DESC LIMIT 25", getPlayerAccountName( player ), getPlayerSerial( player )
        )
    end
end