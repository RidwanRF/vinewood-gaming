--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

local tonumber = tonumber

-- List of possible punishments
reasons = {
	mute = {
	    "Testing punishments",
	    "Insulting/flaming",
	    "Advertising for other servers",
	    "Support channel misuse",
	    "Non-English in main/team chat",
	    "Using main/team chat for advertising",
	    "Using an unacceptable name",
	    "Trolling/griefing",
	    "Spamming/flooding"
	},

	jail = {
	    "Testing punishments",
	    "Deathmatching",
	    "Avoiding ingame situations",
	    "Camping",
	    "Using an unacceptable name",
	    "Not listening to staff",
	    "Blackmailing players",
	    "Abusing bug(s)",
	    "Trolling/griefing",
	    "Annoying server staff(s)"
	},

	ban = {
		"Testing punishments",
		"Cheating/hacking",
		"Selling ingame contents",
		"Abusing bug(s)",
		"Blackmailing players",
		"Avoiding ingame situations",
		"Repeat offender"
	}
}

-- Mute Window
GUI.mute                = { button = {}, edit = {}, combo = {}, check = {}, label = {} }	
GUI.mute.window         = guiCreateWindow( 314, 390, 304, 259, "", false )
GUI.mute.label.reason   = guiCreateLabel( 2, 21, 297, 23, "Select or enter a reason:", false, GUI.mute.window )
GUI.mute.combo.reason   = guiCreateComboBox( 9, 44, 285, 205, "Select a reason", false, GUI.mute.window )
GUI.mute.check.reason   = guiCreateCheckBox( 9, 75, 17, 24, "", false, false, GUI.mute.window )
GUI.mute.edit.reason    = guiCreateEdit( 30, 73, 264, 26, "Custom reason", false, GUI.mute.window )
GUI.mute.label.type     = guiCreateLabel( 0, 103, 297, 23, "Select a mute type:", false, GUI.mute.window )
GUI.mute.check.global   = guiCreateCheckBox( 9, 131, 59, 24, "Global", false, false, GUI.mute.window )
GUI.mute.check.main     = guiCreateCheckBox( 94, 131, 74, 24, "Main chat", false, false, GUI.mute.window )
GUI.mute.check.support  = guiCreateCheckBox( 197, 131, 97, 24, "Support chat", false, false, GUI.mute.window )
GUI.mute.label.duration = guiCreateLabel( 0, 160, 297, 23, "Select a mute duration:", false, GUI.mute.window )
GUI.mute.edit.duration  = guiCreateEdit( 9, 187, 83, 26, "", false, GUI.mute.window )
GUI.mute.check.seconds  = guiCreateRadioButton( 94, 183, 64, 31, "Sec.", false, GUI.mute.window )
GUI.mute.check.minutes  = guiCreateRadioButton( 158, 183, 64, 31, "Min.", false, GUI.mute.window )
GUI.mute.check.hours    = guiCreateRadioButton( 223, 183, 64, 31, "Hrs.", false, GUI.mute.window )
GUI.mute.button.mute    = guiCreateButton( 9, 219, 93, 27, "Mute", false, GUI.mute.window )
GUI.mute.button.unmute  = guiCreateButton( 105, 219, 93, 27, "Unmute", false, GUI.mute.window )
GUI.mute.button.close   = guiCreateButton( 201, 219, 93, 27, "Close", false, GUI.mute.window ) 

setWindow( GUI.mute.window )
setOrangeFont( GUI.mute.label.duration )
setOrangeFont( GUI.mute.label.type )
setOrangeFont( GUI.mute.label.reason )

-- Jail Window
GUI.jail                = { button = {}, edit = {}, combo = {}, check = {}, label = {} }   
GUI.jail.window         = guiCreateWindow( 314, 390, 304, 203, "", false )
GUI.jail.label.reason   = guiCreateLabel( 2, 21, 297, 23, "Select or enter a reason:", false, GUI.jail.window )
GUI.jail.combo.reason   = guiCreateComboBox( 9, 44, 285, 149, "Select a reason", false, GUI.jail.window )
GUI.jail.check.reason   = guiCreateCheckBox( 9, 75, 17, 24, "", false, false, GUI.jail.window )
GUI.jail.edit.reason    = guiCreateEdit( 30, 73, 264, 26, "Custom reason", false, GUI.jail.window )
GUI.jail.label.duration = guiCreateLabel( 0, 103, 297, 23, "Select a jail duration:", false, GUI.jail.window )
GUI.jail.edit.duration  = guiCreateEdit( 9, 130, 83, 26, "", false, GUI.jail.window )
GUI.jail.check.seconds  = guiCreateRadioButton( 92, 126, 64, 31, "Sec.", false, GUI.jail.window )
GUI.jail.check.minutes  = guiCreateRadioButton( 156, 126, 64, 31, "Min.", false, GUI.jail.window )
GUI.jail.check.hours    = guiCreateRadioButton( 220, 126, 64, 31, "Hrs.", false, GUI.jail.window )
GUI.jail.button.jail    = guiCreateButton( 9, 162, 93, 27, "Jail", false, GUI.jail.window )
GUI.jail.button.unjail  = guiCreateButton( 105, 162, 93, 27, "Unjail", false, GUI.jail.window )
GUI.jail.button.close   = guiCreateButton( 201, 162, 93, 27, "Close", false, GUI.jail.window )

