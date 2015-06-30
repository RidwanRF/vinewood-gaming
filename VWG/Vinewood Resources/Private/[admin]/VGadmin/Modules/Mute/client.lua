--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

local isMuted = false

local reasons = {
    "Testing punishments",
    "Insulting/flaming",
    "Advertising for other servers",
    "Support channel misuse",
    "Non-English in main/team chat",
    "Using main/team chat for advertising",
    "Using an unacceptable name",
    "Trolling/griefing",
    "Spamming/flooding"
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

for _, reason in ipairs( reasons ) do
	guiComboBoxAddItem( GUI.mute.combo.reason, reason )
end

-- Get the select punishment
function getSelectedPunishmentReason( combo, check, edit )
	if ( guiCheckBoxGetSelected ( check ) ) then
		return guiGetText( edit )
	end
	
	local reason = guiComboBoxGetItemText ( combo, guiComboBoxGetSelected ( combo ) )
	if ( guiComboBoxGetSelected ( combo ) ) and ( reason ) and ( reason ~= "Select a reason" ) and not ( empty( reason ) ) then
		return reason
	end
		
	showMessageDX( "You didn't enter a valid punishment reason!", 225, 0, 0 )
	return false
end

-- Buttons to close windows
addEventHandler( "onClientGUIClick", root,
	function ()
		if not ( guiGetEnabled( source ) ) then return end

		if ( source == GUI.mute.button.close ) then
			guiSetVisible( GUI.mute.window, false )
		elseif ( GUI.mute.check.global == source ) then
			guiCheckBoxSetSelected( GUI.mute.check.main, false )
			guiCheckBoxSetSelected( GUI.mute.check.support, false )
		elseif ( GUI.mute.check.main == source ) then
			guiCheckBoxSetSelected( GUI.mute.check.global, false )
			guiCheckBoxSetSelected( GUI.mute.check.support, false )
		elseif ( GUI.mute.check.support == source ) then
			guiCheckBoxSetSelected( GUI.mute.check.main, false )
			guiCheckBoxSetSelected( GUI.mute.check.global, false )
		elseif ( source == GUI.mute.button.mute) then
			if ( getSelectedPunishmentReason( GUI.mute.combo.reason, GUI.mute.check.reason, GUI.mute.edit.reason ) ) and ( getMuteType() ) and ( getMutePunishmentTime() ) then
				local theReason = getSelectedPunishmentReason( GUI.mute.combo.reason, GUI.mute.check.reason, GUI.mute.edit.reason )
				triggerServerEvent( "onServerPlayerMute", localPlayer, getAdminPanelSelectedPlayer(), getMutePunishmentTime(), theReason, getMuteType() )
				guiSetVisible( GUI.mute.window, false )
			end
		elseif ( source == GUI.mute.button.unmute ) then
			triggerServerEvent( "onServerPlayerUnmute", localPlayer, getAdminPanelSelectedPlayer () )
			guiSetVisible( GUI.mute.window, false )
		end
	end
)

-- Get the mute type
function getMuteType ()
	if ( guiCheckBoxGetSelected( GUI.mute.check.global, false ) ) then
		return "Global"
	elseif( guiCheckBoxGetSelected( GUI.mute.check.main, false ) ) then
		return "Main"
	elseif( guiCheckBoxGetSelected( GUI.mute.check.support, false ) ) then
		return "Support"
	end

	showMessageDX( "You didn't enter a valid punishment type!", 225, 0, 0 )
	return false
end

-- Get the mute punishment time
function getMutePunishmentTime ( )
	if ( string.match( guiGetText( GUI.mute.edit.duration ), '^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( GUI.mute.check.seconds) ) then
			return tonumber( guiGetText( GUI.mute.edit.duration ) )
		elseif ( guiRadioButtonGetSelected( GUI.mute.check.minutes ) ) then
			return tonumber( guiGetText( GUI.mute.edit.duration ) ) * 60
		elseif ( guiRadioButtonGetSelected( GUI.mute.check.hours ) ) then
			return tonumber( guiGetText( GUI.mute.edit.duration ) ) * 3600
		end
	end

	showMessageDX( "You didn't enter a valid punishment time!", 225, 0, 0 )
	return false
end

-- Show mutes window
addEvent( "onClientShowMutesWindow", true )
addEventHandler( "onClientShowMutesWindow", root,
	function ( isMuted )
		if ( isMuted ) then
			guiSetEnabled( GUI.mute.button.unmute, true )
		end

		guiSetEnabled( GUI.mute.button.unmute, false )
		guiSetVisible( GUI.mute.window, true )
		guiBringToFront( GUI.mute.window )
		guiSetProperty( GUI.mute.window, "AlwaysOnTop", "True" )
	end
)

-- Event to unmute
addEvent( "onClientPlayerMute", true )
addEventHandler( "onClientPlayerMute", root,
	function ( muted )
		isMuted = muted
		triggerEvent( "onClientPlayerMuted", localPlayer, muted )
	end
)

-- Function to check if muted
function isClientMuted()
	return isMuted
end

-- Function for when the resource start
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		triggerServerEvent( "requestPlayerMuteTime", localPlayer )
	end
)