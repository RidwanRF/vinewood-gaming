
local table = table




-- Variable global
isVehicleWindowShowing = false
selectedItem = false
local iter = 1

-- Table with the vehicles
local vehicleTable = {}

-- Get the screen size
local sx, sy = guiGetScreenSize()

function drawVehicleWindow ()
	selectedItem = false
	
	dxDrawRectangle(sx*(326.0/1440),sy*(236.0/900),sx*(767.0/1440),sy*(3.0/900), tocolor(0, 0, 0, 184), false)
	dxDrawLine(sx*(326.0/1440),sy*(237.0/900),sx*(1092.0/1440),sy*(237.0/900), tocolor(255, 255, 255, 255), sx*(1.0/1440), false)
    dxDrawBorderedText("Your Vehicles", sx*(328/1440),sy*(176/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255, 255, 255, 255), 2.0, "bankgothic", "left", "top", false, false, false, false, false)
	
	if not ( vehicleTable ) or ( #vehicleTable == 0 ) then
		dxDrawBorderedText("You have no vehicles!", sx*(328.0/1440),sy*(241.0/900),sx*(832.0/1440),sy*(299.0/900), tocolor(255, 255, 255, 255), 1.3, "bankgothic", "left", "top", false, false, false, false, false)
		return
	else
		dxDrawBorderedText("Scroll with your mouse wheel to move up or down! Double click a button to perform the action!", sx*(328/1440),sy*(242/900),sx*(894.0/1440),sy*(261.0/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
	end
		
	-- Loop and draw the GUI
	local loopI = 0
	local aTable = {}
	for i = 1, #vehicleTable do
		if ( isElement( vehicleTable[ i ].vehicle ) ) then
			table.insert( aTable, vehicleTable[ i ] )
		end
	end
	
	-- If the iter is greater than the table
	if ( iter + 4 > #aTable ) then
		iter = iter - 1
	end
	
	-- Check needed to loop proper
	local iters = #aTable
	if ( #aTable > 5 ) then
		iters = iter + 4
	elseif ( #aTable <= 5 ) then
		iter = 1
	end
	
	for i = iter, iters do
		-- Couple checks
		if ( aTable[ i ] ) and ( isElement( aTable[ i ].vehicle ) ) then
			-- Loop iter
			loopI = loopI +1
			
			-- Vehicle settings	
			local vehicleName = getVehicleNameFromModel ( aTable[ i ].model )
			local vehicleType = getVehicleType( aTable[ i ].model )
			local x, y, z = getElementPosition( aTable[ i ].vehicle )
			local vehicleLocation = getZoneName ( x, y, z )
			local vehiclePrice = exports.VGutils:convertNumber( aTable[ i ].boughtprice )
			local vehicleFuel, vehicleHealth = exports.VGfuel:getVehicleFuel( aTable[ i ].vehicle ), getElementHealth( aTable[ i ].vehicle )
		
			local it, at, et, ot = sy*(110/900), sy*(110/900), sx*(24/1440), sy*(137/900)
			local h1, w1, x1, y1 = sx*(722/1440),sy*(162/900)+(loopI*it),sx*(113.0/1440),sy*(85.0/900)
			local h2, w2, x2, y2 = sx*(976/1440),sy*(163/900)+(loopI*it),sx*(113.0/1440),sy*(85.0/900)
			local h3, w3, x3, y3 = sx*(849/1440),sy*(163/900)+(loopI*it),sx*(113.0/1440),sy*(85.0/900)
			dxDrawRectangle(sx*(441/1440),sy*(159/900)+(loopI*it),sx*(653.0/1440),sy*(91.0/900), tocolor(0, 0, 0, 145), false)
			dxDrawRectangle(h1, w1, x1, y1, tocolor(0, 0, 0, 210), false)
			if ( isDrawElementSelected ( h1, w1, h1+x1, w1+y1 ) ) then color = tocolor(180, 0, 0, 255) selectedItem = i else color = tocolor(255, 255, 255, 255) end
			dxDrawBorderedText("Mark", sx*(749/1440),sy*(188/900)+(loopI*at),sx*(815.0/1440),sy*(320.0/900), color, 1.0, "pricedown", "left", "top", false, false, false, false, false)
			dxDrawRectangle(sx*(325/1440),sy*(159/900)+(loopI*it),sx*(109.0/1440),sy*(91.0/900), tocolor(0, 0, 0, 145), false)
			dxDrawImage (sx*(325/1440),sy*(159/900)+(loopI*it),sx*(109.0/1440),sy*(91.0/900), "GUI/images/"..vehicleType..".png" )
			dxDrawBorderedText("Vehicle: "..vehicleName, sx*(445/1440),sy*(162/900)+(loopI*at),sx*(675.0/1440)+(loopI*at),sy*(279.0/900)+(loopI*at), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
			dxDrawBorderedText("Bought Price: $"..vehiclePrice, sx*(445/1440),sy*(179/900)+(loopI*at),sx*(675.0/1440),sy*(296.0/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
			dxDrawBorderedText("Health: "..math.floor(vehicleHealth/10).."%", sx*(445/1440),sy*(196/900)+(loopI*at),sx*(675.0/1440),sy*(313.0/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
			dxDrawBorderedText("Fuel: "..math.floor(vehicleFuel).."%", sx*(445/1440),sy*(213/900)+(loopI*at),sx*(675.0/1440),sy*(330.0/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
			dxDrawBorderedText("Location: "..vehicleLocation, sx*(445/1440),sy*(231/900)+(loopI*at),sx*(675.0/1440),sy*(348.0/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
			dxDrawRectangle(h3, w3, x3, y3, tocolor(0, 0, 0, 210), false)
			dxDrawRectangle(h2, w2, x2, y2, tocolor(0, 0, 0, 210), false)
			if ( isDrawElementSelected ( h3, w3, h3+x3, w3+y3 ) ) then color = tocolor(180, 0, 0, 255) selectedItem = i else color = tocolor(255, 255, 255, 255) end
			dxDrawBorderedText("Sell", sx*(884/1440),sy*(188/900)+(loopI*at),sx*(950.0/1440),sy*(320.0/900), color, 1.0, "pricedown", "left", "top", false, false, false, false, false)
			if ( isDrawElementSelected ( h2, w2, h2+x2, w2+y2 ) ) then color = tocolor(180, 0, 0, 255) selectedItem = i else color = tocolor(255, 255, 255, 255) end
			dxDrawBorderedText("Lock", sx*(1012/1440),sy*(189/900)+(loopI*at),sx*(1078.0/1440),sy*(321.0/900), color, 1.0, "pricedown", "left", "top", false, false, false, false, false)
		end
	end
end 

-- Function that shows the window
addEvent( "onClientShowVehicleWindow", true )
addEventHandler( "onClientShowVehicleWindow", root,
	function ( table )
		if ( isVehicleWindowShowing ) then
			showPlayerVehicleWindow( false )
		else
			vehicleTable = table
			showPlayerVehicleWindow( true )
		end
	end
)

-- Function that toggles the window
function showPlayerVehicleWindow( state )
	if ( state ) then
		if not ( isVehicleWindowShowing ) then
			exports.VGdrawing:dxStopScreenRendering()
			isVehicleWindowShowing = true
			addEventHandler( "onClientRender", root, drawVehicleWindow )
			showCursor( true ) showChat( false ) showPlayerHudComponent ( "all", false )
			exports.VGblur:setBlurEnabled()
		end
	else
		if ( isVehicleWindowShowing ) then
			isVehicleWindowShowing = false
			removeEventHandler( "onClientRender", root, drawVehicleWindow )
			showCursor( false ) showChat( true ) showPlayerHudComponent ( "all", true )
			exports.VGblur:setBlurDisabled()
		end
	end
end

-- Check if the draw element is selected
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

-- Function to draw borderd text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, false, false, false, false, false )
end

-- When the player scrols the mouse
addEventHandler( "onClientKey", root,
    function ( type )
		if ( isVehicleWindowShowing ) then
			-- If table amount is < 5 then return
			local i = #vehicleTable
			if ( i < 5 ) then return end
			
			-- Do the 'math'
			if ( type == 'mouse_wheel_up' ) then
				if not ( vehicleTable[ iter -1 ] ) then return end
				iter = iter -1
			elseif ( type == 'mouse_wheel_down' ) then
				if ( ( iter +1 ) + 4 > i ) then return end
				iter = iter +1
			end
		end
    end
)