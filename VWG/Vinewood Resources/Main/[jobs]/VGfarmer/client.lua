local trailer = createVehicle(450, -1160.59998, -1121.5, 129.89999, 0, 0, 270)
setElementFrozen(trailer, true)
setVehicleDamageProof(trailer, true)
--COMMAND TO DETACH

setDevelopmentMode(true)

local vehicleLoads = { }
local vehicleMarkers = { }

addEvent("onPlayerEnterJobVehicle", true)
function onPlayerEnterHarvester ()
	if ( getElementData(localPlayer, "Occupation") == "Farmer" ) and ( getElementModel(source) == 532 ) then
		
		
		local harvestMarker = createMarker(0,0,0, "cylinder", 8)
		attachElements(harvestMarker, source, 0, 4, -2, 0, 0, 0)
		addEventHandler("onClientMarkerHit", harvestMarker,  harvest)
		vehicleMarkers[source] = harvestMarker
		exports.VGprogbar:dxCreateProgressBar( "Vehicle load", "", false, 255, 255,0 , 255, 215, 0 )
		if not (vehicleLoads[source]) then 
			vehicleLoads[source] = 0 
		else
			exports.VGprogbar:dxChangeProgressBarProgress ( vehicleLoads[source] ) 
		end
	
	end
end
addEventHandler("onPlayerEnterJobVehicle", root, onPlayerEnterHarvester)


addEvent("onPlayerExitJobVehicle", true)
function onPlayerExitHarvester ()
	if ( getElementData(localPlayer, "Occupation") == "Farmer" ) and ( getElementModel(source) == 532 ) then
		exports.VGprogbar:destroyProgressBar( true )
		if ( isElement(vehicleMarkers[source]) ) then removeEventHandler("onClientMarkerHit", vehicleMarkers[source],  harvest) destroyElement(vehicleMarkers[source]) end
	end
end
addEventHandler("onPlayerExitJobVehicle", root, onPlayerExitHarvester)


-- function to delete de bar and the marker on veh delete


function harvest (hitElement, md)
	if ( hitElement ) and ( md ) then
		local load = exports.VGprogbar:dxGetProgressBarProgress( ) 
		if ( load ~= 100 ) then
			if ( isElement(hitElement) ) then destroyElement(hitElement) end
			local load = load + 1
			vehicleLoads[getElementAttachedTo(source)] = load
			exports.VGprogbar:dxChangeProgressBarProgress ( load ) 
		else
			harvesterFull(getElementAttachedTo(source))
		end
	end
end

function harvesterFull (vehicle)
	--createMarker()

end


