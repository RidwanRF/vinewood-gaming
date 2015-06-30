


-- Get the screen size
local sW, sH = guiGetScreenSize()
exports.VGhud:setPhoneEnabled( false )

caseWidth,caseHeight = 289,527
BGWidth,BGHeight = 245,414
caseX,caseY = sW-caseWidth-18,sH-caseHeight-48
BGX,BGY = sW-BGWidth-40,sH-BGHeight-110
labelWidth,labelHeight = 63, 20
LBX,LBY = sW-labelWidth-120,sH-labelHeight-72

-- Table with all the apps in it
local horizontal = 60
apps = { 
	-- Row 1
	{ nil, BGX+8+(horizontal*0), BGY+18, 56, 54, "icons/phone.png", false, false, false, "Phone" },
	{ nil, BGX+8+(horizontal*1), BGY+18, 56, 54, "icons/contacts.png", false, false, false, "Contacts" },
	{ nil, BGX+8+(horizontal*2), BGY+18, 56, 54, "icons/messages.png", false, false, false, "SMS" },
	{ nil, BGX+8+(horizontal*3), BGY+18, 56, 54, "icons/maps.png", false, false, false, "Maps" },
	-- Row 2
	{ nil, BGX+8+(horizontal*0), BGY+98, 56, 54, "icons/vsettings.png", false, false, false, "Visual Settings" },
	{ nil, BGX+8+(horizontal*1), BGY+98, 56, 54, "icons/mods.png", false, false, false, "Modded Files" },
	{ nil, BGX+8+(horizontal*2), BGY+98, 56, 54, "icons/settings.png", false, false, false, "General Settings" },
	{ nil, BGX+8+(horizontal*3), BGY+98, 56, 54, "icons/calendar.png", false, false, false, "Calendar" },
	-- Row 3
	{ nil, BGX+8+(horizontal*0), BGY+178, 56, 54, "icons/calculator.png", false, false, false, "Calculator" },
	{ nil, BGX+8+(horizontal*1), BGY+178, 56, 54, "icons/news.png", false, false, false, "News" },
	{ nil, BGX+8+(horizontal*2), BGY+178, 56, 54, "icons/notes.png", false, false, false, "Notes" },
}

-- Some global variables and tables
drawText = false
isPhoneVisable = false
hasAppOpen = false
phoneGUI = {}
appGUI = {}

-- Function that creates the apps
function createApps ()
	for i, v in ipairs( apps ) do
		v[1] = guiCreateStaticImage(v[2], v[3], v[4], v[5], v[6], false ) 
		table.insert ( appGUI, v[1] )
		guiSetProperty ( v[1], "AlwaysOnTop", "True" )
	end
	addEventHandler ( "onClientMouseEnter", root, onAppMouseEnter )
	addEventHandler ( "onClientMouseLeave", root, onAppMouseLeave )
end

-- Function that creates the phone
function createPhone ()
	if not ( phoneGUI[1] ) then
		local aPhone = guiCreateStaticImage( BGX, BGY, BGWidth +12, BGHeight +12, "backgrounds/background1.png", false )
		table.insert ( phoneGUI, aPhone )
	end
	if not ( phoneGUI[2] ) then
		local aBackground = guiCreateStaticImage( caseX, caseY, caseWidth +12, caseHeight +12, "images/phone.png", false )
		table.insert ( phoneGUI, aBackground )
	end
	if not ( phoneGUI[3] ) then
		local aLabel = guiCreateLabel ( LBX, LBY, labelWidth, labelHeight, "", false )
		guiSetProperty ( aLabel, "AlwaysOnTop", "True" ) guiBringToFront( aLabel )
		table.insert ( phoneGUI, aLabel )
	end
	if not ( phoneGUI[4] ) then
		local aBackground2 = guiCreateStaticImage(BGX, BGY, BGWidth +12, BGHeight +12, "backgrounds/background0.png", false )
		table.insert ( phoneGUI, aBackground2 )
	end
	guiSetVisible( phoneGUI[1], true )
	guiSetVisible( phoneGUI[2], true )
	guiSetVisible( phoneGUI[3], true )
	guiSetVisible( phoneGUI[4], false )
	addEventHandler ( "onClientGUIClick", root, onAppMouseClick )
end

-- Key to show the phone
bindKey ( "n", "down", 
	function ()
		if ( exports.VGaccounts:isPlayerLoggedIn( localPlayer ) ) then
			if not ( isPhoneVisable ) then
				if ( getElementHealth( localPlayer ) == 0 ) then return end
				createPhone ()
				createApps ()
				showCursor( true )
				isPhoneVisable = true
				guiSetInputMode( "no_binds_when_editing" )
				exports.VGhud:setPhoneEnabled( true )
			else
				if ( hasAppOpen ) then
					for i=1, #apps do
						if ( apps[i][9] ) then 
							closeApp( apps[i][8] ) 
						end
					end
				end
				destroyPhone ()
				showCursor( false )
				isPhoneVisable = false
				hasAppOpen = false
				exports.VGhud:setPhoneEnabled( false )
			end
		end
	end
)

