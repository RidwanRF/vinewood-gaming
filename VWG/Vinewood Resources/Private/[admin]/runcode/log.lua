addEvent( "clientRuncodeResult", true )
addEventHandler( "clientRuncodeResult", root, 
    function( cmd, res )
        logRuncode( client, cmd, res, "client" )
    end
)

function logRuncode( plr, cmd, res, rType )
    exports.VGlogging:log( "runcode", plr, cmd, res or "", rType or "unknown" )
end