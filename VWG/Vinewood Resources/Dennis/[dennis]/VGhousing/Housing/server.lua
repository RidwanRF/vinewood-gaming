-- Table that holds all the data related to houses
aTable = {
	-- Table with the housing data
	hDetails = {},
	-- Table with: pickup -> house ID
	hPickips = {},
	-- Table with: house ID -> players inside
	hPlayers = {},
	-- Table with: colShape -> house ID
	hColshap = {},
	-- Table with: house ID -> index
	hIndexes = {},
	-- Table with: house ID -> blip
	hBlips	 = {},
}

-- Event for when the server starts
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		local theTable = exports.VGmysql:query( "GEW783UH230WEGE978GW", "SELECT * FROM housing" )
		if ( theTable ) then
			-- Set the houses table
			aTable.hDetails = theTable
			
			-- Create all the houses
			for i=1,#aTable.hDetails do
				createHouse( aTable.hDetails[ i ], i )
			end
		else
			outputConsole ( "Housing system couldn't start! Check the MySQL connection." )
			cancelEvent()
		end
	end
)

-- Function that creates a house and adds everything to the tables
function createHouse ( theTable, index )
	if ( theTable ) and ( index ) then
		if ( theTable.sale ) and ( theTable.sale == 0 ) then
			local thePickup = createPickup ( theTable.x, theTable.y, theTable.z, 3, 1272, 0 )
			local theCol = createColTube ( theTable.x, theTable.y, theTable.z - 2, 0.8, 3 )
			addEventHandler( "onColShapeHit", theCol, onPlayerHousePickupHit )
			addEventHandler( "onColShapeLeave", theCol, onPlayerHousePickupLeave )
			aTable.hColshap[ theCol ] = theTable.houseid
			aTable.hPickips[ theTable.houseid ] = thePickup
			aTable.hPickips[ thePickup ] = theTable.houseid
			aTable.hIndexes[ theTable.houseid ] = index
			aTable.hBlips  [ theTable.houseid ] = createBlip ( theTable.x, theTable.y, theTable.z, 32, 0, 0, 0, 0, 0, 0, 0, root )
			setElementVisibleTo( aTable.hBlips [ theTable.houseid ], root, false )
			return true
		else
			local thePickup = createPickup ( theTable.x, theTable.y, theTable.z, 3, 1273, 0 )
			local theCol = createColTube ( theTable.x, theTable.y, theTable.z - 2, 0.8, 3 )
			addEventHandler( "onColShapeHit", theCol, onPlayerHousePickupHit )
			addEventHandler( "onColShapeLeave", theCol, onPlayerHousePickupLeave )
			aTable.hColshap[ theCol ] = theTable.houseid
			aTable.hPickips[ theTable.houseid ] = thePickup
			aTable.hPickips[ thePickup ] = theTable.houseid
			aTable.hIndexes[ theTable.houseid ] = index
			aTable.hBlips  [ theTable.houseid ] = createBlip ( theTable.x, theTable.y, theTable.z, 31, 0, 0, 0, 0, 0, 0, 0, root )
			setElementVisibleTo( aTable.hBlips [ theTable.houseid ], root, false )
			return true
		end
	else
		return false
	end
end

-- Toggle the house blips for a player
function showHouseBlips( thePlayer, state )
	if ( aTable.hBlips ) and ( isElement( thePlayer ) ) then
		for _, theBlip in pairs ( aTable.hBlips ) do
			setElementVisibleTo( theBlip, thePlayer, state )
		end
	else
		return false
	end
end

-- Function when the player hits a house icon
function onPlayerHousePickupHit ( thePlayer, matchingDimension )
	if ( isElement( thePlayer ) ) and ( getElementType( thePlayer ) == "player" ) and ( matchingDimension ) and ( colToData ( source ) ) then
		triggerClientEvent( thePlayer, "toggleHouseInformationWindow", thePlayer, true, colToData ( source ) )
	end
end

-- Function when the player leaves a house icon
function onPlayerHousePickupLeave ( thePlayer, matchingDimension )
	if ( isElement( thePlayer ) ) and ( getElementType( thePlayer ) == "player" ) and ( matchingDimension ) then
		triggerClientEvent( thePlayer, "toggleHouseInformationWindow", thePlayer, false )
	end
end

-- Colshape to house data
function colToData ( colShape )
	if ( aTable.hColshap[ colShape ] ) and ( aTable.hIndexes[ aTable.hColshap[ colShape ] ] ) and ( aTable.hDetails[ aTable.hIndexes[ aTable.hColshap[ colShape ] ] ] ) then
		return aTable.hDetails[ aTable.hIndexes[ aTable.hColshap[ colShape ] ] ]
	else
		return false
	end
end

-- House ID to house data
function IDToData( houseID )
	if ( aTable.hIndexes[ houseID ] ) and ( aTable.hDetails[ aTable.hIndexes[ houseID ] ] ) then
		return aTable.hDetails[ aTable.hIndexes[ houseID ] ]
	else
		return false
	end
end

-- House ID to index
function IDToIndex ( houseID )
	if ( aTable.hIndexes[ houseID ] ) then
		return aTable.hIndexes[ houseID ]
	else
		return false
	end
end

-- Pickup to ID
function pickupToID ( pickup )
	if ( Table.hPickips[ pickup ] ) then
		return Table.hPickips[ pickup ]
	else
		return false
	end
end

-- ID to pickup
function IDToPickup( houseID )
	if ( Table.hPickips[ houseID ] ) then
		return Table.hPickips[ houseID ]
	else
		return false
	end
end