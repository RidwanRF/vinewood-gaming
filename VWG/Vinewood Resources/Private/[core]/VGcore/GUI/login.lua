


-- Get the screen size
local sx, sy = guiGetScreenSize()

-- The state of the 2 tick boxes
local saveUsername = false
local savePassword = false

-- Function when you press enter
function onClientPressedEnter ()
	triggerEvent( "onClientLoginButtonClicked", root, guiGetText( GUILogin.edits[1] ), guiGetText( GUILogin.edits[2] ), saveUsername, savePassword )
end

-- Function that shows the login window
function setLoginWindowVisable ( state )
	if ( state ) then bindKey ( "enter", "down", onClientPressedEnter ) else unbindKey ( "enter", "down", onClientPressedEnter ) end
	local username, password = getAccountXMLData ()
	
	guiSetText( GUILogin.edits[1], username )
	guiSetText( GUILogin.edits[2], password )
	
	if ( username == "" ) then guiStaticImageLoadImage ( GUILogin.images[11], "images/tick_unticked.png" ) saveUsername = false else guiStaticImageLoadImage ( GUILogin.images[11], "images/tick_ticked.png" ) saveUsername = true end
	if ( password == "" ) then guiStaticImageLoadImage ( GUILogin.images[12], "images/tick_unticked.png" ) savePassword = false else guiStaticImageLoadImage ( GUILogin.images[12], "images/tick_ticked.png" ) savePassword = true end
	
	for k, aTable in pairs ( GUILogin ) do
		for k, element in pairs ( aTable ) do
			if ( isElement( element ) ) then
				if ( element == GUILogin.edits[1] ) or ( element == GUILogin.edits[2] ) then
					setEditBoxVisable( element, state )
				else
					guiSetVisible( element, state )
				end
			end
		end
	end
end

-- Get the username and/or password is saved
function getAccountXMLData ()
	local theFile = xmlLoadFile ( "@userdata.xml" )
	if not ( theFile ) then
		local theFile = xmlCreateFile( "@userdata.xml","accounts" )
		xmlCreateChild( theFile, "username" )
		xmlCreateChild( theFile, "password" )
		xmlSaveFile( theFile )
		return "", ""
	else
		usernameNode = xmlFindChild( theFile, "username", 0 )
		username = xmlNodeGetValue ( usernameNode )
		passwordNode = xmlFindChild( theFile, "password", 0 )
		password = xmlNodeGetValue ( passwordNode )
		return username, password
	end
	xmlUnloadFile ( theFile )
end

-- Update the XML file with the new data
function setAccountXMLData( username, password, usernameTick, passwordTick )
	local theFile = xmlLoadFile ( "@userdata.xml" )
	if ( theFile ) then
		-- If we want to save the username
		if ( usernameTick ) then
			xmlNodeSetValue( xmlFindChild( theFile, "username", 0 ), username )
		else
			xmlNodeSetValue( xmlFindChild( theFile, "username", 0 ), "" )
		end
		
		-- If we want to save the password
		if ( passwordTick ) then
			xmlNodeSetValue( xmlFindChild( theFile, "password", 0 ), password )
		else
			xmlNodeSetValue( xmlFindChild( theFile, "password", 0 ), "" )
		end
		-- Close all the files
		xmlSaveFile( theFile )
		xmlUnloadFile ( theFile )
	end
end

-- Table with the login GUI
GUILogin = {
    images = {},
    edits = {},
    labels = {},
}

-- GUI code itself
GUILogin.images[1] = guiCreateStaticImage(sx*(329.0/1440),sy*(376.0/900),sx*(173.0/1440),sy*(26.0/900), "images/your_username_label.png", false)
GUILogin.images[2] = guiCreateStaticImage(sx*(329.0/1440),sy*(429.0/900),sx*(175.0/1440),sy*(28.0/900), "images/your_password_label.png", false)
GUILogin.images[5] = guiCreateStaticImage(sx*(767.0/1440),sy*(223.0/900),sx*(3.0/1440),sy*(421.0/900), "images/color_line.png", false)
GUILogin.images[6] = guiCreateStaticImage(sx*(897.0/1440),sy*(453.0/900),sx*(376.0/1440),sy*(191.0/900), "images/hydra_logo.png", false)
GUILogin.images[7] = guiCreateStaticImage(sx*(792.0/1440),sy*(223.0/900),sx*(320.0/1440),sy*(84.0/900), "images/register_label.png", false)
GUILogin.images[9] = guiCreateStaticImage(sx*(792.0/1440),sy*(362.0/900),sx*(261.0/1440),sy*(27.0/900), "images/new_password_label.png", false)
GUILogin.images[10] = guiCreateStaticImage(sx*(792.0/1440),sy*(399.0/900),sx*(192.0/1440),sy*(43.0/900), "images/forget_password_button.png", false)
GUILogin.images[11] = guiCreateStaticImage(sx*(536.0/1440),sy*(467.0/900),sx*(17.0/1440),sy*(16.0/900), "images/tick_unticked.png", false)
GUILogin.images[12] = guiCreateStaticImage(sx*(536.0/1440),sy*(495.0/900),sx*(17.0/1440),sy*(16.0/900), "images/tick_unticked.png", false)
GUILogin.images[13] = guiCreateStaticImage(sx*(558.0/1440),sy*(467.0/900),sx*(149.0/1440),sy*(18.0/900), "images/remember_username_label.png", false)
GUILogin.images[14] = guiCreateStaticImage(sx*(558.0/1440),sy*(495.0/900),sx*(148.0/1440),sy*(18.0/900), "images/remember_password_label.png", false)
GUILogin.images[15] = guiCreateStaticImage(sx*(531.0/1440),sy*(526.0/900),sx*(126.0/1440),sy*(43.0/900), "images/sign_in_button.png", false)

