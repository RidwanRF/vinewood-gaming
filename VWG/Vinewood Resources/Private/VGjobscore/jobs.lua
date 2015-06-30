-- Vehicle table
jobSettingsTable = exports.VGtables:getTable('jobs')

-- Create the markers
local markerColors = {
	["blue"] = {0, 0, 255},
	["lightblue"] = {65, 105, 225},
	["yellow"] = {255, 255, 0},
	["red"] = {255, 0, 0}
}
local blipColors = {
	["blue"] = "imgs/blue.png",
	["lightblue"] = "imgs/lightblue.png",
	["yellow"] = "imgs/yellow.png",
	["red"] = "imgs/red.png"
}
skinColors = {
	["blue"] = "imgs/blueSkin.png",
	["lightblue"] = "imgs/lightblueSkin.png",
	["yellow"] = "imgs/yellowSkin.png",
	["red"] = "imgs/redSkin.png"
}

jobMarkers = { }


local unpack = unpack

-- Create everything 
for i, v in pairs(jobSettingsTable) do

	for index, value in pairs(v.bossX) do
		-- get all needed table settings
		local bossX, bossY, bossZ, bossRot, bossSkin = v.bossX[index], v.bossY[index], v.bossZ[index], v.bossRot[index], v.bossSkin
		local markerOffSetX, markerOffSetY, markerOffSetZ, markerColor = v.markerOffSetX[index], v.markerOffSetY[index], v.markerOffSetZ[index], v.markerColor
		local interior, dimension = v.interior[index], v.dimension[index]
		local blipX, blipY, blipColor = v.blipX[index], v.blipY[index], v.blipColor
		
		-- create the ped(boss) set the sit animation and the right interior/dimension
		local boss = exports.VGpeds:createStaticPed(bossSkin, bossX, bossY, bossZ, bossRot)
		setElementInterior(boss, interior)
		setElementDimension(boss, dimension)
		setElementFrozen(boss, true)
		addEventHandler("onClientPedDamage", boss, cancelEvent)
		
		-- create the marker, set the right interior and dimension, attach it to the boss ped with the right offsets and add the event handlers
		local mr, mg, mb = unpack(markerColors[markerColor])
		local marker = createMarker(0,0,0, "cylinder", 0.9, mr, mg, mb)
		setElementInterior(marker, interior)
		setElementDimension(marker, dimension)
		attachElements(marker, boss, markerOffSetX, markerOffSetY, markerOffSetZ)
		jobMarkers[marker] = i
		addEventHandler("onClientMarkerHit", marker, openJobGUI)
		addEventHandler("onClientMarkerLeave", marker, closeJobGUI)
		
		-- Create the blip
		exports.customblips:createCustomBlip ( blipX, blipY, 20, 20, blipColors[blipColor], 75)
	end
end