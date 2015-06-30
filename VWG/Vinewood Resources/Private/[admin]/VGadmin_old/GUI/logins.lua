--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- The window of the logins GUI
loginsWindow = guiCreateWindow(505, 315, 562, 221, "10 latest logins on this account", false)
loginsGrid = guiCreateGridList(9, 21, 544, 166, false, loginsWindow)
loginsButton = guiCreateButton(430, 189, 123, 22, "Close Window", false, loginsWindow)
loginsLabel = guiCreateLabel(11, 192, 403, 16, "Here you'll find the 10 latest logins for the selected player!", false, loginsWindow)
guiSetFont(loginsLabel, "default-bold-small")

guiGridListAddColumn( loginsGrid, "Date:", 0.30 )
guiGridListAddColumn( loginsGrid, "IP:", 0.20 )
guiGridListAddColumn( loginsGrid, "Serial:", 0.45 )

guiWindowSetMovable ( loginsWindow, true )
guiWindowSetSizable ( loginsWindow, false )
guiSetVisible ( loginsWindow, false )

local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize(loginsWindow,false)
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition(loginsWindow,x,y,false)

-- Open the window and put the login history in a gridlist
addEvent( "onClientShowPlayerLatestLogins", true )
addEventHandler( "onClientShowPlayerLatestLogins", root,
	function ( theTable )
		if ( theTable ) then
			guiGridListClear( loginsGrid )
			for i=1,#theTable do
				local row = guiGridListAddRow( loginsGrid )
				guiGridListSetItemText( loginsGrid, row, 1, theTable[i].date, false, false )
				guiGridListSetItemText( loginsGrid, row, 2, theTable[i].ip, false, false )
				guiGridListSetItemText( loginsGrid, row, 3, theTable[i].serial, false, false )
				
				guiSetText( loginsWindow, "Login History From: "..theTable[i].accountname )
			end	
			guiSetVisible ( loginsWindow, true )
			guiBringToFront( loginsWindow )
			guiSetProperty( loginsWindow, "AlwaysOnTop", "True" )
			showCursor( true )
		end
	end
)

-- Close window
addEventHandler( "onClientGUIClick", loginsButton,
	function ()
		guiSetVisible ( loginsWindow, false )
	end, false
)