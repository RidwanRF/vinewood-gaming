--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Import the MySQL query tool
loadstring( exports.MySQL:getQueryTool( "4A^Ppk2N7q9gTq^YERGBj^xWQGuJgj" ) )() MySQL_init();


local table = table


local tostring = tostring
local tonumber = tonumber

-- Tables and variables
local vehicleTable = {}
local adminTable = {}
local onlineAdmins = {}

-- Rank names
local rankTable = {
	[ 1 ] = "Probation Staff",
	[ 2 ] = "Junior Staff",
	[ 3 ] = "Senior Staff",
	[ 4 ] = "Supervising Staff",
	[ 5 ] = "Management Staff",
	[ 6 ] = "Leading Staff",
	[ 0 ] = "Developer",
}

-- Get the ACL group of an admin to double check the performed action
function getPlayerACLGroup ( thePlayer )
	if ( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) then
		local ACLGroups = { "L1", "L2", "L3", "L4", "L5", "L6", "Developer" }
		for k, ACL in pairs ( ACLGroups  ) do
			if ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) ), aclGetGroup ( ACL ) ) ) then
				return ACL
			end
		end
		outputDebugString( "Admin security - Client without admin panel rights trigged an admin panel event. " .. getPlayerName( thePlayer ) .. " (" .. getPlayerSerial( thePlayer ) .. ")", 2 )
		return false
	else
		outputDebugString( "Admin security - Client without admin panel rights trigged an admin panel event. " .. getPlayerName( thePlayer ) .. " (" .. getPlayerSerial( thePlayer ) .. ")", 2 )
		return false
	end
end

-- Check if the player is in any ACL group before doing certain actions
function checkPlayerACL ( thePlayer, skip )
	if ( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) then
		local ACLGroups = { "L1", "L2", "L3", "L4", "L5", "L6", "Developer" }
		for k, ACL in pairs ( ACLGroups  ) do
			if ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) ), aclGetGroup ( ACL ) ) ) then
				return ACL
			end
		end
		if not ( skip ) then outputDebugString( "Admin security - Client without admin panel rights trigged an admin panel event. " .. getPlayerName( thePlayer ) .. " (" .. getPlayerSerial( thePlayer ) .. ")", 2 ) end
		return false
	else
		if not ( skip ) then outputDebugString( "Admin security - Client without admin panel rights trigged an admin panel event. " .. getPlayerName( thePlayer ) .. " (" .. getPlayerSerial( thePlayer ) .. ")", 2 ) end
		return false
	end
end

-- Check if the admin is higher than the person he wants to punish
function isPunishAllowed( theAdmin, thePlayer )
	if ( exports.VGaccounts:getPlayerAccountName( theAdmin ) == "dennis" ) then return true end
	if ( adminTable[ exports.VGaccounts:getPlayerAccountName( theAdmin ) ] ) and ( adminTable[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] ) and ( theAdmin ~= thePlayer ) then
		if ( tonumber( adminTable[ exports.VGaccounts:getPlayerAccountName( theAdmin ) ] ) <= tonumber( adminTable[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] ) ) then
			return false
		else
			return true
		end
	else
		return true
	end
end

-- On the start of the resource
addEventHandler( "onResourceStart", root,
	function ( resource )
		if ( getResourceName( resource ) == "VGadmin" ) then 
			for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
				if ( checkPlayerACL ( thePlayer, true ) ) then
					bindKey ( thePlayer, "i", "down", "chatbox", "VG" )
					outputChatBox( "Press 'P' for your administration panel!", thePlayer, 0, 225, 0 )
					onlineAdmins[ thePlayer ] = thePlayer
				end
			end
		end
	end
)

-- Get admin table
addEvent( "onServerRequestAminTable", true )
addEventHandler( "onServerRequestAminTable", root,
	function ()
		-- Sync the player table with the client
		local aTable = {}
		for k, thePlayer in ipairs( getElementsByType( "Player" ) ) do
			table.insert( aTable, { thePlayer, getPlayerSerial( thePlayer ), getPlayerIP( thePlayer ) } )
		end
		triggerClientEvent( client, "onClientSyncAdminTable", client, adminTable )
		triggerClientEvent( client, "onClientPlayerConnected", client, false, false, false, aTable )
	end
)

