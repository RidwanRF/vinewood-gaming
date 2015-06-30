-- Function that checks if a vehicle is laying on his roof
function isVehicleOnRoof( theVehicle )
    local rx, ry = getElementRotation( theVehicle )
    if ( rx > 90 ) and ( rx < 270 ) or ( ry > 90 ) and ( ry < 270 ) then
        return true
	else
		return false
    end
end

-- Function that convert R G B A to a hex color
function RGBToHex( red, green, blue, alpha )
	if not ( red ) or not ( green ) or not ( blue ) then
		return false
	end

	if ( red < 0 ) or ( red > 255 ) or ( green < 0 ) or ( green > 255 ) or ( blue < 0 ) or ( blue > 255 ) then
		return false
	end
	
	if ( alpha ) then
		if ( alpha < 0 ) or ( alpha > 255 ) then
			return false
		end
	end
	
	-- Check for alpha and return the hex
	if ( alpha ) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

-- Get the size of a table
function getTableSize ( table )
    local iter = 0
    for _, _ in pairs( table ) do iter = iter + 1 end
    return iter
end

-- Get a exact copy of the table
function getTableCopy ( table )
    local tbl = {}
    for key, value in pairs( table ) do
        if ( type( value ) == "table" ) then 
			tbl[ key ] = getTableCopy( value )
        else 
			tbl[ key ] = value 
		end
    end
    return tbl
end

-- Check if a ped is aiming
function isPedAiming ( thePed )
	if ( isElement( thePed ) ) then
		if ( getElementType( thePed ) == "player" ) or ( getElementType( thePed ) == "ped" ) then
			if ( getPedTask( thePed, "secondary", 0) == "TASK_SIMPLE_USE_GUN" ) then
				return true
			end
		end
	end
	return false
end

-- Get player from name part
function getPlayerFromNamePart( aName )
	local result = false
    if ( aName ) then
        for i, aPlayer in ipairs( getElementsByType( "player" ) ) do
            if ( string.find( getPlayerName( aPlayer ):lower(), tostring( aName ):lower(), 1, true ) ) then
				if ( result ) then return false end
					result = aPlayer 
				end
			end
		end
    return result
end

-- Function that converts a number into a proper string
function convertNumber ( theNumber )
	if ( theNumber ) then
		local function cvtNumber( theNumber )  
			local formatted = theNumber  
			while true do      
				formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )    
				if ( k == 0 ) then      
					break   
				end  
			end  
			return formatted
		end
		return tostring( cvtNumber( theNumber ) )
	end
end

-- Get a random string
function randomString( length )
	local c = 
	{ "a", "b", "c", 
	"d", "e", "f", 
	"g", "h", "i",
	"j", "k", "l", 
	"m", "n", "o", 
	"p", "q", "r", 
	"s", "t", "u", 
	"v", "w", "x", 
	"y", "z", "0",
	"1", "2", "3",
	"4", "5", "6",
	"7", "8", "9" }
	local st = {}
	for i=1,length or 12 do
		if ( math.random( 1, 2 ) == 1 ) then
			table.insert( st, string.upper( c[ math.random( 1, #c ) ] ) )
		else
			table.insert( st, string.lower( c[ math.random( 1, #c ) ] ) )
		end
	end
	return( table.concat( st ) )
end

-- Function to get all players with a certain occupation
function getPlayersFromOccupation ( occupation )
	if ( occupation ) and ( type( occupation ) == "string" ) then
		local tbl = {}
		for i, aPlayer in ipairs( getElementsByType( "player" ) ) do
			if ( getElementData( aPlayer, "occupation" ) ) and ( getElementData( aPlayer, "occupation" ) == occupation ) then
				table.insert( tbl, aPlayer )
			end
		end
		return tbl
	else
		return false
	end
end

-- Function to get all players with a certain group
function getPlayersFromGroup ( group )
	if ( group ) and ( type( group ) == "string" ) then
		local tbl = {}
		for i, aPlayer in ipairs( getElementsByType( "player" ) ) do
			if ( getElementData( aPlayer, "group" ) ) and ( getElementData( aPlayer, "group" ) == group ) then
				table.insert( tbl, aPlayer )
			end
		end
		return tbl
	else
		return false
	end
end

-- Convert seconds to a valid time
function secondsToTimeString( seconds )
	if ( seconds ) then
		if ( seconds == 0 ) then return "0 second (permanently)" end
		local table = { { "day", 60*60*24 },  { "hour", 60*60 },  { "minute", 60 },  { "second", 1 } }
		for i, item in ipairs( table ) do
			local t = math.floor( seconds / item[ 2 ] )
			if ( t > 0 ) or ( i == #table ) then
				return tostring( t ) .. " " .. item[ 1 ] .. ( t ~= 1 and "s" or "" )
			end
		end
	end
end

-- Timestamp to a date
function timestampToDate ( stamp, timeType )
	-- Get the time data
	local time = ( stamp ) and getRealTime( stamp ) or getRealTime( )
	local year = time.year + 1900
	local month = time.month + 1
	local day = time.monthday
	local hour = time.hour
	local minute = time.minute
	local second = time.second
	
	local day = ( day < 10 ) and "0" .. day or day
	local month = ( month < 10 ) and "0" .. month or month
	local hour = ( hour < 10 ) and "0" .. hour or hour
	local minute = ( minute < 10 ) and "0" .. minute or minute
	local second = ( second < 10 ) and "0" .. second or second
	
	if not ( timeType ) or ( timeType == 1 ) then
		return "" .. year .."-" .. month .."-" .. day .." " .. hour ..":" .. minute ..":" .. second ..""
	else
		return "" .. day .."-" .. month .."-" .. year .." " .. hour ..":" .. minute ..":" .. second ..""
	end
end

-- Get the zone of the user
function getPlayChatZone( thePlayer )
	if ( isElement( thePlayer ) ) then
		local x, y, z = getElementPosition(thePlayer)
		if x < -920 then
			return "SF"
		elseif y < 420 then
			return "LS"
		else
			return "LV"
		end
	else
		return false
	end
end