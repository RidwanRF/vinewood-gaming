


-- Some variables
local isCruising = false
local aTimer = false
local theSpeed = 0

-- function to delete the event
function deleteEvent ()
	removeEventHandler( "onClientPreRender", root, toggleCruising )
end

-- Function to toggle the isCruising
function toggleCruising()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if ( theVehicle ) and not ( getVehicleEngineState( theVehicle ) ) then deleteEvent () setControlState( "accelerate", false ) isCruising = false end
	if ( isCruising ) then
		if not ( theVehicle ) or not ( isElement( theVehicle ) ) then return end
		local v1, v2, v3 = getElementVelocity( theVehicle )
		local currentSpeed = ( v1^2 + v2^2 + v3^2 )^( 0.5 )
		local speedC = (v1^2 + v2^2 + v3^2) ^ 0.5 * 1.61 * 100
		if ( math.floor( speedC ) <= 1 ) then deleteEvent () setControlState( "accelerate", false ) isCruising = false return end
		if ( currentSpeed < theSpeed ) then
			setControlState( "accelerate", true )
		else
			setControlState( "accelerate", false )
		end
	end
end

-- Function to cruise
bindKey( "c", "up",
	function ()
		local theVehicle = getPedOccupiedVehicle( localPlayer )
		if not ( theVehicle ) or not ( isElement( theVehicle ) ) then return end
		if ( getVehicleOccupant( theVehicle, 0 ) ~= localPlayer ) or not ( getVehicleOccupant( theVehicle, 0 ) ) then
			return false
		end
		if not ( isCruising ) then
			isCruising = true
			local speedx, speedy, speedz = getElementVelocity( theVehicle )
			theSpeed = ( speedx^2 + speedy^2 + speedz^2 )^( 0.5 )
			addEventHandler( "onClientPreRender", root, toggleCruising )
			exports.VGdx:showMessageDX( "You are now cruising", 0, 255, 0 )
		else
			exports.VGdx:showMessageDX( "You have disabled cruising", 0, 255, 0 )
			isCruising = false
			deleteEvent ()
			theSpeed = 0
			setControlState( "accelerate", false )
		end
	end
)

-- When the player exits the vehicle
addEventHandler( "onClientVehicleExit", root,
	function ( thePlayer )
		if ( isCruising ) and ( thePlayer == localPlayer ) then
			isCruising = false
			deleteEvent ()
			theSpeed = 0
			setControlState( "accelerate", false )
		end
	end
)

-- When the player dies
addEventHandler( "onClientPlayerWasted", localPlayer,
	function ()
		if ( isCruising ) then
			isCruising = false
			deleteEvent ()
			theSpeed = 0
			setControlState( "accelerate", false )
		end
	end
)