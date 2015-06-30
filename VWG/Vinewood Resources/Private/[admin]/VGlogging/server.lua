-- Load the MySQL query tool
loadstring( exports.MySQL:getQueryTool( '4A^Ppk2N7q9gTq^YERGBj^xWQGuJgj' ) )() MySQL_init()

-- Load some exports
loadstring( exports.VGshortcuts:load() )()

local logFunc = {}

function timestamp()
    return getRealTime().timestamp
end

function getPlayerData( plr )
    if ( isElement( plr ) ) then
        local data   = {}
        data.plr     = plr
        data.ip      = getPlayerIP( plr ) or ""
        data.serial  = getPlayerSerial( plr ) or ""
        data.nick    = getPlayerName( plr ):gsub ( "#%x%x%x%x%x%x", "" ) or ""
        data.account = getPlayerAccountName( plr ) or ""

        return data
    end

    return false
end

function log( logType, plr, ... )
    if ( logType == 'error' ) then
        return logFunc[ logType ]( plr, ... )
    end

    local data = getPlayerData( plr );

    if ( logType ) and ( data ) and ( logFunc[ logType ] ) then
        return logFunc[ logType ]( data, ... )
    end

    return false
end

logFunc.runcode = function ( plr, cmd, res, rType )
    if ( plr ) and ( cmd ) and ( rType ) then
        return exec( "logging", "INSERT INTO logs_runcode SET account = ?, nick = ?, serial = ?, ip = ?, type = ?, command = ?, result = ?, timestamp = ?", plr.account, plr.nick, plr.serial, plr.ip, tostring( rType ), tostring( cmd ), tostring( res ), timestamp() )
    end

    return false
end

logFunc.nick = function ( plr, newNick )
    if ( plr ) and ( newNick ) then
        return exec( "logging", "INSERT INTO logs_nick_changes SET account = ?, new_nick = ?, old_nick = ?, serial = ?, ip = ?, timestamp = ?", plr.account, tostring( newNick ), plr.nick, plr.serial, plr.ip, timestamp() )
    end

    return false
end

logFunc.login = function ( plr )
    if ( plr ) then
        return exec( "logging", "INSERT INTO logs_logins SET account = ?, nick = ?, serial = ?, ip = ?, timestamp = ?", plr.account, plr.nick, plr.serial, plr.ip, timestamp() )
    end

    return false
end

logFunc.error = function ( err, file, line )
    if ( err ) then
        return exec( "logging", "INSERT INTO logs_errors SET file = ?, line = ?, error = ?, timestamp = ?", file or "", line or "", err, timestamp() )
    end

    return false
end

logFunc.admin = function ( plr, action )
    if ( plr ) and ( action ) then
        return exec( "logging", "INSERT INTO logs_admin_actions SET account = ?, nick = ?, serial = ?, ip = ?, action = ?, timestamp = ?", plr.account, plr.nick, plr.serial, plr.ip, tostring( action ), timestamp() )
    end

    return false
end

logFunc.chat = function ( plr, chat, msg, group )
    if ( plr ) and ( chat ) and ( msg ) then
        msg = msg:gsub ( "#%x%x%x%x%x%x", "" )
        group = not group and " " or group
        return exec( "logging", "INSERT INTO logs_chats SET account = ?, nick = ?, serial = ?, ip = ?, chat = ?, chat2 = ?, message = ?, timestamp = ?", plr.account, plr.nick, plr.serial, plr.ip, tostring( chat ), tostring( group ), tostring( msg ), timestamp() )
    end

    return false
end