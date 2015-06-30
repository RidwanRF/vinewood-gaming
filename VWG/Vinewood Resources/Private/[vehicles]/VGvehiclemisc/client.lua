



-- Function to disable the speedmeter
function setVehicleHudEnabled()
	return true
end

-- Function that gets the vehicle speed
function getVehicleSpeed() 
    if ( isPedInVehicle( localPlayer ) ) then
        local vx, vy, vz = getElementVelocity( getPedOccupiedVehicle( localPlayer ) )
        local speed = (vx^2 + vy^2 + vz^2) ^ 0.5 * 1.61 * 100
		if ( speed >= 260 ) then speed = 260 end
		return speed - 6
    end
    return 0
end

-- Table with the vehicles that have flashing headlights
local table = {}

-- Function that sets the vehicle lights flashing
function setVehicleLightsFlasing ( aVehicle )
	if ( isElement( aVehicle ) ) then
		if ( getVehicleOverrideLights ( aVehicle ) ~= 2 ) then  
			setVehicleOverrideLights ( aVehicle, 2 ) 
		end
		if ( getVehicleLightState( aVehicle, 0 ) == 0 ) then
			setVehicleLightState ( aVehicle, 0,  1 )
			setVehicleLightState ( aVehicle, 1,  0 )
			setVehicleHeadLightColor( aVehicle, 0, 0, 255 )
		elseif ( getVehicleLightState( aVehicle, 1 ) == 0 ) then
			setVehicleLightState ( aVehicle, 0,  0 )
			setVehicleLightState ( aVehicle, 1,  1 )
			setVehicleHeadLightColor(aVehicle, 225, 0, 0)
		end
	end
end

-- Timer that loops through the vehicles
setTimer( 
	function ()
		for k, theVehicle in ipairs( getElementsByType( "vehicle" ) ) do
			if ( isElementStreamedIn ( theVehicle ) ) then
				if ( getVehicleSirensOn( theVehicle ) ) then
					table[ theVehicle ] = true
					setVehicleLightsFlasing ( theVehicle )
				elseif( table[ theVehicle ] ) and not ( getVehicleSirensOn( theVehicle ) ) then
					table[ theVehicle ] = false
					setVehicleLightState ( theVehicle, 1,  0 )
					setVehicleLightState ( theVehicle, 0,  0 )
					setVehicleHeadLightColor( theVehicle, 225, 225, 225 )
				end
			end
		end
	end, 500, 0
)