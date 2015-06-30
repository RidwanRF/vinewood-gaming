

local table = table


-- Carwash table
local washTable = {}
local washMarker = {}
local objectTable = {}

-- On resource start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		-- The marker positions
		local table = exports.VGtables:getTable('paynspray')

		-- Create the markers
		for i=1,#table do
			local theMarker = createMarker( table[i][1], table[i][2], table[i][3], "cylinder", 4, 190, 0, 0, 170 )
			if ( table[i][4] ) then createBlipAttachedTo( theMarker, 63, 2, 255, 0, 0, 255, 0, 250 ) end
			addEventHandler( "onMarkerHit", theMarker, onPlayerRepairMarkerHit )
		end
		
		-- Open all the garages
		for i=0,49 do
			setGarageOpen( i, true )
		end
		
		-- The marker positions
		local table = {
			{ 1911.339, -1783.942, 12.089, 0.923, { 1914.6080322266, -1756.5134277344, 19.568500518799, 1914.3620605469, -1757.3673095703, 19.109773635864, 0, 70 }, { { 1911.243, -1773.621, 12.383, 2050 }, { 1911.243, -1777.248, 13.383, 2050 } } },
			{ 2450.334, -1461.132, 22.707, 270.549, { 2477.3894042969, -1456.3939208984, 28.933300018311, 2476.4716796875, -1456.6441650391, 28.624605178833, 0, 70 }, { { 2451.479, -1461.051, 24, 2050 }, { 2455.165, -1460.931, 24, 2050 } } },
			{ 1016.888, -911.698, 41.056, 188, { 1017.0158081055, -936.32708740234, 47.401599884033, 1017.0903930664, -935.43420410156, 46.957511901855, 0, 70 }, { { 1017.405, -915.9, 42.336, 2050 }, { 1017.838, -919.166, 42.336, 2050 } } },
			{ -1688.164, 397.764, 6.18, 43.949, { -1699.6617431641, 414.72439575195, 12.432800292969, -1699.1560058594, 413.94952392578, 12.053477287292, 0, 70 }, { { -1689.208, 400.482, 7.18, 2050 }, { -1690.705, 401.97, 7.18, 2050 } } },
		}

		-- Create the markers
		for i=1,#table do
			local theMarker = createMarker( table[i][1], table[i][2], table[i][3], "cylinder", 3, 190, 0, 0, 170 )
			washTable [ theMarker ] = table[i]
			washMarker[ theMarker ] = false
			createBlipAttachedTo( theMarker, 46, 2, 255, 0, 0, 255, 0, 250 )
			addEventHandler( "onMarkerHit", theMarker, onPlayerCarWashMarkerHit )
		end
	end
)

-- Function when the players hits the wash marker
function onPlayerCarWashMarkerHit ( theVehicle, matchingDimension )
	if ( matchingDimension ) and ( getElementType( theVehicle ) == "vehicle" )then
		local theDriver = getVehicleOccupant( theVehicle )
		if ( theDriver ) then
			if ( getPlayerMoney( theDriver ) < 100 ) then
				exports.VGdx:showMessageDX( theDriver, "Insufficient funds to pay the repair! Price: $100", 225, 0, 0 )
			elseif ( washMarker[ source ] ) then
				exports.VGdx:showMessageDX( theDriver, "There is already a car being washed, please wait!", 225, 0, 0 )
			else
				-- Take the money
				takePlayerMoney( theDriver, 100 )
				toggleAllControls ( theDriver, false, true )
				local matrix = washTable[ source ][ 5 ]
				setCameraMatrix( theDriver, matrix[1], matrix[2], matrix[3], matrix[4], matrix[5], matrix[6] )
				setElementPosition( theVehicle, washTable[ source ][ 1 ], washTable[ source ][ 2 ], washTable[ source ][ 3 ] + 0.8 )
				setElementRotation( theVehicle, 0, 0, washTable[ source ][ 4 ] )
				setTimer( moveCarForward, 50, 320, theVehicle, washTable[ source ][ 1 ] )
				setTimer( resetWashMarker, 17000, 1, source, theDriver, theVehicle )
				exports.VGdx:showMessageDX( theDriver, "We're washing your car! Please wait...", 0, 225, 0 )
				washMarker[ source ] = true
				
				-- Play the sound for all people in the vehicle
				local occupants = getVehicleOccupants ( theVehicle )
				for i=0,5 do
					if ( isElement( occupants[ i ] ) ) then
						triggerClientEvent( occupants[ i ], "onClientPlayerCarwashSound", occupants[ i ] )
					end
				end
				
				-- Some objects to make the carwash look cool
				objectTable[ source ] = {}
				for i=1,#washTable[ source ][6] do
					table.insert( objectTable[ source ], createObject( washTable[ source ][6][i][4], washTable[ source ][6][i][1], washTable[ source ][6][i][2], washTable[ source ][6][i][3] ) )
				end
				
				-- Reset the rotation
				setElementRotation( theVehicle, 0, 0, washTable[ source ][ 4 ] )
			end
		end
	end
