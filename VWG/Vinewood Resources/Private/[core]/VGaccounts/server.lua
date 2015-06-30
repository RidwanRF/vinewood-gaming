



local tostring = tostring
local tonumber = tonumber

-- Table that stores all the data
local dataTable = {}
local antispam = {}
local guestStaff = {}

-- Table that convert the rank to a ACL right
local ACLGroups  = { "L1", "L2", "L3", "L4", "L5", "L6", "Developer" }
local groupToACL = { [ 1 ]  = "L6", [ 13 ]  = "L5", [ 12 ] = "L4", [ 11 ] = "L3", [ 10 ] = "L2", [ 9 ] = "L1", [ 14 ] = "Developer" }

-- Function for when the resource start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "accountdataTable" )
		if ( tbl ) then dataTable = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "accountdataTable", dataTable )
	end
)

-- Function to check if all the data is still there
function checkPlayerData ( thePlayer )
	if not ( dataTable[ thePlayer ] ) and ( isPlayerLoggedIn ( thePlayer ) ) then 
		local table = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM accounts WHERE accountname=? LIMIT 1", getElementData( thePlayer, "isLoggedIn" ) )
		if ( table ) then
			dataTable[ thePlayer ] = table
			triggerClientEvent( thePlayer, "syncPlayerDataTable", thePlayer, table )
			outputDebugString ( "Retrieving accountdata from " .. getPlayerName( thePlayer ) .. ", mind checking MySQL overload!" )
		end
	end
end

-- Function to delete a account
function deleteAccount ( accountname )
	if not ( accountname ) then
		return false, "No username enterd"
	else
		if ( exports.VGmysql:exec( "GEW783UH230WEGE978GW", "DELETE FROM accounts WHERE accountname=?", string.lower( accountname ) ) ) then
			return true
		else
			return false
		end
	end
end

-- Function to login a player
function loginPlayer ( thePlayer, aTable, forumData )
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif ( antispam[ thePlayer ] ) and ( getTickCount()-antispam[ thePlayer ] <= 10000 ) then
		return false, "Loading... Please wait!"
	elseif ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "Already logged in"
	else
		antispam[ thePlayer ] = getTickCount()
		if ( aTable ) then
			dataTable[ thePlayer ] = aTable
			setElementData( thePlayer, "isLoggedIn", aTable.accountname )
			triggerClientEvent( thePlayer, "syncPlayerDataTable", thePlayer, aTable )
			if ( forumData ) then
				checkACLRights( aTable.accountname, forumData.id_group, forumData.additional_groups )
				dataTable[ thePlayer ].password = forumData.passwd
				dataTable[ thePlayer ].email = forumData.email_address
				setPlayerAccountData( thePlayer, "credits", tonumber( aTable.credits or 0 ) + tonumber( forumData.funds or 0 ) )
				-- dbExec( exports.VGforum:getConnection(), "UPDATE `smf_members` SET `funds`=? WHERE `id_member`=?", 0, aTable.userid )
			end
			setPlayerAccountData( thePlayer, "lastnick", getPlayerName( thePlayer )  )
			setPlayerAccountData( thePlayer, "serial", getPlayerSerial( thePlayer )  )
			loginPlayerAdmin ( thePlayer, string.lower( aTable.accountname ) )
			exports.VGlogging:log( "login", thePlayer )
			return true, aTable
		else
			return false, "Something went wrong, try again"
		end
	end
end

-- Function ACL Check
function checkACLRights( accountname, groupID, additionalGroups )
	local accountname = string.lower( tostring ( accountname ) )
	for _, ACL in pairs ( ACLGroups ) do
		-- Remove them from all the ACL groups
		if ( isObjectInACLGroup ( "user.".. accountname, aclGetGroup ( ACL ) ) ) then
			aclGroupRemoveObject( aclGetGroup( ACL ), "user." .. accountname )
		end
			
		-- Add the user in the main group
		if ( groupID ) and ( groupToACL[ groupID ] ) and ( groupToACL[ groupID ] == ACL ) then
			aclGroupAddObject( aclGetGroup( ACL ), "user." .. accountname )
		end
		
		-- Check for additional groups
		if ( additionalGroups ) then
			local groups = split ( additionalGroups, "," )
			if ( groups ) then
				for _, aGroup in ipairs ( groups ) do
					if ( tonumber( aGroup ) ) and ( groupToACL[ tonumber( aGroup ) ] ) and ( groupToACL[ tonumber( aGroup ) ] == ACL ) then
						aclGroupAddObject( aclGetGroup( ACL ), "user." .. accountname )
					end
				
					-- If the player is a guest staff
					if ( aGroup ) and ( tonumber( aGroup ) == 38 ) then
						guestStaff[ accountname ] = true
					end
				end
			end
		end
	end
