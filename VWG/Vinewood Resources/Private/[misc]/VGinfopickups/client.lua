-- Get the screen color
local sx, sy = guiGetScreenSize()
local drawString = false

-- Table with positions and the text
local pickupTable = {
	{ 556.949, -1291.002, 17.248, 1 },
	{ 2127.193, -1152.048, 24, 1 },
	{ -1951.183, 297.556, 35.469, 1 },
	{ -1649.436, 1209.801, 7.25, 1 },
	{ 1955.967, 2039.98, 11.061, 1 },
}

-- Table wit the information textx
local textsTable = {
	{ "Can't find the vehicle you are looking for on the local stands around San Andreas? Don't worry, you can always import it from other countries. To import a vehicle you need to head to the docks in San Fierro or Los Santos and fill the order form on the auto import office. Your vehicle will then be imported from the outside and will arrive by ship and you can pick it from the docks as soon as it arrives!" }
}

-- Draw the pickups window
function renderPickupWindow ()
	if ( drawString ) then
		dxDrawRectangle(sx*(489/1440), sy*(186/900), sx*(452/1440), sy*(208/900), tocolor(0, 0, 0, 135))
		exports.VGdrawing:dxDrawBorderedRectangle(sx*(489/1440), sy*(186/900), sx*(452/1440), sy*(208/900), tocolor(0, 0, 0, 255), false)
		exports.VGdrawing:dxDrawBorderedText("Information window:", sx*(600/1440), sy*(210/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "top")	
		dxDrawRectangle(sx*(500/1440), sy*(230/900), sx*(431/1440), sy*(130/900), tocolor(0, 0, 0, 255))
		dxDrawRectangle(sx*(505/1440), sy*(235/900), sx*(421/1440), sy*(120/900), tocolor(255, 255, 255, 200))
		dxDrawText(drawString, sx*(508/1440), sy*(245/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1.0, "default", "center", "top", true, true)
	end
end

-- When the players hits the pickup
function onInfoPickupHit ( thePlayer, mathcingDimension )
	if ( thePlayer == localPlayer ) and ( mathcingDimension ) and ( textsTable[ pickupTable[ source ] ] ) then
		drawString = textsTable[ pickupTable[ source ] ][ 1 ]
		addEventHandler( "onClientRender", root, renderPickupWindow )
	end
end

-- When the players leaves the pickup
function onInfoPickupLeave ( thePlayer, mathcingDimension )
	if ( thePlayer == localPlayer ) and ( mathcingDimension ) then
		drawString = false
		removeEventHandler( "onClientRender", root, renderPickupWindow )
	end
end

-- Create the pickups
for i=1, #pickupTable do
	local thePickup = createPickup( pickupTable[i][1], pickupTable[i][2], pickupTable[i][3], 3, 1239 )
	pickupTable[ thePickup ] = pickupTable[i][4]
	addEventHandler( "onClientPickupHit", thePickup, onInfoPickupHit )
	addEventHandler( "onClientPickupLeave", thePickup, onInfoPickupLeave )
end