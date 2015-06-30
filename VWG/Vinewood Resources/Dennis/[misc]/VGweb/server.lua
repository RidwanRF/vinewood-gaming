-- MySQL querytool
loadstring( exports.MySQL:getQueryTool( "4A^Ppk2N7q9gTq^YERGBj^xWQGuJgj" ) )() MySQL_init()

function update()
    local data = {}

    for _, player in ipairs( getElementsByType( "player" ) ) do
        local team = getPlayerTeam( player )

        if ( team ) and ( getTeamName( team ) ~= "Not Logged In" ) then
            local team = getTeamName( team )

            if not ( data[ team ] ) then data[ team ] = {} end
            
            local arr = {}
            arr.occupation = getElementData( player, "Occupation" )
            arr.group = getElementData( player, "Group" ) or ""
            arr.wl = getElementData( player, "WL" )
            arr.city = getElementData( player, "City" )
            arr.money = getElementData( player, "Money" )
            arr.playtime = getElementData( player, "cPlaytime" )
            arr.vip = getElementData( player, "VIP" ) or "No"
            arr.country = getElementData( player, "Country" )
            arr.ping = getPlayerPing( player )

            data[ team ][ getPlayerName( player ) ] = arr
        end
    end

    local JSON = toJSON( data )

    if ( JSON ) then
        exec( "website", "UPDATE scoreboard SET scoreboard_json = ?", JSON )
    end
end

update()
setTimer( update, 30000, 0 )