-- When a staff login
addEventHandler( "onPlayerLogin", root,
	function ( )
		outputChatBox( "Press 'P' for your administration panel!", source, 0, 225, 0 )
		onlineAdmins[ source ] = source
		
		bindKey ( source, "i", "down", "chatbox", "VG" )
		
		-- Sync the player table with the client
		local aTable = {}
		for k, thePlayer in ipairs( getElementsByType( "Player" ) ) do
			table.insert( aTable, { thePlayer, getPlayerSerial( thePlayer ), getPlayerIP( thePlayer ) } )
		end
		
		-- Set the ACL
		local lvl = false
		local ACLGroups = { "L1", "L2", "L3", "L4", "L5", "L6", "Developer" }
		if ( exports.VGaccounts:getPlayerAccountName( source ) ) then
			for k, ACL in pairs ( ACLGroups  ) do
				if ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( source ) ) ), aclGetGroup ( ACL ) ) ) then
					if ( ACL == "Developer" ) then ACL = "L0" end
					local level = string.gsub( ACL, "L", "" )
					adminTable [ exports.VGaccounts:getPlayerAccountName( source ) ] = tonumber( level )
					setElementData( source, "isPlayerAdmin", tonumber( level ) )
					triggerClientEvent( "onClientSyncAdminTable", source, adminTable )
					if ( tonumber( level ) >= 3 ) then triggerClientEvent( source, "onClientSendAdminTable", source, exports.VGpunish:getServerBans () ) end
					break;
				end
			end
		end
		
		triggerClientEvent( source, "onClientPlayerConnected", source, false, false, false, aTable )
	end
)

-- Function to check if an player is a admin
function isPlayerAdmin( thePlayer )
	if ( adminTable [ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] ) then
		return true, adminTable [ exports.VGaccounts:getPlayerAccountName( thePlayer ) ]
	else
		return false
	end
end

-- When resource starts
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
			if ( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) then
				local ACLGroups = { "L1", "L2", "L3", "L4", "L5", "L6", "Developer" }
				for k, ACL in pairs ( ACLGroups  ) do
					if ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) ), aclGetGroup ( ACL ) ) ) then
						if ( ACL == "Developer" ) then ACL = "L0" end
						local level = string.gsub( ACL, "L", "" )
						adminTable [ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] = tonumber( level )
						break;
					end
				end
			end
		end
	end
)

-- When a player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		if ( adminTable [ exports.VGaccounts:getPlayerAccountName( source ) ] ) then
			adminTable [ exports.VGaccounts:getPlayerAccountName( source ) ] = nil
			onlineAdmins[ source ] = false
		end
	end
)

-- Request player data
addEvent( "onServerRequestPlayerData", true )
addEventHandler( "onServerRequestPlayerData", root,
	function ( thePlayer )
		local nickname, accountname, IP, serial, version = getPlayerName( thePlayer ), exports.VGaccounts:getPlayerAccountName( thePlayer ) or "Not logged in", getPlayerIP( thePlayer ), getPlayerSerial( thePlayer ), getPlayerVersion( thePlayer )
		local country = exports.VGmisc:getPlayerCountry ( thePlayer ) or 'Unknown'
		if ( CountryCodes[ country ] ) then country = "(".. country ..") "..CountryCodes[ country ] end
		local string1 =  "Nickname: "..nickname.."\nAccountname: "..accountname.."\nIP: "..IP.."\nSerial: "..serial.."\nMTA Version: "..version.."\nCountry: "..country..""
		
		local health, armor, skin, occupation, team, group, grouprank, cash, bankmoney = getElementHealth( thePlayer ), getPedArmor( thePlayer ), getElementModel( thePlayer ), getElementData( thePlayer, "Occupation" ) or "Not logged in", getPlayerTeamName( thePlayer ), getElementData( thePlayer, "Group" ) or "N/A", getElementData( thePlayer, "GroupRank" ) or "N/A", getPlayerMoney( thePlayer ), exports.VGaccounts:getPlayerAccountData( thePlayer, "bankmoney" ) or "Not logged in"
		local string2 =  "Health: "..health.."\nArmor: "..armor.."\nSkin: "..skin.."\nOccupation: "..occupation.."\nTeam: "..team.."\nGroup: "..group.."\nGroup Rank: "..grouprank.."\nCash: "..exports.VGutils:convertNumber ( cash ).."\nBank Money: "..exports.VGutils:convertNumber ( bankmoney )..""
		
		triggerClientEvent( client, "onClientReturnPlayerData", client, string1, string2 )
	end
)