GUILogin.edits[1] = createEditBox( sx*(532.0/1440),sy*(372.0/900),sx*(220.0/1440),sy*(36.0/900) )
GUILogin.edits[2] = createEditBox( sx*(532.0/1440),sy*(425.0/900),sx*(220.0/1440),sy*(36.0/900), true )

setLoginWindowVisable ( false )

-- Check if player is loggedin, if not show login
if not ( exports.VGaccounts:isPlayerLoggedIn ( localPlayer ) ) then
	setLoginWindowVisable ( true )
	showCursor( true )
end

-- When the player clicks the mouse
addEventHandler ( "onClientClick", root,
	function ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "left" ) then
			if ( isDrawElementSelected(sx*(531.0/1440),sy*(526.0/900),(sx*(531.0/1440))+(sx*(126.0/1440)),(sy*(526.0/900))+(sy*(43.0/900))) ) then
				if ( state == "down" ) then guiStaticImageLoadImage ( GUILogin.images[15], "images/sign_in_button_clicked.png" ) elseif ( state == "up" ) then guiStaticImageLoadImage ( GUILogin.images[15], "images/sign_in_button.png" ) end
				return
			end
			
			if ( isDrawElementSelected(sx*(792.0/1440),sy*(399.0/900),(sx*(792.0/1440))+(sx*(192.0/1440)),(sy*(399.0/900))+(sy*(43.0/900))) ) then
				if ( state == "down" ) then guiStaticImageLoadImage ( GUILogin.images[10], "images/forget_password_button_clicked.png" ) elseif ( state == "up" ) then guiStaticImageLoadImage ( GUILogin.images[10], "images/forget_password_button.png" ) end
				return
			end
		end
	end
)

-- When the player leaves the element with the mouse
addEventHandler( "onClientMouseLeave", root, 
	function( absoluteX, absoluteY )
		if ( source == GUILogin.images[15] ) then
			guiStaticImageLoadImage ( GUILogin.images[15], "images/sign_in_button.png" )
		elseif ( source == GUILogin.images[10] ) then
			guiStaticImageLoadImage ( GUILogin.images[10], "images/forget_password_button.png" )
		end
	end
)

-- Click handler for the tick boxes
addEventHandler ( "onClientGUIClick", root, 
	function ( button, state )
		if ( button == "left" ) and ( state == "up" ) then
			if ( source == GUILogin.images[11] ) then
				if ( saveUsername ) then guiStaticImageLoadImage ( GUILogin.images[11], "images/tick_unticked.png" ) saveUsername = false else guiStaticImageLoadImage ( GUILogin.images[11], "images/tick_ticked.png" ) saveUsername = true end
			elseif ( source == GUILogin.images[12] ) then
				if ( savePassword ) then guiStaticImageLoadImage ( GUILogin.images[12], "images/tick_unticked.png" ) savePassword = false else guiStaticImageLoadImage ( GUILogin.images[12], "images/tick_ticked.png" ) savePassword = true end
			-- Events for the buttons that are clicked
			elseif ( source == GUILogin.images[15] ) then
				triggerEvent( "onClientLoginButtonClicked", root, guiGetText( GUILogin.edits[1] ), guiGetText( GUILogin.edits[2] ), saveUsername, savePassword )
			elseif ( source == GUILogin.images[10] ) then
				setLoginWindowVisable ( false )
				setPasswordWindowVisable ( true )
			end
		end
	end
)

-- Check the the draw element is selected
function isDrawElementSelected ( minX, minY, maxX, maxY )
	local x, y = getCursorPosition()
	if ( sx*x >= minX ) and ( sx*x <= maxX ) then
		if ( sy*y >= minY ) and ( sy*y <= maxY ) then
			return true
		else
			return false
		end
	else
		return false
	end
end