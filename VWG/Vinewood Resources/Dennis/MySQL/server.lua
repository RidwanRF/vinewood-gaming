-- The MySQL connection
local conn = {}

-- The MySQL key
local key = '4A^Ppk2N7q9gTq^YERGBj^xWQGuJgj'

-- The MySQL query tool
local queryTool = false

-- Create a connection on resource start
addEventHandler( 'onResourceStart', resourceRoot, 
    function ()    
        conn['mtasa']   = { elm = dbConnect( 'mysql', 'dbname=mtasa;host=127.0.0.1;port=3306;unix_socket=/var/run/mysqld/mysqld.sock', 'mtasa', 'vkWPFJuCfuKsd' ) }
        conn['logging'] = { elm = dbConnect( 'mysql', 'dbname=logging;host=127.0.0.1;port=3306;unix_socket=/var/run/mysqld/mysqld.sock', 'logging', 'weIOUgh439gweG3grg' ) }
        conn['forum']   = { elm = dbConnect( 'mysql', 'dbname=forum;host=127.0.0.1;port=3306;unix_socket=/var/run/mysqld/mysqld.sock', 'forum', 'rb4tXkTUpUWgK' ) }
        conn['website'] = { elm = dbConnect( 'mysql', 'dbname=website;host=127.0.0.1;port=3306;unix_socket=/var/run/mysqld/mysqld.sock', 'website', 'V9PNqbSejud3ssS5' ) }

        for cName, connection in pairs ( conn ) do
            if not ( connection.elm ) then
                outputDebugString( "Failed connecting to MySQL - Database: " .. cName, 1 )
            end
        end

        loadQueryTool()
    end
)

-- Get the MySQL connection
function getConnection( str, cName )
    if ( str == key ) and ( cName == "all" ) then
        return conn
    end

    if not ( str == key ) or not ( conn[ cName ] ) then
        return false
    end

    return conn[ cName ]
end

-- Load the MySQL query tool
function loadQueryTool()
    if ( fileExists( 'queryTool' ) ) then
        local file = fileOpen( 'queryTool' )
        local buff

        buff = fileRead( file, fileGetSize( file ) )

        fileClose( file )

        queryTool = buff

        return true
    end
    
    return false
end

-- Get the MySQL query tool
function getQueryTool( str )
    if ( queryTool ) and ( str == key ) then
        return queryTool
    end
        
    return false
end