-- Functon to get the player's team proper
function getPlayerTeamName ( thePlayer )
	if ( getPlayerTeam( thePlayer ) ) and ( getTeamName( getPlayerTeam( thePlayer ) ) ) then
		return getTeamName( getPlayerTeam( thePlayer ) )
	else
		return "Not in a team"
	end
end

-- Give player vehicle
addEvent( "onServerGivePlayerVehicle", true )
addEventHandler( "onServerGivePlayerVehicle", root,
	function ( thePlayer, vehiclename )
		local vehicleID = getVehicleModelFromName ( vehiclename )
		if ( vehicleID ) and ( checkPlayerACL ( client ) ) and not ( isPedDead( thePlayer ) ) then
			if ( isPedInVehicle( thePlayer ) ) then setElementModel( getPedOccupiedVehicle( thePlayer ), vehicleID ) return end
			local x, y, z = getElementPosition( thePlayer )
			local vehicle = createVehicle( vehicleID, x, y, z +2, 0, 0, getPedRotation( thePlayer ) )
			if ( vehicle ) then
				setElementDimension( vehicle, getElementDimension( thePlayer ) )
				setElementInterior( vehicle, getElementInterior( thePlayer ) )
				vehicleTable[ vehicle ] = vehicle
				warpPedIntoVehicle( thePlayer, vehicle )
				outputChatBox( getPlayerName( client ) .. " gave you a " .. vehiclename, thePlayer, 0, 225, 0 )
				outputChatBox( "You gave " .. getPlayerName( thePlayer ) .. " a " .. vehiclename, client, 0, 225, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " spawned a " .. vehiclename .. " to " .. getPlayerName( thePlayer ) )
			end
			
			-- If the vehicle is for Dennis make it damageproof
			if ( getPlayerACLGroup ( client ) == "L6" ) then
				if ( isAdminOnDuty( thePlayer ) ) then
					setVehicleDamageProof( vehicle, true )
				end
			end
		end
	end
)

-- Destroy the vehicle when it'll blow
addEventHandler ( "onVehicleExplode", root, 
	function ()
		if ( vehicleTable[ source ] == source ) then
			setTimer( destroyElement, 5000, 1, source )
			vehicleTable[ source ] = false
		end
	end
)

-- Give player weapon
addEvent( "onServerGivePlayerWeapon", true )
addEventHandler( "onServerGivePlayerWeapon", root,
	function ( thePlayer, weaponname )
		local weaponID = getWeaponIDFromName ( weaponname )
		if ( weaponID ) and ( getPlayerACLGroup ( client ) == "L6" ) then
			if ( exports.VGweaponsync:givePlayerWeapon ( thePlayer, weaponID, 100, true ) ) then
				outputChatBox( getPlayerName( client ) .. " gave you a " .. weaponname .. " with 100 ammo", thePlayer, 0, 225, 0 )
				outputChatBox( "You gave " .. getPlayerName( thePlayer ) .. " a " .. weaponname .. " with 100 ammo", client, 0, 225, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " gave " .. getPlayerName( thePlayer ) .. " a " .. weaponname .. " with 100 ammo" )
			end
		end
	end
)

