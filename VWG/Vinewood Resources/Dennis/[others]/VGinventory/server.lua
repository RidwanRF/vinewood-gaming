-- Table with all the items in it
local aTable = {}
local droppedItems = {}

-- All the available items, just needed to check when give or take an item
itemTable = {
	[ "burger" ] 		= { true, 2880, "Burger" },
	[ "coke" ] 			= { true, 2647, "Glass Coke" },
	[ "medic" ] 		= { true, false, "Medic Kit" },
	[ "pizza" ] 		= { true, 2881, "Pizza Slice" },
	[ "beer" ] 			= { true, false, "Glass Beer" },
	[ "chicken" ] 		= { true, false, "Chicken" },
	[ "donut1" ]		= { true, false, "Donut" },
	[ "donut2" ]		= { true, false, "Donut" },
	[ "pie" ] 			= { true, false, "Pie" },
	[ "screwdriver" ]	= { true, false, "Screwdriver" },
	[ "salad" ] 		= { true, false, "Salad" },
	[ "tools" ]			= { true, false, "Toolbox" },
	[ "icecream" ]		= { true, false, "Ice Cream" },
	[ "wheel" ] 		= { true, 1098, "Wheel" },
	[ "wine" ] 			= { true, 1667, "Glass Whine" },
	[ "fuel" ] 			= { true, 1650, "Fuel can" },
}

-- Event when the player does logIn
addEvent( "onServerPlayerSpawned" )
addEventHandler( "onServerPlayerSpawned", root,
	function ()
		if ( exports.VGaccounts:isPlayerLoggedIn( source ) ) then
			local string = exports.VGaccounts:getPlayerAccountData( source, "inventory" )
			if ( string ) and ( fromJSON( string ) ) then
				aTable[ source ] = fromJSON( string )
				triggerClientEvent( source, "onClientSyncInventoryTable", source, aTable[ source ] )
			end
		end
	end
)

-- When the resource starts
addEventHandler( "onResourceStart", root,
	function ( resource )
		if ( getResourceName( resource ) == "VGinventory" ) or ( getResourceName( resource ) == "VGaccounts" ) then
			for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
				if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
					local string = exports.VGaccounts:getPlayerAccountData( thePlayer, "inventory" )
					if ( string ) and ( fromJSON( string ) ) then
						aTable[ thePlayer ] = fromJSON( string )
					end
				end
			end
		end
	end
)

-- Event when the player uses an item
addEvent( "serverInventoryItemUse", true )
addEventHandler( "serverInventoryItemUse", root,
	function ( item )
		if ( aTable[ client ] ) then
			if ( aTable[ client ][ item ] == 1 ) then
				triggerEvent( "onPlayerInventoryItemUse", client, aTable[ client ][ item ] )
				exports.VGdx:showMessageDX( client, "You used a "..string.lower( itemTable[ item ][ 3 ] ), 0, 225, 0 ) 
				aTable[ client ][ item ] = nil
				exports.VGaccounts:setPlayerAccountData( client, "inventory", toJSON( aTable[ client ] ) )
			else
				triggerEvent( "onPlayerInventoryItemUse", client, aTable[ client ][ item ] )
				exports.VGdx:showMessageDX( client, "You used a "..string.lower( itemTable[ item ][ 3 ] ), 0, 225, 0 ) 
				aTable[ client ][ item ] = aTable[ client ][ item ] - 1
				exports.VGaccounts:setPlayerAccountData( client, "inventory", toJSON( aTable[ client ] ) )
			end
		end
	end
)

-- Event for when the player drops an item
addEvent( "serverInventoryItemDrop", true )
addEventHandler( "serverInventoryItemDrop", root,
	function ( item )
		if ( aTable[ client ] ) and ( itemTable[ item ] ) and ( itemTable[ item ][ 2 ] ) then
			if ( aTable[ client ][ item ] == 1 ) then
				triggerEvent( "onPlayerInventoryItemDrop", client, aTable[ client ][ item ] )
				exports.VGdx:showMessageDX( client, "You dropped a "..string.lower( itemTable[ item ][ 3 ] ), 0, 225, 0 ) 
				aTable[ client ][ item ] = nil
				exports.VGaccounts:setPlayerAccountData( client, "inventory", toJSON( aTable[ client ] ) )
				local x, y, z = getElementPosition( client )
				local pickup = createPickup( x, y, z, 3, itemTable[ item ][ 2 ] )
				setElementDimension( pickup, getElementDimension( client ) )
				setElementInterior( pickup, getElementInterior( client ) )
				droppedItems[ pickup ] = { item, getTickCount() }
			else
				triggerEvent( "onPlayerInventoryItemDrop", client, aTable[ client ][ item ] )
				exports.VGdx:showMessageDX( client, "You dropped a "..string.lower( itemTable[ item ][ 3 ] ), 0, 225, 0 ) 
				aTable[ client ][ item ] = aTable[ client ][ item ] - 1
				exports.VGaccounts:setPlayerAccountData( client, "inventory", toJSON( aTable[ client ] ) )
				local x, y, z = getElementPosition( client )
				local pickup = createPickup( x, y, z, 3, itemTable[ item ][ 2 ] )
				setElementDimension( pickup, getElementDimension( client ) )
				setElementInterior( pickup, getElementInterior( client ) )
				droppedItems[ pickup ] = { item, getTickCount() }
			end
		end
	end
)

