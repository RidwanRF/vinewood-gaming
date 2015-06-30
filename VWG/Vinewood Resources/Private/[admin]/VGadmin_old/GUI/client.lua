--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

local table = table



local tostring = tostring
local tonumber = tonumber





-- Player table
local playerTable = {}
local bansTable = {}

-- Table with all the GUI elements
DENAdminGUI = {
    tab = {},
    button = {},
    edit = {},
    window = {},
	radiobutton = {},
    gridlist = {},
	checkbox = {},
    combobox = {},
    label = {},
    tabpanel = {},
}

-- Ban window
DENAdminGUIB = {
    tab = {},
    button = {},
    edit = {},
	radiobutton = {},
    window = {},
	checkbox = {},
    gridlist = {},
    combobox = {},
    label = {},
    tabpanel = {},
}

-- Make the GUI movable and center it
function centerWindow ( window )
	guiWindowSetMovable ( window, true )
	guiWindowSetSizable ( window, false )
	guiSetVisible ( window, false )

	local screenW,screenH=guiGetScreenSize()
	local windowW,windowH=guiGetSize(window,false)
	local x,y = (screenW-windowW)/2,(screenH-windowH)/2
	guiSetPosition(window,x,y,false)
end

-- The window
DENAdminGUI.window[1] = guiCreateWindow(468, 209, 683, 541, "Vinewood Gaming - Admin Panel", false)
guiWindowSetSizable(DENAdminGUI.window[1], false) centerWindow ( DENAdminGUI.window[1] )

-- The tabpanel
DENAdminGUI.tabpanel[1] = guiCreateTabPanel(9, 19, 665, 513, false, DENAdminGUI.window[1])

