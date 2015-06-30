--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	admin_ACL.lua
*
*	Original File by lil_Toady
*
**************************************]]

local table = table



local tostring = tostring
local tonumber = tonumber
local type = type

_root = getRootElement()
_types = { "player", "team", "vehicle", "resource", "server", "admin" }
_settings = nil

function aSetupACL ()
	local temp_acl_nodes = {}
	local node = xmlLoadFile ( "conf\\ACL.xml" )
	if ( node ) then
		--Get ACLs
		local acls = 0
		while ( xmlFindChild ( node, "acl", acls ) ~= false ) do
			local aclNode = xmlFindChild ( node, "acl", acls )
			local aclName = xmlNodeGetAttribute ( aclNode, "name" )
			if ( ( aclNode ) and ( aclName ) ) then
				temp_acl_nodes[aclName] = aclNode
			end
			acls = acls + 1
		end
		-- Add missing rights
		local totalAdded = 0
		for id, acl in ipairs ( aclList () ) do
			local aclName = aclGetName ( acl )
			local node = temp_acl_nodes[aclName] or temp_acl_nodes["Default"]
			if node then
				totalAdded = totalAdded + aACLLoad ( acl, node )
			end
		end
		if totalAdded > 0 then
			outputServerLog ( "Admin access list successfully updated " )
			outputConsole ( "Admin access list successfully updated " )
			outputDebugString ( "Admin added " .. totalAdded .. " missing rights" )
		end
		xmlUnloadFile ( node )
	else
		outputServerLog ( "Failed to install admin access list - File missing" )
		outputConsole ( "Failed to install admin access list - File missing" )
	end
end

function aACLLoad ( acl, node )
	local added = 0
	local rights = 0
	while ( xmlFindChild ( node, "right", rights ) ~= false ) do
		local rightNode = xmlFindChild ( node, "right", rights )
		local rightName = xmlNodeGetAttribute ( rightNode, "name" )
		local rightAccess = xmlNodeGetAttribute ( rightNode, "access" )
		if ( ( rightName ) and ( rightAccess ) ) then
			-- Add if missing from this acl
			if not aclRightExists ( acl, rightName ) then
				aclSetRight ( acl, rightName, rightAccess == "true" )
				added = added + 1
			end
		end
		rights = rights + 1
	end
	return added
end

_hasObjectPermissionTo = hasObjectPermissionTo
function hasObjectPermissionTo ( object, action )
	if ( ( isElement ( object ) ) and ( getElementType ( object ) == "player" ) ) then
		if ( aclGetAccount ( object ) ) then
			return _hasObjectPermissionTo ( aclGetAccount ( object ), action )
		end
	else
		return _hasObjectPermissionTo ( object, action )
	end
	return false
end

function aclGetAccount ( player )
	return "user.".. tostring ( getPlayerAccountName ( player ) )
end

function isValidSerial ( serial )
	-- Did you know gmatch returns an iterator function?
	return string.gmatch ( serial, "%w%w%w%w-%w%w%w%w-%w%w%w%w-%w%w%w%w" )
end

function getPlayerAccountName( player )
	return exports.VGaccounts:getPlayerAccountName( player )
end

function aclGetAccountGroups ( account )
	if ( not account ) then return false end
	local res = {}
	account = "user."..account
	local all = "user.*"
	for ig, group in ipairs ( aclGroupList() ) do
		for io, object in ipairs ( aclGroupListObjects ( group ) ) do
			if ( ( account == object ) or ( all == object ) ) then
				table.insert ( res, aclGroupGetName ( group ) )
				break
			end
		end
	end
	return res
end

function aclRightExists( acl, right )
	for _,name in ipairs( aclListRights( acl ) ) do
		if name == right then
			return true
		end
	end
	return false
end

