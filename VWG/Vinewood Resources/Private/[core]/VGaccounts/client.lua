


-- Table with all the data in it
local dataTable = {}

-- Function for when the resource start
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "accountdataTable" )
		if ( tbl ) then dataTable = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onClientResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "accountdataTable", dataTable )
	end
)

-- Function to set the player's data clientside
addEvent ( "syncPlayerDataTable", true )
addEventHandler ( "syncPlayerDataTable", root,
	function ( aTable )
		if ( aTable ) then
			dataTable[ source ] = aTable
		end
	end
)

-- Event when an data updates
addEvent ( "onClientPlayerDataUpdate", true )
addEventHandler ( "onClientPlayerDataUpdate", root,
	function ( data, value )
		if ( data ) and ( value ) then
			dataTable[ localPlayer ][ data ] = value
		end
	end
)

-- Function to check if a player is loggedin
function isPlayerLoggedIn ( thePlayer )
	if ( getElementData( thePlayer, "isLoggedIn" ) ) then
		return true
	else
		return false
	end
end

-- Function to get a player's accountname
function getPlayerAccountName ( thePlayer )
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "This player is not logged in"
	else
		return getElementData( thePlayer, "isLoggedIn" ) or false
	end
end

-- Function to get a player's accountid
function getPlayerAccountID ( )
	if not ( isElement( localPlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( localPlayer ) ) then
		return false, "This player is not logged in"
	elseif not ( dataTable[ localPlayer ] ) then
		return false, "Internal error"
	else
		return dataTable[ localPlayer ].userid
	end
end

-- Function to get a player's accountdata
function getPlayerAccountData( dataname )
	if not ( isElement( localPlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( localPlayer ) ) then
		return false, "This player is not logged in"
	elseif not ( dataTable[ localPlayer ] ) then
		return false, "Internal error"
	elseif not ( dataTable[ localPlayer ][ dataname ] ) then
		return false, "No data found with this dataname"
	else
		return dataTable[ localPlayer ][ dataname ]
	end
end

-- Function to get a player from a account
function getPlayerFromAcountName ( accountname )
	if not ( accountname ) then
		return false, "No username enterd"
	else
		for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
			if ( getPlayerAccountName ( thePlayer ) == accountname ) then
				return thePlayer
			end
		end
		return false, "No player with that accountname"
	end
end