-- Slap player event
addEvent( "onServerSlapPlayer", true )
addEventHandler( "onServerSlapPlayer", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and not ( isPedDead( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			if not ( isPunishAllowed( client, thePlayer ) ) then outputChatBox( "Insufficient permissions, can't punish higher staff", client, 225, 0, 0 ) return end
			killPed( thePlayer )
			outputChatBox( "You got slapped by " .. getPlayerName( client ) .. " (100HP)", thePlayer, 225, 0, 0 )
			outputChatBox( "You slapped " .. getPlayerName( thePlayer ) .. " (100HP)", client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " slapped " .. getPlayerName( thePlayer ) .. " (100HP)" )
		end
	end
)

-- Freeze player event
addEvent( "onServerFreezePlayer", true )
addEventHandler( "onServerFreezePlayer", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and not ( isPedDead( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			if not ( isPunishAllowed( client, thePlayer ) ) then outputChatBox( "Insufficient permissions, can't punish higher staff", client, 225, 0, 0 ) return end
			if ( isElementFrozen( thePlayer ) ) then
				outputChatBox( "You have unfrozen ".. getPlayerName( thePlayer ), client, 0, 225, 0 )
				outputChatBox( "You have been unfrozen by " .. getPlayerName( client ), thePlayer, 0, 225, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " froze " .. getPlayerName( thePlayer ) .. "" )
				toggleAllControls ( thePlayer, true, true, true )
				setElementFrozen( thePlayer, false )
			else
				outputChatBox( "You have frozen ".. getPlayerName( thePlayer ), client, 0, 225, 0 )
				outputChatBox( "You have been frozen by " .. getPlayerName( client ), thePlayer, 225, 0, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " unfroze " .. getPlayerName( thePlayer ) .. "" )
				toggleAllControls ( thePlayer, false, true, false )
				setElementFrozen( thePlayer, true )
			end
		end
	end
)

-- Slap player event
addEvent( "onServerKickPlayer", true )
addEventHandler( "onServerKickPlayer", root,
	function ( thePlayer, reason )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			if not ( isPunishAllowed( client, thePlayer ) ) then outputChatBox( "Insufficient permissions, can't punish higher staff", client, 225, 0, 0 ) return end
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " kicked " .. getPlayerName( thePlayer ) .. "" )
			exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " kicked " .. getPlayerName( thePlayer ) .. " (" .. reason .. ")", client )
			outputChatBox( getPlayerName( client ) .. " kicked " .. getPlayerName( thePlayer ) .. " (" .. reason .. ")", root, 225, 0, 0 )
			kickPlayer( thePlayer, getPlayerName( client ).." kicked you! Reason: "..reason )
		end
	end
)

-- Warp player event
addEvent( "onServerWarpPlayerToPlayer", true )
addEventHandler( "onServerWarpPlayerToPlayer", root,
	function ( thePlayer, toPlayer, warpTo )
		if ( isElement( thePlayer ) ) and ( isElement( toPlayer ) ) and ( checkPlayerACL ( client ) ) then
			if ( warpTo ) then
				if ( devCheck( client, thePlayer ) ) then devError( client ) return end
				outputChatBox( getPlayerName( client ) .. " warped you to " .. getPlayerName( toPlayer ), thePlayer, 0, 225, 0 )
				outputChatBox( "You warped " .. getPlayerName( thePlayer ) .. " to " .. getPlayerName( toPlayer ), client, 0, 225, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " warped " .. getPlayerName( thePlayer ) .. " to " .. getPlayerName( toPlayer ) )
			else
				if ( devCheck( client, toPlayer ) ) then devError( client ) return end
				outputChatBox( "You warped yourself to ".. getPlayerName( toPlayer ), thePlayer, 0, 225, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " warped to " .. getPlayerName( toPlayer ) .. "" )
			end
			
			-- Warp the player
			warpPlayerToPlayer ( thePlayer, toPlayer )
		end
	end
)

-- Repair and destroy vehicle event
addEvent( "onServerVehicleRepairDestroy", true )
addEventHandler( "onServerVehicleRepairDestroy", root,
	function ( thePlayer, option )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			if ( getPedOccupiedVehicle( thePlayer ) ) then
				if ( option == "repair" ) then
					-- if ( getElementHealth( getPedOccupiedVehicle( thePlayer ) ) >= 999 ) then return end
					fixVehicle( getPedOccupiedVehicle( thePlayer ) )
					outputChatBox( getPlayerName( client ) .. " fixed your vehicle", thePlayer, 0, 225, 0 )
					outputChatBox( "You fixed the vehicle from " .. getPlayerName( thePlayer ), client, 0, 225, 0 )
					exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " repaired the vehicle from " .. getPlayerName( thePlayer ) )
					local rx, ry, rz = getVehicleRotation ( getPedOccupiedVehicle( thePlayer ) )
					if ( rx > 110 ) and ( rx < 250 ) then
						local x, y, z = getElementPosition ( getPedOccupiedVehicle( thePlayer ) )
						setVehicleRotation ( getPedOccupiedVehicle( thePlayer ), rx + 180, ry, rz )
						setElementPosition ( getPedOccupiedVehicle( thePlayer ), x, y, z + 2 )
					end
				else
					destroyElement( getPedOccupiedVehicle( thePlayer ) )
					outputChatBox( getPlayerName( client ) .. " destroyed your vehicle", thePlayer, 0, 225, 0 )
					outputChatBox( "You destroyed the vehicle from " .. getPlayerName( thePlayer ), client, 0, 225, 0 )
					exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " destroyed the vehicle from " .. getPlayerName( thePlayer ) )
				end
			end
		end
	end
)

