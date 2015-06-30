
local tostring = tostring




-- Load the settings file if there's any or create it otherwise
local settingFile = xmlLoadFile ( "settings.xml" )
if not ( settingFile ) then
	settingFile = xmlCreateFile( "settings.xml","settings" )
end
xmlSaveFile( settingFile )

-- Function to get a player setting
function getPlayerSetting ( aSetting )
	local theNode = xmlFindChild( settingFile, tostring( aSetting ), 0 )
	if ( theNode ) and ( settingFile ) then
		local theNodeValue = xmlNodeGetValue ( theNode )
		if ( theNodeValue ) then
			if ( theNodeValue == "true" ) then
				return true
			elseif ( theNodeValue == "false" ) then
				return false
			else
				return theNodeValue
			end
		else
			return false
		end
	else
		return false
	end
end

-- Function to set a player setting
function setPlayerSetting ( aSetting, value )
	local oldValue = getPlayerSetting ( aSetting )
	local theNode = xmlFindChild( settingFile, tostring( aSetting ), 0 )
	if ( theNode ) and ( settingFile ) then
		xmlNodeSetValue( theNode, tostring( value ) )
		triggerEvent ( "onClientPlayerSettingChange", localPlayer, aSetting, getPlayerSetting ( aSetting ), oldValue )
		outputDebugString( "Setting " .. aSetting .. " updated: "..tostring( value ) )
		xmlSaveFile( settingFile )
		return true
	else
		return false
	end
end

-- Function to add a player setting
function addPlayerSetting ( aSetting, value )
	if ( aSetting ) and ( settingFile ) then
		local theNode = xmlFindChild( settingFile, tostring( aSetting ), 0 )
		if ( theNode ) then
			return false
		else
			xmlNodeSetValue( xmlCreateChild( settingFile, tostring( aSetting ) ), tostring ( value ) )
			outputDebugString( "Setting " .. aSetting .. " created: "..tostring( value ) )
			xmlSaveFile( settingFile )
			return true
		end
	else
		return false
	end
end