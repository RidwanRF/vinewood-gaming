-- The table with all the data in it
local dataTable = {}

-- Function for when the resource start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "userdataTable" )
		if ( tbl ) then dataTable = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "userdataTable", dataTable )
	end
)

-- Function that checks the data and if it's set or not
function isPlayerDataSet ( thePlayer, authorized )
	if ( isElement( thePlayer ) ) and ( exports.VGaccounts:getPlayerAccountID( thePlayer ) ) then
		if not ( dataTable[ thePlayer ] ) then
			local table = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM accountdata WHERE userid=?", exports.VGaccounts:getPlayerAccountID( thePlayer ) )
			dataTable[ thePlayer ] = table
			triggerClientEvent( thePlayer, "syncPlayerUserDataTable", thePlayer, table )
			if not ( authorized ) then outputDebugString ( "Retrieving accountdata from " .. getPlayerName( thePlayer ) .. ", mind checking MySQL overload!" ) end
			return true
		end
	end
	return false
end

-- Function to set player data
function setPlayerData( thePlayer, dataName, dataValue, sync )
	if not ( isElement( thePlayer ) ) or not ( exports.VGaccounts:getPlayerAccountID( thePlayer ) ) then
		return false, "Invalid player or not logged in"
	elseif not ( dataName ) or not ( dataValue ) then
		return false, "No data or value set"
	elseif not ( dataTable[ thePlayer ] ) then
		local data, error = performDataCheck ( thePlayer, dataName )
		return data, error
	elseif ( dataName == "dataid" ) or ( dataName == "userid" ) then
		return false, "This data is protected and can't be updated"
	elseif not ( dataTable[ thePlayer ][ dataName ] ) then
		exports.VGmysql:createDatabaseColumn ( "accountdata", dataName, "TEXT" )
		exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE accountdata SET `??`=? WHERE userid=?", dataName, dataValue, exports.VGaccounts:getPlayerAccountID( thePlayer ) )
		dataTable[ thePlayer ][ dataName ] = dataValue
		if ( sync == nil ) or ( sync ) then syncPlayerData( thePlayer, dataName, dataValue ) end
		return true
	else
		exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE accountdata SET `??`=? WHERE userid=?", dataName, dataValue, exports.VGaccounts:getPlayerAccountID( thePlayer ) )
		dataTable[ thePlayer ][ dataName ] = dataValue
		if ( sync == nil ) or ( sync ) then syncPlayerData( thePlayer, dataName, dataValue ) end
		return true
	end
end

-- Function to get player data
function getPlayerData( thePlayer, dataName )
	if not ( isElement( thePlayer ) ) then
		return false, "Invalid player"
	elseif not ( dataName ) then
		return false, "No data or value set"
	elseif not ( dataTable[ thePlayer ] ) then
		local data, error = performDataCheck ( thePlayer, dataName )
		return data, error
	elseif not ( dataTable[ thePlayer ][ dataName ] ) then
		return false, "No data found for this data"
	else
		return dataTable[ thePlayer ][ dataName ]
	end
end

-- Perform a check for when the player table is not found on data get
function performDataCheck ( thePlayer, dataName )
	if not ( isPlayerDataSet ( thePlayer ) ) then
		return false, "Error while getting the data"
	else
		if ( dataTable[ thePlayer ] ) and ( dataTable[ thePlayer ][ dataName ] ) then
			return dataTable[ thePlayer ][ dataName ]
		else
			return false, "No data found for this data"
		end
	end
end

-- Function to get all the player data
function getAllPlayerData( thePlayer )
	if not ( isElement( thePlayer ) ) then
		return false, "Invalid player"
	else
		return dataTable[ thePlayer ]
	end
end

-- When a player login
addEvent( "onServerPlayerLogin" )
addEventHandler( "onServerPlayerLogin", root,
	function ()
		local table = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM accountdata WHERE userid=?", exports.VGaccounts:getPlayerAccountID( source ) )
		if ( table ) then
			dataTable[ source ] = table
			triggerClientEvent( source, "syncPlayerUserDataTable", source, table )
		else
			exports.VGmysql:exec( "GEW783UH230WEGE978GW", "INSERT INTO accountdata SET userid=?", exports.VGaccounts:getPlayerAccountID( source ) )
			dataTable[ source ] = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM accountdata WHERE userid=?", exports.VGaccounts:getPlayerAccountID( source ) )
			triggerClientEvent( source, "syncPlayerUserDataTable", source, dataTable[ source ] )
		end
	end
)

-- When a player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		if ( dataTable [ source ] ) then
			dataTable [ source ] = nil
		end
	end
)

-- Function that syncs that data with the client
function syncPlayerData( thePlayer, dataName, dataValue )
	triggerClientEvent( thePlayer, "onClientPlayerUserDataUpdate", thePlayer, dataName, dataValue )
end