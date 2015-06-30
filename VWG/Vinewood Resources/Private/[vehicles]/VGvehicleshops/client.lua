


local sx, sy = guiGetScreenSize()
local scrollState = 0 
local gridStartx, gridStarty = sx*(505/1440), sy*(345/900)
local colorIndex = 1

---------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------CAR SHOP WINDOW----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
vehicleShopPositions = { --X, Y, Z, StandList, blip, blipPath, displayX, displayY, displayZ, displyRot
	{560.869, -1290.622, 16.248, grottiList, 55, "images/car.png", 559.659, -1265.532, 16.867, 11.473},
	{2131.969, -1150.204, 23.185, couttAndSchutzList, 55, "images/car.png", 2127.133, -1128.983, 25.167, 345.275}, 
	{-1953.756, 297.454, 34.469, wangCarsList, 55, "images/car.png", -1976.304, 288.004, 35.172, 90},
	{-1657.916, 1210.566, 6.25, ottosAutosList, 55, "images/car.png", -1636.001, 1201.93, 6.814, 248}, 
	{2172.279, 1397.095, 10.063, autoBahnList, 55, "images/car.png", 2107.855, 1386.149, 10.445, 174.11},  
	{1950.325, 2040.171, 10.06, autoBahn2List, 55, "images/car.png", 1943.466, 2030.857, 10.442, 178.681},
}

vehicleShopMarkers = {}

function openVehicleShopWindow (hitElement, md)
	local px, py, pz = getElementPosition(hitElement)
	local mx, my, mz = getElementPosition(source)
	if ( hitElement == localPlayer ) and ( md ) and ( not isPedInVehicle(localPlayer) ) and ( pz - mz < 3 )then
		addEventHandler("onClientRender", root, showVehicleShopWindow)
		showCursor(true)
		standList = vehicleShopMarkers[source][1]
		img = vehicleShopMarkers[source][2]
		vehX, vehY, vehZ, vehRot = vehicleShopMarkers[source][3], vehicleShopMarkers[source][4], vehicleShopMarkers[source][5], vehicleShopMarkers[source][6]
		addEventHandler("onClientClick", root, clickHandler)
		addEventHandler( "onClientKey", root, scrollHandler )
	end
end


function closeVehicleShopWindow (player)
	if ( localPlayer == player ) and ( not isPedInVehicle(localPlayer) ) then
		removeEventHandler("onClientClick", root, clickHandler)
		removeEventHandler("onClientRender", root, showVehicleShopWindow)
		removeEventHandler("onClientKey", root, scrollHandler)
		if ( stage3 ) then
			setCameraTarget(localPlayer)
			setElementDimension(localPlayer, 0)
			if ( isElement(tempVehicle) ) then destroyElement(tempVehicle) end
			exports.VGcolorpicker:closeColorpicker( )
			removeEventHandler("onColorPickerChange", root, finalize )
		end
		standList = false
		showCursor(false)
		stage1= false
		stage2= false
		stage3= false
		selectedIndex = false
	end
end
addEvent("onColorPickerClosedByPlayer")
addEventHandler("onColorPickerClosedByPlayer", root, closeVehicleShopWindow)

for i=1, #vehicleShopPositions do
	local marker = createMarker(vehicleShopPositions[i][1], vehicleShopPositions[i][2], vehicleShopPositions[i][3], "cylinder", 2, 255, 255, 0 )
	local vehX, vehY, vehZ, vehRot = vehicleShopPositions[i][7], vehicleShopPositions[i][8], vehicleShopPositions[i][9], vehicleShopPositions[i][10]
	addEventHandler("onClientMarkerHit", marker, openVehicleShopWindow)
	addEventHandler("onClientMarkerLeave", marker, closeVehicleShopWindow)
	vehicleShopMarkers[marker] = {vehicleShopPositions[i][4],vehicleShopPositions[i][6], vehX, vehY, vehZ, vehRot}
	createBlip(vehicleShopPositions[i][1], vehicleShopPositions[i][2], vehicleShopPositions[i][3], vehicleShopPositions[i][5], 2, 255, 0, 0, 255, 0, 300)
end


