-- Table with all the data in it
local dataTable = {}

-- Function for when the resource start
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "userdataTable" )
		if ( tbl ) then dataTable = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onClientResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "userdataTable", dataTable )
	end
)

-- Function to set the player's data clientside
addEvent ( "syncPlayerUserDataTable", true )
addEventHandler ( "syncPlayerUserDataTable", root,
	function ( aTable )
		if ( aTable ) then
			dataTable[ localPlayer ] = aTable
		end
	end
)

-- Event when an data updates
addEvent ( "onClientPlayerUserDataUpdate", true )
addEventHandler ( "onClientPlayerUserDataUpdate", root,
	function ( dataName, dataValue )
		if ( dataName ) and ( dataValue ) then
			dataTable[ localPlayer ][ dataName ] = dataValue
		end
	end
)

-- Function to get player data
function getPlayerData( dataName )
	if not ( dataName ) then
		return false, "No data or value set"
	elseif not ( dataTable[ localPlayer ] ) then
		return false, "Data table not found"
	elseif not ( dataTable[ localPlayer ][ dataName ] ) then
		return false, "No data found for this data"
	else
		return dataTable[ localPlayer ][ dataName ]
	end
end

-- Function to get all the player data
function getAllPlayerData( )
	return dataTable[ localPlayer ]
end
