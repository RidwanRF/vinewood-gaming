--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--






-- Punishments windows
punishlogWindow = guiCreateWindow(614, 284, 659, 297, "Player Latest Punishments", false)
guiWindowSetSizable(punishlogWindow, false)
accountPunishGrid = guiCreateGridList(9, 21, 641, 237, false, punishlogWindow)
guiGridListSetSelectionMode(accountPunishGrid,0)
guiGridListAddColumn( accountPunishGrid, "Date:", 0.24 )
guiGridListAddColumn( accountPunishGrid, "Punishment:", 0.73 )
punishlogButton = guiCreateButton(420, 263, 230, 23, "Close Window", false, punishlogWindow)

local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize(punishlogWindow,false)
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition(punishlogWindow,x,y,false)

guiWindowSetMovable (punishlogWindow, true)
guiWindowSetSizable (punishlogWindow, false)
guiSetVisible (punishlogWindow, false)

-- When the player closes the window
addEventHandler( "onClientGUIClick", punishlogButton, 
	function() 
		guiSetVisible( punishlogWindow, false ) 
	end, false
)

-- The event that puts the punishments in the list
addEvent( "showPunishmentsWindow", true )
addEventHandler( "showPunishmentsWindow", root,
	function ( theTable, thePlayer, serial )
		guiGridListClear( accountPunishGrid )
		if ( theTable ) then
			for key, punish in ipairs( theTable ) do
				local row = guiGridListAddRow ( accountPunishGrid )
				guiGridListSetItemText ( accountPunishGrid, row, 1, punish.date, false, false )
				guiGridListSetItemText ( accountPunishGrid, row, 2, punish.action, false, false )
			end
		end
			
		guiSetVisible( punishlogWindow, true ) 
		guiBringToFront( punishlogWindow )
		guiSetProperty( punishlogWindow, "AlwaysOnTop", "True" )
		showCursor( true, true )
	end
)