-- Tab one
DENAdminGUI.tab[1] = guiCreateTab("Player Information", DENAdminGUI.tabpanel[1])
DENAdminGUI.edit[1] = guiCreateEdit(3, 5, 175, 21, "", false, DENAdminGUI.tab[1])
DENAdminGUI.gridlist[1] = guiCreateGridList(3, 30, 175, 456, false, DENAdminGUI.tab[1])
guiGridListAddColumn(DENAdminGUI.gridlist[1], "Players:", 0.85)
DENAdminGUI.label[1] = guiCreateLabel(191, 9, 276, 15, "General Information:", false, DENAdminGUI.tab[1])
guiSetFont(DENAdminGUI.label[1], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[1], 245, 157, 19)
DENAdminGUI.label[2] = guiCreateLabel(191, 31, 276, 93, "Nickname:\nAccountname:\nIP:\nSerial:\nMTA Version:\nCountry:", false, DENAdminGUI.tab[1])
DENAdminGUI.label[3] = guiCreateLabel(191, 129, 275, 15, "Player Status Information:", false, DENAdminGUI.tab[1])
guiSetFont(DENAdminGUI.label[3], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[3], 245, 157, 19)
DENAdminGUI.label[4] = guiCreateLabel(191, 151, 275, 135, "Health:\nArmor:\nSkin:\nOccupation:\nTeam\nGroup:\nGroup Rank:\nCash:\nBank Money:", false, DENAdminGUI.tab[1])
DENAdminGUI.label[5] = guiCreateLabel(191, 295, 274, 15, "Player Vehicle Information:", false, DENAdminGUI.tab[1])
guiSetFont(DENAdminGUI.label[5], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[5], 245, 157, 19)
DENAdminGUI.label[6] = guiCreateLabel(191, 317, 273, 33, "Vehicle:\nVehicle Health:\n", false, DENAdminGUI.tab[1])
DENAdminGUI.button[1] = guiCreateButton(570, 6, 91, 20, "Mute", false, DENAdminGUI.tab[1])
DENAdminGUI.button[2] = guiCreateButton(476, 6, 91, 20, "Jail", false, DENAdminGUI.tab[1])
DENAdminGUI.button[3] = guiCreateButton(476, 30, 91, 20, "Ban", false, DENAdminGUI.tab[1])
DENAdminGUI.button[4] = guiCreateButton(570, 30, 91, 20, "Slap", false, DENAdminGUI.tab[1])
DENAdminGUI.button[5] = guiCreateButton(476, 54, 91, 20, "Kick", false, DENAdminGUI.tab[1])
DENAdminGUI.button[6] = guiCreateButton(570, 54, 91, 20, "Freeze", false, DENAdminGUI.tab[1])
DENAdminGUI.edit[2] = guiCreateEdit(477, 94, 186, 20, "", false, DENAdminGUI.tab[1])
DENAdminGUI.button[7] = guiCreateButton(476, 118, 91, 20, "Set Nick", false, DENAdminGUI.tab[1])
DENAdminGUI.button[8] = guiCreateButton(570, 118, 91, 20, "Set Skin", false, DENAdminGUI.tab[1])
DENAdminGUI.button[9] = guiCreateButton(476, 142, 91, 20, "Set Health", false, DENAdminGUI.tab[1])
DENAdminGUI.button[10] = guiCreateButton(570, 143, 91, 20, "Set Armor", false, DENAdminGUI.tab[1])
DENAdminGUI.button[11] = guiCreateButton(476, 167, 91, 20, "Give Money", false, DENAdminGUI.tab[1])
DENAdminGUI.button[12] = guiCreateButton(570, 167, 91, 20, "Take Money", false, DENAdminGUI.tab[1])
DENAdminGUI.button[13] = guiCreateButton(476, 192, 91, 20, "Set Dim.", false, DENAdminGUI.tab[1])
DENAdminGUI.button[14] = guiCreateButton(570, 192, 91, 20, "Set Int.", false, DENAdminGUI.tab[1])
DENAdminGUI.button[15] = guiCreateButton(476, 234, 92, 20, "Warp to...", false, DENAdminGUI.tab[1])
DENAdminGUI.button[16] = guiCreateButton(476, 258, 184, 20, "Warp Player To...", false, DENAdminGUI.tab[1])
DENAdminGUI.combobox[1] = guiCreateComboBox(478, 297, 136, 180, "", false, DENAdminGUI.tab[1])
DENAdminGUI.button[17] = guiCreateButton(617, 298, 44, 22, "Give", false, DENAdminGUI.tab[1])
DENAdminGUI.combobox[2] = guiCreateComboBox(478, 324, 136, 160, "", false, DENAdminGUI.tab[1])
DENAdminGUI.button[18] = guiCreateButton(617, 325, 44, 22, "Give", false, DENAdminGUI.tab[1])
DENAdminGUI.button[19] = guiCreateButton(476, 365, 184, 20, "Get Player Punishments", false, DENAdminGUI.tab[1])
DENAdminGUI.button[20] = guiCreateButton(476, 389, 91, 20, "Logins", false, DENAdminGUI.tab[1])
DENAdminGUI.button[22] = guiCreateButton(476, 426, 91, 20, "Fix Vehicle", false, DENAdminGUI.tab[1])
DENAdminGUI.button[23] = guiCreateButton(569, 426, 91, 20, "Dest. Vehicle", false, DENAdminGUI.tab[1])
DENAdminGUI.label[9] = guiCreateLabel(191, 356, 274, 15, "Position Information:", false, DENAdminGUI.tab[1])
DENAdminGUI.button[24] = guiCreateButton(476, 464, 91, 20, "ACL M.", false, DENAdminGUI.tab[1])
DENAdminGUI.button[25] = guiCreateButton(569, 464, 91, 20, "Resource M.", false, DENAdminGUI.tab[1])
DENAdminGUI.button[26] = guiCreateButton(570, 234, 92, 20, "Spectate", false, DENAdminGUI.tab[1])
DENAdminGUI.button[27] = guiCreateButton(569, 388, 91, 20, "Screens", false, DENAdminGUI.tab[1])
guiSetFont(DENAdminGUI.label[9], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[9], 245, 157, 19)
DENAdminGUI.label[10] = guiCreateLabel(191, 376, 273, 105, "X:\nY:\nZ:\nCity:\nArea:\nDimension:\nInterior:", false, DENAdminGUI.tab[1])

-- Bans tab
DENAdminGUI.tab[2] = guiCreateTab("Bans", DENAdminGUI.tabpanel[1])
DENAdminGUI.edit[3] = guiCreateEdit(2, 4, 443, 25, "", false, DENAdminGUI.tab[2])
DENAdminGUI.gridlist[2] = guiCreateGridList(3, 32, 658, 427, false, DENAdminGUI.tab[2])
guiGridListAddColumn(DENAdminGUI.gridlist[2], "Nickname:", 0.2)
guiGridListAddColumn(DENAdminGUI.gridlist[2], "Accountname:", 0.25)
guiGridListAddColumn(DENAdminGUI.gridlist[2], "Untill: (Y:M:D H:M:S)", 0.25)
guiGridListAddColumn(DENAdminGUI.gridlist[2], "Serial:", 0.4)
guiGridListAddColumn(DENAdminGUI.gridlist[2], "IP:", 0.24)
guiGridListAddColumn(DENAdminGUI.gridlist[2], "Reason:", 0.5)
guiGridListAddColumn(DENAdminGUI.gridlist[2], "Admin:", 0.2)
DENAdminGUI.label[123] = guiCreateLabel(449, 9, 204, 15, "Search on accountname, IP or serial", false, DENAdminGUI.tab[2])
guiSetFont(DENAdminGUI.label[123], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[123], 245, 157, 19)
DENAdminGUI.label[124] = guiCreateLabel(10, 465, 147, 17, "Action with selected ban:", false, DENAdminGUI.tab[2])
guiSetFont(DENAdminGUI.label[124], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[124], 245, 157, 19)
DENAdminGUI.button[260] = guiCreateButton(157, 463, 167, 21, "Remove Ban", false, DENAdminGUI.tab[2])
-- DENAdminGUI.button[270] = guiCreateButton(496, 463, 167, 21, "Edit Ban", false, DENAdminGUI.tab[2])
DENAdminGUI.button[280] = guiCreateButton(327, 463, 167, 21, "Add Ban", false, DENAdminGUI.tab[2])