addEvent ( "aAdmin", true )
addEventHandler ( "aAdmin", root, function ( action, ... )
	if checkClient( true, source, 'aAdmin', action ) then return end
	local mdata = ""
	local mdata2 = ""
	if ( action == "password" ) then
		action = nil
		if ( not arg[1] ) then outputChatBox ( "Error - Password missing.", source, 255, 0, 0 )
		elseif ( not arg[2] ) then outputChatBox ( "Error - New password missing.", source, 255, 0, 0 )
		elseif ( not arg[3] ) then outputChatBox ( "Error - Confirm password.", source, 255, 0, 0 )
		elseif ( tostring ( arg[2] ) ~= tostring ( arg[3] ) ) then outputChatBox ( "Error - Passwords do not match.", source, 255, 0, 0 )
		else
			local account = getAccount ( getPlayerAccountName ( source ), tostring ( arg[1] ) )
			if ( account ) then
				action = "password"
				setAccountPassword ( account, arg[2] )
				mdata = arg[2]
			else
				outputChatBox ( "Error - Invalid password.", source, 255, 0, 0 )
			end
		end
	elseif ( action == "autologin" ) then

	elseif ( action == "settings" ) then
		local cmd = arg[1]
		local resName = arg[2]
		local tableOut = {}
		if ( cmd == "change" ) then
			local name = arg[3]
			local value = arg[4]
			-- Get previous value
			local settings = aGetResourceSettings( resName )
			local oldvalue = settings[name].current
			-- Match type
			local changed = false
			if type(oldvalue) == 'boolean' then value = value=='true'   end
			if type(oldvalue) == 'number'  then value = tonumber(value) end
			if type(oldvalue) == "table" then
				value = fromJSON("[["..value.."]]")
				changed = not table.compare(value, oldvalue)
			else
				changed = value ~= oldvalue
			end
			if changed then
				if aSetResourceSetting( resName, name, value ) then
					-- Tell the resource one of its settings has changed
					local res = getResourceFromName(resName)
					local resRoot = getResourceRootElement(res)
					if resRoot then
						if getVersion().mta < "1.1" then
							triggerEvent('onSettingChange', resRoot, name, oldvalue, value, source )
						end
					end
					mdata = resName..'.'..name
					mdata2 = type(value) == "table" and string.gsub(toJSON(value),"^(%[ %[ )(.*)( %] %])$", "%2") or tostring(value)
				end
			end
		elseif ( cmd == "getall" ) then
			tableOut = aGetResourceSettings( resName )
			for name,value in pairs(tableOut) do
				if type(value.default) == "table" then
					tableOut[name].default = string.gsub(toJSON(value.default),"^(%[ %[ )(.*)( %] %])$", "%2")
					tableOut[name].current = string.gsub(toJSON(value.current),"^(%[ %[ )(.*)( %] %])$", "%2")
				end
			end
		end
		triggerClientEvent ( source, "aAdminSettings", _root, cmd, resName, tableOut )
		if mdata == "" then
			action = nil
		end
	elseif ( action == "sync" ) then
		local type = arg[1]
		local tableOut = {}
		if ( type == "aclgroups" ) then
			tableOut["groups"] = {}
			for id, group in ipairs ( aclGroupList() ) do
				table.insert ( tableOut["groups"] ,aclGroupGetName ( group ) )
			end
			tableOut["acl"] = {}
			for id, acl in ipairs ( aclList() ) do
				table.insert ( tableOut["acl"] ,aclGetName ( acl ) )
			end
		elseif ( type == "aclobjects" ) then
			local group = aclGetGroup ( tostring ( arg[2] ) )
			if ( group ) then
				tableOut["name"] = arg[2]
				tableOut["objects"] = aclGroupListObjects ( group )
				tableOut["acl"] = {}
				for id, acl in ipairs ( aclGroupListACL ( group ) ) do
					table.insert ( tableOut["acl"], aclGetName ( acl ) )
				end
			end
		elseif ( type == "aclrights" ) then
			local acl = aclGet ( tostring ( arg[2] ) )
			if ( acl ) then
				tableOut["name"] = arg[2]
				tableOut["rights"] = {}
				for id, name in ipairs ( aclListRights ( acl ) ) do
					tableOut["rights"][name] = aclGetRight ( acl, name )
				end
			end
		end
		triggerClientEvent ( source, "aAdminACL", _root, type, tableOut )
	elseif ( action == "aclcreate" ) then
		local name = arg[2]
		if ( ( name ) and ( string.len ( name ) >= 1 ) ) then
			if ( arg[1] == "group" ) then
				mdata = "Group "..name
				if ( not aclCreateGroup ( name ) ) then
					action = nil
				end
			elseif ( arg[1] == "acl" ) then
				mdata = "ACL "..name
				if ( not aclCreate ( name ) ) then
					action = nil
				end
			end
			triggerEvent ( "aAdmin", source, "sync", "aclgroups" )
		else
			outputChatBox ( "Error - Invalid "..arg[1].." name", source, 255, 0, 0 )
		end
	elseif ( action == "acldestroy" ) then
		local name = arg[2]
		if ( arg[1] == "group" ) then
			if ( aclGetGroup ( name ) ) then
				mdata = "Group "..name
				aclDestroyGroup ( aclGetGroup ( name ) )
			else
				action = nil
			end
		elseif ( arg[1] == "acl" ) then
			if ( aclGet ( name ) ) then
				mdata = "ACL "..name
				aclDestroy ( aclGet ( name ) )
			else
				action = nil
			end
		end
		triggerEvent ( "aAdmin", source, "sync", "aclgroups" )
	elseif ( action == "acladd" ) then
		if ( arg[3] ) then
			action = action
			mdata = "Group '"..arg[2].."'"
			if ( arg[1] == "object" ) then
				local group = aclGetGroup ( arg[2] )
				local object = arg[3]
				if ( not aclGroupAddObject ( group, object ) ) then
					action = nil
					outputChatBox ( "Error adding object '"..tostring ( object ).."' to group '"..tostring ( arg[2] ).."'", source, 255, 0, 0 )
				else
					mdata2 = "Object '"..arg[3].."'"
					triggerEvent ( "aAdmin", source, "sync", "aclobjects", arg[2] )
				end
			elseif ( arg[1] == "acl" ) then
				local group = aclGetGroup ( arg[2] )
				local acl = aclGet ( arg[3] )
				if ( not aclGroupAddACL ( group, acl ) ) then
					action = nil
					outputChatBox ( "Error adding ACL '"..tostring ( arg[3] ).."' to group '"..tostring ( arg[2] ).."'", source, 255, 0, 0 )
				else
					mdata2 = "ACL '"..arg[3].."'"
					triggerEvent ( "aAdmin", source, "sync", "aclobjects", arg[2] )
				end
			elseif ( arg[1] == "right" ) then
				local acl = aclGet ( arg[2] )
				local right = arg[3]
				local enabled = true
				if ( not aclSetRight ( acl, right, enabled ) ) then
					action = nil
					outputChatBox ( "Error adding right '"..tostring ( arg[3] ).."' to group '"..tostring ( arg[2] ).."'", source, 255, 0, 0 )
				else
					mdata2 = "Right '"..arg[3].."'"
					triggerEvent ( "aAdmin", source, "sync", "aclrights", arg[2] )
				end
			end
		else
			action = nil
		end
	elseif ( action == "aclremove" ) then
		--action = nil
		if ( arg[3] ) then
			action = action
			mdata = "Group '"..arg[2].."'"
			if ( arg[1] == "object" ) then
				local group = aclGetGroup ( arg[2] )
				local object = arg[3]
				if ( not aclGroupRemoveObject ( group, object ) ) then
					action = nil
					outputChatBox ( "Error - object '"..tostring ( object ).."' does not exist in group '"..tostring ( arg[2] ).."'", source, 255, 0, 0 )
				else
					mdata2 = "Object '"..arg[3].."'"
					triggerEvent ( "aAdmin", source, "sync", "aclobjects", arg[2] )
				end
			elseif ( arg[1] == "acl" ) then
				local group = aclGetGroup ( arg[2] )
				local acl = aclGet ( arg[3] )
				if ( not aclGroupRemoveACL ( group, acl ) ) then
					action = nil
					outputChatBox ( "Error - ACL '"..tostring ( arg[3] ).."' does not exist in group '"..tostring ( arg[2] ).."'", source, 255, 0, 0 )
				else
					mdata2 = "ACL '"..arg[3].."'"
					triggerEvent ( "aAdmin", source, "sync", "aclobjects", arg[2] )
				end
			elseif ( arg[1] == "right" ) then
				local acl = aclGet ( arg[2] )
				local right = arg[3]
				if ( not aclRemoveRight ( acl, right ) ) then
					action = nil
					outputChatBox ( "Error - right '"..tostring ( arg[3] ).."' does not exist in ACL '"..tostring ( arg[2] ).."'", source, 255, 0, 0 )
				else
					mdata = "ACL '"..arg[2].."'"
					mdata2 = "Right '"..arg[3].."'"
					triggerEvent ( "aAdmin", source, "sync", "aclrights", arg[2] )
				end
			end
		else
			action = nil
		end
	end
	if ( action ~= nil ) then aAction ( "admin", action, source, false, mdata, mdata2 ) end
end )

