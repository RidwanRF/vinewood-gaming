


local tostring = tostring
local tonumber = tonumber




-- Tables for the fuel markers
local pumpsMarkers = {}
local pumpsTable = exports.VGtables:getTable('fuelstations')


-- Some stats
local isPumping = false
local fuelPrice = 5
local currentMarker
local doEventHandlers

-- When the player enters a vehicle
addEventHandler ( "onClientVehicleEnter", root,
	function ( thePlayer, seat )
		if ( thePlayer == localPlayer ) and ( seat == 0 ) then
			if ( fuelTimer ) and ( isTimer( fuelTimer ) ) then killTimer( fuelTimer ) end
			if not ( getElementData ( source, "vehicleFuel" ) ) then
				setElementData ( source, "vehicleFuel", 100 )
			elseif ( getElementData ( source, "vehicleFuel" ) <= 0 ) then
				disableVehicleFunctions( source )
			else
				enableVehicleFunctions( source )
			end

			if ( doEventHandlers ) then
				addEventHandler ( "onClientVehicleExit", source, onVehicleExitDestroy, false )
				addEventHandler ( "onClientElementDestroy", source, onVehicleExitDestroy, false )
				doEventHandlers = false
			end

			fuelTimer = setTimer ( onDecreaseFuel, 30000, 0 )
		end
	end
)

-- Disable all vehicle functions whenever the vehicle has no fuel left
function disableVehicleFunctions ( theVehicle )
	if ( fuelTimer ) and ( isTimer( fuelTimer ) ) then killTimer( fuelTimer ) end
	setVehicleEngineState( theVehicle, false )
	toggleControl ( "accelerate", false )
	toggleControl ( "brake_reverse", false )
	exports.VGdx:showMessageDX( "You ran out of fuel! Call a mechanic or use a jerrycan to refuel your vehicle!", 0, 225, 0 )
end

-- Enable the vehicle functions again
function enableVehicleFunctions( theVehicle )
	setVehicleEngineState( theVehicle, true )
	toggleControl ( "accelerate", true )
	toggleControl ( "brake_reverse", true )
end

-- When the resource starts
addEventHandler ( "onClientResourceStart", resourceRoot,
	function ()
		if ( getPedOccupiedVehicle ( localPlayer ) ) and ( getVehicleOccupant ( getPedOccupiedVehicle ( localPlayer ), 0 ) == localPlayer ) then
			doEventHandlers = true
			local theVehicle = getPedOccupiedVehicle ( localPlayer )
			if not ( getElementData ( theVehicle, "vehicleFuel" ) ) then
				setElementData ( theVehicle, "vehicleFuel", 100 )
			elseif ( getElementData ( theVehicle, "vehicleFuel" ) <= 0 ) then
				disableVehicleFunctions( theVehicle )
			end

			if ( doEventHandlers ) then
				addEventHandler ( "onClientVehicleExit", root, onVehicleExitDestroy, false )
				addEventHandler ( "onClientElementDestroy", root, onVehicleExitDestroy, false )
				doEventHandlers = false
			end

			fuelTimer = setTimer ( onDecreaseFuel, 30000, 0 )
		end
	end
)

-- Function when a vehicle gets destroyed or when a player exit the vehicle
function onVehicleExitDestroy ( theVehicle )
	local theVehicle = theVehicle or source
	if ( fuelTimer ) and ( isTimer( fuelTimer ) ) then killTimer( fuelTimer ) end

	if ( getElementData ( theVehicle, "vehicleFuel" ) ) then
		setElementData ( theVehicle, "vehicleFuel", getElementData ( theVehicle, "vehicleFuel" ) )
	end

	unbindKey ( "space", "down", onRefuelVehicle )
	unbindKey ( "space", "up", onStopRefuelVehicle )
	isPumping = false

	if ( theVehicle ) then
		removeEventHandler ( "onClientVehicleExit", theVehicle, onVehicleExitDestroy, false )
		removeEventHandler ( "onClientElementDestroy", theVehicle, onVehicleExitDestroy, false )
		doEventHandlers = true
	end
end

