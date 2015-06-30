-- All the items are stored here with their data
itemTable = {
	[ "burger" ] 		= { "Half cooked meat dripping with fat, nomnomnom (restores 5% health)", "images/burger.png" },
	[ "coke" ] 			= { "Served cold, with iceblocks! (restores 3% health)", "images/coke.png" },
	[ "medic" ] 		= { "For those injuries that need instant fixing (restores 12% health)", "images/medic.png" },
	[ "pizza" ] 		= { "Everything you can imagine has been thrown on here.. (restores 5% health)", "images/pizza.png" },
	[ "beer" ] 			= { "A real man’s morning drink (restores 5% health)", "images/beer.png" },
	[ "chicken" ] 		= { "If you listen closely you can still hear it cluck (restores 6% health)", "images/chicken.png" },
	[ "donut1" ]		= { "A cop’s best friend (restores 2% health)", "images/donut1.png" },
	[ "donut2" ]		= { "A cop’s best friend (restores 2% health)", "images/donut2.png" },
	[ "pie" ] 			= { "If this was a cake, it would have been a lie (restores 3% health)", "images/pie.png" },
	[ "screwdriver" ]	= { "A driver to screw things, what? (used to enforce houses)", "images/screwdriver.png" },
	[ "salad" ] 		= { "Looks healthy.. (restores 6% health)", "images/salad.png" },
	[ "tools" ]			= { "Can fix everything, at least that’s what the box says (repairs your vehicle for 10%)", "images/tools.png" },
	[ "wheel" ] 		= { "Avoidance of sharp objects advised (repairs a flat tire on your car)", "images/wheel.png" },
	[ "wine" ] 			= { "Instead of walking over water, this blessed wine makes you jump higher", "images/wine.png" },
	[ "fuel" ] 			= { "Filled to the top (restores 10% fuel to your vehicle)", "images/fuel.png" },
	[ "icecream" ] 		= { "Eat it before it melts! (restores 6% fuel to your vehicle)", "images/ice.png" },
}

-- Table with all the items in it, table is global
inventoryTable = {}

-- Event when the player logged in, so the client has the items too
addEvent( "onClientSyncInventoryTable", true )
addEventHandler( "onClientSyncInventoryTable", root,
	function ( table )
		if ( table ) then
			inventoryTable = table
		end
	end
)

-- When the resource starts
addEventHandler( "onClientResourceStart", root,
	function ( resource )
		if ( getResourceName( resource ) == "VGinventory" ) or ( getResourceName( resource ) == "VGaccounts" ) then
			if ( exports.VGaccounts:isPlayerLoggedIn( localPlayer ) ) then
				local string = exports.VGaccounts:getPlayerAccountData( "inventory" )
				if ( string ) and ( fromJSON( string ) ) then
					inventoryTable = fromJSON( string )
				end
			end
		end
	end
)

-- Event when resource starts
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "inventoryTable" )
		if ( tbl ) then inventoryTable = tbl end
	end
)

-- Event for when the resource stops
addEventHandler( "onClientResourceStop", resourceRoot,
	function ()
		if ( inventoryTable ) and ( #inventoryTable ~= 0 ) then
			exports.VGcache:setTemporaryData( "inventoryTable", inventoryTable )
		end
	end
)

-- Even to update an item amount
addEvent( "onClientUpdatePlayerInventoryItem", true )
addEventHandler( "onClientUpdatePlayerInventoryItem", root,
	function ( item, amount )
		inventoryTable[ item ] = amount
	end
)

-- Function to get the amount of items a player has
function getPlayerItemAmount ( item )
	if not ( inventoryTable ) then
		return false, "No inventory found"
	elseif not ( inventoryTable[ item ] ) then
		return false, "Client does not have that item"
	else
		return inventoryTable[ item ]
	end
end

-- Function to get the table with player items
function getPlayerItems ()
	if not ( inventoryTable ) then
		return false, "No inventory found for that player"
	else
		return inventoryTable
	end
end