-- The ID off the app, ask Dennis to add an app and icon
local APPID = 6
local GUI = {}

-- Function that gets triggerd when the app opens
function onVisualSettingsAppOpen()	
	-- When the app opens set the GUI visable and on top
	local size = 124
	if not ( GUI[1] ) then GUI[1] = guiCreateGridList ( BGX+4, BGY+18, 248, 370, false ) guiGridListAddColumn( GUI[1], "Modded File:", 0.86 ) end
	if not ( GUI[2] ) then GUI[2] = guiCreateButton ( BGX+4, BGY+392, size, 25, "Enable Mod", false ) end
	if not ( GUI[3] ) then GUI[3] = guiCreateButton ( BGX+(4+size), BGY+392, size, 25, "Disable Mod", false ) end
	
	-- Put everything in the grid
	guiGridListClear( GUI[1] )
	guiGridListSetSortingEnabled( GUI[1], false )
	for k, tbl in ipairs( exports.VGmods:getDownloadTable() ) do
		if not ( tbl.skiptoggle ) then
			local row = guiGridListAddRow ( GUI[1] )
			guiGridListSetItemText ( GUI[1], row, 1, tbl.name, false, false )
			if ( tbl.skipinstall ) then
				guiGridListSetItemColor ( GUI[1], row, 1, 225, 0, 0 )
			else
				guiGridListSetItemColor ( GUI[1], row, 1, 0, 225, 0 )
			end
		end
	end
	
	addEventHandler( "onClientGUIClick", GUI[2], toggleModEnabled, false )
	addEventHandler( "onClientGUIClick", GUI[3], toggleDisabled, false )
		
	-- When the app opens set the GUI visable and on top
	for i=1, #GUI do
		guiSetVisible ( GUI[i], true )
		guiSetProperty ( GUI[i], "AlwaysOnTop", "True" )
	end
	
	setAppVisible( APPID, true )
end

-- When the player enables a mod
function toggleModEnabled ()
	if ( guiGridListGetSelectedItem ( GUI[1] ) == -1 ) then exports.VGdx:showMessageDX( "You didn't select a mod!", 225, 0, 0 ) return end
	local modFile = guiGridListGetItemText ( GUI[1], guiGridListGetSelectedItem ( GUI[1] ), 1 )
	if ( modFile ) then
		for k, tbl in ipairs( exports.VGmods:getDownloadTable() ) do
			if ( tbl.name == modFile ) then
				exports.VGmods:setModEnabled( tbl.modelid )
				guiGridListSetItemColor ( GUI[1], guiGridListGetSelectedItem ( GUI[1] ), 1, 0, 225, 0 )
				return
			end
		end
	end
end

-- When the player disables a mod
function toggleDisabled ()
	if ( guiGridListGetSelectedItem ( GUI[1] ) == -1 ) then exports.VGdx:showMessageDX( "You didn't select a mod!", 225, 0, 0 ) return end
	local modFile = guiGridListGetItemText ( GUI[1], guiGridListGetSelectedItem ( GUI[1] ), 1 )
	if ( modFile ) then
		for k, tbl in ipairs( exports.VGmods:getDownloadTable() ) do
			if ( tbl.name == modFile ) then
				exports.VGmods:setModDisabled( tbl.modelid )
				guiGridListSetItemColor ( GUI[1], guiGridListGetSelectedItem ( GUI[1] ), 1, 225, 0, 0 )
				return
			end
		end
	end
end

-- Function to register the function that should open the app
registerAppOpenFunction( APPID, onVisualSettingsAppOpen )

-- Function that gets triggerd when the app closes
function onVisualSettingsAppClose()
	-- Hide the GUI
	for i=1, #GUI do
		guiSetVisible ( GUI[i], false )
	end
	
	removeEventHandler( "onClientGUIClick", GUI[2], toggleModEnabled, false )
	removeEventHandler( "onClientGUIClick", GUI[3], toggleDisabled, false )
	
	setAppVisible( APPID, false )
end

-- Function to register the function that should close the app
registerAppCloseFunction( APPID, onVisualSettingsAppClose )