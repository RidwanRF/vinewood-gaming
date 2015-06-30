


local sx, sy = guiGetScreenSize()
local receiptData = {}
local costPerTire = 100
---------Mechanic side
function requestRepairVehicle(key, pressed)
	if ( key == "mouse2" ) and ( pressed ) and ( getElementData ( localPlayer, "Occupation" ) == "Mechanic" ) then 

		if ( getPedWeaponSlot ( localPlayer ) == 0 ) and not ( isPedInVehicle ( localPlayer ) ) then
			local vehicle = getClosestVehicle ( localPlayer )
			if not ( vehicle ) then
				exports.VGdx:showMessageDX("You need to be close to a vehicle to repair it!", 255, 0, 0)
				return
			elseif ( getElementHealth ( vehicle ) >= 1000 ) then
				exports.VGdx:showMessageDX("This vehicle doesn't need to be repaired!", 255, 0, 0)
				return
			elseif not ( getVehicleOccupant ( vehicle ) ) then
				exports.VGdx:showMessageDX("The vehicle must have a driver in it!", 255, 0, 0)
				return
			end
			triggerServerEvent("onPlayerRepairVehicle", localPlayer, localPlayer, getVehicleOccupant(vehicle), vehicle)
		end
		
	end
end
addEventHandler("onClientKey", root, requestRepairVehicle)


---------Both sides
addEvent("onVehicleBeingRepaired", true)
function showProgressBar(healthCost,  tireCost, labourCost, mechanic )
	exports.VGprogbar:createProgressBar( 100, "Repairing..." )
	receiptData = { healthCost,  tireCost, labourCost, getPlayerName(mechanic), os.date() }

	if ( source ~= localPlayer ) then
		setTimer ( showReceipt, 10000, 1 )
	end
end
addEventHandler("onVehicleBeingRepaired", root, showProgressBar)


----------Costumer side

function showReceipt ()
	showCursor( true, true )
	isReceiptShowing = true
	addEventHandler("onClientRender", root, drawReceipt)
end
addCommandHandler("showUI", showReceipt )--------