-- Warp window
DENAdminGUI.window[2] = guiCreateWindow(105, 392, 243, 301, "Warp Player To...", false)
guiWindowSetSizable(DENAdminGUI.window[2], false) centerWindow ( DENAdminGUI.window[2] )
DENAdminGUI.edit[101] = guiCreateEdit(9, 40, 225, 24, "", false, DENAdminGUI.window[2])
DENAdminGUI.gridlist[101] = guiCreateGridList(9, 68, 223, 197, false, DENAdminGUI.window[2])
guiGridListAddColumn(DENAdminGUI.gridlist[101], "Players:", 0.85)
DENAdminGUI.button[101] = guiCreateButton(9, 267, 110, 22, "Warp to...", false, DENAdminGUI.window[2])
DENAdminGUI.button[102] = guiCreateButton(121, 267, 111, 22, "Cancel", false, DENAdminGUI.window[2])
DENAdminGUI.label[12] = guiCreateLabel(3, 22, 236, 19, "Playername:", false, DENAdminGUI.window[2])
guiSetFont(DENAdminGUI.label[12], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[12], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUI.label[12], "center", false)

-- Kick window
DENAdminGUI.window[3] = guiCreateWindow(572, 207, 292, 97, "Kick Player", false)
guiWindowSetSizable(DENAdminGUI.window[3], false) centerWindow ( DENAdminGUI.window[3] )
DENAdminGUI.label[11] = guiCreateLabel(5, 22, 276, 16, "Kick Reason:", false, DENAdminGUI.window[3])
guiSetFont(DENAdminGUI.label[11], "default-bold-small")
guiLabelSetColor(DENAdminGUI.label[11], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUI.label[11], "center", false)
DENAdminGUI.edit[102] = guiCreateEdit(9, 39, 274, 24, "", false, DENAdminGUI.window[3])
DENAdminGUI.button[103] = guiCreateButton(9, 66, 137, 22, "Kick Player", false, DENAdminGUI.window[3])
DENAdminGUI.button[104] = guiCreateButton(147, 66, 136, 22, "Cancel", false, DENAdminGUI.window[3])

-- Ban window
DENAdminGUIB.window[4] = guiCreateWindow(80, 290, 296, 353, "Add ban", false)
guiWindowSetSizable(DENAdminGUIB.window[4], false) centerWindow ( DENAdminGUIB.window[4] )
DENAdminGUIB.label[1] = guiCreateLabel(14, 23, 262, 20, "Accountname:", false, DENAdminGUIB.window[4])
guiSetFont(DENAdminGUIB.label[1], "default-bold-small")
guiLabelSetColor(DENAdminGUIB.label[1], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUIB.label[1], "center", false)
DENAdminGUIB.edit[1] = guiCreateEdit(9, 40, 277, 25, "", false, DENAdminGUIB.window[4])
DENAdminGUIB.label[2] = guiCreateLabel(14, 80, 262, 20, "Serial:", false, DENAdminGUIB.window[4])
guiSetFont(DENAdminGUIB.label[2], "default-bold-small")
guiLabelSetColor(DENAdminGUIB.label[2], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUIB.label[2], "center", false)
DENAdminGUIB.edit[2] = guiCreateEdit(9, 97, 277, 25, "", false, DENAdminGUIB.window[4])
DENAdminGUIB.label[3] = guiCreateLabel(14, 130, 262, 20, "IP:", false, DENAdminGUIB.window[4])
guiSetFont(DENAdminGUIB.label[3], "default-bold-small")
guiLabelSetColor(DENAdminGUIB.label[3], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUIB.label[3], "center", false)
DENAdminGUIB.edit[3] = guiCreateEdit(9, 147, 277, 25, "", false, DENAdminGUIB.window[4])
DENAdminGUIB.label[4] = guiCreateLabel(14, 186, 262, 20, "Select a reason or enter a custom reason:", false, DENAdminGUIB.window[4])
guiSetFont(DENAdminGUIB.label[4], "default-bold-small")
guiLabelSetColor(DENAdminGUIB.label[4], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUIB.label[4], "center", false)
DENAdminGUIB.combobox[1] = guiCreateComboBox(10, 204, 276, 140, "", false, DENAdminGUIB.window[4])
DENAdminGUIB.edit[4] = guiCreateEdit(33, 228, 254, 25, "", false, DENAdminGUIB.window[4])
DENAdminGUIB.checkbox[1] = guiCreateCheckBox(12, 234, 21, 16, "", true, false, DENAdminGUIB.window[4])
DENAdminGUIB.label[5] = guiCreateLabel(14, 267, 262, 20, "Select a time:", false, DENAdminGUIB.window[4])
guiSetFont(DENAdminGUIB.label[5], "default-bold-small")
guiLabelSetColor(DENAdminGUIB.label[5], 245, 157, 19)
guiLabelSetHorizontalAlign(DENAdminGUIB.label[5], "center", false)
DENAdminGUIB.edit[5] = guiCreateEdit(9, 284, 95, 25, "", false, DENAdminGUIB.window[4])
DENAdminGUIB.radiobutton[1] = guiCreateRadioButton(109, 289, 41, 15, "Hrs.", false, DENAdminGUIB.window[4])
guiRadioButtonSetSelected(DENAdminGUIB.radiobutton[1], true)
DENAdminGUIB.radiobutton[2] = guiCreateRadioButton(169, 289, 54, 15, "Days.", false, DENAdminGUIB.window[4])
DENAdminGUIB.radiobutton[3] = guiCreateRadioButton(237, 289, 50, 15, "Perm.", false, DENAdminGUIB.window[4])
DENAdminGUIB.button[1] = guiCreateButton(10, 314, 133, 25, "Add Ban", false, DENAdminGUIB.window[4])
DENAdminGUIB.button[2] = guiCreateButton(146, 314, 141, 25, "Cancel", false, DENAdminGUIB.window[4])   