end

-- Event when the player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		local accountname = string.lower ( tostring( getPlayerAccountName ( source ) ) )
		if ( guestStaff[ accountname ] ) then guestStaff[ accountname ] = nil end
		for _, ACL in pairs ( ACLGroups ) do
			if ( isObjectInACLGroup ( "user.".. accountname, aclGetGroup ( ACL ) ) ) then
				aclGroupRemoveObject( aclGetGroup( ACL ), "user." .. accountname )
			end
		end
	end
)

-- Function that handles the login for admins so they login through the MTA default system
function loginPlayerAdmin ( thePlayer, accountname )
	if ( getPlayerAccountName( thePlayer ) ) then
		for k, ACL in pairs ( ACLGroups  ) do
			if ( isObjectInACLGroup ( "user.".. string.lower( tostring ( accountname ) ), aclGetGroup ( ACL ) ) ) then
				-- Create an unique account for admins each login
				local password = exports.VGutils:randomString()
				if ( getAccount ( string.lower( accountname ) ) ) then removeAccount ( getAccount ( string.lower( accountname )  ) ) end
				if ( addAccount ( string.lower( accountname ), password ) ) then logIn ( thePlayer, getAccount ( string.lower( accountname ) ), password ) end
				return true
			end
		end
		return false
	end
end

-- Function to log a player out
function logoutPlayer ( thePlayer )
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "This player is not logged in"
	else
		setTimer( removePlayerFromTable, 5000, 1, thePlayer )
		return true
	end
end

-- Nothing important
function removePlayerFromTable ( thePlayer )
	dataTable[ thePlayer ] = nil
end

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
		checkPlayerData ( thePlayer )
		return dataTable[ thePlayer ].accountname
	end
end

-- Function to get a player's accountid
function getPlayerAccountID ( thePlayer )
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "This player is not logged in"
	else
		checkPlayerData ( thePlayer )
		return dataTable[ thePlayer ].userid
	end
end

-- Function to get a player's accountdata
function getPlayerAccountData( thePlayer, dataname )
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "This player is not logged in"
	elseif not ( dataTable[ thePlayer ] ) then
		return false, "Internal error"
	elseif not ( dataTable[ thePlayer ][ dataname ] ) then
		return false, "No data found with this dataname"
	else
		checkPlayerData ( thePlayer )
		return dataTable[ thePlayer ][ dataname ]
	end
end