-- When the resource gets stopped
addEventHandler ( "onClientResourceStop", resourceRoot,
	function ()
		if ( getPedOccupiedVehicle ( localPlayer ) ) and ( getVehicleOccupant ( getPedOccupiedVehicle ( localPlayer ), 0 ) == localPlayer ) then
			onVehicleExitDestroy ( getPedOccupiedVehicle ( localPlayer ) )
		end
	end
)

-- Function that decreases the fuel
function onDecreaseFuel ()
	local theVehicle = getPedOccupiedVehicle ( localPlayer )
	if ( theVehicle ) then
		if ( getElementModel ( theVehicle ) == 509 ) or ( getElementModel ( theVehicle ) == 481 ) or ( getElementModel ( theVehicle ) == 510 ) then return end
		local theFuel = getElementData ( theVehicle, "vehicleFuel" )
		if not ( getTeamName( getPlayerTeam( localPlayer ) ) == "Staff" ) and ( theFuel ) and not ( isPumping ) and ( getVehicleEngineState ( theVehicle ) ) and ( theFuel > 0 ) and ( getVehicleOccupant ( getPedOccupiedVehicle ( localPlayer ), 0 ) == localPlayer ) then
			setElementData ( theVehicle, "vehicleFuel", theFuel - 1 )
			if ( getElementData ( theVehicle, "vehicleFuel" ) <= 0 ) then
				disableVehicleFunctions( theVehicle )
			end
		end
	end
end

-- Get the vehicle speed
function getVehicleSpeed ( theVehicle, unit )
	if ( unit == nil ) then unit = 0 end
	if ( isElement( theVehicle ) ) then
		local x,y,z = getElementVelocity( theVehicle )
		if ( unit=="mph" or unit==1 or unit =='1' ) then
			return ( x^2 + y^2 + z^2 ) ^ 0.5 * 100
		else
			return ( x^2 + y^2 + z^2 ) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

-- When the player hits a fuel marker
function onFuelPumpMarkerHit ( hitElement, matchingDimension, msgs, theMarker )
	local theMarker = theMarker or source
	if ( hitElement ) and ( getElementType ( hitElement ) == "player" ) and ( matchingDimension ) and ( getPedOccupiedVehicle( hitElement ) ) and ( isFuelMarker ( theMarker ) ) and ( getVehicleController( getPedOccupiedVehicle( hitElement ) ) == localPlayer ) then
		local theVehicle = getPedOccupiedVehicle( hitElement )
		if ( getVehicleSpeed ( theVehicle, "kmh" ) >= 1 ) then
			if ( msgs ~= 1 ) or ( msgs ~= 2 ) then exports.VGdx:showMessageDX ( "Please bring the vehicle to a complete stop!", 225, 0, 0 ) end
			setTimer( onFuelPumpMarkerHit, 1000, 1, hitElement, true, 1, theMarker )
		elseif ( getVehicleEngineState( theVehicle ) ) then
			if ( msgs ~= 2 ) then exports.VGdx:showMessageDX ( "Turn off the vehicle engine before refueling! (Press 'Z')", 225, 0, 0 ) end
			setTimer( onFuelPumpMarkerHit, 1000, 1, hitElement, true, 2, theMarker )
		elseif ( getElementData( theVehicle, "vehicleFuel" ) >= 100 ) then
			exports.VGdx:showMessageDX ( "Your vehicle has already a full tank!", 225, 0, 0 )
		else
			currentMarker = theMarker
			bindKey ( "space", "down", onRefuelVehicle )
			exports.VGdx:showMessageDX ( "Keep holding 'space' to refuel your vehicle!", 0, 255, 0 )
		end
	end
end

-- When the player hits a fuel marker
function onFuelPumpMarkerLeave ( hitElement, matchingDimension )
	if ( hitElement == localPlayer ) then
		unbindKey ( "space", "down", onRefuelVehicle )
		unbindKey ( "space", "up", onStopRefuelVehicle )

		isPumping = false
	end
end