end

-- Function to reset the wash street
function resetWashMarker ( theMarker, thePlayer, theVehicle )
	washMarker[ theMarker ] = false
	setCameraTarget( thePlayer, thePlayer )
	toggleAllControls ( thePlayer, true, true )
	triggerClientEvent( thePlayer, "onChangeVehicleDirtLevel", thePlayer, theVehicle )
	for k, obj in ipairs( objectTable[ theMarker ] ) do if ( isElement( obj ) ) then destroyElement( obj ) end end
	exports.VGdx:showMessageDX( thePlayer, "Your cas has been washed! All dirt has been removed! Costs: $100", 0, 225, 0 )
end

-- Function that drives the car forward really slow
function moveCarForward( theVehicle, type, rotation )
	if ( isElement( theVehicle ) ) then
		if ( type == 2450.334 ) then
			setElementVelocity( theVehicle, 0.02, 0, 0 )
		elseif ( type == 1016.888 ) then
			setElementVelocity( theVehicle, 0, -0.02, 0 )
		elseif ( type == -1686.311 ) then
			setElementVelocity( theVehicle, -0.01, 0.02, 0 )
		else
			setElementVelocity( theVehicle, 0, 0.02, 0 )
		end
	end
end

-- Function when the players hits the marker
function onPlayerRepairMarkerHit ( theVehicle, matchingDimension )
	if ( matchingDimension ) and ( getElementType( theVehicle ) == "vehicle" )then
		local theDriver = getVehicleOccupant( theVehicle )
		if ( theDriver ) then
			if ( getElementHealth( theVehicle ) > 999 ) then
				exports.VGdx:showMessageDX( theDriver, "This vehicle doesn't need a repair!", 225, 0, 0 )
			else
				local theMoney = math.floor( 1000 - getElementHealth( theVehicle ) )
				if ( getPlayerMoney( theDriver ) < theMoney ) then
					exports.VGdx:showMessageDX( theDriver, "Insufficient funds to pay the repair! Price: $"..theMoney, 225, 0, 0 )
				else 
					-- Take the money
					takePlayerMoney( theDriver, theMoney )
					
					-- Toggle the controls
					togglePlayerControls( theDriver, false, true )
					
					fadeCamera( theDriver, false, 1 )
					setTimer( togglePlayerControls, 3000, 1, theDriver, true, true )
					setTimer( fadeCamera, 3000, 1, theDriver, true )
					playSoundFrontEnd ( theDriver, 46 )
					fixVehicle( theVehicle )
				end
			end
		end
	end
end

-- Function to restore the controls
function togglePlayerControls( thePlayer, state, handbreak )
	for k, control in ipairs( { "accelerate", "enter_exit", "handbrake" } ) do
		toggleControl( thePlayer, control, state )
		if ( handbreak ) then setControlState( thePlayer, "handbrake", not state ) end
	end
end