-- Function when the user presses the add ban button
addEventHandler( "onClientGUIClick", DENAdminGUIB.button[1],
	function ()
		if ( getSelectedPunishmentReason( DENAdminGUIB.combobox[1], DENAdminGUIB.checkbox[1], DENAdminGUIB.edit[5] ) ) and ( getCustomBanPunishmentTime ( ) ) then
			local theReason = getSelectedPunishmentReason( DENAdminGUIB.combobox[1], DENAdminGUIB.checkbox[1], DENAdminGUIB.edit[5] )
			triggerServerEvent ( "onServerCustomBan", localPlayer, getCustomBanPunishmentTime (), theReason, guiGetText( DENAdminGUIB.edit[1] ), guiGetText( DENAdminGUIB.edit[3] ), guiGetText( DENAdminGUIB.edit[2] ) )
			guiSetVisible( DENAdminGUIB.window[4], false )
		end
	end, false
)

-- Event that parses the newest ban table
addEvent( "onClientSendAdminTable", true )
addEventHandler( "onClientSendAdminTable", root,
	function ( table )
		if ( table ) then
			bansTable = table
		end
		
		-- Add the admin tables into the grid
		fillBanGridlist ( bansTable )
	end
)

-- When resource starts
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		if ( getElementData( localPlayer, "isPlayerAdmin" ) ) then
			triggerServerEvent( "onServerRequestAminTable", localPlayer )
			local bTable = exports.VGcache:getTemporaryData( "clientAdminBans" )
			if ( bTable ) then 
				bansTable = bTable 
				-- Add the admin tables into the grid
				fillBanGridlist ( bTable )
			end
		end
	end
)

-- Function to fill the bans gridlist
function fillBanGridlist ( bTable )
	guiGridListClear( DENAdminGUI.gridlist[2] )
	for k, tbl in ipairs( bTable ) do
		local row = guiGridListAddRow( DENAdminGUI.gridlist[2] )
		if ( tbl.nickname == "" ) then aNick = "N/A" else aNick = tbl.nickname end
		if ( tbl.accountname == "" ) then aAccount = "N/A" else aAccount = tbl.accountname end
		if ( tbl.serial == "" ) then aSerial = "N/A" else aSerial = tbl.serial end
		if ( tbl.ip == "" ) then aIP = "N/A" else aIP = tbl.ip end
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 1, aNick, false, false )
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 2, aAccount, false, false )
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 3, exports.VGutils:timestampToDate ( tbl.banstamp ), false, false )
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 4, aSerial, false, false )
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 5, aIP, false, false )
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 6, tbl.reason, false, false )
		guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 7, tbl.admin, false, false )
		guiGridListSetItemData ( DENAdminGUI.gridlist[2], row, 3, tbl.banid )
	end
end

-- Function to get the selected banID
function getSelectedBanID ()
	local row = guiGridListGetSelectedItem ( DENAdminGUI.gridlist[2] )
	local banID = guiGridListGetItemData ( DENAdminGUI.gridlist[2], row, 3 )
	if ( banID ) and ( tostring( row ) ~= "-1" ) then
		return banID
	else
		return false
	end
end

-- Function for when the resource stops
addEventHandler( "onClientResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "clientAdminBans", bansTable )
	end
)

-- Set the vehicle names in the dropdown box
local vehicleNames = {}
for i = 400, 611 do
	if ( getVehicleNameFromModel ( i ) ~= "" ) then
		table.insert( vehicleNames, { model = i, name = getVehicleNameFromModel ( i ) } )
	end
