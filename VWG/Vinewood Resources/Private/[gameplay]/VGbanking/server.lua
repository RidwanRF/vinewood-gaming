-- Get the transactions of a player
addEvent( "requestPlayerTransactions", true )
addEventHandler( "requestPlayerTransactions", root,
	function ()
		local userID = exports.VGaccounts:getPlayerAccountID( client )
		local query = exports.VGmysql:query( "GEW783UH230WEGE978GW", "SELECT * FROM transactions WHERE userid=? ORDER BY date DESC LIMIT 10", userID )
		if ( query ) then
			triggerClientEvent( client, "requestPlayerTransactions:callBack", client, query )
		else
			triggerClientEvent( client, "requestPlayerTransactions:callBack", client )
		end
	end
)

-- Event to withdraw
addEvent( "onServerWithdrawMoney", true )
addEventHandler( "onServerWithdrawMoney", root,
	function ( all, money )
		if ( all ) then money = exports.VGaccounts:getPlayerAccountData( client, "bankmoney" ) elseif not ( money ) then return end
		local money = math.floor( money )
		if ( money > tonumber ( exports.VGaccounts:getPlayerAccountData( client, "bankmoney" ) ) ) then
			exports.VGdx:showMessageDX( client, "You don't have this much money in your bank account!", 225, 0, 0 )
		else
			exports.VGplayers:givePlayerCash( client, money, "Withdrawn money from bank" )
			local bankMoney = exports.VGaccounts:getPlayerAccountData( client, "bankmoney" )
			exports.VGaccounts:setPlayerAccountData( client, "bankmoney", bankMoney - money )
			local transaction = addBankTransfer ( exports.VGaccounts:getPlayerAccountID( client ), "Withdrawn $" .. exports.VGutils:convertNumber( money ) .. "" )
			triggerClientEvent( client, "onClientUpdatePlayerMoney", client, tostring( exports.VGaccounts:getPlayerAccountData( client, "bankmoney" ) ), transaction, exports.VGutils:timestampToDate ( ) )
		end
	end
)

-- Event to deposit
addEvent( "onServerDepositMoney", true )
addEventHandler( "onServerDepositMoney", root,
	function ( all, money )
		if ( all ) then money = getPlayerMoney( client ) elseif not ( money ) then return end
		local money = math.floor( money )
		if ( money > getPlayerMoney( client ) ) then
			exports.VGdx:showMessageDX( client, "You don't have this much money in your bank account!", 225, 0, 0 )
		else
			exports.VGplayers:takePlayerCash( client, money, "Deposited money from bank" )
			local bankMoney = exports.VGaccounts:getPlayerAccountData( client, "bankmoney" )
			exports.VGaccounts:setPlayerAccountData( client, "bankmoney", bankMoney + money )
			local transaction = addBankTransfer ( exports.VGaccounts:getPlayerAccountID( client ), "Deposited $" .. exports.VGutils:convertNumber( money ) .. "" )
			triggerClientEvent( client, "onClientUpdatePlayerMoney", client, tostring( exports.VGaccounts:getPlayerAccountData( client, "bankmoney" ) ), transaction, exports.VGutils:timestampToDate ( ) )
		end
	end
)

-- Event to transfer
addEvent( "onServerTransferMoney", true )
addEventHandler( "onServerTransferMoney", root,
	function ( money, recipient )
		local money = math.floor( money )
		if ( money > tonumber ( exports.VGaccounts:getPlayerAccountData( client, "bankmoney" ) ) ) then
			exports.VGdx:showMessageDX( client, "You don't have this much money in your bank account!", 225, 0, 0 )
		elseif not ( isElement( recipient ) ) then
			exports.VGdx:showMessageDX( client, "We couldn't find that recipient!", 225, 0, 0 )
		else
			-- Take money from sender
			local bankMoney1 = exports.VGaccounts:getPlayerAccountData( client, "bankmoney" )
			exports.VGaccounts:setPlayerAccountData( client, "bankmoney", bankMoney1 - money )
			local transaction1 = addBankTransfer ( exports.VGaccounts:getPlayerAccountID( client ), "Transferred $" .. exports.VGutils:convertNumber( money ) .. " to " .. getPlayerName( recipient ) )
			triggerClientEvent( client, "onClientUpdatePlayerMoney", client, tostring( exports.VGaccounts:getPlayerAccountData( client, "bankmoney" ) ), transaction1, exports.VGutils:timestampToDate ( ) )
			exports.VGdx:showMessageDX( client, "You sent $" .. exports.VGutils:convertNumber( money ) .. " to " .. getPlayerName( recipient ), 0, 255, 0 )
			
			-- Give money to the recipient
			local bankMoney2 = exports.VGaccounts:getPlayerAccountData( recipient, "bankmoney" )
			exports.VGaccounts:setPlayerAccountData( recipient, "bankmoney", bankMoney2 + money )
			local transaction2 = addBankTransfer ( exports.VGaccounts:getPlayerAccountID( recipient ), "Recieved $" .. exports.VGutils:convertNumber( money ) .. " from " .. getPlayerName( client ) )
			triggerClientEvent( recipient, "onClientUpdatePlayerMoney", recipient, tostring( exports.VGaccounts:getPlayerAccountData( recipient, "bankmoney" ) ), transaction2, exports.VGutils:timestampToDate ( ) )
			exports.VGdx:showMessageDX( recipient, "You recieved $" .. exports.VGutils:convertNumber( money ) .. " from " .. getPlayerName( client ), 0, 255, 0 )
		end
	end
)

-- Function that insert a new bank transfer log
function addBankTransfer ( userid, action )
	if ( userid ) and ( action ) then
		exports.VGmysql:exec( "GEW783UH230WEGE978GW", "INSERT INTO transactions SET userid=?, action=?", userid, action )
		return action
	else
		return false
	end
end