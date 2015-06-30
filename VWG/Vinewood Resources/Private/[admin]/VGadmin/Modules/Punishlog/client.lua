--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--



GUI.punishlog = {}

-- Punishments windows
GUI.punishlog.window = guiCreateWindow( 458, 364, 726, 244, "", false )
GUI.punishlog.gridlist = guiCreateGridList(9, 22, 707, 212, false, GUI.punishlog.window )
guiGridListAddColumn( GUI.punishlog.gridlist, "Date:", 0.24 )
guiGridListAddColumn( GUI.punishlog.gridlist, "Punishlog:", 0.73 )

exports.VGutils:centerWindow( GUI.punishlog.window )

guiWindowSetMovable ( GUI.punishlog.window, true )
guiWindowSetSizable ( GUI.punishlog.window, false )
guiSetVisible ( GUI.punishlog.window, false )

-- When the player closes the window
addEventHandler( "onClientGUIDoubleClick", GUI.punishlog.window, 
	function() 
		guiSetVisible( GUI.punishlog.window, false )
	end, false
)

-- The event that puts the punishments in the list
addEvent( "onClientAdminReceivePunishments", true )
addEventHandler( "onClientAdminReceivePunishments", root,
	function ( punishments, player )
		guiGridListClear( GUI.punishlog.gridlist )

		if ( punishments ) then
			for _, punishment in ipairs( punishments ) do
				local row = guiGridListAddRow ( GUI.punishlog.gridlist )
				guiGridListSetItemText ( GUI.punishlog.gridlist, row, 1, exports.VGutils:timestampToDate( punishment.timestamp ), false, false )
				guiGridListSetItemText ( GUI.punishlog.gridlist, row, 2, punishment.punishment, false, false )
				guiGridListSetItemData ( GUI.punishlog.gridlist, row, 1, punishment.log_id )
			end

			for i=1,2 do 
				guiGridListAutoSizeColumn( GUI.punishlog.gridlist, i )
				local col = guiGridListGetColumnWidth( GUI.punishlog.gridlist, i, true )
				guiGridListSetColumnWidth( GUI.punishlog.gridlist, i, col + 0.02, true )
			end
		end

		guiSetText( GUI.punishlog.window, "Punishments from " .. getPlayerName( player ) .. " (Double click here to close)" )
			
		guiSetVisible( GUI.punishlog.window, true ) 
		guiBringToFront( GUI.punishlog.window )
		guiSetProperty( GUI.punishlog.window, "AlwaysOnTop", "True" )
		showCursor( true, true )
	end
)