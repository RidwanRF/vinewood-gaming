-- The ID off the app, ask Dennis to add an app and icon
local APPID = 5

-- Function when the resource starts
addEventHandler ( 'onClientResourceStart', resourceRoot, 
	function () 
		-- Create the table with the settings
		settingsTable = {
			{ nil, "speedmeter", "true", BGX+8, BGY+18+(0*20), 236, 19, "Show vehicle speedometer" },
			{ nil, "fuelmeter", "true", BGX+8, BGY+18+(1*20), 236, 19, "Show vehicle fuelmeter" },
			{ nil, "radar", "true", BGX+8, BGY+18+(2*20), 236, 19, "Show radar city and area names" },
			{ nil, "blur", "false", BGX+8, BGY+18+(3*20), 236, 19, "Show blur while driving" },
			{ nil, "clouds", "true", BGX+8, BGY+18+(4*20), 236, 19, "Show clouds" },
			{ nil, "fpsmeter", "false", BGX+8, BGY+18+(5*20), 236, 19, "Show digital FPS meter" },
			{ nil, "sms", "true", BGX+8, BGY+18+(6*20), 236, 19, "Show SMS messages in chat" },
			{ nil, "shader1", "false", BGX+8, BGY+18+(8*20), 236, 19, "Enable road shine shader" },
			{ nil, "shader2", "true", BGX+8, BGY+18+(9*20), 236, 19, "Enable realistic water shader" },
			{ nil, "shader3", "false", BGX+8, BGY+18+(10*20), 236, 19, "Enable bloom shader" },
			{ nil, "shader4", "false", BGX+8, BGY+18+(11*20), 236, 19, "Enable HDR shader" },
			{ nil, "shader5", "false", BGX+8, BGY+18+(12*20), 236, 19, "Enable HD detail shader" },
			{ nil, "shader6", "false", BGX+8, BGY+18+(13*20), 236, 19, "Enable radial blur shader" },
			{ nil, "shader7", "false", BGX+8, BGY+18+(14*20), 236, 19, "Enable shiny cars shader" },
			{ nil, "shader8", "true", BGX+8, BGY+18+(15*20), 236, 19, "Enable carwash cleaning shader" },
		}
		
		for i=1, #settingsTable do
			exports.VGsettings:addPlayerSetting( settingsTable[i][2], settingsTable[i][3] )
		end
	end
)

-- Function that gets triggerd when the app opens
function onVisualSettingsAppOpen()	
	-- When the app opens set the GUI visable and on top
	for i=1, #settingsTable do
		if not ( settingsTable[i][1] ) then
			settingsTable[i][1] = guiCreateCheckBox ( settingsTable[i][4], settingsTable[i][5], settingsTable[i][6], settingsTable[i][7], settingsTable[i][8], true, false )
		end
		
		guiCheckBoxSetSelected( settingsTable[i][1], exports.VGsettings:getPlayerSetting( settingsTable[i][2] ) )
		guiSetVisible ( settingsTable[i][1], true )
		guiSetProperty ( settingsTable[i][1], "AlwaysOnTop", "True" )
	end
	
	addEventHandler( "onClientGUIClick", root, onClientSettingClick )
	
	setAppVisible( APPID, true )
end

-- Function to register the function that should open the app
registerAppOpenFunction( APPID, onVisualSettingsAppOpen )

-- Function that gets triggerd when a settings changes
function onClientSettingClick ()
	for i=1, #settingsTable do
		if ( settingsTable[i][1] == source ) then
			exports.VGsettings:setPlayerSetting( settingsTable[i][2], guiCheckBoxGetSelected( source ) )
			return
		end
	end
end

-- Function that gets triggerd when the app closes
function onVisualSettingsAppClose()
	-- Hide the GUI
	for i=1,#settingsTable do
		guiSetVisible ( settingsTable[i][1], false )
	end
	
	removeEventHandler( "onClientGUIClick", root, onClientSettingClick )
	
	setAppVisible( APPID, false )
end

-- Function to register the function that should close the app
registerAppCloseFunction( APPID, onVisualSettingsAppClose )