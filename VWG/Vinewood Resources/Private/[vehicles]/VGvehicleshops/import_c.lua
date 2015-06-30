


local sx, sy = guiGetScreenSize()
local scrollState = 0 
local gridStartx, gridStarty = sx*(505/1440), sy*(345/900)
local feePerKg = 1.5
local importInfoString = "\nWelcome to the Vehicle Import Center.\n\nHere you can order any vehicle that isn't available in the San Andreas local vehicle stands.\n\nYou will fill an order and your vehicle will be brought from other country by sea.\n\nTo import a vehicle you need to pay the vehicle plus a fee for the transportation that depends on his weight. The company that ensures the transportation currently charges "..feePerKg.."$ per kg of goods transported.\n\nAfter your order is finalized it will take a few hours for your vehicle to arrive.\n\n\nGood shopping!"
local importMarkers = {}

--vehicle import WINDOW
importPositions = { --X, Y, Z
	{2422.345, -2451.582, 12.647},
	{-1716.054, -41.234, 2.555},
}

function openImportWindow (hitElement, md)
	local px, py, pz = getElementPosition(hitElement)
	local mx, my, mz = getElementPosition(source)
	if ( hitElement == localPlayer ) and ( md ) and ( not isPedInVehicle(localPlayer) ) and ( pz - mz < 3 )then
		addEventHandler("onClientRender", root, showImportWindow)
		stage1 = true
		showCursor(true)
		
		function clickHandler(btn, state)
			if ( btn == "left" ) and ( state == "down" ) then
				if (isDrawElementSelected ( sx*(513/1440), sy*(670/900), sx*(134/1440)+sx*(513/1440), sy*(28/900)+sy*(670/900) ) ) then --close window btn
					closeImportWindow(localPlayer) 
				end 
				if ( stage1 ) then 
					if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then 
						stage1 = false 
						stage2 = true 
					end
				end
				if ( stage4 ) then
					if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then 
						stage2 = false 
						stage3 = false 
						stage4 = false 
						stage5 = true 
					end
				elseif ( stage5 ) then
					if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then 
						stage2 = false 
						stage3 = false 
						stage4 = false 
						stage5 = false  
						local x, y, z = getElementPosition(localPlayer)
						triggerServerEvent("onVehicleBought", localPlayer, getVehicleModelFromName(vehicles[importList[selectedIndex]].name),  getZoneName(x, y, z, true ), (vehicles[importList[selectedIndex]].price+(vehicles[importList[selectedIndex]].weight*feePerKg)))
						closeImportWindow (localPlayer)
					end
				end				
			end
		end
		addEventHandler("onClientClick", root, clickHandler)
		
		-- When the player scrols the mouse	
		function scrollHandler ( type )
				-- Do the 'math'
				if ( type == 'mouse_wheel_up' ) then
					if ( scrollState >= 0 ) then return end
					scrollState = scrollState + 1
				elseif ( type == 'mouse_wheel_down' ) then
					if ( math.abs(scrollState) == #importList-9 ) then return end
					scrollState = scrollState - 1
				end
		end
		addEventHandler( "onClientKey", root, scrollHandler )
		
	end
end

function closeImportWindow (player)
	if ( localPlayer == player ) and ( not isPedInVehicle(localPlayer) ) then
		removeEventHandler("onClientClick", root, clickHandler)
		removeEventHandler("onClientRender", root, showImportWindow)
		removeEventHandler("onClientClick", root, importGridListClickHandler )
		removeEventHandler("onClientKey", root, scrollHandler)

		showCursor(false)
		stage1 = false
		stage2 = false
		stage3 = false
		stage4 = false
		stage5 = false
		selectedIndex = false
	end
end


for i=1, #importPositions do
	local marker = createMarker(importPositions[i][1], importPositions[i][2], importPositions[i][3], "cylinder", 2, 255, 255, 0 )
	addEventHandler("onClientMarkerHit", marker, openImportWindow)
	--addEventHandler("onClientMarkerLeave", marker, closeImportWindow)
	importMarkers[marker] = {importPositions[i][4],importPositions[i][6]}
	exports.customblips:createCustomBlip ( importPositions[i][1], importPositions[i][2], 32, 32, "images/importBlip.png", 100 )
end



function showImportWindow ()
	dxDrawRectangle(sx*(489/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 135))
	dxDrawBorderedRectangle(sx*(489/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 255), false)
	dxDrawBorderedText("Vehicle Import Agency", sx*(600/1440), sy*(250/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "top")	
	dxDrawImage(sx*(449/1440), sy*(170/900), sx*(150/1440), sy*(150/900), "images/import.png", 0, 0, 0, tocolor(255, 255, 255, 255))


	dxDrawRectangle(sx*(500/1440), sy*(320/900), sx*(431/1440), sy*(300/900), tocolor(0, 0, 0, 255))
	dxDrawRectangle(sx*(505/1440), sy*(325/900), sx*(421/1440), sy*(290/900), tocolor(255, 255, 255, 200))
	if ( stage1 ) then
		dxDrawText(importInfoString, sx*(508/1440), sy*(328/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1.0, "default", "left", "top", true, true)
	end
	
	if ( stage2 ) then 
		dxDrawRectangle(gridStartx, gridStarty-20, sx*(421.0/1440), sy*(20.0/900),  tocolor(255,255,255,50))
		dxDrawText("Car Name:", gridStartx+(sx*(20/1440)), gridStarty+5-20, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Price:", gridStartx+(sx*(250/1440)), gridStarty+5-20, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
			
		for i=1, #importList do
				if ( i > math.abs(scrollState) ) and ( i <= math.abs(scrollState)+9 )then 
					local x, y = gridStartx, gridStarty + ( sy*(32/960) * (i-1) + ( scrollState * sy*(32/960) ) )
				
					--Create the row
					if ( isDrawElementSelected ( x, y, x+sx*(421/1440),y + sy*(32.0/900) ) ) then hoveredY, hoveredIndex, color = y, i, tocolor(255, 255, 255, 100)  else color =  tocolor(255,255,255,50) end
					if ( i == selectedIndex ) then color = tocolor(255, 255, 255,100) end
					dxDrawRectangle(x, y, sx*(421.0/1440), sy*(32.0/900),  color)
					dxDrawText(vehicles[importList[i]].name, x+(sx*(20/1440)), y+8, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
					dxDrawText("$"..vehicles[importList[i]].price , x+(sx*(250/1440)), y+8, sx, sy, tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
				end
			
		end
		
		-- Function to handle the clicks on the grid list
		function importGridListClickHandler (btn, state)
			if ( btn == "left" ) and ( state == "down" ) then
				if (hoveredY) then
					if ( isDrawElementSelected (  gridStartx, hoveredY, gridStartx+sx*(421.0/1440), hoveredY+sy*(32.0/900) ) ) then 
						selectedIndex = hoveredIndex 
						stage3 = true
						stage4 = false
						lenght = 10
					end
				end
			end
		end
		addEventHandler("onClientClick", root, importGridListClickHandler )

				
		dxDrawBorderedText("Scroll up and down to check the whole list. Click any row to check the vehicle's details.", sx*(1050/1440), sy*(620/900), sx*(400/1440), sy*(200/900), tocolor(255, 255, 255, 255), 0.70, "default-bold", "center", "top")	
	end
	
	if ( stage3 ) then --Expand the details tab
		if ( selectedIndex > math.abs(scrollState) ) and ( selectedIndex <= math.abs(scrollState)+9 ) then 
			maxWidth = dxGetTextWidth("Vehicle model: ".. vehicles[importList[selectedIndex]].name, 1.0, "default-bold")+50
			maxHeight = (dxGetFontHeight(1, "default-bold")) * 14
			if ( lenght < maxWidth ) then lenght = lenght + 5 else stage4 = true end
			dxDrawRectangle(sx*(926/1440), gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ), sx*((lenght+10)/1440), sy*(maxHeight/900), tocolor(0, 0, 0, 255))
			dxDrawRectangle(sx*(931/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+5, sx*(lenght/1440), sy*((maxHeight-10)/900), tocolor(255, 255, 255, 220))
			
			dxDrawRectangle(sx*(926/1440), gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ), sx*(5/1440), sy*(maxHeight/900), tocolor(0, 0, 0, 255))
		else 
			stage4 = false
		end
	end
	
	if ( stage4 ) then
		dxDrawText("Vehicle model: ".. vehicles[importList[selectedIndex]].name , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(15/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Vehicle type: ".. vehicles[importList[selectedIndex]].type , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(35/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Number of seats: ".. vehicles[importList[selectedIndex]].seats , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(55/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Traction: ".. vehicles[importList[selectedIndex]].traction , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(75/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Number of gears: ".. vehicles[importList[selectedIndex]].gears , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(95/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Max. speed: ".. vehicles[importList[selectedIndex]].maxSpeed .."km/h", sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(115/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Engine type: ".. vehicles[importList[selectedIndex]].engType , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(135/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Weight: ".. vehicles[importList[selectedIndex]].weight .."kg" , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(155/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Transport fee: $".. vehicles[importList[selectedIndex]].weight*feePerKg , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(175/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
		dxDrawText("Price: $".. vehicles[importList[selectedIndex]].price , sx*(940/1440), (gridStarty + ( sy*(32/960) * (selectedIndex-1) + ( scrollState * sy*(32/960) ) ))+sy*(195/960), sx*(1200/1440), sy*(400/900), tocolor(0, 0, 0, 255 ), 1.0, "default-bold", "left", "top" )
	end
	
	if ( stage5 ) then
			dxDrawBorderedText("Import Receipt", sx*(600/1440), sy*(300/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "top")	
			local time = getRealTime()
			dxDrawText("Date:"..time.monthday.."/"..time.month.."/"..( time.year + 1900 ), sx*(530/1440), sy*(340/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1, "default-bold", "left", "top", true, true)
			dxDrawText("Vehicle import receipt", sx*(508/1440), sy*(370/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1.3, "default-bold", "center", "top", true, true)
			dxDrawText("Vehicle("..vehicles[importList[selectedIndex]].name.."):\n\nTransportation Fees:\n\n       Total:", sx*(530/1440), sy*(410/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1, "default-bold", "left", "top", true, true)
			dxDrawText("$"..vehicles[importList[selectedIndex]].price.."\n\n$"..(vehicles[importList[selectedIndex]].weight*feePerKg).."\n\n$"..(vehicles[importList[selectedIndex]].price+(vehicles[importList[selectedIndex]].weight*feePerKg)), sx*(508/1440), sy*(410/900), sx*(850/1440), sy*(612/900), tocolor(0,0,0,255), 1, "default", "right", "top", true, true)
			
			dxDrawText("As soon as you press the \"Accept\" button your vehicle will be queued for shipment. You can check the shipping times on the Import App on your phone.", sx*(508/1440), sy*(510/900), sx*(923/1440), sy*(712/900), tocolor(0,0,0,255), 0.8, "default-bold", "center", "top", true, true)

			
	end
	
	if (isDrawElementSelected ( sx*(513/1440), sy*(670/900), sx*(134/1440)+sx*(513/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
	dxDrawRectangle(sx*(510/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
	dxDrawRectangle(sx*(513/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
	dxDrawBorderedText("Close Window", sx*(535/1440), sy*(676/900), sx*(603/1440), sy*(492/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top" )
	

	if ( stage1 ) then 
		if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
		dxDrawRectangle(sx*(780/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
		dxDrawRectangle(sx*(783/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
		dxDrawBorderedText("Next", sx*(830/1440), sy*(676/900), sx*(603/1440), sy*(492/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top" )
	elseif ( stage5 ) then
			if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
			dxDrawRectangle(sx*(780/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(783/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
			dxDrawBorderedText("Accept", sx*(830/1440), sy*(676/900), sx*(603/1440), sy*(492/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top" )
	else
		if ( selectedIndex ) then
			if (isDrawElementSelected ( sx*(783/1440), sy*(670/900), sx*(134/1440)+sx*(783/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
			dxDrawRectangle(sx*(780/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(783/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
			dxDrawBorderedText("Order", sx*(830/1440), sy*(676/900), sx*(603/1440), sy*(492/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top" )
		else
			dxDrawRectangle(sx*(780/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(783/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, 75))
			dxDrawBorderedText("Order", sx*(830/1440), sy*(676/900), sx*(603/1440), sy*(492/900), tocolor(255, 255, 255, 150), 1.0, "default-bold", "left", "top" )
		end
	end
	
end





--Stages explanation
--stage1 is true when the player first opens the import window, gets set to false after player presses "Next"
--stage2 gets set to true when the player clicks "Next" and it enables the drawing of the gridlist with the vehicles available to import
--stage3 i set to true when a player presses a vehicle from the gridlist and and is true while the info box is expanding
--stage4 is true after the info box finished expanding (setting stage3 to false) and it shows the info about the selected model 
--stage5 is true after the player pressed the order button




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