-- Housekeeping GUI
local housekeepingGUI = {
    tabs = {},
    buttons = {},
    edits = {},
    windows = {},
    comboboxs = {},
	comboboxindex = {},
    labels = {},
    tabpanels = {},
}

-- The window
housekeepingGUI.windows[1] = guiCreateWindow(592, 251, 320, 338, "Housing Management", false)
guiWindowSetSizable(housekeepingGUI.windows[1], false)
housekeepingGUI.tabpanels[1] = guiCreateTabPanel(9, 22, 302, 307, false, housekeepingGUI.windows[1])
housekeepingGUI.buttons[8] = guiCreateButton(279, 20, 31, 24, "X", false, housekeepingGUI.windows[1])
guiSetProperty ( housekeepingGUI.buttons[8], "AlwaysOnTop", "true" )

-- Tab one
housekeepingGUI.tabs[1] = guiCreateTab("Create House", housekeepingGUI.tabpanels[1])
housekeepingGUI.labels[1] = guiCreateLabel(8, 3, 292, 20, "House Interior:", false, housekeepingGUI.tabs[1])
housekeepingGUI.comboboxs[1] = guiCreateComboBox(6, 19, 290, 200, "Select an interior", false, housekeepingGUI.tabs[1])
housekeepingGUI.labels[2] = guiCreateLabel(8, 44, 292, 20, "House Price:", false, housekeepingGUI.tabs[1])
housekeepingGUI.edits[1] = guiCreateEdit(7, 60, 290, 24, "", false, housekeepingGUI.tabs[1])
housekeepingGUI.buttons[2] = guiCreateButton(6, 88, 289, 24, "Create House", false, housekeepingGUI.tabs[1])
housekeepingGUI.labels[3] = guiCreateLabel(7, 118, 288, 158, "Be aware that everything in housing management\nis logged and checked frequently.\nAny kind of abuse of your privileges will\nresult in a kick and possibly a ban.\n\nGive houses correct prices based on the location\n interior AND exterior!\n\nFor any questions about house mapping\nplease contact Dennis or LeJoker!", false, housekeepingGUI.tabs[1])
guiLabelSetHorizontalAlign(housekeepingGUI.labels[3], "center", false)

-- Tab Two
housekeepingGUI.tabs[2] = guiCreateTab("Edit House", housekeepingGUI.tabpanels[1])
housekeepingGUI.edits[4] = guiCreateEdit(6, 6, 292, 26, "House ID", false, housekeepingGUI.tabs[2])
housekeepingGUI.buttons[3] = guiCreateButton(6, 35, 291, 27, "Request House Data", false, housekeepingGUI.tabs[2])
housekeepingGUI.buttons[4] = guiCreateButton(4, 252, 144, 26, "Delete House", false, housekeepingGUI.tabs[2])
housekeepingGUI.buttons[5] = guiCreateButton(152, 252, 144, 26, "Edit House", false, housekeepingGUI.tabs[2])
housekeepingGUI.edits[5] = guiCreateEdit(6, 209, 292, 26, "", false, housekeepingGUI.tabs[2])
guiSetEnabled(housekeepingGUI.edits[5], false)
housekeepingGUI.edits[6] = guiCreateEdit(6, 124, 292, 26, "", false, housekeepingGUI.tabs[2])
housekeepingGUI.edits[7] = guiCreateEdit(6, 167, 292, 26, "", false, housekeepingGUI.tabs[2])
guiSetEnabled(housekeepingGUI.edits[7], false)
housekeepingGUI.labels[4] = guiCreateLabel(10, 64, 285, 19, "House Interior:", false, housekeepingGUI.tabs[2])
housekeepingGUI.labels[5] = guiCreateLabel(10, 107, 285, 19, "House Price:", false, housekeepingGUI.tabs[2])
housekeepingGUI.labels[6] = guiCreateLabel(10, 150, 285, 19, "House Boughtprice:", false, housekeepingGUI.tabs[2])
housekeepingGUI.labels[7] = guiCreateLabel(10, 193, 285, 19, "Accountname Owner:", false, housekeepingGUI.tabs[2])
housekeepingGUI.comboboxs[2] = guiCreateComboBox(8, 81, 290, 160, "Select an interior", false, housekeepingGUI.tabs[2])

-- Center Window
local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize(housekeepingGUI.windows[ 1 ],false)
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition(housekeepingGUI.windows[ 1 ],x,y,false)
guiSetVisible(housekeepingGUI.windows[ 1 ],false)