-- When the player dies
addEventHandler( "onClientPlayerWasted", localPlayer,
	function ()
		if ( source ~= localPlayer ) then return end
		if ( hasAppOpen ) then
			for i=1, #apps do
				if ( apps[i][9] ) then 
					closeApp( apps[i][8] ) 
				end
			end
		end
		destroyPhone ()
		showCursor( false )
		isPhoneVisable = false
		hasAppOpen = false
		exports.VGhud:setPhoneEnabled( false )
	end
)

-- Function that destroys the phone
function destroyPhone()
	for i, aImage in ipairs( phoneGUI ) do
		guiSetVisible( aImage, false )
	end
	for i, aApp in ipairs( appGUI ) do
		destroyElement( aApp )
	end
	drawText = false
	appGUI = {}
	removeEventHandler ( "onClientMouseEnter", root, onAppMouseEnter )
	removeEventHandler ( "onClientMouseLeave", root, onAppMouseLeave )
	removeEventHandler ( "onClientGUIClick", root, onAppMouseClick )
end

-- Function for when you move over the app
function onAppMouseEnter ()
	if ( source == phoneGUI[3] ) then
		drawText = "Return"
		addEventHandler( "onClientRender", root, drawPopUpText )
		return
	end
	
	for i, v in ipairs( apps ) do		
		if ( v[1] == source ) then			
			local image, X, Y, width, height = v[1], v[2], v[3], v[4], v[5]
			guiSetSize ( image, width+10, height+10, false )
			guiSetPosition ( image, X-5, Y-5, false )	
			drawText = v[10]
			addEventHandler( "onClientRender", root, drawPopUpText )
			return
		end
	end
end

-- Function when you leave the app
function onAppMouseLeave ()
	if ( source == phoneGUI[3] ) then
		drawText = false
		removeEventHandler( "onClientRender", root, drawPopUpText )
		return
	end
	
	for i, v in ipairs( apps ) do			
		if ( v[1] == source ) then
			local image, X, Y, width, height = v[1], v[2], v[3], v[4], v[5]	
			guiSetSize ( image, width, height, false )
			guiSetPosition ( image, X, Y, false )
			drawText = false
			removeEventHandler( "onClientRender", root, drawPopUpText )
			return
		end
	end
end

-- Function that draws the text above the popup
function drawPopUpText ()
	local x, y = getCursorPosition ( )
	if not ( x ) or not ( drawText ) then removeEventHandler( "onClientRender", root, drawPopUpText ) return end
	local cursorsX, corsorsY = ( x * sW ), ( y * sH )
    exports.VGdrawing:dxDrawBorderedText( drawText, cursorsX + 15, corsorsY, sW*(766.0/1440), sH*(380.0/900), tocolor(255, 255, 255, 255), sW*(0.5/1440), "bankgothic", "left", "top", tocolor ( 0, 0, 0, 255 ), false, false, true, false )
end

-- When the player clicks an app
function onAppMouseClick ()
	for i=1, #apps do
		if ( apps[i][1] == source ) then
			if ( apps[i][7] ) then openApp( apps[i][7] ) end
			return
		end
	end
	
	if ( source == phoneGUI[3] ) then
		if ( hasAppOpen ) then
			for i=1, #apps do
				if ( apps[i][9] ) then 
					closeApp( apps[i][8] )
					return
				end
			end
		else
			destroyPhone ()
			showCursor( false )
			isPhoneVisable = false
			hasAppOpen = false
		end
	end
end

-- Function that opens the app
function openApp( theApp )
	guiSetVisible( phoneGUI[4], true ) guiSetVisible( phoneGUI[1], false ) guiMoveToBack( phoneGUI[4] )
	for i, app in ipairs( apps ) do
		if ( isElement( app[1] ) ) then 
			guiSetVisible ( app[1], false )
		end
	end
	theApp()
	hasAppOpen = true
	drawText = false
	removeEventHandler( "onClientRender", root, drawPopUpText )
	removeEventHandler ( "onClientMouseEnter", root, onAppMouseEnter )
	removeEventHandler ( "onClientMouseLeave", root, onAppMouseLeave )
end

-- Function that closes the app
function closeApp( theApp )
	guiSetVisible( phoneGUI[1], true ) guiSetVisible( phoneGUI[4], false ) guiMoveToBack( phoneGUI[1] )
	hasAppOpen = false
	theApp()
	createApps ()
end

-- Function to set a app visible
function setAppVisible( id, state )
	apps[id][9] = state
end

-- Function register the open function
function registerAppOpenFunction( id, func )
	apps[id][7] = func
end

-- Function register the close function
function registerAppCloseFunction( id, func )
	apps[id][8] = func
end