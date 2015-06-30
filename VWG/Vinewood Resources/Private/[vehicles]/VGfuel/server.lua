


-- Event that let the drive pay for the refueling
addEvent ( "takePlayerFuelPayment", true )
addEventHandler ( "takePlayerFuelPayment", root,
	function ( thePrice )
		takePlayerMoney ( source, thePrice )
	end
)

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

-- Key to turn of the engine
function bindEngineKey ( aPlayer )
	local aPlayer = aPlayer or source
	bindKey( aPlayer, "z", "down",
		function ( thePlayer )
			if ( getPedOccupiedVehicle( thePlayer ) ) and ( getPedOccupiedVehicleSeat ( thePlayer ) == 0 ) then
				setVehicleEngineState ( getPedOccupiedVehicle( thePlayer ), not getVehicleEngineState( getPedOccupiedVehicle( thePlayer ) ) )
			end
		end
	)
end

addEventHandler( "onResourceStart", resourceRoot, 
	function ()
		-- Event to bind the key for new playerss
		addEventHandler( "onPlayerJoin", root, bindEngineKey )
		
		-- Bind the key
		for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
			bindEngineKey ( thePlayer )
		end
	end
)