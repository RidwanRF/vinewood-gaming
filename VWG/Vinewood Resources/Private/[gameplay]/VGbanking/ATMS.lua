local markers = exports.VGtables:getTable('atms')

-- Function triggerd when the player hits the marker
function onClientMarkerHitATM ( thePlayer, matchingDimension )
	local _, _, pz = getElementPosition( thePlayer )
	local _, _, mz = getElementPosition( source )
	if ( thePlayer == localPlayer ) and ( matchingDimension ) and not ( bankingUI.window ) and not ( isPedInVehicle ( localPlayer ) ) and ( pz - mz < 3 ) then
		checkPlayerTransactions ()
		bankingUI.window = 1
		showCursor( true )
		addEventHandler( "onClientRender", root, drawBankingWindow )
		bankingUI.balance = exports.VGaccounts:getPlayerAccountData( "bankmoney" )
	end
end

-- Create ATM's
for i = 1,#markers do 
	local ATMObject = createObject ( 2942, markers[ i ][ 1 ], markers[ i ][ 2 ], markers[ i ][ 3 ], 0, 0, markers[ i ][ 4 ] )
	local ATMMarker = createMarker ( markers[ i ][ 1 ], markers[ i ][ 2 ], markers[ i ][ 3 ] - 1, "cylinder", 1.2, 255, 255, 225, 150 )
	addEventHandler( "onClientMarkerHit", ATMMarker, onClientMarkerHitATM )
	createBlip( markers[ i ][ 1 ], markers[ i ][ 2 ], markers[ i ][ 3 ], 52, 0, 0, 0, 0, 0, 0, 120 )
	setObjectBreakable( ATMObject, false )
	setElementFrozen( ATMObject, true )
end