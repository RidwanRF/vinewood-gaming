--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--



local tonumber = tonumber




-- GUI table
local DENAdminGUI = getAdminPanelGUI ()

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

-- Admin table
local adminTable = {}
local isDeveloper = false

-- ACL Table
local adminPanelACL = {
	-- Buttons
	{ DENAdminGUI.button[1], 1 },  -- Mute button
	{ DENAdminGUI.button[2], 1 },  -- Jail button
	{ DENAdminGUI.button[3], 2 },  -- Ban button
	{ DENAdminGUI.button[4], 1 },  -- Slap button
	{ DENAdminGUI.button[5], 1 },  -- Kick button
	{ DENAdminGUI.button[6], 1 },  -- Freeze button
	{ DENAdminGUI.button[7], 1 },  -- Set nick
	{ DENAdminGUI.button[8], 4 },  -- Set skin
	{ DENAdminGUI.button[9], 4 },  -- Set health
	{ DENAdminGUI.button[10], 4 }, -- Set armor
	{ DENAdminGUI.button[11], 6 }, -- Give money
	{ DENAdminGUI.button[26], 1 }, -- Spectate
	{ DENAdminGUI.button[12], 6 }, -- Take money
	{ DENAdminGUI.button[13], 1 }, -- Set dimension
	{ DENAdminGUI.button[14], 1 }, -- Set interior
	{ DENAdminGUI.button[15], 1 }, -- Warp to...
	{ DENAdminGUI.button[16], 1 }, -- Warp player to...
	{ DENAdminGUI.button[17], 1 }, -- Give Car
	{ DENAdminGUI.combobox[1], 1 },-- Give Car
	{ DENAdminGUI.button[18], 6 }, -- Give weapon
	{ DENAdminGUI.combobox[2], 6 },-- Give weapon
	{ DENAdminGUI.button[19], 1 }, -- Get punishments
	{ DENAdminGUI.button[20], 1 }, -- Get logins
	{ DENAdminGUI.button[22], 1 }, -- Fix vehicle
	{ DENAdminGUI.button[23], 2 }, -- Destroy vehicle
	{ DENAdminGUI.button[25], 5 }, -- Resource management
	{ DENAdminGUI.button[24], 6 }, -- ACL management
	{ DENAdminGUI.tab[2], 3 }, 	   -- Bans tab
	{ DENAdminGUI.button[260], 5 },-- Bans unban
}

-- Sync the table
addEvent( "onClientSyncAdminTable", true )
addEventHandler( "onClientSyncAdminTable", root,
	function ( theTable )
		adminTable = theTable
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

-- Function to get a player's staff rank
function getPlayerAdminRank ( thePlayer )
	if ( isElement( thePlayer ) ) and ( adminTable[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] ) then
		return adminTable[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ]
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

-- Function that gets the ACL table
function onCheckPlayerAdminRights ()
	if ( adminTable ) then
		for accountname, rank in pairs ( adminTable ) do
			if ( rank == 0 ) then rank = 3 isDeveloper = true end
			if ( exports.VGaccounts:getPlayerAccountName( localPlayer ) ) then
				if ( string.lower( exports.VGaccounts:getPlayerAccountName( localPlayer ) ) == string.lower( accountname ) ) then
					for i=1,#adminPanelACL do
						if ( tonumber( rank ) >= adminPanelACL[i][2] ) then
							guiSetEnabled ( adminPanelACL[i][1], true )
						else
							guiSetEnabled ( adminPanelACL[i][1], false )
						end
					end
					-- If the player is a developer
					if ( isDeveloper ) then
						guiSetEnabled ( DENAdminGUI.button[25], true )
					end
					return true
				end
			end
		end
		return false
	else
		return false
	end
end