-- Set nick event
addEvent( "onServerPlayerChangeNick", true )
addEventHandler( "onServerPlayerChangeNick", root,
	function ( thePlayer, theNick )
		if ( isElement( thePlayer ) ) and not ( getPlayerFromName( theNick ) ) and ( checkPlayerACL ( client ) ) then
			if not ( isPunishAllowed( client, thePlayer ) ) then outputChatBox( "Insufficient permissions, can't punish higher staff", client, 225, 0, 0 ) return end
			local oldNick = getPlayerName( thePlayer )
			setPlayerName ( thePlayer, theNick )
			outputChatBox( getPlayerName( client ) .. " changed your nick to " .. theNick, thePlayer, 0, 225, 0 )
			outputChatBox( "You changed the nick from " .. oldNick .. " to " .. theNick, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " changed the nick from " .. oldNick .. " to " .. theNick )
			exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " changed the nick from " .. oldNick .. " to " .. theNick, client )
		else
			outputChatBox( "This nickname is already in use!", client, 225, 0, 0 )
		end
	end
)

-- Change skin event
addEvent( "onServerPlayerChangeSkin", true )
addEventHandler( "onServerPlayerChangeSkin", root,
	function ( thePlayer, skinID )
		if ( isElement( thePlayer ) ) and not ( isPedDead( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			setElementModel( thePlayer, skinID )
			outputChatBox( getPlayerName( client ) .. " changed your skinID to " .. skinID, thePlayer, 0, 225, 0 )
			outputChatBox( "You changed the skin from " .. getPlayerName( thePlayer ) .. " to " .. skinID, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " changed the skin from " .. getPlayerName( thePlayer ) .. " to " .. skinID )
		end
	end
)

-- Set health event
addEvent( "onServerPlayerChangeHealth", true )
addEventHandler( "onServerPlayerChangeHealth", root,
	function ( thePlayer, health )
		if ( isElement( thePlayer ) ) and not ( isPedDead( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			setElementHealth( thePlayer, health )
			outputChatBox( getPlayerName( client ) .. " changed your health to " .. health, thePlayer, 0, 225, 0 )
			outputChatBox( "You changed the health from " .. getPlayerName( thePlayer ) .. " to " .. health, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " changed the health from " .. getPlayerName( thePlayer ) .. " to " .. health )
		end
	end
)

-- Set armor event
addEvent( "onServerPlayerChangeArmor", true )
addEventHandler( "onServerPlayerChangeArmor", root,
	function ( thePlayer, armor )
		if ( isElement( thePlayer ) ) and not ( isPedDead( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			setPedArmor( thePlayer, armor )
			outputChatBox( getPlayerName( client ) .. " changed your armor to " .. armor, thePlayer, 0, 225, 0 )
			outputChatBox( "You changed the armor from " .. getPlayerName( thePlayer ) .. " to " .. armor, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " changed the armor from " .. getPlayerName( thePlayer ) .. " to " .. armor )
		end
	end
)

-- Give money event
addEvent( "onServerPlayerGiveMoney", true )
addEventHandler( "onServerPlayerGiveMoney", root,
	function ( thePlayer, money )
		if ( isElement( thePlayer ) ) and ( getPlayerACLGroup ( client ) == "L6" ) then
			exports.VGplayers:givePlayerCash( thePlayer, money, getPlayerName( client ) .. " added $".. money )
			outputChatBox( getPlayerName( client ) .. " gave you $" .. money, thePlayer, 0, 225, 0 )
			outputChatBox( "You gave " .. getPlayerName( thePlayer ) .. " $" .. money, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " gave " .. getPlayerName( thePlayer ) .. " $" .. money )
		end
	end
)

-- Take money event
addEvent( "onServerPlayerTakeMoney", true )
addEventHandler( "onServerPlayerTakeMoney", root,
	function ( thePlayer, money )
		if ( isElement( thePlayer ) ) and ( getPlayerACLGroup ( client ) == "L6" ) then
			exports.VGplayers:takePlayerCash( thePlayer, money, getPlayerName( client ) .. " took $".. money )
			outputChatBox( getPlayerName( client ) .. " took $" .. money .. " of your money", thePlayer, 0, 225, 0 )
			outputChatBox( "You took $" .. money .. " from " .. getPlayerName( thePlayer ), client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " took $" .. money .. " from " .. getPlayerName( thePlayer ) )
		end
	end
)

-- Set dimension event
addEvent( "onServerPlayerChangeDimension", true )
addEventHandler( "onServerPlayerChangeDimension", root,
	function ( thePlayer, dimension )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			setElementDimension( thePlayer, dimension )
			outputChatBox( getPlayerName( client ) .. " changed your dimension to " .. dimension, thePlayer, 0, 225, 0 )
			outputChatBox( "You changed the dimension from " .. getPlayerName( thePlayer ) .. " to " .. dimension, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " changed the dimension from " .. getPlayerName( thePlayer ) .. " to " .. dimension )
		end
	end
)

-- Set interior event
addEvent( "onServerPlayerChangeInterior", true )
addEventHandler( "onServerPlayerChangeInterior", root,
	function ( thePlayer, interior )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			setElementInterior( thePlayer, interior )
			outputChatBox( getPlayerName( client ) .. " changed your interior to " .. interior, thePlayer, 0, 225, 0 )
			outputChatBox( "You changed the interior from " .. getPlayerName( thePlayer ) .. " to " .. interior, client, 0, 225, 0 )
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " changed the interior from " .. getPlayerName( thePlayer ) .. " to " .. interior )
		end
	end
)

-- Show the last logins for the selected account
addEvent( "onServerRequestLatestLogins", true )
addEventHandler( "onServerRequestLatestLogins", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			local theTable = exports.VGlogging:getPlayerLatestLogins ( thePlayer )
			triggerClientEvent( client, "onClientShowPlayerLatestLogins",client, theTable )
		end
	end
)

-- Get the latest punishments for an account
addEvent( "onServerRequestLatestPunishments", true )
addEventHandler( "onServerRequestLatestPunishments", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			local theTable = exports.VGlogging:getPlayerPunishments( thePlayer )
			triggerClientEvent( client, "showPunishmentsWindow", client, theTable, thePlayer, getPlayerSerial( thePlayer ) )
		end
	end
)

-- Ban event
addEvent( "onServerPlayerBan", true )
addEventHandler( "onServerPlayerBan", root,
	function ( thePlayer, theTime, theReason, accountOnly, IPban )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) )  then
			if ( theTime == 0 ) then banTime = 0 else banTime = getRealTime().timestamp + theTime end
			if ( accountOnly ) then
				outputChatBox( getPlayerName( client ) .. " account banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " account banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
				exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " account banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", source )
				exports.VGpunish:addBan ( theReason, banTime, exports.VGaccounts:getPlayerAccountName( thePlayer ), false, false, getPlayerName( client ), thePlayer )
			elseif ( IPban ) then
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
				outputChatBox( getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )
				exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", source )
				exports.VGpunish:addBan ( theReason, banTime, exports.VGaccounts:getPlayerAccountName( thePlayer ), getPlayerSerial( thePlayer ), getPlayerIP( thePlayer ), getPlayerName( client ), thePlayer )
			else
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
				outputChatBox( getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )
				exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " banned " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", source )
				exports.VGpunish:addBan ( theReason, banTime, exports.VGaccounts:getPlayerAccountName( thePlayer ), getPlayerSerial( thePlayer ), false, getPlayerName( client ), thePlayer )
			end
		end
	end
)

-- Custom ban event
addEvent( "onServerCustomBan", true )
addEventHandler( "onServerCustomBan", root,
	function ( theTime, theReason, theAccount, theIP, theSerial )
		if ( checkPlayerACL ( client ) )  then
			if ( theTime == 0 ) then banTime = 0 else banTime = getRealTime().timestamp + theTime end
			local isBanCreated, error = exports.VGpunish:addBan ( theReason, banTime, theAccount, theSerial, theIP, getPlayerName( client ) )
			if ( isBanCreated ) then
				local theAction1 = getPlayerName( client ) .. " banned this serial or account for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")"
				dbExec( exports.VGlogging:getLoggingMySQLConnection(), "INSERT INTO punishlogs SET accountname=?, serial=?, action=?, admin=?", theAccount, theSerial, theAction1, getPlayerName( client ) )
				local theAction2 = getPlayerName( client ) .. " added a ban with ID: " .. error .. " (Account: " .. theAccount .. ") (Serial: " .. theSerial .. ") for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")"
				dbExec( exports.VGlogging:getLoggingMySQLConnection(), "INSERT INTO adminlogs SET accountname=?, nickname=?, serial=?, action=?", exports.VGaccounts:getPlayerAccountName( client ), getPlayerName( client ), getPlayerSerial( client ), theAction2 )
				outputChatBox( "Ban has been added!", client, 0, 225, 0 )
			else
				outputChatBox( "Something went wrong while adding the ban! (" .. error .. ")", client, 225, 0, 0 )
			end
		end
	end
)

-- Jail event
addEvent( "onServerPlayerJail", true )
addEventHandler( "onServerPlayerJail", root,
	function ( thePlayer, theTime, theReason )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) )  then
			exports.VGpunish:jailPlayer( thePlayer, theTime )
			outputChatBox( getPlayerName( client ) .. " jailed " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )			
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " jailed " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
			exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " jailed " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", source )
		end
	end
)