end
							
table.sort( vehicleNames, function(a, b) return a.name < b.name end )

for i, data in ipairs(vehicleNames) do
	guiComboBoxAddItem( DENAdminGUI.combobox[1], data.name )
	guiComboBoxSetSelected ( DENAdminGUI.combobox[1], 1 )
end

-- Set the weapon names inthe dropdown box
for i = 1, 46 do 
	if ( getWeaponNameFromID ( i ) ~= false ) and ( i ~= 19 ) and ( i ~= 20 ) then 
		guiComboBoxAddItem( DENAdminGUI.combobox[2], getWeaponNameFromID ( i ) )
		guiComboBoxSetSelected ( DENAdminGUI.combobox[2], 1 )
	end
end

-- Function that returns the complete window table
function getAdminPanelGUI ()
	return DENAdminGUI
end

-- Buttons to close windows
addEventHandler( "onClientGUIClick", root,
	function ()
		if ( source == DENAdminGUI.button[102] ) then
			guiSetVisible( DENAdminGUI.window[2], false )
		elseif ( source == muteGUI.button[2] ) then
			guiSetVisible( muteGUI.window[1], false )
		elseif ( source == jailGUI.button[2] ) then
			guiSetVisible( jailGUI.window[1], false )
		elseif ( source == banGUI.button[2] ) then
			guiSetVisible( banGUI.window[1], false )
		elseif ( source == DENAdminGUI.button[104] ) then
			guiSetVisible( DENAdminGUI.window[3], false )
		end
	end
)

-- When a player joins build the player's table
addEvent( "onClientPlayerConnected", true )
addEventHandler( "onClientPlayerConnected", root,
	function ( aPlayer, aSerial, aIP, aTable )
		if ( aTable ) then
			playerTable = aTable
		else
			table.insert( playerTable, { aPlayer, aSerial, aIP } )
		end
	end
)

-- Function to open the GUI
bindKey ( "P", "Down",
	function ()
		if ( guiGetVisible( DENAdminGUI.window[1] ) ) then
			showCursor( false )
			guiSetVisible ( DENAdminGUI.window[1], false )
		else
			if ( onCheckPlayerAdminRights () ) and ( isPlayerAdmin ( localPlayer ) ) then
				showCursor( true )
				guiSetVisible ( DENAdminGUI.window[1], true )
				guiSetInputMode( "no_binds_when_editing" )
			end
		end
	end
)

-- Command
addCommandHandler( "admin",
	function ()
		if ( guiGetVisible( DENAdminGUI.window[1] ) ) then
			showCursor( false )
			guiSetVisible ( DENAdminGUI.window[1], false )
		else
			if ( onCheckPlayerAdminRights () ) and ( isPlayerAdmin ( localPlayer ) ) then
				showCursor( true )
				guiSetVisible ( DENAdminGUI.window[1], true )
				guiSetInputMode( "no_binds_when_editing" )
			end
		end
	end
)

-- When resource starts
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		triggerServerEvent( "onServerRequestAminTable", localPlayer )
	end
)

-- Get the select player
function getAdminPanelSelectedPlayer ()
	local playerName = guiGridListGetItemText ( DENAdminGUI.gridlist[1], guiGridListGetSelectedItem ( DENAdminGUI.gridlist[1] ), 1 )
	local row, column = guiGridListGetSelectedItem ( DENAdminGUI.gridlist[1] )
	if ( playerName ) and ( tostring( row ) ~= "-1" ) then
		if ( getPlayerFromName( playerName ) ) then
			return getPlayerFromName( playerName )
		end
	end
end

-- Get the select player from the warp list
function getWarpListSelectedPlayer ()
	local playerName = guiGridListGetItemText ( DENAdminGUI.gridlist[101], guiGridListGetSelectedItem ( DENAdminGUI.gridlist[101] ), 1 )
	local row, column = guiGridListGetSelectedItem ( DENAdminGUI.gridlist[101] )
	if ( playerName ) and ( tostring( row ) ~= "-1" ) then
		if ( getPlayerFromName( playerName ) ) then
			return getPlayerFromName( playerName )
		end
	end
end

-- This puts all the players in a gridlist
for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
	local row = guiGridListAddRow ( DENAdminGUI.gridlist[1] )
	if ( getPlayerTeam( thePlayer ) ) then
		guiGridListSetItemText ( DENAdminGUI.gridlist[1], row, 1, getPlayerName( thePlayer ), false, false )
		guiGridListSetItemColor( DENAdminGUI.gridlist[1], row, 1, getTeamColor ( getPlayerTeam( thePlayer ) ) )
	else
		guiGridListSetItemText ( DENAdminGUI.gridlist[1], row, 1, getPlayerName( thePlayer ), false, false )
	end
	
	local row = guiGridListAddRow ( DENAdminGUI.gridlist[101] )
	guiGridListSetItemText ( DENAdminGUI.gridlist[101], row, 1, getPlayerName( thePlayer ), false, false )
