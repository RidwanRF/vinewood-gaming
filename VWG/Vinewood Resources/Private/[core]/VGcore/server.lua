



local tonumber = tonumber
local unpack = unpack

-- Positions for the matrix view for the login screen
local matrixViewPositions = {
	{2060.693359375, 1323.3287353516, 65.554336547852, 2154.0563964844, 1301.9788818359, 36.787712097168},
	{-488.73297119141, 2129.7478027344, 131.07089233398, -577.43792724609, 2095.4423828125, 100.17473602295},
	{355.38235473633, -1999.6640625, 34.214122772217, 401.36798095703, -2077.3337402344, -8.8294067382813},
	{2373.4975585938, 69.472595214844, 68.322166442871, 2420.0559082031, -10.329551696777, 30.060695648193},
	{2055.7841796875, 1197.9633789063, 25.738883972168, 2141.7668457031, 1147.1596679688, 20.643169403076},
	{2321.8068847656, -1100.53125, 76.947044372559, 2365.5268554688, -1017.3639526367, 42.716026306152},
	{-807.52880859375, 2699.8017578125, 75.263061523438, -853.92779541016, 2777.5541992188, 32.816757202148},
	{196.63110351563, 2660.5759277344, 53.300601959229, 262.5549621582, 2594.3989257813, 17.598323822021},
	{-458.94390869141, -164.11698913574, 123.5959777832, -548.6953125, -195.21823120117, 92.332641601563},
	{-1070.3149414063, -1610.5084228516, 94.326530456543, -1135.0595703125, -1682.0073242188, 67.944076538086},
	{-632.33306884766, -1473.3518066406, 44.557136535645, -545.33532714844, -1492.6140136719, -0.833984375},
	{270.52749633789, -1205.0640869141, 110.60611724854, 321.99029541016, -1128.5759277344, 71.861503601074},
	{1156.4423828125, -1441.9432373047, 38.343357086182, 1086.1207275391, -1504.4560546875, 4.4757308959961},
	{-1267.3508300781, 1106.96484375, 102.32939910889, -1311.2535400391, 1019.9342041016, 80.008575439453},
	{-2662.2238769531, 2242.8115234375, 89.52938079834, -2584.8740234375, 2297.583984375, 57.639293670654},
}

-- Things that should run at the start can be handled here
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()),
	function ()
		setOcclusionsEnabled( false )
		
		-- Set the rows of the scoreboard
		exports.VGscoreboard:scoreboardAddColumn ( "Occupation", root, 130 )
		exports.VGscoreboard:scoreboardAddColumn ( "Group", root, 110 )
		exports.VGscoreboard:scoreboardAddColumn ( "WL", root, 20 )
		exports.VGscoreboard:scoreboardAddColumn ( "City", root, 25 )
		exports.VGscoreboard:scoreboardAddColumn ( "Money" )
		exports.VGscoreboard:scoreboardAddColumn ( "Playtime", 42 )
		exports.VGscoreboard:scoreboardAddColumn ( "VIP", root, 25 )
		exports.VGscoreboard:scoreboardAddColumn ( "Flag", root, 45, "Country" )
		
		setMinuteDuration( 5000 )
	end
)

-- Event when the player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		-- Save the data and if that's done then log the player out
		local logout = exports.VGaccounts:savePlayerData( source )
		if ( logout ) then exports.VGaccounts:logoutPlayer ( source ) end
	end
)

-- Event for when a player joined the game
addEventHandler ( "onPlayerJoin", root,
	function ()
		setPlayerTeam ( source, getTeamFromName( "Not Logged In" ) )
		
		showPlayerHudComponent ( source, "radar", false )
		showPlayerHudComponent ( source, "area_name", false )
		setElementDimension ( source, 1234 )
		showChat( source, false )
		
		-- Set the country flag of the player
		local code, country = exports.VGmisc:getPlayerCountry( source )
		if ( code ) and ( code ~= "" ) and ( code ~= " " ) then
			setElementData( source, "Flag", ":VGmisc/flags/" .. code .. ".png" )
			setElementData( source, "Country", code )
		else
			setElementData( source, "Flag", "Unknown" )
		end
	end
)

