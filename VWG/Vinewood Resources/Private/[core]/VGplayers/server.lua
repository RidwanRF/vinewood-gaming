


local tonumber = tonumber
local type = type

-- Handle the change of the wanted points
addEventHandler( "onElementDataChange", root,
	function ( data )
		if ( data == "wantedlevel" ) then
			local wantedlevel = getElementData ( source, data )
			if ( wantedlevel >= 10 ) and ( wantedlevel < 20 ) and ( getPlayerWantedLevel( source ) ~= 1 ) then
				setPlayerWantedLevel( source, 1 )
			elseif ( wantedlevel >= 20 ) and ( wantedlevel < 30 ) and ( getPlayerWantedLevel( source ) ~= 2 )  then
				setPlayerWantedLevel( source, 2 )
			elseif ( wantedlevel >= 30 ) and ( wantedlevel < 40 ) and ( getPlayerWantedLevel( source ) ~= 3 )  then
				setPlayerWantedLevel( source, 3 )
			elseif ( wantedlevel >= 40 ) and ( wantedlevel < 50 ) and ( getPlayerWantedLevel( source ) ~= 4 )  then
				setPlayerWantedLevel( source, 4 )
			elseif ( wantedlevel >= 50 ) and ( wantedlevel < 60 ) and ( getPlayerWantedLevel( source ) ~= 5 )  then
				setPlayerWantedLevel( source, 5 )
			elseif ( wantedlevel >= 60 ) and ( getPlayerWantedLevel( source ) ~= 6 ) then
				setPlayerWantedLevel( source, 6 )
			elseif ( wantedlevel < 10 )  and ( getPlayerWantedLevel( source ) ~= 0 ) then
				setPlayerWantedLevel( source, 0 )
			end
			setPlayerNametagText( source, string.sub( getPlayerName( source ), 0, 18 ) .. " (" .. getPlayerWantedLevel( source ).. ")" )
			setElementData( source, "WL", getPlayerWantedLevel( source ) )
		end
	end
)

-- Get the player his wanted points
function getPlayerWantedPoints ( thePlayer )
	if ( isElement( thePlayer ) ) then
		return getElementData( thePlayer, "wantedlevel" )
	else
		return false
	end
end

-- Set the player his wanted points
function setPlayerWantedPoints ( thePlayer, level )
	if ( isElement( thePlayer ) ) and ( type( level ) == "number" ) then
		setElementData( thePlayer, "wantedlevel", tonumber( level ) )
		return true
	else
		return false
	end
end

-- Get the player his wanted points
function givePlayerWantedPoints ( thePlayer, level )
	if ( isElement( thePlayer ) ) and ( type( level ) == "number" ) and ( getElementData( thePlayer, "wantedlevel" ) ) then
		setElementData( thePlayer, "wantedlevel", tonumber( ( getElementData( thePlayer, "wantedlevel" ) + level ) ) )
		return true
	else
		return false
	end
end

-- Remove the player his wanted points
function takePlayerWantedPoints ( thePlayer, level )
	if ( isElement( thePlayer ) ) and ( type( level ) == "number" ) and ( getElementData( thePlayer, "wantedlevel" ) ) then
		setElementData( thePlayer, "wantedlevel", tonumber( ( getElementData( thePlayer, "wantedlevel" ) - level ) ) )
		return true
	else
		return false
	end
end

-- Function to give the player money
function givePlayerCash ( thePlayer, cash, reason )
	if ( isElement( thePlayer ) ) and ( cash ) and ( type( cash ) == "number" ) and ( reason ) then
		if ( cash < 1000 ) then
			exports.VGlogging:addAccountLogRow ( thePlayer, "Money", "Added: $" .. cash .. " New Amount: $" .. getPlayerMoney( thePlayer ) + math.floor( cash ) .. " Reason: "..reason )
			givePlayerMoney( thePlayer, cash )
			return true
		else
			exports.VGlogging:addAccountLogRow ( thePlayer, "Money", "Added: $" .. cash .. " New Amount: $" .. getPlayerMoney( thePlayer ) + math.floor( cash ) .. " Reason: "..reason )
			exports.VGaccounts:setPlayerAccountData( thePlayer, "money", getPlayerMoney( thePlayer ) + math.floor( cash ) )
			givePlayerMoney( thePlayer, cash )
			return true
		end
	else
		return false
	end
end

-- Function to take the player money
function takePlayerCash ( thePlayer, cash, reason )
	if ( isElement( thePlayer ) ) and ( cash ) and ( type( cash ) == "number" ) and ( reason ) then
		if ( cash < 1000 ) then
			exports.VGlogging:addAccountLogRow ( thePlayer, "Money", "Removed: $" .. cash .. " New Amount: $" .. getPlayerMoney( thePlayer ) - math.floor( cash ) .. " Reason: "..reason )
			takePlayerMoney( thePlayer, cash )
			return true
		else
			exports.VGlogging:addAccountLogRow ( thePlayer, "Money", "Removed: $" .. cash .. " New Amount: $" .. getPlayerMoney( thePlayer ) - math.floor( cash ) .. " Reason: "..reason )
			exports.VGaccounts:setPlayerAccountData( thePlayer, "money", getPlayerMoney( thePlayer ) - math.floor( cash ) )
			takePlayerMoney( thePlayer, cash )
			return true
		end
	else
		return false
	end
end

-- Set server player interior
addEvent( "setServerElementInterior", true )
addEventHandler( "setServerElementInterior", root,
	function ( theElement, interior )
		setElementInterior( theElement, interior )
	end
)

-- Set server player dimension
addEvent( "setServerElementDimension", true )
addEventHandler( "setServerElementDimension", root,
	function ( theElement, dimension )
		setElementDimension( theElement, dimension )
	end
)