setWindow( GUI.jail.window )
setOrangeFont( GUI.jail.label.duration )
setOrangeFont( GUI.jail.label.reason )

-- Ban Window
GUI.ban                = { button = {}, edit = {}, combo = {}, check = {}, label = {} }  
GUI.ban.window         = guiCreateWindow(314, 390, 304, 259, "", false)
GUI.ban.label.reason   = guiCreateLabel(2, 21, 297, 23, "Select or enter a reason:", false, GUI.ban.window)
GUI.ban.combo.reason   = guiCreateComboBox(9, 44, 285, 29, "", false, GUI.ban.window)
GUI.ban.check.reason   = guiCreateCheckBox(9, 75, 17, 24, "Select a reason", false, false, GUI.ban.window)
GUI.ban.edit.reason    = guiCreateEdit(30, 73, 264, 26, "Custom reason", false, GUI.ban.window)
GUI.ban.label.type     = guiCreateLabel(0, 103, 297, 23, "Select a mute type:", false, GUI.ban.window)
GUI.ban.check.account  = guiCreateCheckBox(9, 131, 68, 24, "Account", false, false, GUI.ban.window)
GUI.ban.check.serial   = guiCreateCheckBox(94, 131, 74, 24, "Serial", false, false, GUI.ban.window)
GUI.ban.check.ip       = guiCreateCheckBox(197, 131, 97, 24, "IP Address", false, false, GUI.ban.window)
GUI.ban.label.duration = guiCreateLabel(0, 160, 297, 23, "Select a mute type:", false, GUI.ban.window)
GUI.ban.edit.duration  = guiCreateEdit(9, 187, 83, 26, "", false, GUI.ban.window)
GUI.ban.check.hours    = guiCreateRadioButton(94, 183, 64, 31, "Hrs.", false, GUI.ban.window)
GUI.ban.check.days     = guiCreateRadioButton(158, 183, 64, 31, "Days.", false, GUI.ban.window)
GUI.ban.check.perm     = guiCreateRadioButton(223, 183, 64, 31, "Perm.", false, GUI.ban.window)
GUI.ban.button.ban     = guiCreateButton(9, 219, 141, 27, "Ban", false, GUI.ban.window)
GUI.ban.button.close   = guiCreateButton(153, 219, 142, 27, "Close", false, GUI.ban.window)

setWindow( GUI.ban.window )
setOrangeFont( GUI.ban.label.reason )
setOrangeFont( GUI.ban.label.type )
setOrangeFont( GUI.ban.label.duration )

-- Fill the comboboxes with punishment reasons




for _, reason in ipairs( reasons.ban ) do
	guiComboBoxAddItem( GUI.ban.combo.reason, reason )
	guiComboBoxAddItem( DENAdminGUIB.combobox[1], reason )
end

-- Buttons to close windows
addEventHandler( "onClientGUIClick", root,
	function ()
		if ( source == GUI.ban.button.close ) then
			guiSetVisible( GUI.ban.window, false )
		end
	end
)

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
	end
	
	showMessageDX( "You didn't enter a valid punishment time!", 225, 0, 0 )
	return false
end

-- Get the ban punishment time
function getBanPunishmentTime ( )
	if ( string.match( guiGetText( GUI.ban.edit.duration ), '^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( GUI.ban.check.hours ) ) then
			return tonumber( guiGetText( GUI.ban.edit.duration ) ) * 3600
		elseif ( guiRadioButtonGetSelected( GUI.ban.check.days ) ) then
			return tonumber( guiGetText( GUI.ban.edit.duration ) ) * 86400
		elseif ( guiRadioButtonGetSelected( GUI.ban.check.perm ) ) then
			return 0
		end
	end

	showMessageDX( "You didn't enter a valid punishment time!", 225, 0, 0 )
	return false
end

-- Event for the punishments
addEventHandler( "onClientGUIClick", root,
	function ()
		if not ( guiGetEnabled( source ) ) then return end

		if ( source == GUI.ban.button.ban) then
			if ( getSelectedPunishmentReason( GUI.ban.combo.reason, GUI.ban.check.reason, GUI.ban.edit.reason ) ) and ( getBanPunishmentTime () ) then
				local theReason = getSelectedPunishmentReason( GUI.ban.combo.reason, GUI.ban.check.reason, GUI.ban.edit.reason )
				local banTypes = { account = guiCheckBoxGetSelected( GUI.ban.check.account )  or "", serial = guiCheckBoxGetSelected( GUI.ban.check.serial )  or "", ip = guiCheckBoxGetSelected( GUI.ban.check.ip ) or "" }
				triggerServerEvent ( "onServerPlayerBan", localPlayer, getAdminPanelSelectedPlayer (), getBanPunishmentTime (), theReason, banTypes )
				guiSetVisible( GUI.ban.window, false )
			end
		end
	end
)

-- Show ban window
function showPlayerBanWindow()
	guiSetVisible( GUI.ban.window, true )
	guiBringToFront( GUI.ban.window )
	guiSetProperty( GUI.ban.window, "AlwaysOnTop", "True" )	
end