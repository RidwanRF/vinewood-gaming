
local tonumber = tonumber
local type = type

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

-- Function to update a player's interior
function setClientElementInterior( theElement, interior )
	if ( isElement( theElement ) ) and ( interior ) then
		triggerServerEvent( "setServerElementInterior", localPlayer, theElement, interior )
		return true
	else
		return false
	end
end

-- Function to update a player's dimension
function setClientElementDimension( theElement, dimension )
	if ( isElement( theElement ) ) and ( dimension ) then
		triggerServerEvent( "setServerElementDimension", localPlayer, theElement, dimension )
		return true
	else
		return false
	end
end