--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--



GUI.logins = {}

-- Punishments windows
GUI.logins.window = guiCreateWindow( 458, 364, 726, 244, "", false )
GUI.logins.gridlist = guiCreateGridList(9, 22, 707, 212, false, GUI.logins.window )
guiGridListAddColumn( GUI.logins.gridlist, "Date:", 0.20 )
guiGridListAddColumn( GUI.logins.gridlist, "Account:", 0.18 )
guiGridListAddColumn( GUI.logins.gridlist, "Nick:", 0.18 )
guiGridListAddColumn( GUI.logins.gridlist, "Serial:", 0.18 )
guiGridListAddColumn( GUI.logins.gridlist, "IP:", 0.15 )

exports.VGutils:centerWindow( GUI.logins.window )

guiWindowSetMovable ( GUI.logins.window, true )
guiWindowSetSizable ( GUI.logins.window, false )
guiSetVisible ( GUI.logins.window, false )

-- When the player closes the window
addEventHandler( "onClientGUIDoubleClick", GUI.logins.window, 
	function() 
		guiSetVisible( GUI.logins.window, false )
	end, false
)

-- The event that puts the punishments in the list
addEvent( "onClientAdminReceiveLogins", true )
addEventHandler( "onClientAdminReceiveLogins", root,
	function ( logins, player )
		guiGridListClear( GUI.logins.gridlist )

		if ( logins ) then
			for _, login in ipairs( logins ) do
				local row = guiGridListAddRow ( GUI.logins.gridlist )
				guiGridListSetItemText ( GUI.logins.gridlist, row, 1, exports.VGutils:timestampToDate( login.timestamp ), false, false )
				guiGridListSetItemText ( GUI.logins.gridlist, row, 2, login.account, false, false )
				guiGridListSetItemText ( GUI.logins.gridlist, row, 3, login.nick, false, false )
				guiGridListSetItemText ( GUI.logins.gridlist, row, 4, login.serial, false, false )
				guiGridListSetItemText ( GUI.logins.gridlist, row, 5, login.ip, false, false )
			end

			for i=1,5 do 
				guiGridListAutoSizeColumn( GUI.logins.gridlist, i )
				local col = guiGridListGetColumnWidth( GUI.logins.gridlist, i, true )
				guiGridListSetColumnWidth( GUI.logins.gridlist, i, col + 0.02, true )
			end
		end

		guiSetText( GUI.logins.window, "25 most recent logins from " .. getPlayerName( player ) .. " (Double click here to close)" )
			
		guiSetVisible( GUI.logins.window, true ) 
		guiBringToFront( GUI.logins.window )
		guiSetProperty( GUI.logins.window, "AlwaysOnTop", "True" )
		showCursor( true, true )
	end
)