-- When the player hits a pickup
addEventHandler ( "onPickupHit", root, 
	function ( thePlayer )
		cancelEvent()
		if ( droppedItems[ source ] ) and ( getTickCount() - droppedItems[ source ][ 2 ] > 6000 ) then	
			givePlayerItem ( thePlayer, droppedItems[ source ][ 1 ], 1 )
			exports.VGdx:showMessageDX( thePlayer, "You picked up a "..string.lower( itemTable[ droppedItems[ source ][ 1 ] ][ 3 ] ), 0, 225, 0 ) 
			droppedItems[ source ] = nil
			destroyElement( source )
		end
	end
)

-- Function to get the amount of items a player has
function getPlayerItemAmount ( thePlayer, item )
	if not ( aTable[ thePlayer ] ) then
		return false, "No inventory found for that player"
	elseif not ( aTable[ thePlayer ][ item ] ) then
		return false, "Player does not have that item"
	else
		return aTable[ thePlayer ][ item ]
	end
end

-- Function to get the table with player items
function getPlayerItems ( thePlayer )
	if not ( aTable[ thePlayer ] ) then
		return false, "No inventory found for that player"
	else
		return aTable[ thePlayer ]
	end
end

-- Function to give the player an item
function givePlayerItem ( thePlayer, item, amount )
	if not ( itemTable[ string.lower( item ) ][ 1 ] ) then
		return false, "There is no such item"
	elseif not ( type( amount ) == "number" ) or ( amount <= 0 ) then
		return false, "Invalid amount"
	else
		if not ( aTable[ thePlayer ] ) then aTable[ thePlayer ] = {} end
		if not ( aTable[ thePlayer ][ item ] ) then
			aTable[ thePlayer ][ item ] = amount
			triggerClientEvent( thePlayer, "onClientUpdatePlayerInventoryItem", thePlayer, item, aTable[ thePlayer ][ item ] )
			exports.VGaccounts:setPlayerAccountData( thePlayer, "inventory", toJSON( aTable[ thePlayer ] ) )
			return true
		else
			aTable[ thePlayer ][ item ] = aTable[ thePlayer ][ item ] + amount
			triggerClientEvent( thePlayer, "onClientUpdatePlayerInventoryItem", thePlayer, item, aTable[ thePlayer ][ item ] )
			exports.VGaccounts:setPlayerAccountData( thePlayer, "inventory", toJSON( aTable[ thePlayer ] ) )
			return true
		end
	end
end

-- Function to take the player an item
function takePlayerItem ( thePlayer, item, amount )
	if not ( itemTable[ string.lower( item ) ][ 1 ] ) then
		return false, "There is no such item"
	elseif not ( aTable[ thePlayer ] ) then
		return false, "No inventory found for that player"
	elseif not ( aTable[ thePlayer ][ item ] ) then
		return false, "Player does not have that item"
	elseif not ( type( amount ) == "number" ) then
		return false, "Invalid amount"
	elseif ( aTable[ thePlayer ][ item ] < amount ) then
		return false, "You can't take more items than the player has"
	else
		if ( amount == 0 ) or ( amount == aTable[ thePlayer ][ item ] ) then
			aTable[ thePlayer ][ item ] = nil
			triggerClientEvent( thePlayer, "onClientUpdatePlayerInventoryItem", thePlayer, item, nil )
			exports.VGaccounts:setPlayerAccountData( thePlayer, "inventory", toJSON( aTable[ thePlayer ] ) )
			return true
		else
			aTable[ thePlayer ][ item ] = aTable[ thePlayer ][ item ] - amount
			triggerClientEvent( thePlayer, "onClientUpdatePlayerInventoryItem", thePlayer, item, aTable[ thePlayer ][ item ] )
			exports.VGaccounts:setPlayerAccountData( thePlayer, "inventory", toJSON( aTable[ thePlayer ] ) )
			return true
		end
	end
end