-- Table that hold the data
local statsTable = {}

-- Function update the stat of a player
function updatePlayerStat( thePlayer, stat, value )
	if not ( isElement( thePlayer ) ) or not ( stat ) or not ( value ) then
		return false
	elseif not ( type ( stat ) == "string" ) or not ( type ( value ) == "number" ) then
		return false
	else
		if ( checkPlayerStats ( thePlayer  ) ) then
			if ( statsTable[ thePlayer ] ) and not ( statsTable[ thePlayer ][ stat ] ) then statsTable[ thePlayer ][ stat ] = 0 end
			statsTable[ thePlayer ][ stat ] = statsTable[ thePlayer ][ stat ] + value
			exports.VGuserdata:setPlayerData( thePlayer, "stats", toJSON( statsTable[ thePlayer ] ) )
			return true
		end
	end
end

-- Function to get the stat of a player
function getPedStat( thePlayer, stat )
	if not ( isElement( thePlayer ) ) or not ( stat ) then
		return false
	elseif not ( type ( stat ) == "string" ) then
		return false
	else
		if ( checkPlayerStats ( thePlayer  ) ) then
			if ( statsTable[ thePlayer ] ) and not ( statsTable[ thePlayer ][ stat ] ) then 
				return false
			else
				return statsTable[ thePlayer ][ stat ]
			end
		end
	end
end

-- Function to get the table with all the stats
function getPlayerStatTable( thePlayer )
	if not ( isElement( thePlayer ) ) then
		return false
	else
		if ( checkPlayerStats ( thePlayer  ) ) then
			return statsTable[ thePlayer ]
		end
	end
end

-- Function that gets the latests stats of a player
function checkPlayerStats ( thePlayer )
	if not ( statsTable[ thePlayer ] ) then
		local data = exports.VGuserdata:getPlayerData( thePlayer, "stats" )
		if ( data ) then
			statsTable[ thePlayer ] = fromJSON( data )
			return true
		else
			exports.VGuserdata:setPlayerData( thePlayer, "stats", "[ [ ] ]" )
			statsTable[ thePlayer ] = fromJSON( "[ [ ] ]" )
			return true
		end
	else
		return true
	end
end