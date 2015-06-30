


-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Table with the login GUI
GUIPassword = {
    images = {},
    edits = {},
    labels = {},
}

-- Functions to show and hide
function setPasswordWindowVisable ( state )
	for k, aTable in pairs ( GUIPassword ) do
		for k, element in pairs ( aTable ) do
			if ( isElement( element ) ) then
				if ( element == GUIPassword.edits[1] ) or ( element == GUIPassword.edits[2] ) then
					setEditBoxVisable( element, state )
				else
					guiSetVisible( element, state )
				end
			end
		end
	end
end

-- GUI code itself
GUIPassword.images[1] = guiCreateStaticImage(sx*(329.0/1440),sy*(376.0/900),sx*(173.0/1440),sy*(26.0/900), "images/your_username_label.png", false)
GUIPassword.images[4] = guiCreateStaticImage(sx*(767.0/1440),sy*(223.0/900),sx*(3.0/1440),sy*(421.0/900), "images/color_line.png", false)
GUIPassword.images[5] = guiCreateStaticImage(sx*(897.0/1440),sy*(453.0/900),sx*(376.0/1440),sy*(191.0/900), "images/hydra_logo.png", false)
GUIPassword.images[7] = guiCreateStaticImage(sx*(791.0/1440),sy*(356.0/900),sx*(296.0/1440),sy*(84.0/900), "images/register_label.png", false)
GUIPassword.images[9] = guiCreateStaticImage(sx*(792.0/1440),sy*(291.0/900),sx*(191.0/1440),sy*(41.0/900), "images/back_to_login_button.png", false)
GUIPassword.images[10] = guiCreateStaticImage(sx*(791.0/1440),sy*(255.0/900),sx*(286.0/1440),sy*(27.0/900), "images/back_to_login_label.png", false)
GUIPassword.images[11] = guiCreateStaticImage(sx*(532.0/1440),sy*(420.0/900),sx*(192.0/1440),sy*(43.0/900), "images/request_password_button.png", false)

GUIPassword.edits[1] = createEditBox( sx*(532.0/1440),sy*(372.0/900),sx*(220.0/1440),sy*(36.0/900) )

setPasswordWindowVisable ( false )

-- When the player clicks the mouse
addEventHandler ( "onClientClick", root,
	function ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
		if ( button == "left" ) then
			if ( isDrawElementSelected(sx*(532.0/1440),sy*(420.0/900),(sx*(532.0/1440))+(sx*(192.0/1440)),(sy*(420.0/900))+(sy*(43.0/900))) ) then
				if ( state == "down" ) then guiStaticImageLoadImage ( GUIPassword.images[11], "images/request_password_button_clicked.png" ) elseif ( state == "up" ) then guiStaticImageLoadImage ( GUIPassword.images[11], "images/request_password_button.png" ) end
				return
			end
			
			if ( isDrawElementSelected(sx*(792.0/1440),sy*(291.0/900),(sx*(792.0/1440))+(sx*(191.0/1440)),(sy*(291.0/900))+(sy*(41.0/900))) ) then
				if ( state == "down" ) then guiStaticImageLoadImage ( GUIPassword.images[9], "images/back_to_login_button_clicked.png" ) elseif ( state == "up" ) then guiStaticImageLoadImage ( GUIPassword.images[9], "images/back_to_login_button.png" ) end
				return
			end
		end
	end
)


-- When the player leaves the element with the mouse
addEventHandler( "onClientMouseLeave", root, 
	function( absoluteX, absoluteY )
		if ( source == GUIPassword.images[11] ) then
			guiStaticImageLoadImage ( GUIPassword.images[11], "images/request_password_button.png" )
		elseif ( source == GUIPassword.images[9] ) then
			guiStaticImageLoadImage ( GUIPassword.images[9], "images/back_to_login_button.png" )
		end
	end
)

-- Events for the buttons that are clicked
addEventHandler ( "onClientGUIClick", root, 
	function ( button, state )
		if ( button == "left" ) and ( state == "up" ) then
			if ( source == GUIPassword.images[11] ) then
				triggerEvent( "onClientPasswordButtonClicked", root, guiGetText( GUIPassword.edits[1] ) )
			elseif ( source == GUIPassword.images[9] ) then
				setPasswordWindowVisable ( false )
				setLoginWindowVisable ( true )
			end
		end
	end
)

-- When the account is created
addEvent( "onClientPasswordChanged", true )
addEventHandler( "onClientPasswordChanged", root,
	function ()
		setPasswordWindowVisable ( false )
		setLoginWindowVisable ( true )
		setWarningBoxVisable( "Email has been sent!" )
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