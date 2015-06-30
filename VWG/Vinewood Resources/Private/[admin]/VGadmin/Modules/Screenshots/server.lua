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
        if ( screenshots[ aPlayer ] ) then
            for _, admin in ipairs ( screenshots[ screenshots[ aPlayer ] ][1] ) do
                if ( admin ) and ( admin == client ) then
                    return
                end
            end

            table.insert( screenshots[ screenshots[ aPlayer ] ][1], client )
            return
        end

        if ( isElement( aPlayer ) ) and ( checkPlayerACL ( client ) ) then
            local rand = exports.VGutils:randomString( 20 )
            screenshots[ rand ] = { { client }, aPlayer }
            screenshots[ aPlayer ] = rand
            takePlayerScreenShot( aPlayer, 900, 900, rand, 35, 40000 )
        end
    end
)

-- Event after a screenshot as been taken and sent to the server
addEventHandler( "onPlayerScreenShot", root,
    function ( _, status, pixels, timestamp, id )
        if ( status == "ok" ) and ( screenshots[ id ] ) and ( isElement( screenshots[ id ][2] ) ) then
            local data = screenshots[ id ]

            screenshots[ id ] = nil

            for _, admin in ipairs ( data[1] ) do
                if ( isElement( admin ) ) then
                    data.admin = admin
                    break
                end
            end

            exports.VGlogging:log( "admin", data.admin, getPlayerName( data.admin ) .. " made a screenshot of " .. getPlayerName( data[2] ) .. " (" .. md5( id .. timestamp ) .. ")" )

            local file = fileCreate( "screenshots/" .. md5( id .. timestamp ) .. ".jpg" )
            fileWrite( file, pixels )
            fileClose( file )

            exec( "mtasa", "INSERT INTO screenshots SET unique_id = ?, nick = ?, serial = ?, account = ?, admin = ?, timestamp = ?", 
                md5( id .. timestamp ),
                getPlayerName( data[2] ),
                getPlayerSerial( data[2] ),
                exports.VGaccounts:getPlayerAccountName( data[2] ),
                getPlayerName( data.admin ),
                getRealTime().timestamp
            )

            screenshots[ data[2] ] = nil

            for _, admin in ipairs ( data[1] ) do
                if ( isElement( admin ) ) then
                    triggerClientEvent( admin, "onClientLoadPlayerScreenShot", admin, status, pixels, md5( id .. timestamp ) )
                    reloadScreenShotWindow( data[2], admin )
                end
            end
        else
            local data = screenshots[ id ]
            screenshots[ data[2] ] = nil
            screenshots[ id ] = nil
            for _, admin in ipairs ( data[1] ) do
                if ( isElement( admin ) ) then
                    triggerClientEvent( admin, "onClientLoadPlayerScreenShot", admin, "error" )
                end
            end
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
        query( "mtasa", 
            function ( result, data ) 
                triggerClientEvent( data[2], "onClientShowScreenShotWindow", data[2], result or {}, data[1], getPlayerName( data[1] ), getPlayerAccountName( data[1] ) )
            end, { aPlayer, admin }, "SELECT unique_id, admin, timestamp FROM screenshots WHERE account = ? AND hidden = 0 OR serial = ? AND hidden = 0 ORDER BY timestamp DESC", getPlayerAccountName( aPlayer ), getPlayerSerial( aPlayer )
        )
    end
end

-- Remove a screenshot
addEvent( "onServerRemovePlayerScreenShot", true )
addEventHandler( "onServerRemovePlayerScreenShot", root,
    function ( _, id )
        if not ( id ) then return end
        exec( "mtasa", "UPDATE screenshots SET hidden = 1 WHERE unique_id = ?",  id )
        exports.VGlogging:log( "admin", client, getPlayerName( client ) .. " deleted screenshot " .. id )
    end
)

-- View a screenshot
addEvent( "onServerViewPlayerScreenShot", true )
addEventHandler( "onServerViewPlayerScreenShot", root,
    function ( account, id )
        if ( isElement( client ) ) and ( checkPlayerACL ( client ) ) then
            local file = fileOpen ( "screenshots/" .. id .. ".jpg", true )

            if not ( file ) then showMessageDX( client, "Couldn't load the screenshot...  Try again", 255, 0, 0 ) return end

            local buff = fileRead( file, fileGetSize( file ) )
            fileClose( file ) 

            triggerClientEvent( client, "onClientLoadPlayerScreenShot", client, "ok", buff, id, true )
        end
    end
)