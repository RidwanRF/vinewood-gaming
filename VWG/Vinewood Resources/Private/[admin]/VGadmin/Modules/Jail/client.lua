--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Some variables
local sx, sy = guiGetScreenSize()
local jailData = {}

local reasons = {
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
}

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

for _, reason in ipairs( reasons ) do
	guiComboBoxAddItem( GUI.jail.combo.reason, reason )
end

-- Buttons to close windows
addEventHandler( "onClientGUIClick", root,
	function ()
		if not ( guiGetEnabled( source ) ) then return end

		if ( source == GUI.jail.button.close ) then
			guiSetVisible( GUI.jail.window, false )
		elseif ( source == GUI.jail.button.jail ) then
			if ( getSelectedPunishmentReason( GUI.jail.combo.reason, GUI.jail.check.reason, GUI.jail.edit.reason ) ) and ( getJailPunishmentTime () ) then
				local theReason = getSelectedPunishmentReason( GUI.jail.combo.reason, GUI.jail.check.reason, GUI.jail.edit.reason )
				triggerServerEvent( "onServerPlayerJail", localPlayer, getAdminPanelSelectedPlayer (), getJailPunishmentTime ( ), theReason )
				guiSetVisible( GUI.jail.window, false )
			elseif ( guiRadioButtonGetSelected( GUI.jail.check.hours ) ) then
				triggerServerEvent( "onServerPlayerUnjail", localPlayer, getAdminPanelSelectedPlayer () )
				guiSetVisible( GUI.jail.window, false )
			end
		end
	end
)

-- Get the jail punishment time
function getJailPunishmentTime ( )
	if ( string.match( guiGetText( GUI.jail.edit.duration ) ,'^%d+$' ) ) then
		if ( guiRadioButtonGetSelected( GUI.jail.check.seconds ) ) then
			return tonumber( guiGetText( GUI.jail.edit.duration ) )
		elseif ( guiRadioButtonGetSelected( GUI.jail.check.minutes ) ) then
			return tonumber( guiGetText( GUI.jail.edit.duration ) ) * 60
		end
	end

	showMessageDX( "You didn't enter a valid punishment time!", 225, 0, 0 )
	return false
end

-- Event when a player gets jailed
addEvent( "onSetPlayerJailed", true )
addEventHandler( "onSetPlayerJailed", root,
	function ( time )
		if ( time ) then
			jailData.time = time
			if not ( isTimer( jailData.timer ) ) then jailData.timer = setTimer( decreaseJailTime, 1000, 0 ) end
		end

		if ( isTimer( jailData.timer ) ) then killTimer( jailData.timer ) end
		jailData = {}
	end
)

-- Jail time render
addEventHandler( "onClientRender", root,
	function ()
		if ( jailData.time ) and ( jailData.time >= 0 ) then
			exports.VGdrawing:dxDrawBorderedText( theTime .. " seconds remaining!", sx*(969.0/1440),sy*(813.0/900),sx*(1394.0/1440),sy*(852.0/900), tocolor(8, 81, 180, 255), sx*(1.4/1440), "pricedown", "right", "top", false, false, true, false, false)
		end
	end
)

-- Function that decreases the jail time
function decreaseJailTime ()
	if ( jailData.time ) and ( jailData.time >= 0 ) then
		jailData.time = jailData.time - 1
	end
end

-- Function for when the resource start
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		triggerServerEvent( "requestPlayerJailTime", localPlayer )
	end
)

-- Show jail window
addEvent( "onClientShowJailWindow", true )
addEventHandler( "onClientShowJailWindow", root,
	function ( isJailed )
		if ( isJailed ) then
			guiSetEnabled( GUI.jail.button.unjail, true )
		end

		guiSetEnabled( GUI.jail.button.unjail, false )
		guiSetVisible( GUI.jail.window, true )
		guiBringToFront( GUI.jail.window )
		guiSetProperty( GUI.jail.window, "AlwaysOnTop", "True" )
	end
)