-- When the player press the space button to refuell
function onRefuelVehicle ()
	if ( getPedOccupiedVehicle( localPlayer ) ) then
		local theVehicle = getPedOccupiedVehicle( localPlayer )
		if ( getPlayerMoney() < fuelPrice ) then
			exports.VGdx:showMessageDX ( "You don't have enough money, the price is $" .. fuelPrice .." per litre!", 255, 0, 0 )
		else
			local oldFuel = math.floor( getElementData ( theVehicle, "vehicleFuel" ) )
			setTimer ( onRefillVehicle, 250, 1, theVehicle, oldFuel )
			exports.VGdx:showMessageDX ( "We are refueling your vehicle, please wait...", 0, 255, 0 )

			isPumping = true

			unbindKey ( "space", "down", onRefuelVehicle )
			bindKey ( "space", "up", onStopRefuelVehicle )
		end
	else
		onStopRefuelVehicle ()
	end
end

-- Actualy refill the vehicle
function onRefillVehicle( theVehicle, oldFuel, price )
	if ( theVehicle ) and ( oldFuel ) then
		local theFuel = tonumber( oldFuel )
		local thePrice = tonumber( price ) or 0
		if not ( getKeyState ( "space" ) ) then
			onStopRefuelVehicle ( theFuel, thePrice, theVehicle )
		elseif ( getPlayerMoney() < fuelPrice ) and not ( getElementData( theVehicle, "vehicleOccupation" ) ) then
			exports.VGdx:showMessageDX ( "You don't have enough money to continue refueling, the price is $" .. fuelPrice .." per litre!", 255, 0, 0 )
			onStopRefuelVehicle ( theFuel, thePrice, theVehicle )
		elseif ( oldFuel >= 100 ) then
			onStopRefuelVehicle ( theFuel, thePrice, theVehicle )
		else
			theFuel = math.floor( theFuel + 1 )
			thePrice = math.floor( thePrice + 5 )
			setTimer ( onRefillVehicle, 250, 1, theVehicle, theFuel, thePrice )
			setElementData ( theVehicle, "vehicleFuel", theFuel )
		end
	end
end

-- When the player stops pressing space or stop fuel
function onStopRefuelVehicle ( theFuel, thePrice, theVehicle )
	unbindKey ( "space", "up", onStopRefuelVehicle )
	isPumping = false

	if ( theFuel ) and ( thePrice ) and not ( tostring( theFuel ) == "space" ) then
		if ( tonumber( theFuel ) < 100 ) then bindKey ( "space", "down", onRefuelVehicle ) exports.VGdx:showMessageDX ( "Keep holding 'space' to refuel your vehicle!", 225, 0, 0 ) end
		triggerServerEvent ( "takePlayerFuelPayment", localPlayer, thePrice )
		if ( thePrice ) then exports.VGdx:showMessageDX ( "You paid $" .. thePrice .. " for the refilling!", 0, 255, 0 ) end
	end
end

-- Create the markers and blips
addEventHandler ( "onClientResourceStart", resourceRoot, 
	function ()
		for i=1,#pumpsTable do
			local x, y, z = pumpsTable[i][1], pumpsTable[i][2], pumpsTable[i][3]
			local theMarker = createMarker ( x, y, z -1, "cylinder", 3.0, 135, 132, 134, 70 )
			table.insert ( pumpsTable, theMarker )
			addEventHandler ( "onClientMarkerHit", theMarker, onFuelPumpMarkerHit, false )
			addEventHandler ( "onClientMarkerLeave", theMarker, onFuelPumpMarkerLeave, false )
		end	
	end
)

-- Function for get all the fuel pump markers
function getFuelMarkers ()
	if ( pumpsMarkers ) then 
		return pumpsMarkers 
	else 
		return false 
	end
end

-- Check if a marker is a fuel marker
function isFuelMarker ( theMarker )
	for k, aMarker in ipairs ( pumpsTable ) do
		if ( aMarker == theMarker ) and ( isElementWithinMarker( localPlayer, theMarker ) ) then
			return true
		end
	end
	return false
end

-- Exports to set vehicle fuel
function setVehicleFuel ( theVehicle, theFuel )
	if ( theVehicle ) and ( isElement( theVehicle ) ) and ( theFuel ) then
		setElementData ( theVehicle, "vehicleFuel", theFuel )
		return true
	else
		return false
	end
end

-- Exports to get vehicle fuel
function getVehicleFuel ( theVehicle )
	if ( theVehicle ) and ( isElement( theVehicle ) ) then
		return getElementData ( theVehicle, "vehicleFuel" )
	else
		return false
	end
end