function drawReceipt ()
	dxDrawRectangle(sx*(500/1440), sy*(235/900), sx*(430/1440), sy*(300/900), tocolor(0, 0, 0, 255))
	dxDrawRectangle(sx*(505/1440), sy*(240/900), sx*(420/1440), sy*(290/900), tocolor(255, 255, 255, 200))
	dxDrawRectangle(sx*(505/1440), sy*(240/900), sx*(420/1440), sy*(50/900), tocolor(0, 0, 0, 50))
	
	dxDrawRectangle(sx*(901/1440), sy*(240/900), sx*(24/1440), sy*(24/900), tocolor(0, 0, 0, 255))
	dxDrawImage(sx*(906/1440), sy*(240/900), sx*(19/1440), sy*(19/900), "imgs/close_button.png")

	dxDrawBorderedText ( "Repair Receipt", sx*(505/1440), sy*(240/900), sx*(925/1440), sy*(290/900), tocolor(255, 255, 255, 255), sy*(2.0/900), "default-bold", "center", "center", tocolor(0, 0, 0, 255) )
	
	dxDrawBorderedText("Mechanic: "..receiptData[4].."  |  Date: "..receiptData[5], sx*(505/1440), sy*(290/900), sx*(925/1440), sy*(340/900), tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", tocolor(0, 0, 0, 255))

	dxDrawBorderedText("Labour", sx*(550/1440), sy*(335/900), sx*(750/1440), sy*(355/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))
	dxDrawBorderedText("Parts", sx*(550/1440), sy*(355/900), sx*(750/1440), sy*(375/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))
	dxDrawBorderedText("Tires", sx*(550/1440), sy*(375/900), sx*(750/1440), sy*(395/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))
	
	dxDrawLine(sx*(540/1440), sy*(395/900), sx*(890/1440), sy*(395/900), tocolor(0,0,0,255))
	dxDrawBorderedText("X"..receiptData[1]/costPerTire, sx*(550/1440), sy*(375/900), sx*(790/1440), sy*(395/900), tocolor(255, 255, 255, 255), 1, "default-bold", "right", "center", tocolor(0, 0, 0, 255))
	dxDrawBorderedText("Total", sx*(550/1440), sy*(395/900), sx*(790/1440), sy*(415/900), tocolor(255, 255, 255, 255), 1, "default-bold", "right", "center", tocolor(0, 0, 0, 255))
	
	dxDrawBorderedText("$"..receiptData[3], sx*(810/1440), sy*(335/900), sx*(850/1440), sy*(355/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))
	dxDrawBorderedText("$"..receiptData[2], sx*(810/1440), sy*(355/900), sx*(850/1440), sy*(375/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))
	dxDrawBorderedText("$"..receiptData[1], sx*(810/1440), sy*(375/900), sx*(850/1440), sy*(395/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))
	dxDrawBorderedText("$"..receiptData[1]+receiptData[2]+receiptData[3], sx*(810/1440), sy*(395/900), sx*(850/1440), sy*(415/900), tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", tocolor(0, 0, 0, 255))

	dxDrawLine(sx*(800/1440), sy*(330/900), sx*(800/1440), sy*(420/900), tocolor(0,0,0,255))

	dxDrawImage(sx*(648/1440), sy*(430/900), sx*(135/1440), sy*(60/900), "imgs/stamp-paid.png")
end


addEvent("getCustomerConfirmation", true)
function showConfirmationUI ( veh, cost )
	mechanic = source
	vehicle = veh
	price = cost
	timeLeft  = 100
	isMechReqShowing = true
	addEventHandler ( "onClientRender", root, drawConfirmationUI )
	showCursor ( true, false )
	timer = setTimer ( function () 
		timeLeft = timeLeft - 1 
		if ( timeLeft == 0 ) then
			removeEventHandler ( "onClientRender", root, drawConfirmationUI )
			showCursor( false, false )
			isMechReqShowing = false
		end
	end, 100, 100)
end
addEventHandler("getCustomerConfirmation", root, showConfirmationUI)



function drawConfirmationUI ()
	dxDrawRectangle(sx*(489/1440), sy*(355/900), sx*(452/1440), sy*(190/900), tocolor(0, 0, 0, 100))
	exports.VGdrawing:dxDrawBorderedRectangle(sx*(489/1440), sy*(355/900), sx*(452/1440), sy*(190/900), tocolor(0, 0, 0, 255), false)
	dxDrawImage(sx*(459/1440), sy*(315/900), sx*(100/1440), sy*(100/900), "imgs/wrench.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	exports.VGdrawing:dxDrawBorderedText("Mechanic Services", sx*(600/1440), sy*(375/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "top")	
	dxDrawRectangle(sx*(500/1440), sy*(395/900), sx*(431/1440), sy*(70/900), tocolor(0, 0, 0, 255))
	dxDrawRectangle(sx*(505/1440), sy*(400/900), sx*(421/1440), sy*(60/900), tocolor(255, 255, 255, 200))
	dxDrawText( getPlayerName ( mechanic ).." has offered himself to repair your "..getVehicleName ( vehicle )..". The cost of the repair is $"..price..". Do you want him to repair it?", sx*(508/1440), sy*(410/900), sx*(923/1440), sy*(777/900), tocolor(0,0,0,255), 1.0, "default", "center", "top", true, true)

	exports.VGdrawing:dxDrawBorderedRectangle(sx*(500/1440), sy*(475/900), sx*(210/1440), sy*(40/900), tocolor(0, 0, 0, 255), false)
	if ( isDrawElementSelected (  sx*(500/1440), sy*(475/900), sx*(710/1440), sy*(515/900) ) ) then
		dxDrawRectangle(sx*(500/1440), sy*(475/900), sx*(210/1440), sy*(40/900), tocolor(0, 0, 0, 200))	
	else
		dxDrawRectangle(sx*(500/1440), sy*(475/900), sx*(210/1440), sy*(40/900), tocolor(0, 0, 0, 150))
	end
	exports.VGdrawing:dxDrawBorderedText("Yes, please!", sx*(500/1440), sy*(475/900), sx*(710/1440), sy*(515/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")	

	exports.VGdrawing:dxDrawBorderedRectangle(sx*(720/1440), sy*(475/900), sx*(210/1440), sy*(40/900), tocolor(0, 0, 0, 255), false)
	if ( isDrawElementSelected ( sx*(720/1440), sy*(475/900), sx*(930/1440), sy*(515/900) ) ) then
		dxDrawRectangle(sx*(720/1440), sy*(475/900), sx*(210/1440), sy*(40/900), tocolor(0, 0, 0, 200))
	else
		dxDrawRectangle(sx*(720/1440), sy*(475/900), sx*(210/1440), sy*(40/900), tocolor(0, 0, 0, 150))
	end
	exports.VGdrawing:dxDrawBorderedText("No, thank you.", sx*(720/1440), sy*(475/900), sx*(930/1440), sy*(515/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")	
	
	exports.VGdrawing:dxDrawBorderedRectangle(sx*(500/1440), sy*(525/900), sx*(430/1440), sy*(5/900), tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(sx*(500/1440), sy*(525/900), sx*(4.3/1440)*timeLeft, sy*(5/900), tocolor(255, 255, 0, 255))
end


--Function to handle the clicks on the UI
addEventHandler("onClientClick", root, 
	function (btn, state)
		if ( btn == "left" ) and ( state == "down" ) then
			if ( isMechReqShowing ) then
				if ( isDrawElementSelected (  sx*(500/1440), sy*(475/900), sx*(710/1440), sy*(515/900) ) ) then --Yes btn
					removeEventHandler ( "onClientRender", root, drawConfirmationUI )
					showCursor( false, false )
					isMechReqShowing = false
					triggerServerEvent ( "anwerMechProposal", localPlayer, mechanic, true, vehicle, price )
					if ( isTimer ( timer ) ) then killTimer ( timer ) end
				elseif ( isDrawElementSelected ( sx*(720/1440), sy*(475/900), sx*(930/1440), sy*(515/900) ) ) then -- No btn
					removeEventHandler ( "onClientRender", root, drawConfirmationUI )
					showCursor( false, false )
					isMechReqShowing = false
					triggerServerEvent ( "anwerMechProposal", localPlayer, mechanic, false )
					if ( isTimer ( timer ) ) then killTimer ( timer ) end
				end
			elseif ( isReceiptShowing ) then
				if ( isDrawElementSelected (  sx*(906/1440), sy*(240/900), sx*(925/1440), sy*(259/900) ) ) then --Close receipt (X)
					removeEventHandler ( "onClientRender", root, drawReceipt )
					showCursor( false, false )
					isReceiptShowing = false
					receiptData = {}
				end			
			end
		end
	end
)



---- Utilities function

--Get the closest vehicle within a 5 meters radius
function getClosestVehicle ( player )
	local myx, myy, myz = getElementPosition(player)
	local maxDistance = 5
	local closestVehicle = false
	for i, vehicle in ipairs ( getElementsByType ( "vehicle" ) ) do
		if ( isElementStreamedIn ( vehicle ) ) and not ( isVehicleBlown ( vehicle ) ) then
			local vehx, vehy, vehz = getElementPosition ( vehicle )
			local distance = getDistanceBetweenPoints3D ( myx, myy, myz, vehx, vehy, vehz )
			local sx, sy, sz = getElementVelocity ( vehicle )
			if ( distance <= maxDistance ) and ( sx + sy + sz <= 0 ) then
				maxDistance = distance
				closestVehicle = vehicle
			end
		end
	end
	return closestVehicle
end

-- Check if the draw element is selected
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

-- Function to draw bordered text
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