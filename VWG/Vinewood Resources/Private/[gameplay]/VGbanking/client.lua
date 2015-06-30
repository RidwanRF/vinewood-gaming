-- Table that holds the transaction details of the player
transactions = false

-- Get player transactions
function checkPlayerTransactions ()
	if not ( transactions ) then
		triggerServerEvent( "requestPlayerTransactions", localPlayer )
	end
end

-- Callback event for the transactions
addEvent( "requestPlayerTransactions:callBack", true )
addEventHandler( "requestPlayerTransactions:callBack", root,
	function ( aTable )
		if ( aTable ) then
			transactions = aTable
		else
			transactions = {}
		end
	end
)

-- Callback event to update the money
addEvent( "onClientUpdatePlayerMoney", true )
addEventHandler( "onClientUpdatePlayerMoney", root,
	function ( tMoney, tTransaction, tTime )
		bankingUI.balance = tonumber( tMoney )
		if ( tTransaction ) and ( tTime ) then
			local newTransactions = {}
			table.insert( newTransactions, { userid = exports.VGaccounts:getPlayerAccountID( localPlayer ), action = tTransaction, date = tTime } )
			for i=1,9 do
				if ( transactions[ i ] ) then table.insert( newTransactions, transactions[ i ] ) end
			end
			transactions = newTransactions
		end
	end
)

-- Event when resource starts
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "bankingTransactions" )
		if ( tbl ) then transactions = tbl end
	end
)

-- Event for when the resource stops
addEventHandler( "onClientResourceStop", resourceRoot,
	function ()
		if ( transactions ) and ( #transactions ~= 0 ) then
			exports.VGcache:setTemporaryData( "bankingTransactions", transactions )
		end
	end
)

-- Function to withdraw money
function withDrawMoney ( all )
	if ( all ) then triggerServerEvent( "onServerWithdrawMoney", localPlayer, true ) return end
	if not ( string.match( guiGetText( editbox ) ,'^%d+$' ) ) then
		exports.VGdx:showMessageDX( "You didn't enter a valid amount!", 225, 0, 0 )
	elseif ( tonumber( guiGetText( editbox ) ) > tonumber ( exports.VGaccounts:getPlayerAccountData( "bankmoney" ) ) ) then
		exports.VGdx:showMessageDX( "You don't have this much money in your bank account!", 225, 0, 0 )
	else
		triggerServerEvent( "onServerWithdrawMoney", localPlayer, false, math.floor( tonumber( guiGetText( editbox ) ) ) )
	end
end

-- Function to deposit money
function depositMoney ( all )
	if ( all ) then triggerServerEvent( "onServerDepositMoney", localPlayer, true ) return end
	if not ( string.match( guiGetText( editbox ) ,'^%d+$' ) ) then
		exports.VGdx:showMessageDX( "You didn't enter a valid amount!", 225, 0, 0 )
	elseif ( tonumber( guiGetText( editbox ) ) > tonumber ( getPlayerMoney() ) ) then
		exports.VGdx:showMessageDX( "You don't have this much money!", 225, 0, 0 )
	else
		triggerServerEvent( "onServerDepositMoney", localPlayer, false, math.floor( tonumber( guiGetText( editbox ) ) ) )
	end
end

-- Function to transfer money
function transferMoney ()
	if not ( string.match( guiGetText( editbox ) ,'^%d+$' ) ) then
		exports.VGdx:showMessageDX( "You didn't enter a valid amount!", 225, 0, 0 )
	elseif ( tonumber( guiGetText( editbox ) ) > tonumber ( exports.VGaccounts:getPlayerAccountData( "bankmoney" ) ) ) then
		exports.VGdx:showMessageDX( "You don't have this much money in your bank account!", 225, 0, 0 )
	elseif ( string.find( guiGetText( editbox_transfer ), "^%s*$" ) ) then
		exports.VGdx:showMessageDX( "You didn't enter a valid recipient!", 225, 0, 0 )
	elseif not ( exports.VGutils:getPlayerFromNamePart( guiGetText( editbox_transfer ) ) ) then
		exports.VGdx:showMessageDX( "No recipient found with that name!", 225, 0, 0 )
	elseif ( exports.VGutils:getPlayerFromNamePart( guiGetText( editbox_transfer ) ) == localPlayer ) then
		exports.VGdx:showMessageDX( "You can't transfer money to yourself!", 225, 0, 0 )
	else
		triggerServerEvent( "onServerTransferMoney", localPlayer, math.floor( tonumber( guiGetText( editbox ) ) ), exports.VGutils:getPlayerFromNamePart( guiGetText( editbox_transfer ) ) )
	end
end