-- Loop to add the rules in a combobox
for interior, aTable in pairs ( houseNames ) do
	local i = guiComboBoxAddItem ( housekeepingGUI.comboboxs[ 1 ], aTable[ 1 ].." - Approx: $"..exports.VGutils:convertNumber ( aTable[ 2 ] ) )
	guiComboBoxAddItem ( housekeepingGUI.comboboxs[ 2 ], aTable[ 1 ].." - Approx: $"..exports.VGutils:convertNumber ( aTable[ 2 ] ) )
	housekeepingGUI.comboboxindex[ interior ] = i
end

-- Button to enter the house
addEventHandler( "onClientGUIClick", housekeepingGUI.buttons[ 8 ],
	function ()
		guiSetVisible( housekeepingGUI.windows[ 1 ], false )
		showCursor( false )
		resetPlayerPosition ()
	end, false
)

-- Command to start housekeeping
addCommandHandler( "housekeeping",
	function ()
		if ( guiGetVisible( housekeepingGUI.windows[ 1 ] ) ) then
			guiSetVisible( housekeepingGUI.windows[ 1 ], false )
			showCursor( false )
			resetPlayerPosition ()
			return
		end
				
		guiSetInputMode( "no_binds_when_editing" )
		guiSetVisible( housekeepingGUI.windows[ 1 ], true )
		showCursor( true )
		return
	end
)

-- Get combobox selected interior
function getSelectedInterior( combobox )
	local selected = guiComboBoxGetItemText ( combobox, guiComboBoxGetSelected ( combobox ) )
	if ( selected ) then
		for i=1,#houseNames do
			if ( houseNames[ i ][ 1 ].." - Approx: $"..exports.VGutils:convertNumber ( houseNames[ i ][ 2 ] ) == selected ) then
				return i
			end
		end
		return false
	else
		return false
	end
end

-- When a combobox gets accepted
local position = {}

addEventHandler ( "onClientGUIComboBoxAccepted", root,
    function ( theCombo )
        if ( theCombo == housekeepingGUI.comboboxs[ 1 ] ) or ( theCombo == housekeepingGUI.comboboxs[ 2 ] ) then
			if ( getSelectedInterior( theCombo ) ) then
				local x, y, z = getElementPosition( localPlayer )
				position = { x, y, z }
				local interior = getSelectedInterior( theCombo )
				local x1, y1, z1, x2, y2, z2 = housekeepingData[ interior ][ 3 ], housekeepingData[ interior ][ 4 ], housekeepingData[ interior ][ 5 ], housekeepingData[ interior ][ 6 ], housekeepingData[ interior ][ 7 ], housekeepingData[ interior ][ 8 ]
				setElementFrozen( localPlayer, true )
				setElementInterior( localPlayer, enterPositions[ interior ][ 1 ] )
				setCameraMatrix( x1, y1, z1, x2, y2, z2 )
			end
        end
    end
)

-- Reset position
function resetPlayerPosition ()
	if ( position[ 1 ] ) then
		setElementInterior( localPlayer, 0 )
		setElementPosition( localPlayer, position[ 1 ], position[ 2 ], position[ 3 ] + 0.8 )
		setElementFrozen( localPlayer, false )
		setCameraTarget ( localPlayer )
		position[ 1 ] = false
	end
end

-- Button to create a house
local spamProtection = false
local lastX = false

addEventHandler( "onClientGUIClick", housekeepingGUI.buttons[ 2 ],
	function ()
		if not ( getSelectedInterior( housekeepingGUI.comboboxs[ 1 ] ) ) then
			exports.VGdx:showMessageDX( "You didn't select an interior!", 225, 0, 0 )
		elseif not ( string.match( guiGetText( housekeepingGUI.edits[ 1 ] ) ,'^%d+$' ) ) then
			exports.VGdx:showMessageDX( "You didn't enter a valid house price!", 225, 0, 0 )
		elseif ( tonumber( houseNames[ getSelectedInterior( housekeepingGUI.comboboxs[ 1 ] ) ][ 2 ] ) > tonumber( guiGetText( housekeepingGUI.edits[ 1 ] ) ) ) then
			exports.VGdx:showMessageDX( "The price of the house is too low, at least use the minimum price!", 225, 0, 0 )
		elseif ( spamProtection ) and ( getTickCount()-spamProtection < 6000 ) then
			exports.VGdx:showMessageDX( "Wow, slow down! Working to fast creates mistakes!", 225, 0, 0 )
		elseif ( lastX == getElementPosition( localPlayer ) ) then
			exports.VGdx:showMessageDX( "Seems there is already a house at the position!", 225, 0, 0 )
		else
			lastX = getElementPosition( localPlayer )
			spamProtection = getTickCount()
			resetPlayerPosition ()
			triggerServerEvent( "onServerAddHouse", localPlayer, getSelectedInterior( housekeepingGUI.comboboxs[ 1 ] ), tonumber( guiGetText( housekeepingGUI.edits[ 1 ] ) ) )
		end
	end, false
)