-- Function to set a password
function setAccountPassword ( accountname, password, unsafeP )
	if not ( accountname ) then
		return false, "No username enterd"
	elseif not ( password ) then
		return false, "Username contains illegal characters"
	elseif ( string.len( password ) < 64 ) then
		return false, "Security issue, password not hashed"
	else
		if ( exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE accounts SET password=? WHERE accountname=?", password, string.lower( accountname ) ) ) then
			if ( dataTable[ thePlayer ] ) then dataTable[ thePlayer ].password = password end
			return true
		else
			return false
		end
	end
end

-- Function to set a player's accountdata
function setPlayerAccountData( thePlayer, dataname, datavalue )
	checkPlayerData ( thePlayer )
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "This player is not logged in"
	elseif not ( dataTable[ thePlayer ][ dataname ] ) then
		return false, "No data found with this dataname"
	elseif not ( datavalue ) then
		return false, "You didn't enter a data value"
	else
		if ( exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE accounts SET `??` = ? WHERE userid=?", dataname, datavalue, getPlayerAccountID ( thePlayer ) ) ) then
			dataTable[ thePlayer ][ dataname ] = datavalue
			triggerClientEvent( thePlayer, "onClientPlayerDataUpdate", thePlayer, dataname, datavalue )
			return true
		else
			return false
		end
	end
end

-- Function to get a player from a account
function getPlayerFromAcountName ( accountname )
	if not ( accountname ) then
		return false, "No username enterd"
	else
		for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
			if ( getPlayerAccountName ( thePlayer ) == string.lower( accountname ) ) then
				return thePlayer
			end
		end
		return false, "No player with that accountname"
	end
end

-- Check for bans
function isPlayerBanned ( type, thePlayer, accountname )
	if ( type == "account" ) then
		local table = exports.VGpunish:getServerBans ()
		if ( table ) then
			for _, tbl in ipairs( table ) do
				if ( string.lower( tbl.accountname ) == string.lower( accountname ) ) then
					if ( getRealTime().timestamp >= tonumber( tbl.banstamp ) ) and not ( tonumber( tbl.banstamp ) == 0 ) then
						exports.VGpunish:removeBan ( tbl.banid )
						return false
					else
						return true, tbl
					end
				else
					return false
				end
			end
		else
			outputDebugString( "WARNING: Couldn't load bans table from VGaccounts!" )
			return false
		end
	else
		local table = exports.VGpunish:getServerBans ()
		if ( table ) then
			for _, tbl in ipairs( table ) do
				if ( string.lower( tbl.serial ) == string.lower( getPlayerSerial( thePlayer ) ) ) or ( tbl.ip == getPlayerIP( thePlayer ) ) then
					if ( getRealTime().timestamp >= tonumber( tbl.banstamp ) ) and not ( tonumber( tbl.banstamp ) == 0 ) then
						exports.VGpunish:removeBan ( tbl.banid )
						return false
					else
						return true, tbl
					end
				else
					return false
				end
			end
		else
			outputDebugString( "WARNING: Couldn't load bans table from VGaccounts!" )
			return false
		end
	end
end

-- Function to save the player's data
function savePlayerData( thePlayer )
	-- Get the player team
	local function getPlayerTeamName ( thePlayer )
		if ( getPlayerTeam( thePlayer ) ) then
			return getTeamName( getPlayerTeam( thePlayer ) )
		else
			return "Unemployed"
		end
	end
	
	-- Safe the data
	if not ( isElement( thePlayer ) ) then
		return false, "This player element does not exist"
	elseif not ( isPlayerLoggedIn ( thePlayer ) ) then
		return false, "This player is not logged in"
	else
		if ( isPedDead( thePlayer ) ) then health = 0 else health = getElementHealth( thePlayer ) end
		
		local x, y, z = getElementPosition( thePlayer )
		local error = exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE accounts SET x=?, y=?, z=?, dimension=?, interior=?, rotation=?, health=?, armor=?, team=?, occupation=?, money=?, wantedlevel=?, playtime=? WHERE userid=?"
			,x
			,y
			,z
			,getElementDimension( thePlayer )
			,getElementInterior( thePlayer )
			,getPedRotation( thePlayer )
			,health
			,getPedArmor( thePlayer )
			,getPlayerTeamName( thePlayer )
			,getElementData( thePlayer, "Occupation" ) or ""
			,getPlayerMoney( thePlayer )
			,exports.VGplayers:getPlayerWantedPoints( thePlayer ) or 0
			,tonumber( getElementData( thePlayer, "Playtime" ) )
			,getPlayerAccountID ( thePlayer )
		)
		if not ( error ) then return false else return true end
	end
end

-- Event that changes the element model in the database
addEventHandler( "onElementModelChange", root, 
	function ( _, model )
		if ( getElementType( source ) == "player" ) and ( getPlayerAccountID ( source ) ) and ( getPlayerTeam ( source ) ) then
			if ( getTeamName ( getPlayerTeam ( source ) )  == "Criminals" ) or ( getTeamName ( getPlayerTeam ( source ) )  == "Unemployed Civilians" ) or ( getTeamName ( getPlayerTeam ( source ) )  == "Unoccupied Civilians" ) then
				setPlayerAccountData( source, "skin", model )
			else
				setPlayerAccountData( source, "jobskin", model )
			end
		end
	end
)

-- Function that checks if a player is a guest staff
function isPlayerGuestStaff ( thePlayer )
	local accountname = string.lower ( tostring( getPlayerAccountName ( thePlayer ) ) )
	if ( guestStaff[ accountname ] ) then
		return true
	else
		return false
	end
end