

local unpack = unpack

-- Tables
local vehicles = {
	owner = {},
	occupation = {},
	data = {},
}
local playerSpawnedVehicle = {}

--create the client side vehicles
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		for _, aTable in pairs( exports.VGtables:getSpawnVehiclesTable() or {} ) do
			for i, _ in pairs( aTable.x ) do
				-- Get the variables from the table
				local spawnX, spawnY, spawnZ, spawnRotX, spawnRotY, spawnRotZ = aTable.x[ i ], aTable.y[ i ], aTable.z[ i ], aTable.rotx[ i ], aTable.roty[ i ], aTable.rotz[ i ]
				local model, occupations = aTable.model, aTable.occupations
				local R1, B1, G1, R2, B2, G2, customColor = aTable.r1 ,aTable.g1, aTable.b1, aTable.r2, aTable.g2, aTable.b2, aTable.customColor
				
				-- Create the vehicle and store the data
				local theVehicle = createVehicle( model, 0,0,0 )
				spawnVehicle( theVehicle,spawnX, spawnY, spawnZ, spawnRotX, spawnRotY, spawnRotZ)
				if ( theVehicle ) then
					if ( customColor ) then 
						setVehicleColor( theVehicle, R1, B1, G1, R2, B2, G2 )
					end
					
					setVehicleDamageProof( theVehicle, true )			
					setElementCollisionsEnabled ( theVehicle, false )
					setElementFrozen(theVehicle, true)
					
					addEventHandler( "onVehicleStartEnter", theVehicle, onPlayerStartSpawnVehicleEnter )
					addEventHandler( "onVehicleEnter", theVehicle, onPlayerSpawnVehicleEnter )
					addEventHandler( "onVehicleExit", theVehicle, onPlayerSpawnVehicleExit )
					addEventHandler( "onVehicleExplode", theVehicle, 
						function () 
							setTimer( destroyVehicle, 3000, 1, source )
						end
					)
					
					-- Save all the data in the tables
					vehicles[ theVehicle ] = {}
					vehicles[ theVehicle ].occupation = occupations

					vehicles[ theVehicle ].data = { model, occupations, spawnX, spawnY, spawnZ, spawnRotX, spawnRotY, spawnRotZ, customColor, R1, B1, G1, R2, B2, G2 }
				end
			end
		end
	end
)

-- Function when the player starts to enter the vehicle
function onPlayerStartSpawnVehicleEnter (thePlayer, seat)
	if ( seat ~= 0 ) then cancelEvent() return end
	if ( exports.VGadmin:isAdminOnDuty( thePlayer ) ) then return end
	
	if ( exports.VGplayers:getPlayerWantedPoints ( thePlayer ) >= 10 ) then cancelEvent() exports.VGdx:showMessageDX( thePlayer, "You can't enter this vehicle while wanted!", 255, 0, 0 ) return end
	
	if ( getElementData(source, "Occupation") == getElementData(thePlayer, "Occupation") ) then
		return
	else
		local occupations = vehicles[ source ].occupation
		for i, v in pairs(occupations) do
			if v == getElementData(thePlayer, "Occupation") then
				return 
			end
		end
	end
	if ( occupations[1] == "*" ) then return end
	exports.VGdx:showMessageDX( thePlayer, "You can't enter this vehicle!", 255, 0, 0 )
	cancelEvent ()
end

-- Function when the player enters the vehicle
function onPlayerSpawnVehicleEnter (thePlayer)
	if not ( vehicles[ source ].owner ) then -- if the vehicle is being entered for the first time
		if ( playerSpawnedVehicle[thePlayer] ) and ( isElement( playerSpawnedVehicle[thePlayer] ) ) then destroyVehicle(playerSpawnedVehicle[thePlayer]) end
		setVehicleDamageProof( source, false )			
		setElementCollisionsEnabled ( source, true )
		setElementFrozen(source, false)
		
		setTimer(fixVehicle, 500, 1, source)
		
		local occupations = vehicles[ source ].occupation
		if ( occupations[1] ~= "*" ) then
			setElementData(source, "Occupation", getElementData( thePlayer, "Occupation" ) )
			triggerClientEvent("onPlayerEnterJobVehicle", source, thePlayer)
		end
		
		playerSpawnedVehicle[thePlayer] = source
		vehicles[ source ].owner = thePlayer

		spawnNewVehicle ( vehicles[source].data )
		
		addEventHandler( "onPlayerQuit", thePlayer, function () 	
			if ( isElement( playerSpawnedVehicle[source] ) ) then
				destroyElement (playerSpawnedVehicle[source])
				vehicles[ playerSpawnedVehicle[source] ] = {}
			end
		end )
		
		addEventHandler( "onPlayerWasted", thePlayer, function () 	
			if ( isElement( playerSpawnedVehicle[source] ) ) then
				destroyElement (playerSpawnedVehicle[source])
				vehicles[ playerSpawnedVehicle[source] ] = {}
			end
		end )
		
		addEventHandler( "onElementDataChange", root, function (data) 	
			if ( data == "Occupation" ) and (getElementType( source ) == "player" ) and ( isElement( playerSpawnedVehicle[source] ) ) then
				destroyElement (playerSpawnedVehicle[source])
				vehicles[ playerSpawnedVehicle[source] ] = {}
			end
		end )
	end
end

function onPlayerSpawnVehicleExit (thePlayer)
	local occupations = vehicles[ source ].occupation
	if ( occupations[1] ~= "*" ) then
		triggerClientEvent("onPlayerExitJobVehicle", source, thePlayer)
	end
end
--Spawn a new vehicle when the one available is taken
function spawnNewVehicle (vehicleDataTable)
	local model, occupations, spawnX, spawnY, spawnZ, spawnRotX, spawnRotY, spawnRotZ, customColor, R1, B1, G1, R2, B2, G2 = unpack(vehicleDataTable)
	-- Create the vehicle and store the data
	local theVehicle = createVehicle( model, 0,0,0 )
	spawnVehicle( theVehicle,spawnX, spawnY, spawnZ, spawnRotX, spawnRotY, spawnRotZ)
	if ( theVehicle ) then
		if ( customColor ) then 
			setVehicleColor( theVehicle, R1, B1, G1, R2, B2, G2 )
		end
	
		setVehicleDamageProof( theVehicle, true )			
		setElementCollisionsEnabled ( theVehicle, false )
		setElementFrozen(theVehicle, true)
			
		addEventHandler( "onVehicleStartEnter", theVehicle, onPlayerStartSpawnVehicleEnter )
		addEventHandler( "onVehicleEnter", theVehicle, onPlayerSpawnVehicleEnter )
		addEventHandler( "onVehicleExplode", theVehicle, 
			function () 
				setTimer( destroyVehicle, 3000, 1, source )
			end
		)
					
		-- Save all the data in the tables
		vehicles[ theVehicle ] = {}
		vehicles[ theVehicle ].occupation = occupations
		vehicles[ theVehicle ].data = { model, occupations, spawnX, spawnY, spawnZ, spawnRotX, spawnRotY, spawnRotZ, customColor, R1, B1, G1, R2, B2, G2 }
	end
end

function destroyVehicle (theVehicle)
	destroyElement (theVehicle)
	vehicles[ theVehicle ] = {}
end

-----------Exports------------
function isSpawnerVehicle (veh)
	if ( vehicles[ veh ] ) then
		return true
	else 
		return false
	end
end

function getVehicleOwner (veh)
	if ( vehicles[ veh ].owner ) then
		return vehicles[ veh ].owner
	else 
		return false
	end
end

function getVehicleOccupation (veh)
	return getElementData(veh, "Occupation")
end