-- Unjail the player
addEvent( "onServerPlayerUnjail", true )
addEventHandler( "onServerPlayerUnjail", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) )  then
			if ( exports.VGpunish:isPlayerJailed( thePlayer ) ) then
				exports.VGpunish:unjailPlayer( thePlayer )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " unjailed " .. getPlayerName( thePlayer ) .. "" )
				outputChatBox( "You have been unjailed by: " .. getPlayerName( client ) .. "", thePlayer, 0, 225, 0 )
			else
				outputChatBox( "This player is not jailed!", client, 225, 0, 0 )
			end
		end
	end
)

-- Mute event
addEvent( "onServerPlayerMute", true )
addEventHandler( "onServerPlayerMute", root,
	function ( thePlayer, theTime, theReason, theType )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then
			exports.VGpunish:mutePlayer( thePlayer, theTime, theType )
			if ( theType == "Global" ) then theType = "globally muted" elseif ( theType == "Support" ) then theType = "support chat muted" elseif ( theType == "Main" ) then theType = "main chat muted" end
			outputChatBox( getPlayerName( client ) .. " " .. theType .. " " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", root, 255, 0, 0 )			
			exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " muted " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")" )
			exports.VGlogging:addPlayerPunishmentLogRow( thePlayer, getPlayerName( client ) .. " muted " .. getPlayerName( thePlayer ) .. " for " .. exports.VGutils:secondsToTimeString ( theTime ) .. " (" .. theReason .. ")", source )
		end
	end
)

