local pots = { }
local colShapes = { }


addEvent("onPlayerInventoryItemUse")
function onDrugItemUsed (itemName)
	if ( isDrugItem(itemName) ) and ( drugItems[itemName][1] == "seed" )then
		for i, v in ipairs(seedsList) do
			if ( itemName == i ) and ( isPedOnGround ( localPlayer ) ) and not ( isElementInWater ( localPlayer ) ) and not ( pots[getPedContactElement(thePlayer)] )then triggerServerEvent("onPlayerPlantDrugPlant", localPlayer, itemName) return end
		end
		cancelEvent()
		exports.VGdx:showMessageDX( "You can't plant that here", 255, 0, 0)
		
	elseif ( isDrugItem(itemName) ) and ( drugItems[itemName][1] == "drug" ) then
		if ( itemName == "Marijuana" ) then
			setMarijuanaEffects( true )
		elseif ( itemName == "Cocaine" ) then
			setCocaineEffects( true )
		elseif ( itemName == "Heroin" ) then
			setHeroinEffects( true )
		elseif ( itemName == "LSD" ) then
			setLSDEffects( true )
		elseif ( itemName == "Crack Cocaine" ) then
			setCrackCocaineEffects( true )
		end
		drugEffectsDuration[itemName] = drugEffectsDuration[itemName] + hitDuration[itemName]
	end
end
addEventHandler("onPlayerInventoryItemUse", root, onDrugItemUsed)


addEvent("onPotCreated", true)
function createPot ()
	local x, y, z = getElementPosition(source)
	local colShape = createColSphere(x, y, z+1, 1 )
	addEventHandler("onClientColShapeHit", colShape, onPlayerEnterColShape)
	addEventHandler("onClientColShapeLeave", colShape, onPlayerLeaveColShape)
	
	colShapes[colShape] = source
	pots[source] = {true, colShape}
end
addEventHandler("onPotCreated", root, createPot)


-- when a player approaches a pot give him the action option he has and bind the keys
function onPlayerEnterColShape(hitElement, md)
	if ( getElementType(hitElement) == "player" ) and ( md ) then
		local pot = colShapes[source]
		if ( exports.VGlaw:isPlayerLaw(hitElement) ) and not ( isElement( potLabel ) ) then	
			potLabel = guiCreateLabel(0, 0.7, 1, 0.3, "Press F to seize the "..getElementData(pot, "drugName"), true)
			guiLabelSetHorizontalAlign(potLabel, "center", true)
			bindKey ( "f", "down", seizePot, pot )
		elseif not ( isElement( potLabel ) ) and ( getElementData(pot, "isDrugReadyToHarvest") ) then
			potLabel = guiCreateLabel(0, 0.7, 1, 0.3, "Press F to harvest the "..getElementData(pot, "plantName"), true)
			guiLabelSetHorizontalAlign(potLabel, "center", true)
			bindKey ( "f", "down", harvestPot, pot )
		end
	end
end

--when a player steps away from a a pot remove any existing label
function onPlayerLeaveColShape(hitElement, md)
	if ( getElementType(hitElement) == "player" ) and ( md ) then
		if ( potLabel ) and ( isElement( potLabel ) ) then destroyElement(potLabel) end
	end
end

function seizePot (key, state, pot)
	if ( potLabel ) and ( isElement( potLabel ) ) then destroyElement(potLabel) end
	unbindKey("f", "down", seizePot)
	triggerServerEvent("onPotSeized", localPlayer, pot)
end

function harvestPot (key, state, pot)
	if ( potLabel ) and ( isElement( potLabel ) ) then destroyElement(potLabel) end
	unbindKey("f", "down", harvestPot)
	triggerServerEvent("onPotHarvested", localPlayer, pot)
end

--triggered when a pot is destroyed/harvested/seized
addEvent("onPotDestroyed", true)
function destroyPot ()
	local colShape = pots[source][2]
	pots[source] = nil
	colShapes[colShape] = nil
	if ( isElement(colShape) ) then destroyElement(colShape) end
end
addEventHandler("onPotDestroyed", root, destroyPot)


--to handle vehicle collisions with pots (avoids road blocks and other abuses)
function onVehicleCollisionWithPot (hitElement, force)
	if ( hitElement ) and ( getElementData(hitElement, "plantName") ) and ( force > 50 ) then --check if it exists, if it is a drug pot, and if the force is enough
		triggerServerEvent("onPotCollision", root, hitElement )
	end
end
addEventHandler("onClientVehicleCollision", root, onVehicleCollisionWithPot)