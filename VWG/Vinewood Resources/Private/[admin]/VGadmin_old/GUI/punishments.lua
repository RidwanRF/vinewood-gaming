--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

local tonumber = tonumber




-- Mute GUI
muteGUI = {
    button = {},
    edit = {},
    window = {},
    combobox = {},
    checkbox = {},
    label = {},
    radiobutton = {},
}

-- Jail GUI
jailGUI = {
    button = {},
    edit = {},
    window = {},
    combobox = {},
    checkbox = {},
    label = {},
    radiobutton = {},
}

-- Ban GUI
banGUI = {
    button = {},
    edit = {},
    window = {},
    combobox = {},
    checkbox = {},
    label = {},
    radiobutton = {},
}

-- List of possible punishments
punishmentReaons = {
	"Removing punishment",
	"Testing punishments",
	"Deathmatching",
	"abusing bug(s)",
	"Insulting/flaming",
	"Annoying server staff(s)",
	"Advertising for other servers",
	"Cheating/hacking",
	"Blackmailing players",
	"Support channel misuse",
	"Avoiding ingame situations",
	"Non-English in main/team chat",
	"Camping",
	"Not listening to staff",
	"Using main/team chat for advertising",
	"Spamming/flooding",
	"Selling ingame contents",
	"Using an unacceptable name",
	"Trolling/griefing",
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

-- Mute GUI elements
muteGUI.window[1] = guiCreateWindow(215, 367, 302, 202, "Mute a Player", false)
guiWindowSetSizable(muteGUI.window[1], false) centerWindow (muteGUI.window[1])
muteGUI.label[1] = guiCreateLabel(4, 21, 292, 22, "Select a reason or enter a custom reason:", false, muteGUI.window[1])
guiSetFont(muteGUI.label[1], "default-bold-small")
guiLabelSetColor(muteGUI.label[1], 245, 157, 9)
guiLabelSetHorizontalAlign(muteGUI.label[1], "center", false)
muteGUI.combobox[1] = guiCreateComboBox(9, 38, 284, 155, "Select a reason", false, muteGUI.window[1])
muteGUI.checkbox[1] = guiCreateCheckBox(1, 24, 16, 23, "", false, false, muteGUI.combobox[1])
muteGUI.edit[1] = guiCreateEdit(19, 24, 265, 23, "", false, muteGUI.combobox[1])
muteGUI.checkbox[2] = guiCreateCheckBox(0, 68, 84, 21, "Global Mute", false, false, muteGUI.combobox[1])
muteGUI.checkbox[3] = guiCreateCheckBox(87, 68, 101, 21, "Mainchat Mute", false, false, muteGUI.combobox[1])
muteGUI.checkbox[4] = guiCreateCheckBox(188, 68, 101, 21, "Support Mute", false, false, muteGUI.combobox[1])
muteGUI.radiobutton[1] = guiCreateRadioButton(100, 110, 59, 15, "Sec.", false, muteGUI.combobox[1])
muteGUI.radiobutton[2] = guiCreateRadioButton(161, 110, 59, 15, "Min.", false, muteGUI.combobox[1])
muteGUI.radiobutton[3] = guiCreateRadioButton(222, 110, 59, 15, "Hrs.", false, muteGUI.combobox[1])
muteGUI.edit[2] = guiCreateEdit(0, 106, 98, 24, "", false, muteGUI.combobox[1])
muteGUI.label[22] = guiCreateLabel(4, 87, 292, 22, "Select a mute type:", false, muteGUI.window[1])
guiSetFont(muteGUI.label[22], "default-bold-small")
guiLabelSetColor(muteGUI.label[22], 245, 157, 9)
guiLabelSetHorizontalAlign(muteGUI.label[22], "center", false)
muteGUI.label[33] = guiCreateLabel(4, 128, 292, 22, "Select a mute time:", false, muteGUI.window[1])
guiSetFont(muteGUI.label[33], "default-bold-small")
guiLabelSetColor(muteGUI.label[33], 245, 157, 9)
guiLabelSetHorizontalAlign(muteGUI.label[33], "center", false)
muteGUI.button[1] = guiCreateButton(9, 172, 138, 22, "Mute Player", false, muteGUI.window[1])
muteGUI.button[2] = guiCreateButton(150, 172, 141, 22, "Cancel", false, muteGUI.window[1])

-- Jail GUI elements
jailGUI.window[1] = guiCreateWindow(605, 315, 292, 187, "Jail a Player", false)
guiWindowSetSizable(jailGUI.window[1], false) centerWindow ( jailGUI.window[1] )
jailGUI.edit[1] = guiCreateEdit(26, 49, 254, 23, "Custom Reason", false, jailGUI.window[1])
jailGUI.checkbox[1] = guiCreateCheckBox(9, 53, 15, 16, "", false, false, jailGUI.window[1])
jailGUI.combobox[1] = guiCreateComboBox(9, 76, 271, 120, "Select a reason", false, jailGUI.window[1])
jailGUI.label[1] = guiCreateLabel(6, 23, 277, 22, "Select a reason or enter a custom reason", false, jailGUI.window[1])
guiSetFont(jailGUI.label[1], "default-bold-small")
guiLabelSetColor(jailGUI.label[1], 245, 157, 19)
guiLabelSetHorizontalAlign(jailGUI.label[1], "center", false)
jailGUI.label[2] = guiCreateLabel(6, 106, 277, 22, "Select a punishment time", false, jailGUI.window[1])
guiSetFont(jailGUI.label[2], "default-bold-small")
guiLabelSetColor(jailGUI.label[2], 245, 157, 19)
guiLabelSetHorizontalAlign(jailGUI.label[2], "center", false)
jailGUI.edit[2] = guiCreateEdit(9, 130, 84, 23, "", false, jailGUI.window[1])
jailGUI.radiobutton[1] = guiCreateRadioButton(98, 134, 42, 15, "Sec.", false, jailGUI.window[1])
jailGUI.radiobutton[2] = guiCreateRadioButton(142, 134, 42, 15, "Min.", false, jailGUI.window[1])
jailGUI.radiobutton[3] = guiCreateRadioButton(186, 134, 95, 15, "Unjail Player", false, jailGUI.window[1])
jailGUI.button[1] = guiCreateButton(9, 156, 132, 22, "Jail Player", false, jailGUI.window[1])
jailGUI.button[2] = guiCreateButton(145, 156, 132, 22, "Close Window", false, jailGUI.window[1])

-- Ban GUI elements
banGUI.window[1] = guiCreateWindow(215, 367, 302, 202, "Ban a Player", false)
guiWindowSetSizable(banGUI.window[1], false) centerWindow ( banGUI.window[1] )
banGUI.label[1] = guiCreateLabel(4, 21, 292, 22, "Select a reason or enter a custom reason:", false, banGUI.window[1])
guiSetFont(banGUI.label[1], "default-bold-small")
guiLabelSetColor(banGUI.label[1], 245, 157, 9)
guiLabelSetHorizontalAlign(banGUI.label[1], "center", false)
banGUI.combobox[1] = guiCreateComboBox(9, 38, 284, 155, "Select a reason", false, banGUI.window[1])
banGUI.checkbox[1] = guiCreateCheckBox(1, 24, 16, 23, "", false, false, banGUI.combobox[1])
banGUI.edit[1] = guiCreateEdit(19, 24, 265, 23, "", false, banGUI.combobox[1])
banGUI.checkbox[2] = guiCreateCheckBox(50, 68, 119, 21, "Account only ban", false, false, banGUI.combobox[1])
banGUI.checkbox[3] = guiCreateCheckBox(171, 68, 101, 21, "Ban IP too", false, false, banGUI.combobox[1])
banGUI.radiobutton[1] = guiCreateRadioButton(100, 110, 59, 15, "Hrs.", false, banGUI.combobox[1])
banGUI.radiobutton[2] = guiCreateRadioButton(161, 110, 59, 15, "Days.", false, banGUI.combobox[1])
banGUI.radiobutton[3] = guiCreateRadioButton(222, 110, 59, 15, "Perm.", false, banGUI.combobox[1])
banGUI.edit[2] = guiCreateEdit(0, 106, 98, 24, "", false, banGUI.combobox[1])
banGUI.label[2] = guiCreateLabel(4, 87, 292, 22, "Select ban options:", false, banGUI.window[1])
guiSetFont(banGUI.label[2], "default-bold-small")
guiLabelSetColor(banGUI.label[2], 245, 157, 9)
guiLabelSetHorizontalAlign(banGUI.label[2], "center", false)
banGUI.label[3] = guiCreateLabel(4, 128, 292, 22, "Select a mute time:", false, banGUI.window[1])
guiSetFont(banGUI.label[3], "default-bold-small")
guiLabelSetColor(banGUI.label[3], 245, 157, 9)
guiLabelSetHorizontalAlign(banGUI.label[3], "center", false)
banGUI.button[1] = guiCreateButton(9, 172, 138, 22, "Ban Player", false, banGUI.window[1])
banGUI.button[2] = guiCreateButton(150, 172, 141, 22, "Cancel", false, banGUI.window[1])

-- Enter all the punishments in the combo
for i = 1, #punishmentReaons do
	guiComboBoxAddItem( muteGUI.combobox[1], punishmentReaons[ i ] )
	guiComboBoxAddItem( jailGUI.combobox[1], punishmentReaons[ i ] )
	guiComboBoxAddItem( banGUI.combobox[1], punishmentReaons[ i ] )
	guiComboBoxAddItem( DENAdminGUIB.combobox[1], punishmentReaons[ i ] )
end

-- Get the select punishment
function getSelectedPunishmentReason( combo, check, edit )
	if ( guiCheckBoxGetSelected ( check ) ) then
		return guiGetText( edit )
	end
	
	local theReason = guiComboBoxGetItemText ( combo, guiComboBoxGetSelected ( combo ) )
	if ( theReason ) and ( theReason ~= "Select a reason" ) then
		return theReason
	else
		outputChatBox( "You didn't enter a valid punishment time!", 225, 0, 0 )
		return false
	end
end

-- Event for the ticks
addEventHandler( "onClientGUIClick", root,
	function ()
		if ( muteGUI.checkbox[2] == source ) then
			guiCheckBoxSetSelected( muteGUI.checkbox[3], false )
			guiCheckBoxSetSelected( muteGUI.checkbox[4], false )
		elseif ( muteGUI.checkbox[3] == source ) then
			guiCheckBoxSetSelected( muteGUI.checkbox[2], false )
			guiCheckBoxSetSelected( muteGUI.checkbox[4], false )
		elseif ( muteGUI.checkbox[4] == source ) then
			guiCheckBoxSetSelected( muteGUI.checkbox[3], false )
			guiCheckBoxSetSelected( muteGUI.checkbox[2], false )
		elseif ( banGUI.checkbox[2] == source ) then
			guiCheckBoxSetSelected( banGUI.checkbox[3], false )
		elseif ( banGUI.checkbox[3] == source ) then
			guiCheckBoxSetSelected( banGUI.checkbox[2], false )
		end
	end
)

-- Get the mute type
function getMuteType ()
	if ( guiCheckBoxGetSelected( muteGUI.checkbox[2], false ) ) then
		return "Global"
	elseif( guiCheckBoxGetSelected( muteGUI.checkbox[3], false ) ) then
		return "Main"
	elseif( guiCheckBoxGetSelected( muteGUI.checkbox[4], false ) ) then
		return "Support"
	else
		outputChatBox( "You didn't enter a valid punishment type!", 225, 0, 0 )
		return false
	end
end

-- Get the ban punishment time
function getCustomBanPunishmentTime ( )
	if ( string.match( guiGetText( DENAdminGUIB.edit[5] ), '^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( DENAdminGUIB.radiobutton[1] ) ) then
			return tonumber( guiGetText( DENAdminGUIB.edit[5] ) ) * 3600
		elseif ( guiRadioButtonGetSelected( DENAdminGUIB.radiobutton[2] ) ) then
			return tonumber( guiGetText( DENAdminGUIB.edit[5] ) ) * 86400
		elseif ( guiRadioButtonGetSelected( DENAdminGUIB.radiobutton[3] ) ) then
			return 0
		end
	else
		outputChatBox( "You didn't enter a valid punishment time!", 225, 0, 0 )
		return false
	end
end

-- Get the ban punishment time
function getBanPunishmentTime ( )
	if ( string.match( guiGetText( banGUI.edit[2] ), '^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( banGUI.radiobutton[1] ) ) then
			return tonumber( guiGetText( banGUI.edit[2] ) ) * 3600
		elseif ( guiRadioButtonGetSelected( banGUI.radiobutton[2] ) ) then
			return tonumber( guiGetText( banGUI.edit[2] ) ) * 86400
		elseif ( guiRadioButtonGetSelected( banGUI.radiobutton[3] ) ) then
			return 0
		end
	else
		outputChatBox( "You didn't enter a valid punishment time!", 225, 0, 0 )
		return false
	end
end

-- Get the mute punishment time
function getMutePunishmentTime ( )
	if ( string.match( guiGetText( muteGUI.edit[2] ), '^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( muteGUI.radiobutton[1] ) ) then
			return tonumber( guiGetText( muteGUI.edit[2] ) )
		elseif ( guiRadioButtonGetSelected( muteGUI.radiobutton[2] ) ) then
			return tonumber( guiGetText( muteGUI.edit[2] ) ) * 60
		elseif ( guiRadioButtonGetSelected( muteGUI.radiobutton[3] ) ) then
			return tonumber( guiGetText( muteGUI.edit[2] ) ) * 3600
		end
	else
		if ( guiGetText( muteGUI.button[1] ) == "Mute Player" ) then outputChatBox( "You didn't enter a valid punishment time!", 225, 0, 0 ) end
		return false
	end
end

-- Get the jail punishment time
function getJailPunishmentTime ( )
	if ( string.match( guiGetText( jailGUI.edit[2] ) ,'^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( jailGUI.radiobutton[1] ) ) then
			return tonumber( guiGetText( jailGUI.edit[2] ) )
		elseif ( guiRadioButtonGetSelected( jailGUI.radiobutton[2] ) ) then
			return tonumber( guiGetText( jailGUI.edit[2] ) ) * 60
		end
	else
		outputChatBox( "You didn't enter a valid punishment time!", 225, 0, 0 )
		return false
	end
end

-- Event for the punishments
addEventHandler( "onClientGUIClick", root,
	function ()
		if ( source == muteGUI.button[1] ) then
			if ( getSelectedPunishmentReason( muteGUI.combobox[1], muteGUI.checkbox[1], muteGUI.edit[1] ) ) and ( getMutePunishmentTime () ) and ( getMuteType () ) then
				if ( guiGetText( muteGUI.button[1] ) == "Mute Player" ) then
					local theReason = getSelectedPunishmentReason( muteGUI.combobox[1], muteGUI.checkbox[1], muteGUI.edit[1] )
					triggerServerEvent( "onServerPlayerMute", localPlayer, getAdminPanelSelectedPlayer (), getMutePunishmentTime ( ), theReason, getMuteType () )
					guiSetVisible( muteGUI.window[1], false )
				else
					triggerServerEvent( "onServerPlayerUnmute", localPlayer, getAdminPanelSelectedPlayer () )
					guiSetVisible( muteGUI.window[1], false )
				end
			elseif ( guiGetText( muteGUI.button[1] ) ~= "Mute Player" ) then
				triggerServerEvent( "onServerPlayerUnmute", localPlayer, getAdminPanelSelectedPlayer () )
				guiSetVisible( muteGUI.window[1], false )
			end
		elseif ( source == jailGUI.button[1] ) then
			if ( getSelectedPunishmentReason( jailGUI.combobox[1], jailGUI.checkbox[1], jailGUI.edit[1] ) ) and ( getJailPunishmentTime () ) then
				local theReason = getSelectedPunishmentReason( jailGUI.combobox[1], jailGUI.checkbox[1], jailGUI.edit[1] )
				triggerServerEvent( "onServerPlayerJail", localPlayer, getAdminPanelSelectedPlayer (), getJailPunishmentTime ( ), theReason )
				guiSetVisible( jailGUI.window[1], false )
			elseif ( guiRadioButtonGetSelected( jailGUI.radiobutton[3] ) ) then
				triggerServerEvent( "onServerPlayerUnjail", localPlayer, getAdminPanelSelectedPlayer () )
				guiSetVisible( jailGUI.window[1], false )
			end
		elseif ( source == banGUI.button[1] ) then
			if ( getSelectedPunishmentReason( banGUI.combobox[1], banGUI.checkbox[1], banGUI.edit[1] ) ) and ( getBanPunishmentTime () ) then
				local theReason = getSelectedPunishmentReason( banGUI.combobox[1], banGUI.checkbox[1], banGUI.edit[1] )
				triggerServerEvent ( "onServerPlayerBan", localPlayer, getAdminPanelSelectedPlayer (), getBanPunishmentTime (), theReason, guiCheckBoxGetSelected( banGUI.checkbox[2] ), guiCheckBoxGetSelected( banGUI.checkbox[3] ) )
				guiSetVisible( banGUI.window[1], false )
			end
		end
	end
)

-- Show mutes window
addEvent( "onClientShowMutesWindow", true )
addEventHandler( "onClientShowMutesWindow", root,
	function ( isMuted )
		if ( isMuted ) then
			guiSetText( muteGUI.button[1], "Unmute Player" )
		else
			guiSetText( muteGUI.button[1], "Mute Player" )
		end
		guiSetVisible( muteGUI.window[1], true )
		guiBringToFront( muteGUI.window[1] )
		guiSetProperty( muteGUI.window[1], "AlwaysOnTop", "True" )
	end
)