-- Unmute event
addEvent( "onServerPlayerUnmute", true )
addEventHandler( "onServerPlayerUnmute", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then			
			if ( exports.VGpunish:isPlayerMuted( thePlayer ) ) then
				exports.VGpunish:unmutePlayer( thePlayer, client )
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " unmuted " .. getPlayerName( thePlayer ) .. "" )
			else
				outputChatBox( "This player is not jailed!", client, 225, 0, 0 )
			end
		end
	end
)

-- Unban event
addEvent( "onServerUnban", true )
addEventHandler( "onServerUnban", root,
	function ( banID )
		if ( checkPlayerACL ( client ) ) and ( getPlayerACLGroup ( client ) == "L5" ) or ( getPlayerACLGroup ( client ) == "L6" ) then
			if ( exports.VGpunish:removeBan( tonumber( banID ) ) ) then
				exports.VGlogging:addAdminLogRow( client, getPlayerName( client ) .. " removed a ban (BANID: " .. banID .. ")" )
				outputChatBox( "Ban with ID " .. banID .. " removed succesfully!", client, 0, 225, 0 )
			else
				outputChatBox( "Ban not found! (Contact L6)", client, 225, 0, 0 )
				exports.VGpunish:resentAdminTable()
			end
		end
	end
)

-- Show mute window
addEvent( "onServerShowMuteWindow", true )
addEventHandler( "onServerShowMuteWindow", root,
	function ( thePlayer )
		if ( isElement( thePlayer ) ) and ( checkPlayerACL ( client ) ) then			
			triggerClientEvent( client, "onClientShowMutesWindow", client, exports.VGpunish:isPlayerMuted( thePlayer ) )
		end
	end
)