function showVehicleShopWindow ()
	if not ( stage3 ) then
		dxDrawRectangle(sx*(489/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 135))
		dxDrawBorderedRectangle(sx*(489/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 255), false)
		dxDrawBorderedText("Vehicle Dealer", sx*(600/1440), sy*(250/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "top")	
		dxDrawImage(sx*(449/1440), sy*(170/900), sx*(150/1440), sy*(150/900), img, 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawBorderedText("Vehicles for sale:", sx*(550/1440), sy*(300/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "top")	

		
		dxDrawRectangle(sx*(500/1440), sy*(320/900), sx*(431/1440), sy*(300/900), tocolor(0, 0, 0, 255))
		dxDrawRectangle(sx*(505/1440), sy*(325/900), sx*(421/1440), sy*(290/900), tocolor(255, 255, 255, 200))
		
		dxDrawRectangle(gridStartx, gridStarty-20, sx*(421.0/1440), sy*(20.0/900),  tocolor(255,255,255,50))
		dxDrawText("Car Name:", gridStartx+(sx*(20/1440)), gridStarty+5-20, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Price:", gridStartx+(sx*(250/1440)), gridStarty+5-20, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			
		for i=1, #standList do
				if ( i > math.abs(scrollState) ) and ( i <= math.abs(scrollState)+9 )then 
					local x, y = gridStartx, gridStarty + ( sy*(32/960) * (i-1) + ( scrollState * sy*(32/960) ) )
				
					--Create the row
					if ( isDrawElementSelected ( x, y, x+sx*(421/1440),y + sy*(32.0/900) ) ) then hoveredY, hoveredIndex, color = y, i, tocolor(255, 255, 255, 100)  else color =  tocolor(255,255,255,50) end
					if ( i == selectedIndex ) then color = tocolor(255, 255, 255,100) end
					dxDrawRectangle(x, y, sx*(421.0/1440), sy*(32.0/900),  color)
					dxDrawText(vehicles[standList[i]].name, x+(sx*(20/1440)), y+8, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
					dxDrawText("$"..vehicles[standList[i]].price , x+(sx*(250/1440)), y+8, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
				end
			
		end

		
		dxDrawBorderedText("Scroll up and down to check the whole list. Click any row to check the vehicle's details.", sx*(1050/1440), sy*(620/900), sx*(400/1440), sy*(200/900), tocolor(255, 255, 255, 255), 0.70, "default-bold", "center", "top")	

		
		if (isDrawElementSelected ( sx*(513/1440), sy*(670/900), sx*(134/1440)+sx*(513/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
		dxDrawRectangle(sx*(510/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
		dxDrawRectangle(sx*(513/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
		dxDrawBorderedText("Close Window", sx*(513/1440), sy*(670/900), sx*(647/1440), sy*(698/900), tocolor(255, 255, 255, 255), sx*(1.00/1152), "default-bold", "center", "center" )
		
		if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
		if not ( selectedIndex ) then  a = 100 end
		dxDrawRectangle(sx*(780/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
		dxDrawRectangle(sx*(783/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
		dxDrawBorderedText("Next", sx*(783/1440), sy*(670/900), sx*(917/1440), sy*(698/900), tocolor(255, 255, 255, 255), sx*(1.00/1152), "default-bold", "center", "center" )
		
		if ( stage1 ) then --Expand the details tab
			if ( selectedIndex > math.abs(scrollState) ) and ( selectedIndex <= math.abs(scrollState)+9 ) then 
				maxWidth = dxGetTextWidth("Vehicle model: ".. vehicles[standList[selectedIndex]].name, 1.0, "default-bold")+50
				maxHeight = (dxGetFontHeight(1, "default-bold")) * 13 
				if ( lenght < maxWidth ) then lenght = lenght + 5 else stage2 = true end
				dxDrawRectangle(sx*(926/1440), gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ), sx*((lenght+10)/1440), sy*(maxHeight/900), tocolor(0, 0, 0, 255))
				dxDrawRectangle(sx*(931/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+5, sx*(lenght/1440), sy*((maxHeight-10)/900), tocolor(255, 255, 255, 220))
				
				dxDrawRectangle(sx*(926/1440), gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ), sx*(5/1440), sy*(maxHeight/900), tocolor(0, 0, 0, 255))
			else 
				stage2 = false
			end
			
		end
		
		if ( stage2 ) then --Show the details
			dxDrawText("Vehicle model: ".. vehicles[standList[selectedIndex]].name , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(15/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Vehicle type: ".. vehicles[standList[selectedIndex]].type , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(35/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Number of seats: ".. vehicles[standList[selectedIndex]].seats , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(55/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Traction: ".. vehicles[standList[selectedIndex]].traction , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(75/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Number of gears: ".. vehicles[standList[selectedIndex]].gears , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(95/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Max. speed: ".. vehicles[standList[selectedIndex]].maxSpeed .."km/h", sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(115/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Engine type: ".. vehicles[standList[selectedIndex]].engType , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(135/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Weight: ".. vehicles[standList[selectedIndex]].weight .."kg" , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(155/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			dxDrawText("Price: $".. vehicles[standList[selectedIndex]].price , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+(sy*(175/960)), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		end
	end
	
	if ( stage3 ) then
		rotateCameraAroundEditVehicle( ) 
		dxDrawRectangle(sx*(440/1440), sy*(570/960), sx*(463/1440), sy*(30/960), tocolor(0, 0, 0, 255))
		local R1, G1, B1, R2, G2, B2 = getVehicleColor(tempVehicle, true)
		
		if ( isDrawElementSelected ( sx*(445/1440), sy*(575/960), sx*(671/1440), sy*(599/960) ) ) then color = tocolor(255, 255, 255, 100) else color = tocolor(255, 255, 255, 50) end
		if ( colorIndex == 1 ) then color = tocolor(255, 255, 255,100) end
		dxDrawRectangle(sx*(445/1440), sy*(575/960), sx*(226/1440), sy*(24/960),  color)
		dxDrawBorderedText("Color 1", sx*(440/1440), sy*(570/960), sx*(671/1440), sy*(599/960), tocolor(R1, G1, B1, 255 ), 1.0, "default-bold", "center", "center" )
	
		if ( isDrawElementSelected ( sx*(671/1440), sy*(575/960), sx*(897/1440), sy*(599/960) ) ) then color = tocolor(255, 255, 255, 100) else color = tocolor(255, 255, 255, 50) end
		if ( colorIndex == 2 ) then color = tocolor(255, 255, 255,100) end
		dxDrawRectangle(sx*(676/1440), sy*(575/960), sx*(226/1440), sy*(24/960),  color)
		dxDrawBorderedText("Color 2", sx*(676/1440), sy*(575/960), sx*(897/1440), sy*(599/960), tocolor(R2, G2, B2, 255 ), 1.0, "default-bold", "center", "center" )

		dxDrawLine(sx*(671/1440), sy*(570/960), sx*(671/1440), sy*(599/960), tocolor(0, 0, 0), 2)
	end
end

--Send the request to the server side
function finalize ()
	local R1, G1, B1, R2, G2, B2 = getVehicleColor(tempVehicle, true)
	triggerServerEvent("onPlayerBuyVehicle", source, standList[selectedIndex], vehX, vehY, vehZ, vehRot, R1, G1, B1, R2, G2, B2)
	closeVehicleShopWindow (source)
end


-- Function that handles the clicks on the gui
function clickHandler(btn, state)
	if ( btn == "left" ) and ( state == "down" ) then
		if (isDrawElementSelected ( sx*(513/1440), sy*(670/900), sx*(134/1440)+sx*(513/1440), sy*(28/900)+sy*(670/900) ) ) and not ( stage3 ) then closeVehicleShopWindow(localPlayer) end --close window btn
		if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) and not ( stage3 ) and ( selectedIndex ) then 
			stage3 = true 
			tempVehicle = createVehicle(standList[selectedIndex], vehX, vehY, vehZ, 0, 0, vehRot) 
			setElementDimension(tempVehicle, 1)
			setElementDimension(localPlayer, 1)
			exports.VGcolorpicker:openColorpicker( sx*(440/1440), sy*(600/960), 100, 100, 100 )
			addEvent("onColorPickerChange")
			addEventHandler("onColorPickerChange", root, finalize )
		end
		if (hoveredY) then
			if ( isDrawElementSelected (  gridStartx, hoveredY, gridStartx+sx*(421.0/1440), hoveredY+sy*(32.0/900) ) ) then 
				selectedIndex = hoveredIndex 
				stage1 = true
				stage2 = false
				lenght = 10
			end
		end
		if ( stage3 ) then
			local r1, g1, b1, r2, g2, b2 = getVehicleColor(tempVehicle, true)
			if ( isDrawElementSelected ( sx*(445/1440), sy*(575/960), sx*(676/1440), sy*(599/960) ) ) then colorIndex = 1 exports.VGcolorpicker:setColorpickerColor( r1, g1, b1 ) end
			if ( isDrawElementSelected (  sx*(676/1440), sy*(575/960), sx*(897/1440), sy*(599/960) ) ) then colorIndex = 2 exports.VGcolorpicker:setColorpickerColor( r2, g2, b2 ) end
		end
	end
end
	
-- When the player scrols the mouse	
function scrollHandler ( type )
	-- Do the 'math'
	if ( type == 'mouse_wheel_up' ) then
		if ( scrollState >= 0 ) then return end
		scrollState = scrollState + 1
	elseif ( type == 'mouse_wheel_down' ) then
		if ( math.abs(scrollState) == #standList-9 ) then return end
		scrollState = scrollState - 1
	end
end


-- Function to draw borderd text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false)
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false)
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, false, false, false, false )
end

-- Check the the draw element is selected
function isDrawElementSelected ( minX, minY, maxX, maxY )
	if ( isCursorShowing() ) then
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
end

--rotate the camera around the vehicle
local facing = 0
function rotateCameraAroundEditVehicle( ) -- credits to 50p
	if ( tempVehicle ) then
		local x, y, z = getElementPosition( tempVehicle )
		local multiplier = 7
		local vehType = getVehicleType( tempVehicle )
		if ( vehType == "Boat" ) or ( vehType == "Plane" ) or ( vehType == "Helicopter" ) then
			multiplier = 14
		end
		local camX = x + math.cos( facing / math.pi * 180 ) * multiplier
		local camY = y + math.sin( facing / math.pi * 180 ) * multiplier
		setCameraMatrix( camX, camY, z+3, x, y, z )
		facing = facing + 0.0002
	end	
end

--Update the vehicle's color when it changes on the color picker
addEvent("onColorPickerPreChange")
function updateVehicleColor (R, G, B)
	if ( tempVehicle ) then
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(tempVehicle, true)
		if ( colorIndex == 1 ) then
			setVehicleColor(tempVehicle, R, G, B, r2, g2, b2)
		elseif ( colorIndex == 2 ) then
			setVehicleColor(tempVehicle, r1, g1, b1, R, G, B)
		end
	end
end
addEventHandler("onColorPickerPreChange", root, updateVehicleColor)


-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end