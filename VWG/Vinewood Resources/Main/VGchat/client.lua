



-- The languages
local languages = {
	[ "NL" ] = { "Dutch" },
	[ "BE" ] = { "Dutch" },
	[ "DE" ] = { "German" },
	[ "BY" ] = { "Belarusian" },
	[ "EG" ] = { "Arabic", },
	[ "TN" ] = { "Arabic", },
	[ "TR" ] = { "Arabic", },
	[ "SE" ] = { "Swedish" },
	[ "FI" ] = { "Swedish" },
	[ "RU" ] = { "Russian" },
	[ "PL" ] = { "Polish" },
	[ "IN" ] = { "Hindi" },
	[ "GR" ] = { "Greek" },
	[ "AL" ] = { "Albanian" },
	[ "RU" ] = { "Russian" },
	[ "HR" ] = { "Croation" },
	[ "SI" ] = { "Slovenian" },
}

-- Table with the chats
local chats = { "Support", "Main", "Team", "Local" }

-- The function that handles the chat output
function onClientGUIChatMessage ()
	local theTab = guiGetText( guiGetSelectedTab( GUIchat.tabpanel[1] ) )
	local theMessage = guiGetText( GUIchat.edit[theTab] )
	if ( string.match( theMessage, "^%s*$" ) ) then
		return
	else
		triggerServerEvent( "onServerGUIChatMessage", localPlayer, theMessage, theTab )
		guiSetText( GUIchat.edit[theTab], "" )
	end
end

-- When a checkbox changes
function onOutputSettingChange ()
	local aName = guiGetText( guiGetSelectedTab( GUIchat.tabpanel[1] ) )
	if ( GUIchat.tab[aName] ) then
		exports.VGsettings:setPlayerSetting( "chat"..aName, guiCheckBoxGetSelected( GUIchat.checkbox[aName] ) )
		setElementData( localPlayer, "chat"..aName, guiCheckBoxGetSelected( GUIchat.checkbox[aName] ) )
	end
end


-- Table with the GUI
GUIchat = {
    tab = {},
    edit = {},
    window = {},
    gridlist = {},
    checkbox = {},
    tabpanel = {},
}

-- The window
GUIchat.window[1] = guiCreateWindow(459, 306, 637, 376, "Network of Entertainment and Gaming", false)
guiWindowSetSizable(GUIchat.window[1], false)
GUIchat.tabpanel[1] = guiCreateTabPanel(9, 21, 619, 346, false, GUIchat.window[1])

addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		-- Add the country chat
		if ( languages[ getElementData( localPlayer, "Country" ) ] ) then
			chats = { "Support", "Main", "Team", "Local", languages[ getElementData( localPlayer, "Country" ) ][ 1 ] }
		end
		-- Create the tabs for all the chats
		for i, aName in ipairs ( chats ) do
			if ( aName ) then
				GUIchat.tab[aName] = guiCreateTab(aName, GUIchat.tabpanel[1])
				GUIchat.gridlist[aName] = guiCreateGridList(2, 1, 616, 292, false, GUIchat.tab[aName])
				GUIchat.edit[aName] = guiCreateEdit(1, 292, 491, 29, "", false, GUIchat.tab[aName])
				GUIchat.checkbox[aName] = guiCreateCheckBox(496, 299, 122, 15, "Enable output", true, false, GUIchat.tab[aName])
				guiSetFont(GUIchat.checkbox[aName], "default-bold-small")
				guiGridListAddColumn( GUIchat.gridlist[aName], "Nickname:", 0.25 )
				guiGridListAddColumn( GUIchat.gridlist[aName], "Message:", 0.72 )
				
				addEventHandler( "onClientGUIClick", GUIchat.checkbox[aName], onOutputSettingChange, false )
				addEventHandler( "onClientGUIAccepted", GUIchat.edit[aName], onClientGUIChatMessage )
				
				exports.VGsettings:addPlayerSetting( "chat"..aName, true )
				guiCheckBoxSetSelected ( GUIchat.checkbox[aName], exports.VGsettings:getPlayerSetting( "chat"..aName ) )
				setElementData( localPlayer, "chat"..aName, exports.VGsettings:getPlayerSetting( "chat"..aName ) )
			end
		end
	end
)

-- Center the window
local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize( GUIchat.window[1], false )
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition( GUIchat.window[1], x, y, false )

guiWindowSetMovable ( GUIchat.window[1], true )
guiWindowSetSizable ( GUIchat.window[1], false )
guiSetVisible ( GUIchat.window[1], false )

-- Bind the key to open the chat
bindKey( "j", "down",
	function()
		if not ( exports.VGaccounts:isPlayerLoggedIn ( localPlayer ) ) then return end
		if ( guiGetVisible ( GUIchat.window[1] ) ) then
			guiSetVisible( GUIchat.window[1], false )
			showCursor( false )
		else
			guiSetVisible( GUIchat.window[1], true )
			showCursor( true )
			guiSetInputMode("no_binds_when_editing")
		end
	end
)

-- Event that puts the messages in the GUI
addEvent( "onClientSendMessageToGUI", true )
addEventHandler("onClientSendMessageToGUI", root,
	function ( thePlayer, theMessage, theChat )
		if ( GUIchat.gridlist[theChat] ) then
			if ( thePlayer ) then
				local row = guiGridListInsertRowAfter ( GUIchat.gridlist[theChat], -1 )
				guiGridListSetItemText ( GUIchat.gridlist[theChat], row, 1, getPlayerName( thePlayer ), false, false )
				guiGridListSetItemText ( GUIchat.gridlist[theChat], row, 2, string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), false, false )
				
				if ( exports.VGadmin:isPlayerAdmin( thePlayer ) ) then
					guiGridListSetItemColor ( GUIchat.gridlist[theChat], row, 1, 255, 128, 0 )
					guiGridListSetItemColor ( GUIchat.gridlist[theChat], row, 2, 255, 128, 0 )
				end
			end
		end
	end
)