-- When a player joins
addEventHandler ( "onPlayerJoin", root,
	function ()
		if ( onlineAdmins ) then
			for k, thePlayer in pairs ( onlineAdmins ) do
				if ( isElement( thePlayer ) ) then
					triggerClientEvent( thePlayer, "onClientPlayerConnected", thePlayer, source, getPlayerSerial( source ), getPlayerIP( source ), false )
				end
			end
		end
	end
)

-- Get a table with all the admins online
function getOnlineAdmins ()
	if ( onlineAdmins ) then
		return onlineAdmins
	else
		return false
	end
end

-- Function to get a player's staff rank
function getPlayerAdminRank ( thePlayer )
	if ( isElement( thePlayer ) ) and ( adminTable[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] ) then
		return adminTable[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ]
	else
		return false
	end	
end

-- Function to get is a player is developer
function isPlayerDeveloper ( thePlayer )
	if ( isElement( thePlayer ) ) and ( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) then
		if ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( thePlayer ) ) ), aclGetGroup ( "Developer" ) ) ) then
			return true
		else
			return false
		end
	else
		return false
	end	
end

-- Function to get if a player is a EM
function isPlayerEventManager ( thePlayer )
	if ( isElement( thePlayer ) ) then
		return false
	else
		return false
	end	
end

-- Function to get if a player is on duty
function isAdminOnDuty( thePlayer )
	if ( isElement( thePlayer ) ) and ( getPlayerTeam( thePlayer ) ) then
		if ( getTeamName( getPlayerTeam( thePlayer ) ) == "Staff" ) then
			return true
		else
			return false
		end
	else
		return false
	end
end

-- Get the name of a player's rank
function getPlayerAdminRankName( thePlayer )
	if ( isElement( thePlayer ) ) and ( isPlayerAdmin( thePlayer ) ) then
		local isAdmin, level = isPlayerAdmin( thePlayer )
		for rank, name in pairs ( rankTable ) do
			if ( rank == level ) then
				return name
			end
		end
		return false
	else
		return false
	end
end