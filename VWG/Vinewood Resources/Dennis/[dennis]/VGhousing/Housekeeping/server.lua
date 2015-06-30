-- Function that creates a new house
function addHouse ( theCreator, houseInterior, housePrice )
	if ( isElement( theCreator ) ) and ( houseInterior ) and ( housePrice ) then
		local x, y, z = getElementPosition( theCreator )
		local hash = md5( getPlayerName( theCreator ) .. getTickCount( ) )
		if ( exports.VGmysql:exec ( "GEW783UH230WEGE978GW", "INSERT INTO housing SET interior=?, x=?, y=?, z=?, houseprice=?, originalprice=?, housemapper=?, hash=?", houseInterior, x, y, z, housePrice, housePrice, getPlayerName( theCreator ), hash ) ) then
			local theTable = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM housing WHERE hash=? LIMIT 1", hash )
			if ( theTable ) then
				table.insert( aTable.hDetails, theTable )
				return createHouse ( theTable, #aTable.hDetails )
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

-- Function to delete a house
function deleteHouse ( houseID )
	if ( houseID ) and ( IDToData( houseID ) ) and ( IDToIndex ( houseID ) ) then
		if ( exports.VGmysql:exec ( "GEW783UH230WEGE978GW", "DELETE FROM housing WHERE houseid=?", houseID ) ) then
			aTable.hDetails[ IDToIndex ( houseID ) ] = nil
			destroyElement( aTable.hPickips[ houseID ] )
			destroyElement( aTable.hBlips [ houseID ] )
			aTable.hBlips [ houseID ] = nil
			return true
		else
			return false
		end
	else
		return false
	end
end

-- Function to edit a house
function editHouse ( houseID, interior, price )
	if ( houseID ) and ( interior ) and ( price ) and ( IDToData( houseID ) ) then
		if ( exports.VGmysql:exec ( "GEW783UH230WEGE978GW", "UPDATE housing SET interior=?, houseprice=? WHERE houseid=?", interior, price, houseID ) ) then
			aTable.hDetails[ IDToIndex( houseID ) ].interior = interior
			aTable.hDetails[ IDToIndex( houseID ) ].houseprice = price
			return true
		else
			return false
		end
	else
		return false
	end
end

-- Event for when a house gets created
addEvent( "onServerAddHouse", true )
addEventHandler( "onServerAddHouse", root,
	function ( interior, price )
		if ( addHouse ( client, interior, price  ) ) then
			exports.VGdx:showMessageDX( client, "The house has been created!", 0, 225, 0 )
		else
			exports.VGdx:showMessageDX( client, "We couldn't create the house!", 225, 0, 0 )
		end
	end
)

-- Event to delete a house
addEvent( "onServerDeleteHouse", true )
addEventHandler( "onServerDeleteHouse", root,
	function ( houseID )
		if ( IDToData( houseID ) ) and ( deleteHouse ( houseID ) ) then
			exports.VGdx:showMessageDX( client, "The house has been deleted!", 0, 225, 0 )
			triggerClientEvent( client, "onServerGetHouseDataCallback", client, false, true )
		else
			exports.VGdx:showMessageDX( client, "We couldn't delete the house!", 225, 0, 0 )
		end
	end
)

-- Event to edit a house
addEvent( "onServerEditHouse", true )
addEventHandler( "onServerEditHouse", root,
	function ( houseID, interior, price )
		if ( editHouse ( houseID, interior, price ) ) then
			exports.VGdx:showMessageDX( client, "The house has been edited!", 0, 225, 0 )
			triggerClientEvent( client, "onServerGetHouseDataCallback", client, false, true )
		else
			exports.VGdx:showMessageDX( client, "We couldn't edit the house!", 225, 0, 0 )
		end
	end
)

-- Event to get house data
addEvent( "onServerGetHouseData", true )
addEventHandler( "onServerGetHouseData", root,
	function ( houseID )
		if ( IDToData( houseID ) ) then
			triggerClientEvent( client, "onServerGetHouseDataCallback", client, IDToData( houseID ), false )
		else
			triggerClientEvent( client, "onServerGetHouseDataCallback", client, false, true )
			exports.VGdx:showMessageDX( client, "We couldn't find that house!", 225, 0, 0 )
		end
	end
)