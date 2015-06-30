-- Products
local products = {
	[ "burger" ] = { 6, 5 },
	[ "chicken" ] = { 6, 6 },
	[ "pizza" ] = { 6, 5 },
	[ "salad" ] = { 5, 6 },
	[ "icecream" ] = { 4, 6 },
	[ "donut1" ] = { 6, 6 },
	[ "donut2" ] = { 6, 6 },
	[ "pie" ] = { 2, 3 },
	[ "coke" ] = { 4, 3 },
}

-- Event that handles the items you bought
addEvent( "onServerPlayerBoughtFood", true )
addEventHandler( "onServerPlayerBoughtFood", root,
	function ( item )
		if ( products[ item ] ) then	
			if ( getPlayerMoney( client ) >= products[ item ][ 1 ] ) then
				if ( math.floor( getElementHealth( client ) ) == 100 ) then
					if ( exports.VGinventory:getPlayerItemAmount ( client, item ) ) and ( exports.VGinventory:getPlayerItemAmount ( client, item  ) >= 3 ) then
						exports.VGdx:showMessageDX( client, "You can't hold more than 3 of these items!", 225, 0, 0 )
					else
						local price = products[ item ][ 1 ]
						exports.VGplayers:takePlayerCash( client, price, "Food store (" .. item .. ")" )
						exports.VGinventory:givePlayerItem ( client, item, 1 )
						exports.VGdx:showMessageDX( client, "Item bought and added to your inventory!", 225, 0, 0 )
					end
				else
					local price = products[ item ][ 1 ]
					local health = products[ item ][ 2 ]
					setElementHealth( client, getElementHealth( client ) + health )
					exports.VGplayers:takePlayerCash( client, price, "Food store (" .. item .. ")" )
					exports.VGdx:showMessageDX( client, "Item bought and consumed!", 225, 0, 0 )
				end
			else
				exports.VGdx:showMessageDX( client, "You don't have enought money for this item!", 225, 0, 0 )
			end
		end
	end
)