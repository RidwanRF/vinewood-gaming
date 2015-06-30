--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Screenshots data
local screenshots = {}

-- Take a player screenshot
addEvent( "onServerTakePlayerScreenShot", true )
addEventHandler( "onServerTakePlayerScreenShot", root,
    function ( aPlayer )
        if ( isElement( aPlayer ) ) and ( checkPlayerACL ( client ) ) and not ( screenshots[ aPlayer ] ) then
            local rand = exports.VGutils:randomString( 20 )
            screenshots[ rand ] = { client, aPlayer }
            screenshots[ aPlayer ] = true
            takePlayerScreenShot( aPlayer, 900, 900, rand )
        end
    end
)

-- Event after a screenshot as been taken and sent to the server
addEventHandler( "onPlayerScreenShot", root,
    function ( _, status, pixels, timestamp, id )
        if ( status == "ok" ) then
            local data = screenshots[ id ]
            screenshots[ id ] = nil

            local file = fileCreate( "screenshots/" .. md5( id .. timestamp ) .. ".jpg" )
            fileWrite( file, pixels )
            fileClose( file )

            exec( "INSERT INTO screenshots SET unique_id = ?, nick = ?, serial = ?, account = ?, admin = ?, timestamp = ?", 
                md5( id .. timestamp ),
                getPlayerName( data[2] ),
                getPlayerSerial( data[2] ),
                exports.VGaccounts:getPlayerAccountName( data[2] ),
                getPlayerName( data[1] ),
                getRealTime().timestamp
            )

            screenshots[ data[2] ] = nil
            triggerClientEvent( data[1], "onClientLoadPlayerScreenShot", data[1], status, pixels, md5( id .. timestamp ) )
            reloadScreenShotWindow( data[2], data[1] )
        else

        end
    end
)

-- Open the screenshots window
addEvent( "onServerOpenScreenShotWindow", true )
addEventHandler( "onServerOpenScreenShotWindow", root,
    function ( aPlayer )
        reloadScreenShotWindow( aPlayer, client )
    end
)

-- Reloads the admin screenshot window
function reloadScreenShotWindow( aPlayer, admin )
    if ( isElement( aPlayer ) ) and ( checkPlayerACL ( admin ) ) then
        query( 
            function ( result, data ) 
                triggerClientEvent( data[2], "onClientShowScreenShotWindow", data[2], result, getPlayerName( data[1] ) )
            end, { aPlayer, admin }, "SELECT unique_id, admin, timestamp FROM screenshots WHERE account = ? OR serial = ?", exports.VGaccounts:getPlayerAccountName( aPlayer ), getPlayerSerial( aPlayer )
        )
    end
end