end

-- Function that takes care of putting all the players in the gridlist for the warp window
function insertPlayersIntoWarpWindow ()
	guiGridListClear( DENAdminGUI.gridlist[101] )
	for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
		local row = guiGridListAddRow ( DENAdminGUI.gridlist[101] )
		guiGridListSetItemText ( DENAdminGUI.gridlist[101], row, 1, getPlayerName( thePlayer ), false, false )
	end
end

-- Add a player when they join
addEventHandler( "onClientPlayerJoin", root, 
	function ()
		local row = guiGridListAddRow ( DENAdminGUI.gridlist[1] )
		if ( getPlayerTeam( source ) ) then
			guiGridListSetItemText ( DENAdminGUI.gridlist[1], row, 1, getPlayerName( source ), false, false )
			guiGridListSetItemColor( DENAdminGUI.gridlist[1], row, 1, getTeamColor ( getPlayerTeam( source ) ) )
		else
			guiGridListSetItemText ( DENAdminGUI.gridlist[1], row, 1, getPlayerName( source ), false, false )
		end
	end
)

-- Remove a player when they quit
addEventHandler( "onClientPlayerQuit", root, 
	function ()
		for i=0,guiGridListGetRowCount ( DENAdminGUI.gridlist[1] ) do
			if ( guiGridListGetItemText ( DENAdminGUI.gridlist[1], i, 1 ) == getPlayerName( source ) ) then
				guiGridListRemoveRow ( DENAdminGUI.gridlist[1], i )
			end
		end
		
		-- Remove the player from the table if he quited
		if ( playerTable ) then
			for k, aTable in ipairs ( playerTable ) do
				if ( aTable[ 1 ] == source ) then
					table.remove( playerTable, k )
				end
			end
		end
	end
)

-- When a player changes his nick
addEventHandler( "onClientPlayerChangeNick", root, 
	function ( oldNick, newNick )
		for i=0,guiGridListGetRowCount ( DENAdminGUI.gridlist[1] ) do
			if ( guiGridListGetItemText ( DENAdminGUI.gridlist[1], i, 1 ) == oldNick ) then
				guiGridListSetItemText ( DENAdminGUI.gridlist[1], i, 1, newNick, false, false )
			end
		end
	end
)

-- Request player data
addEvent( "onClientReturnPlayerData", true )
addEventHandler( "onClientReturnPlayerData", root,
	function ( string1, string2 )
		guiSetText( DENAdminGUI.label[2], string1 )
		guiSetText( DENAdminGUI.label[4], string2 )
	end
)

-- When the player selects a player
addEventHandler( "onClientGUIClick", DENAdminGUI.gridlist[1],
	function ()
		if ( getAdminPanelSelectedPlayer () ) then
			triggerServerEvent( "onServerRequestPlayerData", localPlayer, getAdminPanelSelectedPlayer () )
		end
	end
)

-- Check for team colors so they are up-to-date and to keep the player field op-to-date
addEventHandler( "onClientRender", root,
	function ()
		for i=0,guiGridListGetRowCount ( DENAdminGUI.gridlist[1] ) do
			local playerName = guiGridListGetItemText ( DENAdminGUI.gridlist[1], i, 1 )
			if ( playerName ) and ( getPlayerFromName( playerName ) ) then
				if ( getPlayerTeam( getPlayerFromName( playerName ) ) ) then
					local R, G, B = getTeamColor ( getPlayerTeam( getPlayerFromName( playerName ) ) )
					guiGridListSetItemColor( DENAdminGUI.gridlist[1], i, 1, R, G, B )
				end
			end
		end
		
		if ( getAdminPanelSelectedPlayer () ) then
			local thePlayer = getAdminPanelSelectedPlayer ()
			local x, y, z = getElementPosition ( thePlayer )
			local int, dim = getElementInterior( thePlayer ), getElementDimension( thePlayer )
			local city, area = getZoneName( x, y, z, true ), getZoneName( x, y, z, false )
			if ( getPedOccupiedVehicle( thePlayer ) ) then theVehicle = getVehicleName ( getPedOccupiedVehicle( thePlayer ) ) vehicleHealth = math.floor( getElementHealth( getPedOccupiedVehicle( thePlayer ) ) ) else theVehicle = "Walking" vehicleHealth = "N/A" end
			guiSetText( DENAdminGUI.label[10], "X: "..x.."\nY: "..y.."\nZ: "..z.."\nCity: "..city.."\nArea: "..area.."\nDimension: "..dim.."\nInterior: "..int.."" )
			guiSetText( DENAdminGUI.label[6], "Vehicle: "..theVehicle.. "\nVehicle Health: "..vehicleHealth.."\n" )
		end
	end
)

