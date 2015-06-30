

local table = table


local tostring = tostring
local unpack = unpack

-- Blips showing
local isHouseBlipShowing = {}

setTimer(
	function ()
		for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
			setElementData( thePlayer, "Money", "$" .. convertNumber ( getPlayerMoney( thePlayer ) ) )
			setElementData( thePlayer, "City", getPlayerChatzone( thePlayer ) )
		end
	end, 5000, 0
)

-- Strip the nickname and put a wanted level behind it when the nick changes
addEventHandler( "onPlayerChangeNick", root, 
	function ( oldNick, newNick )
		local _newNick = string.lower( newNick:gsub( "#%x%x%x%x%x%x", "" ) ):gsub( "i", "l" )

		for _, aPlayer in ipairs ( getElementsByType( "player" ) ) do
			local _nick = string.lower( getPlayerName( aPlayer ) ):gsub( "i", "l" ) 

			if ( _newNick == _nick ) then
				exports.VGdx:showMessageDX( source, "Sorry, but this name has already been taken by someone else.", 255, 0, 0 ) 
				cancelEvent()
				return
			end
		end

		local nick = newNick:gsub( "#%x%x%x%x%x%x", "" )

		if ( nick:len() < 1 ) then
			exports.VGdx:showMessageDX( source, "Sorry, but your name contains invalid characters or hex color codes.", 255, 0, 0 ) 
			cancelEvent()
			return
		end

		if ( newNick:find( "#%x%x%x%x%x%x" ) ) then
			setPlayerName( source, nick )
			cancelEvent()
			return
		end

		if ( nick ~= oldNick:gsub( "#%x%x%x%x%x%x", "" ) ) then
			setPlayerNametagText( source, string.sub( nick, 0, 18 ) .. " (" .. getPlayerWantedLevel( source ).. ")" )
			exports.VGstaff:createNewAdminDxMessage( oldNick.." is now known as "..nick, 225, 0, 0 )
			exports.VGlogging:log( 'nick', source, nick )
		end
	end
)

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

-- Function to get a player's chatzone
function getPlayerChatzone( thePlayer )
	local x, y, z = getElementPosition(thePlayer)
	if x < -920 then
		return "SF"
	elseif y < 420 then
		return "LS"
	else
		return "LV"
	end
end

-- Get a random string
function stringRandom( length )
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

-- Function to call a client function
function callClientFunction( client, funcname, ... )
    local arg = { ... }
    if ( arg[ 1 ] ) then
        for key, value in next, arg do
            if ( type( value ) == "number" ) then arg[ key ] = tostring( value ) end
        end
    end
    
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack( arg or { } ) )
end

-- Get the player pos
function pos( thePlayer )
	local function round( number, decimal )
		local multiplier = 10^( decimal or 3 )
		return math.floor( number * multiplier + 0.5 ) / multiplier
	end

	local x, y, z = getElementPosition( thePlayer )
	local rotation = getPedRotation( thePlayer )
	local dimension, interior = getElementDimension( thePlayer ), getElementInterior( thePlayer )

	return round( x ), round( y ), round( z ), round( rotation ), round( dimension ), round( interior )
end


-- Get the current position
addCommandHandler( "pos",
	function ( thePlayer )
		local x, y, z, r, d, i = pos( thePlayer )

		outputChatBox( "X: " .. x .. " Y: " .. y .. " Z: " .. z .. " Rotation: " .. r .. " Dimension: " .. d .. " Interior: " .. i .. "", thePlayer, 0, 225, 0 )
		outputChatBox( "{ " .. x .. ", " .. y .. ", " .. z .. ", " .. r .. " }", thePlayer, 0, 225, 0 )
	end
)

-- Show house blips
addEvent( "showHousingBlips", true )
addEventHandler( "showHousingBlips", root,
	function ()
		if not ( isHouseBlipShowing[ client ] ) then isHouseBlipShowing[ client ] = false end
		exports.VGhousing:showHouseBlips( client, not isHouseBlipShowing[ client ] )
		isHouseBlipShowing[ client ] = not isHouseBlipShowing[ client ]
	end
)

-- On error
addEventHandler( "onDebugMessage", root, 
	function( message, level, file, line )
		if ( level == 1 ) then
			exports.VGlogging:log( "error", message, file, line )
		end
	end
)

addEventHandler( "onPlayerJoin", root,
	function()
		local nick = getPlayerName( source )

		if ( nick:find( "#%x%x%x%x%x%x" ) ) then
			nick = nick:gsub( "#%x%x%x%x%x%x", "" )

			if ( nick:len() > 0 ) then
				setPlayerName( source, nick )
			else
				setPlayerName( source, "Noob_" .. tostring( math.random( 100 ) ) )
			end
		end	
	end
)