-- Button to edit a house
addEventHandler( "onClientGUIClick", housekeepingGUI.buttons[ 5 ],
	function ()
		if not ( getSelectedInterior( housekeepingGUI.comboboxs[ 2 ] ) ) then
			exports.VGdx:showMessageDX( "You didn't select an interior!", 225, 0, 0 )
		elseif not ( string.match( guiGetText( housekeepingGUI.edits[ 6 ] ) ,'^%d+$' ) ) then
			exports.VGdx:showMessageDX( "You didn't enter a valid house price!", 225, 0, 0 )
		-- elseif not ( string.match( guiGetText( housekeepingGUI.edits[ 7 ] ) ,'^%d+$' ) ) then
			-- exports.VGdx:showMessageDX( "You didn't enter a valid house boughtprice!", 225, 0, 0 )
		elseif ( tonumber( houseNames[ getSelectedInterior( housekeepingGUI.comboboxs[ 2 ] ) ][ 2 ] ) > tonumber( guiGetText( housekeepingGUI.edits[ 6 ] ) ) ) then
			exports.VGdx:showMessageDX( "The price of the house is too low, at least use the minimum price!", 225, 0, 0 )
		-- elseif not ( string.match( guiGetText( housekeepingGUI.edits[ 5 ] ), '^[%w%s]*%w[%w%s]*$' ) ) then
			-- exports.VGdx:showMessageDX( "You didn't enter a valid username!", 225, 0, 0 )
		else
			resetPlayerPosition ()
			triggerServerEvent( "onServerEditHouse", localPlayer, tonumber( guiGetText( housekeepingGUI.edits[ 4 ] ) ), getSelectedInterior( housekeepingGUI.comboboxs[ 2 ] ), tonumber( guiGetText( housekeepingGUI.edits[ 6 ] ) ) )
		end
	end, false
)

-- Request house data from a house
addEventHandler( "onClientGUIClick", housekeepingGUI.buttons[ 3 ],
	function ()
		if not ( string.match( guiGetText( housekeepingGUI.edits[ 4 ] ) ,'^%d+$' ) ) then
			exports.VGdx:showMessageDX( "You didn't enter a valid house ID!", 225, 0, 0 )
		else
			triggerServerEvent( "onServerGetHouseData", localPlayer, tonumber( guiGetText( housekeepingGUI.edits[ 4 ] ) ) )
		end
	end, false
)

-- Request house data from a house
addEventHandler( "onClientGUIClick", housekeepingGUI.buttons[ 4 ],
	function ()
		if not ( string.match( guiGetText( housekeepingGUI.edits[ 4 ] ) ,'^%d+$' ) ) then
			exports.VGdx:showMessageDX( "You didn't enter a valid house ID!", 225, 0, 0 )
		else
			triggerServerEvent( "onServerDeleteHouse", localPlayer, tonumber( guiGetText( housekeepingGUI.edits[ 4 ] ) ) )
		end
	end, false
)

-- Request house data from a house
addEvent( "onServerGetHouseDataCallback", true )
addEventHandler( "onServerGetHouseDataCallback", root,
	function ( theTable, clear )
		if ( clear ) then
			guiComboBoxSetSelected ( housekeepingGUI.comboboxs[ 2 ], -1 )
			guiSetText( housekeepingGUI.edits[ 6 ], "" )
			guiSetText( housekeepingGUI.edits[ 7 ], "" )
			guiSetText( housekeepingGUI.edits[ 5 ], "" )
		else
			guiComboBoxSetSelected ( housekeepingGUI.comboboxs[ 2 ], housekeepingGUI.comboboxindex[ theTable.interior ] )
			guiSetText( housekeepingGUI.edits[ 6 ], theTable.houseprice )
		end
	end
)