-- When searching a player
addEventHandler( "onClientGUIChanged", root, 
	function ( theElement )
		if ( source == DENAdminGUI.edit[1] ) then
			guiGridListClear( DENAdminGUI.gridlist[1] )
			for k, aTable in ipairs( playerTable ) do
				if ( isElement( aTable[ 1 ] ) ) then
					if ( string.find( getPlayerName( aTable[ 1 ] ):lower(), guiGetText( DENAdminGUI.edit[1] ):lower() ) ) or ( string.lower( tostring( aTable[ 2 ] ) ) == string.lower( guiGetText( DENAdminGUI.edit[1] ) ) ) or ( string.lower( tostring( aTable[ 3 ] ) ) == string.lower( guiGetText( DENAdminGUI.edit[1] ) ) ) then
						local row = guiGridListAddRow ( DENAdminGUI.gridlist[1] )
						if ( getPlayerTeam( aTable[ 1 ] ) ) then
							guiGridListSetItemText ( DENAdminGUI.gridlist[1], row, 1, getPlayerName( aTable[ 1 ] ), false, false )
							guiGridListSetItemColor( DENAdminGUI.gridlist[1], row, 1, getTeamColor ( getPlayerTeam( aTable[ 1 ] ) ) )
						else
							guiGridListSetItemText ( DENAdminGUI.gridlist[1], row, 1, getPlayerName( aTable[ 1 ] ), false, false )
						end
					end
				end
			end
		elseif ( source == DENAdminGUI.edit[101] ) then
			guiGridListClear( DENAdminGUI.gridlist[101] )
			for k, thePlayer in pairs( getElementsByType( "player" ) ) do
				if ( string.find( getPlayerName( thePlayer ):lower(), guiGetText( DENAdminGUI.edit[101] ):lower() ) ) then
					local row = guiGridListAddRow ( DENAdminGUI.gridlist[101] )
					guiGridListSetItemText ( DENAdminGUI.gridlist[101], row, 1, getPlayerName( thePlayer ), false, false )
				end
			end
		elseif ( source == DENAdminGUI.edit[3] ) then
			guiGridListClear( DENAdminGUI.gridlist[2] )
			for k, aTable in ipairs( bansTable ) do
				if ( string.find( aTable.serial:lower(), guiGetText( DENAdminGUI.edit[3] ):lower() ) ) or ( string.lower( aTable.ip ) == string.lower( guiGetText( DENAdminGUI.edit[3] ) ) ) or ( string.lower( aTable.accountname ) == string.lower( guiGetText( DENAdminGUI.edit[3] ) ) ) then
					local row = guiGridListAddRow ( DENAdminGUI.gridlist[2] )
					if ( aTable.nickname == "" ) then aNick = "N/A" else aNick = aTable.nickname end
					if ( aTable.accountname == "" ) then aAccount = "N/A" else aAccount = aTable.accountname end
					if ( aTable.serial == "" ) then aSerial = "N/A" else aSerial = aTable.serial end
					if ( aTable.ip == "" ) then aIP = "N/A" else aIP = aTable.ip end
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 1, aNick, false, false )
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 2, aAccount, false, false )
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 3, exports.VGutils:timestampToDate ( aTable.banstamp ), false, false )
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 4, aSerial, false, false )
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 5, aIP, false, false )
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 6, aTable.reason, false, false )
					guiGridListSetItemText ( DENAdminGUI.gridlist[2], row, 7, aTable.admin, false, false )
				end
			end
		end
	end
)

-- When the player clicks the give vehicle button
addEventHandler( "onClientGUIClick", DENAdminGUI.button[17],
	function ()
		if ( getAdminPanelSelectedPlayer () ) then
			local vehiclename = guiComboBoxGetItemText ( DENAdminGUI.combobox[1], guiComboBoxGetSelected ( DENAdminGUI.combobox[1] ) )
			if ( vehiclename ) then
				triggerServerEvent( "onServerGivePlayerVehicle", localPlayer, getAdminPanelSelectedPlayer (), vehiclename )
			else
				outputChatBox( "You didn't select a player!", 225, 0, 0 )
			end
		else
			outputChatBox( "You didn't select a player!", 225, 0, 0 )
		end
	end, false
)

-- When the player clicks the give weapon button
addEventHandler( "onClientGUIClick", DENAdminGUI.button[18],
	function ()
		if ( getAdminPanelSelectedPlayer () ) then
			local weaponname = guiComboBoxGetItemText ( DENAdminGUI.combobox[2], guiComboBoxGetSelected ( DENAdminGUI.combobox[2] ) )
			if ( weaponname ) then
				triggerServerEvent( "onServerGivePlayerWeapon", localPlayer, getAdminPanelSelectedPlayer (), weaponname )
			end
		else
			outputChatBox( "You didn't select a player!", 225, 0, 0 )
		end
	end, false
)

