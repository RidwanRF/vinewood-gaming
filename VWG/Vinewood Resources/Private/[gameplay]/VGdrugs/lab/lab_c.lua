
ipairs = ipairs
math = math

local sx, sy = guiGetScreenSize()

function showLabel (hitElement)
	if ( getPedOccupiedVehicle( localPlayer ) ) or not ( hitElement == localPlayer ) then return end
	if not ( isElement ( machineLabel ) ) then
		machineLabel = guiCreateLabel(0, 0.7, 1, 0.3, "Open your inventory and select an item to put on the "..getElementData(source, "machineName"), true)
		guiLabelSetHorizontalAlign(machineLabel, "center", true)
	end
end

function destroyLabel ()
	if ( machineLabel ) and ( isElement( machineLabel ) ) then destroyElement ( machineLabel ) machineType = false end
end

-- function that handles the item the player clicked and if that item can be used 
addEvent("onPlayerInventoryItemUse")
function onItemUse (itemName)
	local colShape = getColShapeThePlayerIsIn ()
	if ( colShape ) and ( isDrugItem(itemName) ) and ( drugItems[itemName][1] == "raw material" ) then
		if ( getElementData(colShape, "machineName") == "squeezer" ) then
			for i, v in ipairs(squeezerList) do
				if ( itemName == i ) then produceItem(i, squeezerList[i][1], squeezerList[i][2]) return end
			end
			cancelEvent()
			exports.VGdx:showMessageDX( "You can't use this item on this machine", 255, 0, 0)
			return
		elseif ( getElementData(colShape, "machineName") == "distiller" ) then
			for i, v in ipairs(destillerList) do
				if ( itemName == i ) then produceItem(i, destillerList[i][1], destillerList[i][2]) return end
			end
			cancelEvent()
			exports.VGdx:showMessageDX( "You can't use this item on this machine", 255, 0, 0)
			return
		elseif ( getElementData(colShape, "machineName") == "microwaves" ) then
			for i, v in ipairs(microwavesList) do
				if ( itemName == i ) then produceItem(i, microwavesList[i][1], microwavesList[i][2]) return end
			end
			cancelEvent()
			exports.VGdx:showMessageDX( "You can't use this item on this machine", 255, 0, 0)
			return
		end
	end
end
addEventHandler("onPlayerInventoryItemUse", root, onItemUse)

-- Function that starts processing the item the player chose
function produceItem(itemName, finalItemName, timeToProduce)
	showCursor(true)
	exports.VGprogbar:createProgressBar ( timeToProduce/100, "Producing drug...", "", true )
	setTimer(finishProdution, timeToProduce, 1, finalItemName)
end

function finishProdution (finalProduct)
	addEventHandler("onClientRender", root, drawPickBox)
	drugToPickup = finalProduct
end

-- Function that creates a dx box for the player to pick the item that has been produced
function drawPickBox ()
	dxDrawRectangle(sx*(560/1280), sy*(400/960), sx*(160/1280), sy*(160/960), tocolor(0, 0, 0))
	dxDrawRectangle(sx*(559/1280), sy*(401/960), sx*(162/1280), sy*(158/960), tocolor(0, 0, 0))
	dxDrawRectangle(sx*(561/1280), sy*(399/960), sx*(158/1280), sy*(162/960), tocolor(0, 0, 0))

	dxDrawRectangle(sx*(565/1280), sy*(405/960), sx*(150/1280), sy*(150/960), tocolor(255, 255, 255))
	dxDrawRectangle(sx*(564/1280), sy*(406/960), sx*(152/1280), sy*(148/960), tocolor(255, 255, 255))
	dxDrawRectangle(sx*(566/1280), sy*(404/960), sx*(148/1280), sy*(152/960), tocolor(255, 255, 255))

	dxDrawRectangle(sx*(565/1280), sy*(405/960), sx*(150/1280), sy*(150/960), tocolor(0, 0, 0, 200))
	dxDrawRectangle(sx*(564/1280), sy*(406/960), sx*(152/1280), sy*(148/960), tocolor(0, 0, 0, 200))
	dxDrawRectangle(sx*(566/1280), sy*(404/960), sx*(148/1280), sy*(152/960), tocolor(0, 0, 0, 200))
	
	if ( drugToPickup ) then
		dxDrawImage(sx*(565/1280), sy*(405/960), sx*(150/1280), sy*(150/960), drugItems[drugToPickup][2] )
	end
	if ( isDrawElementSelected ( sx*(565/1280), sy*(405/960), sx*(715/1280), sy*(555/960) ) ) then
		local x, y = getCursorPosition()
		dxDrawBorderedText ( "Double click to add to the inventory", (x*sx)+20, (y*sy), (x*sx)+200, (y*sy)+20, tocolor(255, 255, 255), 1, "default-bold", "left", "top" )
		-- Function to handle the double clicks
		function clickHandler (btn)
			if ( btn == "left" ) then
				if ( isDrawElementSelected ( sx*(565/1280), sy*(405/960), sx*(715/1280), sy*(555/960) ) ) then
					triggerServerEvent("onPlayerCollectDrugsFromMachine", drugToPickup, math.random (1, 3 ))
					drugToPickup = false
					setTimer(removeEventHander("onClientRender", root, drawPickBox), 500, 1)
				end
			end
		end
		addEventHandler("onClientDoubleClick", root, clickHandler )
	end
end

--function to get the machine on which the player is
function getColShapeThePlayerIsIn ()
	for i=1, #machineColShapes do
		if ( isElementWithinColShape( localPlayer, machineColShapes[i] ) ) then return machineColShapes[i] end
	end
	return false
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

createMachines ()