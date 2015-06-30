-- The connection element
local connection = false

-- When the resource stats create a connection
addEventHandler ( "onResourceStart", resourceRoot, 
	function ()	
		connection = dbConnect( "mysql", "dbname=forum;host=127.0.0.1;port=3306;unix_socket=/var/run/mysqld/mysqld.sock", "forum", "rb4tXkTUpUWgK", "share=1" )	
		if not ( connection ) then
			cancelEvent()
		end
	end
)

-- Get the MySQL connection element
function getConnection ()
	if ( connection ) then
		return connection
	else
		return false
	end
end