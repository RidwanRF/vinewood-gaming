-- The connection element
local connection = false
local MySQLKey = "GEW783UH230WEGE978GW"

-- When the resource stats create a connection
addEventHandler ( "onResourceStart", getResourceRootElement( getThisResource () ), 
	function ()	
		connection = dbConnect( "mysql", "dbname=mtasa;host=127.0.0.1;port=3306;unix_socket=/var/run/mysqld/mysqld.sock", "mtasa", "vkWPFJuCfuKsd", "share=1" )	
		if ( connection ) then
			outputConsole ( "Server is now connected with the MySQL database!" )
		else
			outputConsole ( "Connection with the MySQL database failed!" )
			cancelEvent()
		end
	end
)

-- Function to check the key
function checkKey ( key )
	if ( key == MySQLKey ) then
		return true
	else
		return false
	end
end

-- Get the MySQL connection element
function getConnection ()
	if ( connection ) then
		return connection
	else
		return false
	end
end

-- Get a MySQL query
function query ( key, ... )
    if ( connection ) and ( checkKey ( key ) ) then
        local qh = dbQuery( connection, ... )
        local result = dbPoll( qh, -1 )
        return result
    else
        return false
    end     
end

-- Get a single row from the database
function querySingle ( key, str, ... )
	if ( connection ) and ( checkKey ( key ) ) then
		local result = query( key, str, ... )
		if ( type( result ) == 'table' ) then
			return result[1]
		else
			return result
		end
	else
		return false
	end
end

-- MySQL database execute
function exec ( key, str, ... )
	if ( connection ) and ( checkKey ( key ) ) then
		local qh = dbExec( connection, str, ... )
		return qh
	else
		return false
	end
end

-- Function to check if a column already exists in a table
function doesDatabaseColumnExist ( tableName, columnName )
	if not ( tableName ) or not ( columnName ) then
		return false
	else
		local theTable = query ( MySQLKey, "DESCRIBE `??`", tableName )
		if not ( theTable ) then
			return false
		else
			for k, i in ipairs ( theTable ) do
				if ( i.Field == columnName ) then
					return true
				end
			end
			return false
		end
	end
end

-- Function that creates a new row in a table
function createDatabaseColumn ( tableName, columnName, columnType )
	if not ( tableName ) or not ( columnName ) or not ( columnType ) then
		return false
	elseif ( doesDatabaseColumnExist ( tableName, columnName ) ) then
		return false
	else
		exec ( MySQLKey, "ALTER TABLE `??` ADD `??` ??", tableName, columnName, columnType )
		return true
	end
end