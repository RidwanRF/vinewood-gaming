
math = math

local labourCost = 200
local costPerHealth = 2
local costPerTire = 100

local isBeingRepaired = {}
local pendingRepairs = {}
local costs = {}
local mechanicsRepairing = {}

addEvent("onPlayerRepairVehicle", true)
function repairVehicle ( mechanic, customer, vehicle )
	if not ( ( isElement ( mechanic ) ) or ( isElement ( customer ) ) or ( isElement ( vehicle ) ) ) then return end
	if ( mechanicsRepairing [ mechanic ] ) then return end
	if ( isBeingRepaired [ vehicle ] ) then
		exports.VGdx:showMessageDX(mechanic, "The vehicle is already being repaired.", 255, 0, 0)
		return
	end
	local healthCost,  tireCost, labourCost = calculateRepairCost ( vehicle )
	local cost = healthCost + tireCost + labourCost
	if ( cost > getPlayerMoney ( customer ) ) then
		exports.VGdx:showMessageDX(mechanic, "The customer doesn't have enough money at the moment!", 255, 0, 0)
		return
	end
	mechanicsRepairing [ mechanic ] = true
	costs [ vehicle ] = {healthCost,  tireCost, labourCost}
	pendingRepairs [ customer ] = {mechanic, vehicle}
	isBeingRepaired [ vehicle ] = true
	setElementFrozen ( mechanic, true )
	setElementFrozen ( customer, true )
	setElementFrozen ( vehicle, true )
	exports.VGdx:showMessageDX ( mechanic, "Awaiting customer's response...", 0, 255, 0 )
	
	addEventHandler ( "onPlayerQuit", customer, onCustomerQuit )
	
	triggerClientEvent ( customer, "getCustomerConfirmation", mechanic, vehicle, cost)
end
addEventHandler("onPlayerRepairVehicle", root, repairVehicle)

function calculateRepairCost(vehicle)
	local healthCost = ( 1000 - getElementHealth ( vehicle ) ) * costPerHealth
	local w1, w2, w3, w4 = getVehicleWheelStates ( vehicle )
	local flatTires = w1 + w2 + w3 + w4
	local tireCost = flatTires * costPerTire
	return healthCost,  tireCost, labourCost 
end

function onCustomerQuit()
	exports.VGdx:showMessageDX ( pendingRepairs [ source ] [ 1 ], "Your customer has logged out.", 255, 0, 0 )
	setElementFrozen ( pendingRepairs [ source ] [ 1 ], false )
	setElementFrozen ( pendingRepairs [ source ] [ 2 ] , false )
	isBeingRepaired [ pendingRepairs [ source ] [ 2 ] ] = nil
	pendingRepairs [ source ] = nil
	mechanicsRepairing [ pendingRepairs [ source ] [ 1 ] ] = nil
	removeEventHandler ( "onPlayerQuit", source, onCustomerQuit )
end

addEvent("anwerMechProposal", true)
function anwerMechProposal (mechanic, answer, vehicle)
	pendingRepairs [ source ] = nil
	removeEventHandler("onPlayerQuit", source, onCustomerQuit)
	local healthCost,  tireCost, labourCost = unpack(costs [ vehicle ] ) 
	costs [ vehicle ] = nil
	local cost = math.round( healthCost + tireCost + labourCost, 0 )
	if ( answer ) and ( isElement ( mechanic ) ) then
		setPedAnimation ( mechanic, "BOMBER", "BOM_Plant_Loop", 10000, true, false, false, false )
		triggerClientEvent ( mechanic, "onVehicleBeingRepaired", mechanic )
		triggerClientEvent ( source, "onVehicleBeingRepaired", mechanic, healthCost,  tireCost, labourCost  )
		setTimer ( endVehicleRepair, 10000, 1, mechanic, source, vehicle, true,  cost )
	elseif ( isElement ( mechanic ) ) then
			exports.VGdx:showMessageDX ( mechanic, "The customer has declined your services.", 255, 0, 0 )
			endVehicleRepair ( mechanic, source, vehicle, false )
	end
end
addEventHandler("anwerMechProposal", root, anwerMechProposal)

function endVehicleRepair(mechanic, customer, vehicle, repaired, cost )
	if ( repaired ) then
		setElementFrozen(mechanic, false)
		exports.VGplayers:givePlayerCash ( mechanic, cost, "Repaired a vehicle" )
		exports.VGdx:showMessageDX(mechanic, "You have earned "..cost.."$".." for repairing a vehicle.", 255, 0, 0)

		setElementFrozen ( customer, false )
		exports.VGplayers:takePlayerCash ( customer, cost, "Vehicle repair" )
		exports.VGdx:showMessageDX(customer, "You have paid "..cost.."$".." to have your vehicle repaired.", 255, 0, 0)

		setElementFrozen ( vehicle, false )
		isBeingRepaired [ vehicle ] = nil
		fixVehicle( vehicle )
	elseif not ( repaired ) then			
		setElementFrozen(mechanic, false)
		setElementFrozen ( customer, false )
		setElementFrozen ( vehicle, false )
		isBeingRepaired [ vehicle ] = nil
	end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