-- Event for clicked buttons
addEventHandler( "onClientGUIClick", root,
	function ()
		if ( guiGetEnabled( source ) ) and ( getAdminPanelSelectedPlayer () ) then
			if ( source == DENAdminGUI.button[26] ) then
				onPlayerSpecate ( getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[4] ) then
				triggerServerEvent( "onServerSlapPlayer", localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[6] ) then
				triggerServerEvent( "onServerFreezePlayer", localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[103] ) then
				triggerServerEvent( "onServerKickPlayer", localPlayer, getAdminPanelSelectedPlayer (), guiGetText( DENAdminGUI.edit[102] ) )
			elseif ( source == DENAdminGUI.button[15] ) then
				triggerServerEvent( "onServerWarpPlayerToPlayer", localPlayer, localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[16] ) then
				insertPlayersIntoWarpWindow ()
				guiSetVisible( DENAdminGUI.window[2], true )
				guiBringToFront( DENAdminGUI.window[2] )
				guiSetProperty( DENAdminGUI.window[2], "AlwaysOnTop", "True" )
			elseif ( source == DENAdminGUI.button[101] ) and ( getWarpListSelectedPlayer () ) then
				triggerServerEvent( "onServerWarpPlayerToPlayer", localPlayer, getAdminPanelSelectedPlayer (), getWarpListSelectedPlayer (), true )
				guiSetVisible( DENAdminGUI.window[2], false )
			elseif ( source == DENAdminGUI.button[22] ) then
				triggerServerEvent( "onServerVehicleRepairDestroy", localPlayer, getAdminPanelSelectedPlayer (), "repair" )
			elseif ( source == DENAdminGUI.button[23] ) then
				triggerServerEvent( "onServerVehicleRepairDestroy", localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[7] ) and ( guiGetText( DENAdminGUI.edit[2] ) ~= "" ) and ( guiGetText( DENAdminGUI.edit[2] ) ~= " " ) then
				triggerServerEvent( "onServerPlayerChangeNick", localPlayer, getAdminPanelSelectedPlayer (), guiGetText( DENAdminGUI.edit[2] ) )
			elseif ( source == DENAdminGUI.button[8] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerChangeSkin", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[9] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerChangeHealth", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[10] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerChangeArmor", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[11] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerGiveMoney", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[12] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerTakeMoney", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[13] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerChangeDimension", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[14] ) and ( string.match( guiGetText( DENAdminGUI.edit[2] ), '^%d+$' ) ) then
				triggerServerEvent( "onServerPlayerChangeInterior", localPlayer, getAdminPanelSelectedPlayer (), tonumber( guiGetText( DENAdminGUI.edit[2] ) ) )
			elseif ( source == DENAdminGUI.button[20] ) then
				triggerServerEvent( "onServerRequestLatestLogins", localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[19] ) then
				triggerServerEvent( "onServerRequestLatestPunishments", localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[1] ) then
				triggerServerEvent( "onServerShowMuteWindow", localPlayer, getAdminPanelSelectedPlayer () )
			elseif ( source == DENAdminGUI.button[5] ) then
				guiSetVisible( DENAdminGUI.window[3], true )
				guiBringToFront( DENAdminGUI.window[3] )
				guiSetProperty( DENAdminGUI.window[3], "AlwaysOnTop", "True" )
			elseif ( source == DENAdminGUI.button[2] ) then
				guiSetVisible( jailGUI.window[1], true )
				guiBringToFront( jailGUI.window[1] )
				guiSetProperty( jailGUI.window[1], "AlwaysOnTop", "True" )
			elseif ( source == DENAdminGUI.button[3] ) then
				guiSetVisible( banGUI.window[1], true )
				guiBringToFront( banGUI.window[1] )
				guiSetProperty( banGUI.window[1], "AlwaysOnTop", "True" )
			elseif ( source == DENAdminGUI.button[27] ) then
				triggerServerEvent( "onServerOpenScreenShotWindow", localPlayer, getAdminPanelSelectedPlayer () )
			end
		end
		
		if ( guiGetEnabled( source ) ) then
			if ( source == DENAdminGUI.button[25] ) then
				triggerServerEvent( "onServerShowResourcesWindow", localPlayer )
			elseif ( source == DENAdminGUIB.button[2] ) then
				guiSetVisible( DENAdminGUIB.window[4], false )
			elseif ( source == DENAdminGUI.button[280] ) then
				guiSetVisible( DENAdminGUIB.window[4], true )
				guiBringToFront( DENAdminGUIB.window[4] )
				guiSetProperty( DENAdminGUIB.window[4], "AlwaysOnTop", "True" )
			elseif ( source == DENAdminGUI.button[24] ) then
				aManageACL ()
			elseif ( source == DENAdminGUI.button[260] ) then
				if ( getSelectedBanID () ) then
					triggerServerEvent( "onServerUnban", localPlayer, getSelectedBanID () )
				else
					outputChatBox( "No ban selected!", 225, 0, 0 )
				end
			end
		end
	end
)