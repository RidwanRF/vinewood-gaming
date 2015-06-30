
local table = table


-- The table that holds the database table
local vehicleDatabase = {}

-- Table with all the vehicles stored
local vehicleTable = {}

-- Function to set the vehicle table
function setPlayerVehicleTable ( thePlayer, table )
	vehicleDatabase[ thePlayer ] = table
end

-- Functio nget the vehicle table
function getPlayerVehicleTable ( thePlayer )
	return vehicleDatabase [ thePlayer ]
end

-- When a player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		if ( vehicleDatabase[ source ] ) then
			vehicleDatabase[ source ] = nil
		end
	end
)

-- Bind the key on resrouce start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
			if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
				-- Check if the player's vehicles are loaded if not load them
				if not ( getPlayerVehicleTable( thePlayer ) ) or ( #getPlayerVehicleTable( thePlayer ) == 0 ) then
					local userID = exports.VGaccounts:getPlayerAccountID( thePlayer )
					local table = exports.VGmysql:query( "GEW783UH230WEGE978GW", "SELECT * FROM vehicles WHERE userid = ?", userID )
					setPlayerVehicleTable( thePlayer, table )
				end
				
				-- Create the vehicles
				createPlayerVehicles( thePlayer )
			end
		end
	end
)

-- When the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
			if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
				exports.VGvehicles:savePlayerVehicles( thePlayer )
			end
		end
	end
)

-- Function that creates all the vehicles from a player that logs in or whenever the resource restarts
function createPlayerVehicles( thePlayer )
	if ( exports.VGaccounts:getPlayerAccountID( thePlayer ) ) and ( getPlayerVehicleTable( thePlayer ) ) then
		local aTable = getPlayerVehicleTable( thePlayer )
		for i = 1, #aTable do
			if ( aTable[i].numberplate == "" ) then aTable[i].numberplate = "Vinewood" end if not ( vehicleTable[ thePlayer ] ) then vehicleTable[ thePlayer ] = {} end
			if ( aTable[i].locked == 0 ) then locked = false else locked = true end
			local aVehicle = createVehicle ( aTable[i].model, aTable[i].x, aTable[i].y, aTable[i].z +1, 0, 0, aTable[i].rotation, aTable[i].numberplate )
			local R1, G1, B1 = getColorFromString ( aTable[i].color1 )
			local R2, G2, B2 = getColorFromString ( aTable[i].color2 )
			table.insert( vehicleTable[ thePlayer ], aVehicle )
			setElementHealth( aVehicle, aTable[i].health or 100 )
			setVehicleColor( aVehicle, R1 or 225, G1 or 225, B1 or 225, R2 or 225, G2 or 225, B2 or 225 )
			exports.VGfuel:setVehicleFuel( aVehicle, aTable[i].fuel or 100 )
			setVehiclePaintjob( aVehicle, aTable[i].paintjob or 3 )
			setVehicleLocked( aVehicle, locked )
			aTable[i].vehicle = aVehicle
		end
		setPlayerVehicleTable( thePlayer, aTable )
	end
end