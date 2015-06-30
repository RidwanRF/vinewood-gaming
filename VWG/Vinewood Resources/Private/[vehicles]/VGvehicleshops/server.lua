--[[local file = fileOpen("output.lua")
addEvent("submitVehicleDetails", true)

function insertOnFile (text)
	fileWrite(file, row)
end
addEventHandler("submitVehicleDetails", root, insertOnFile)

addCommandHandler("closefile", function()
	fileClose(file)
end)]]



local unpack = unpack


addEvent("onPlayerBuyVehicle", true)
function onPlayerBuyVehicle (id, vehX, vehY, vehZ, vehRot, R1, G1, B1, R2, G2, B2)
	outputChatBox("Vehicle Shops: needs finishing", client)
end
addEventHandler("onPlayerBuyVehicle", root, onPlayerBuyVehicle)





----------------------------------------------------------------------------------------------
--------------------------------------------IMPORT---------------------------------------
----------------------------------------------------------------------------------------------
local timeUntilNextArrival = 150 --Minutes
--The Vessel takes 30 minutes from departure till arrival in SA so if there is less then 30 minutes until a vessel arrives the vehicle that has been ordered  will only be dispatched in the next load cuz the shipment is already on the move
local currentShipment = {}
local nextShipment = {}
local spawnPositions = {
	["Los Santos"] = { 2416.811, -2466.903, 13.625, 314.738},
	["San Fierro"] = { -1729.694, -38.31, 3.555, 315.227},
}

setTimer(function ()
	timeUntilNextArrival = timeUntilNextArrival - 1 
	if ( timeUntilNextArrival == 0 ) then
		deliverVehicles()
		timeUntilNextArrival = 150
		currentShipment = nextShipment
		nextShipment = { }
		
	end
end, 60000, 0 )

function getTimeUntilArrival ()
	if ( timeUntilNextArrival < 30 ) then
		return 150 + timeUntilNextArrival
	else 
		return timeUntilNextArrival 
	end
end


addEvent("onVehicleBought", true)
function addVehicleToShipmentList (vehicleModel, city, price)
	exports.VGplayers:takePlayerCash( client, price, "Import Center: Bought a(n) "..getVehicleNameFromModel(vehicleModel) )
	if ( timeUntilNextArrival  < 30 ) then
		nextShipment[client] = { vehicleModel, city }
	else
		currentShipment[client] = { vehicleModel, city }
	end
end
addEventHandler("onVehicleBought", root, addVehicleToShipmentList )

function deliverVehicle ()
	for i, v in ipairs(currentShipment) do
		local city = currentShipment[i][2]
		local sx, sy, sz, srot = unpack(spawnPositions[city])
		--SMS to owner (i)
		--Add vehicle to the owner
	end

end