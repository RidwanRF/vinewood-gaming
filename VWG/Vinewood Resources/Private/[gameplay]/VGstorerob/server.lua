



local pedPositions = { --id, x, y, z, rotz, int, dim
--24/7
	{0, 2.26, -30.7, 1003.5, 0, 10, 1},
--Burger Shot
	{0, 376.57, -65.77, 1001.5, 182, 10, 1},
	{0, 376.57, -65.77, 1001.5, 182, 10, 2},
	{0, 376.57, -65.77, 1001.5, 182, 10, 3},
	{0, 376.57, -65.77, 1001.5, 182, 10, 4},
	{0, 376.57, -65.77, 1001.5, 182, 10, 5},
	{0, 376.57, -65.77, 1001.5, 182, 10, 6},
	{0, 376.57, -65.77, 1001.5, 182, 10, 7},
	{0, 376.57, -65.77, 1001.5, 182, 10, 8},
	{0, 376.57, -65.77, 1001.5, 182, 10, 9},
-- Cluckin bell
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,1},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,2},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,3},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,4},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,5},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,6},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,7},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,8},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,9},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,10},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,11},
	{0, 368.075, -4.491, 1001.852, 182.939, 9 ,12},
--Pizza
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 1},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 2},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 3},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 4},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 5},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 6},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 7},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 8},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 9},
	{0, 374.731, -117.278, 1001.492, 181.016, 5, 10},
}
local peds = { }
local robs = { }
local pickups = { }
local playersRobbing = { }
local robbers = { }

function createPeds ()
	for i=1, #pedPositions do
		local ped = createPed ( pedPositions[i][1], pedPositions[i][2], pedPositions[i][3], pedPositions[i][4], pedPositions[i][5] )
		setElementInterior ( ped, pedPositions[i][6] )
		setElementDimension ( ped, pedPositions[i][7] )
		setElementFrozen ( ped, true )
		peds[ (#peds +1) ] = ped 
		robs[ ped ] = { false, 0, { } }
	end
	setTimer(triggerClientEvent, 1000, 1, "syncPeds", root, peds)
	addEventHandler( "onPlayerLogin", root, function() setTimer(triggerClientEvent, 1000, 1, "syncPeds", root, peds) end ) 
end
createPeds ()



function onPlayerTarget ( target )
	if ( exports.VGlaw:isPlayerLaw ( source ) ) then return end
	if ( playersRobbing[ source ] ) then return end
	for i, v in ipairs ( peds ) do
		if ( target == v ) and ( getPedWeaponSlot ( source ) ~= 0 ) and ( getPedWeaponSlot ( source ) ~= 10 ) and ( getPedWeaponSlot ( source ) ~= 11 ) and ( getPedWeaponSlot ( source ) ~= 12 ) then
			if not ( robs[v][1] ) then
				triggerClientEvent ( "checkForPlayerAim", source, "newRob", v )
			else
				triggerClientEvent ( "checkForPlayerAim", source, "joinRob", v ) 
			end
		end
	end
end
addEventHandler( "onPlayerTarget", root, onPlayerTarget )

addEvent("startStoreRob", true)
function startStoreRob ( ped )
	if ( playersRobbing[ source ] ) then return end
	playersRobbing[ source ] = true
	local robbers = robs[ped][3]
	robbers[1] = source
	robs[ped] = { true, 1, robbers }
	exports.VGgetWanted:addOffence(source, 13)
	setTimer ( spawnMoney, 15000, 4, ped )
	setTimer( endStoreRob, 160000, 1, ped, source )
	triggerClientEvent ( "startStoreRob", root, source, ped ) 
end
addEventHandler("startStoreRob", root, startStoreRob)

addEvent("addPlayerToStoreRob", true)
function addPlayerToStoreRob ( ped )
	if ( playersRobbing[ source ] ) then return end
	playersRobbing[ source ] = true
	local numberOfRobbers = robs[ ped ][ 2 ]
	local robbers = robs[ped][3]
	robbers[#robbers+1] = source
	robs[ped] = { true, numberOfRobbers + 1, robbers }
	exports.VGgetWanted:addOffence(source, 13)
	triggerClientEvent ( "addPlayerToStoreRob", root, source, ped ) 
end
addEventHandler("addPlayerToStoreRob", root, addPlayerToStoreRob)


function spawnMoney ( ped )
	local x, y, z = getElementPosition ( ped )
	local rx, ry, rz = getElementRotation ( ped )
	x = x - math.sin ( math.rad ( rz ) ) * 2
	y = y + math.cos ( math.rad ( rz ) ) * 2
	local pickup =  createPickup ( x, y, z, 3, 1212 )
	local int, dim = getElementInterior ( ped ), getElementDimension ( ped )
	setElementInterior ( pickup, int )
	setElementDimension ( pickup, dim )
	pickups[pickup] = ped
	setTimer(function (pickup) if ( isElement ( pickup ) ) then destroyElement ( pickup ) end end, 45000, 1, pickup)
	addEventHandler ( "onPickupHit", pickup, function ( hitElement )
		if ( isElement ( source ) ) then destroyElement ( source ) end
		local ped = pickups[source]
		pickups[source] = nil
		local numberOfRobbers = robs[ped][2]
		local moneyAmount = math.random(50, 200)
		local moneyAmount = moneyAmount * ( numberOfRobbers+( 0.1*(numberOfRobbers-1) ) )
		exports.VGplayers:givePlayerCash( hitElement, moneyAmount, "Store Rob" ) --------------------Should I use it?
		exports.VGdx:showMessageDX( hitElement, "You have picked up $"..moneyAmount, 0, 255, 0 )
	end)
end

function endStoreRob ( ped )
	local robbers = robs[ped][3]
	for i, v in ipairs(robbers) do
		playersRobbing[ v ] = nil
	end
	robs[ ped ] = { false, 0, { } }
end