-- Event when the client is ready
addEvent( "onClientDownloadReady", true )
addEventHandler( "onClientDownloadReady", root,
	function ( screenX, screenY )
		-- Check for low screen resolutions
		if ( screenX <= 800 ) and ( screenY <= 600 ) then
			kickPlayer( client, "Your resolution is too low! Change it in settings!" )
			return
		end
		
		local isPlayerBanned, table = exports.VGaccounts:isPlayerBanned ( nil, client, nil )
		if ( isPlayerBanned ) then
			triggerClientEvent( client, "onPlayerClientJoined", client, true, table, getRealTime().timestamp )
		else
			triggerClientEvent( client, "onPlayerClientJoined", client, false, false )
		end
		
		-- local x, y, z, lx, ly, lz = unpack( matrixViewPositions[ math.random ( #matrixViewPositions ) ] )
		-- setCameraMatrix( client, x, y, z, lx, ly, lz )
		
		fadeCamera( client, true, 2, 0, 0, 0 )	
	end
)

-- Event when the player wants to change the password
addEvent( "onServerRecoverPlayerPassword", true )
addEventHandler( "onServerRecoverPlayerPassword", root,
	function ( username )
		-- Not done yet
	end
)

-- Event to check the login detials of the player
addEvent( "onServerLoginPlayer", true )
addEventHandler( "onServerLoginPlayer", root,
	function ( username, password )
		-- Check if the account is banned
		local isPlayerBanned = exports.VGaccounts:isPlayerBanned ( "account", client, string.lower( username ) )
		if ( isPlayerBanned ) then
				triggerClientEvent( client, "setWarningBoxText", client, "This account is banned!" )
			return
		end
		
		-- If it's not banned login the player
		dbQuery( onCheckDatabaseResult, { client, username, password }, exports.VGforum:getConnection(), "SELECT * FROM `smf_members` WHERE `member_name`=? AND passwd=? LIMIT 1", string.lower( username ), saltHash( string.lower( username ), password ) )
	end
)

-- Function the database result from the query
function onCheckDatabaseResult ( query, thePlayer, username, password )
	local result = dbPoll( query, 0 )
	if not ( result ) or not ( result[ 1 ] ) then
		triggerClientEvent( thePlayer, "setWarningBoxText", thePlayer, "Invalid username or password!1" )
	else
		dbQuery( onCheckDatabaseAccount, { thePlayer, username, password, result[ 1 ] }, exports.VGmysql:getConnection(), "SELECT * FROM accounts WHERE accountname=? LIMIT 1", string.lower( username ) )
	end
end

-- Function the database result from the query
function onLoginDatabaseResult ( query, thePlayer, username, password, forumData )
	local result = dbPoll( query, 0 )
	if not ( result ) or not ( result[ 1 ] ) then
		triggerClientEvent( thePlayer, "setWarningBoxText", thePlayer, "Invalid username or password!2" )
	else
		handleLogin( thePlayer, result[ 1 ], forumData )
	end
end

-- Function when the account needs to be moved to the MTA accounts
function onCheckDatabaseAccount ( query, thePlayer, username, password, forumData )
	local result = dbPoll( query, 0 )
	if ( result ) and ( result[ 1 ] ) then
		handleLogin( thePlayer, result[ 1 ], forumData )
	else
		if ( exports.VGmysql:exec( "GEW783UH230WEGE978GW", "INSERT INTO accounts SET userid=?, accountname=?, email=?", forumData.id_member, string.lower( forumData.member_name ), forumData.email_address ) ) then
			dbQuery( onLoginDatabaseResult, { thePlayer, username, password, forumData }, exports.VGmysql:getConnection(), "SELECT * FROM accounts WHERE accountname=? LIMIT 1", string.lower( username ) )
		else
			triggerClientEvent( thePlayer, "setWarningBoxText", thePlayer, "Something went wrong, try again!" )
		end
	end
end

-- Function to handle the login
function handleLogin( thePlayer, aTable, forumData )
	if ( aTable ) and ( exports.VGaccounts:loginPlayer ( thePlayer, aTable, forumData ) ) then
		triggerEvent( "onServerPlayerLogin", thePlayer )
		fadeCamera( thePlayer, false, 1.0, 0, 0, 0 )
		setTimer( fadeCamera, 2000, 1, thePlayer, true, 1.0, 0, 0, 0 )
		setTimer( doSpawnPlayer, 1000, 1, thePlayer, aTable )
	else
		triggerClientEvent( thePlayer, "setWarningBoxText", thePlayer, "Something went wrong, try again!" )
	end
end

-- Function to spawn the player ingame
function doSpawnPlayer ( thePlayer, aTable )
	triggerClientEvent( thePlayer, "onClientPlayerLoggedIn", thePlayer, aTable.accountname )
	
	-- Set all the player data
	setPlayerMoney( thePlayer, aTable.money )
	exports.VGplayers:setPlayerWantedPoints( thePlayer, aTable.wantedlevel )
	setElementData( thePlayer, "Playtime", math.floor( tonumber( aTable.playtime ) ) )
	setElementData( thePlayer, "cPlaytime", convertPlaytime( math.floor( tonumber( aTable.playtime ) ) ) )
	setElementData( thePlayer, "Occupation", aTable.occupation )
	setElementData( thePlayer, "Group", aTable.group )
	setElementData( thePlayer, "JoinTick", getTickCount() )

	-- Spawn the player ingame and let him have fun
	if ( aTable.team == "Not Logged In" ) then aTable.team = "Unoccupied Civilians" end
	if ( aTable.team == "Criminals" ) or ( aTable.team == "Unemployed Civilians" ) or ( aTable.team == "Unoccupied Civilians" ) then
		spawnPlayer( thePlayer, aTable.x, aTable.y, aTable.z +1, aTable.rotation, aTable.skin, aTable.interior, aTable.dimension, getTeamFromName( aTable.team ) or getTeamFromName( "Unoccupied Civilians" ) )
	else
		spawnPlayer( thePlayer, aTable.x, aTable.y, aTable.z +1, aTable.rotation, aTable.jobskin, aTable.interior, aTable.dimension, getTeamFromName( aTable.team ) or getTeamFromName( "Unoccupied Civilians" ) )
	end
	
	-- If the ped had no health when the disconnected we should kill him!
	if ( aTable.health == 0 ) then
		killPed( thePlayer )
	else
		setElementHealth( thePlayer, aTable.health )
		setPedArmor( thePlayer, aTable.armor )
	end
	
	-- Event that triggers when all data is set
	triggerEvent( "onServerPlayerSpawned", thePlayer, aTable.accountname, aTable )
end

-- Timer to update the playtime
setTimer( 
	function ()
		for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
			if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) and ( getElementData( thePlayer, "Playtime" ) ) then
				setElementData( thePlayer, "Playtime", math.floor( ( getElementData( thePlayer, "Playtime" ) + 1 ) ) )
				setElementData( thePlayer, "cPlaytime", convertPlaytime ( math.floor( ( getElementData( thePlayer, "Playtime" ) + 1 ) ) ) )
			end
		end
	end, 60000, 0
)

-- Convert the playtime
function convertPlaytime ( minutes )
	local minutes = tonumber( minutes )
	if ( minutes == 1 ) then
		return "1 Minute"
	elseif ( minutes < 60 ) then
		return tostring ( minutes ).." Minutes"
	else
		local hours = tostring ( math.floor( ( minutes/60 ) ) )
		if ( math.floor( hours ) == 1 ) then
			return "1 Hour"
		else
			return hours.." Hours"
		end
	end
end

-- Function to hash the password
function saltHash ( username, password )
	return sha1( string.lower( username ) .. "" .. password )
end