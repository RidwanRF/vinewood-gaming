
unpack = unpack
pairs = pairs

local plantsID = {
["Marijuana Seed"] = {862, "marijuana"},
["Coca Bush Seed"] = {861, "coca bush"},
}
local pots = { }

function plantDrug (thePlayer)
		setPedAnimation(client, "BOMBER", "BOM_Plant", -1, false ) 
		setTimer(setPedAnimation, 1000, 1, client)
		local x, y, z = getElementPosition(client)
		local pot = createObject(743, x, y, z-0.7)
		local plant = createObject(plantsID[itemName][1], x, y, z-0.4)
		setObjectScale(plant, 0.0625)
		local timer = setTimer(grow, 240000, 15, pot)--240000
		setElementData(pot, "plantName", plantsID[itemName][2])
		pots[pot] = {plant, timer}
		triggerClientEvent("onPotCreated", pot, root )
end

--Function triggered by a timer that simulates the growth of the plant
function grow (pot)
	local plant = pots[pot][1]
	local size = getObjectScale(plant) 
	local size = size + 0.0625
	setObjectScale(plant, size)
	if ( size == 1 ) then setElementData(pot, "isDrugReadyToHarvest", true) end
end


addEvent("onPotSeized", true)
function seizePot (pot)
--ACTION REQUIRED
	setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false ) 
	setTimer(setPedAnimation, 1000, 1, source)
	destroyPot(pot)
	exports.VGstats:updatePlayerStat( source, "Drug Busts", 1 )
	--exports.VGplayers:givePlayerCash( source, amount, reason )
end
addEventHandler("onPotSeized", root, seizePot)

addEvent("onPotHarvested", true)
function harvestPot (pot)
	setPedAnimation(source, "BOMBER", "BOM_Plant", -1, false ) 
	setTimer(setPedAnimation, 1000, 1, source)
	local drugType = getElementData(pot, "plantName")
	destroyPot(pot)
	exports.VGinventory:givePlayerItem ( client, drugType, math.random ( 1, 4 ) )
end
addEventHandler("onPotHarvested", root, harvestPot)

--Function that destroys a pot
addEvent("onPotCollision", true)
function destroyPot (pot)
	if ( pot ) then
		local plant, timer = unpack(pots[pot])
		pots[pot] = nil
		triggerClientEvent("onPotDestroyed", pot, root)
		if ( isElement(pot) ) then destroyElement(pot) end
		if ( isElement(plant) ) then destroyElement(plant) end
		if ( isTimer(timer) ) then killTimer(timer) end
	end
end
addEventHandler("onPotCollision", root, destroyPot)

--synch the player when he connects
function onPlayerConnect ()
	for i, _ in pairs(pots) do
		triggerClientEvent("onPotCreated", i, source )
	end
end
addEventHandler("onPlayerLogin", root, onPlayerConnect)