function aAction ( )
	-- notinnn haha
end

-- returns true if there is trouble
function checkClient(checkAccess,player,...)
	if client and client ~= player and g_Prefs.securitylevel >= 2 then
		local desc = table.concat({...}," ")
		local ipAddress = getPlayerIP(client)
		outputDebugString( "Admin security - Client/player mismatch from " .. tostring(ipAddress) .. " (" .. tostring(desc) .. ")", 1 )
		cancelEvent()
		if g_Prefs.clientcheckban then
			local reason = "admin checkClient (" .. tostring(desc) .. ")"
			addBan ( ipAddress, nil, nil, getRootElement(), reason )
		end
		return true
	end
	if checkAccess and g_Prefs.securitylevel >= 1 then
		if type(checkAccess) == 'string' then
			if hasObjectPermissionTo ( player, checkAccess ) then
				return false	-- Access ok
			end
			if hasObjectPermissionTo ( player, "general.adminpanel" ) then
				outputDebugString( "Admin security - Client does not have required rights ("..checkAccess.."). " .. tostring(ipAddress) .. " (" .. tostring(desc) .. ")" )
				return true		-- Low risk fail - Can't do specific command, but has access to admin panel
			end
		end
		if not hasObjectPermissionTo ( player, "general.adminpanel" ) then
			local desc = table.concat({...}," ")
			local ipAddress = getPlayerIP(client or player)
			outputDebugString( "Admin security - Client without admin panel rights trigged an admin panel event. " .. tostring(ipAddress) .. " (" .. tostring(desc) .. ")", 2 )
			return true			-- High risk fail - No access to admin panel
		end
	end
	return false
end

---------------------------------------------------------------------------
--
-- gets
--
---------------------------------------------------------------------------

-- get string or default
function getString(var,default)
	local result = get(var)
	if not result then
		return default
	end
	return tostring(result)
end

-- get number or default
function getNumber(var,default)
	local result = get(var)
	if not result then
		return default
	end
	return tonumber(result)
end

-- get true or false or default
function getBool(var,default)
	local result = get(var)
	if not result then
		return default
	end
	return result == 'true'
end


--------------------------------------------------------------------------------
-- Coroutines
--------------------------------------------------------------------------------
-- Make sure errors inside coroutines get printed somewhere
_coroutine_resume = coroutine.resume
function coroutine.resume(...)
	local state,result = _coroutine_resume(...)
	if not state then
		-- Then not
	end
	return state,result
end

g_Prefs = {}
g_Prefs.maxmsgs			= getNumber('maxmsgs',99)
g_Prefs.bandurations	= getString('bandurations','60,3600,43200,0')
g_Prefs.mutedurations	= getString('mutedurations','60,120,300,600,0')
g_Prefs.clientcheckban	= getBool('clientcheckban',false)
g_Prefs.securitylevel	= getNumber('securitylevel',2)
