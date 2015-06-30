local offences = {
[1] = {"Homicide", 30}, --done
[2] = {"Assault", 15}, --done
[3] = {"Assault with a deadly weapon", 20}, --done
[4] = {"Assault to a law officer", 30}, --done
[5] = {"Assault with intent to murder", 25}, --done
[6] = {"Driving under the influence of illegal substances", 10}, --When  seen by a law officer
[7] = {"Driving under the influence of alcohol", 5}, --When  seen by a law officer 
[8] = {"Illegal car racing", 15}, --When  seen by a law officer 
[9] = {"Reckless driving", 15}, --done
[10] = {"Possession of a stolen vehicle", 20},
[11] = {"Use of illegal explosives", 10}, --When fires RPG, molotov, grenade, satchel on sight of a law member (exeption for law players)
[12] = {"Destruction of property", 10},--done
[13] = {"Armed robbery", 30},
}

local table = table

local tonumber = tonumber

local vehiclesReportedStolen = { }
local offenceLog = { }
local JSONOffenceLog = toJSON ( offenceLog )

--Export to report the vehicle stolen
addEvent("onVehicleReportedStolen", true)
addEventHandler("onVehicleReportedStolen", root, 
	function (state)
		if ( state == true ) then
			local col = createColSphere(0,0,0,50)
			attachElements(col, source)
			addEventHandler("onColShapeHit", col, onColHit)
			
			vehiclesReportedStolen[#vehiclesReportedStolen+1] = source
		elseif ( state == false ) then
			for k, veh in ipairs(vehiclesReportedStolen) do
				if (source == veh ) then
					table.remove(vehiclesReportedStolen, k)
				end
			end
		end
	end
)

function onColHit (hitElement, md)
	if ( getElementType(hitElement) == "player" ) and ( exports.VGlaw:isPlayerLaw ( hitElement ) ) and ( isLineOfSightClear(getElementPosition(hitElement), getElementPosition(source) ) ) then
		local veh = getElementAttachedTo(source)
		local occupants = getVehicleOccupants(veh)
		for i=1, #occupants do
			addOffence(occupants[i], 10)--Possession of a stolen vehicle
		end
	end
end

--Function to add the wanted points and the offences record to the criminal
addEvent( "onPlayerOffence", true )
function addOffence ( player, offenceIndex ) 
	if not ( player ) or not ( offenceIndex ) then return false end
	exports.VGplayers:givePlayerWantedPoints ( player, offences [ offenceIndex ] [ 2 ]  )
	--[[local playerOffenceTable = { }

	local offenceLog = fromJSON ( JSONOffenceLog )
	local playerOffenceTable = offenceLog [ player ]

	counts = playerOffenceTable [ offences [ offenceIndex ][1] ]  [ 1 ] 
	if ( counts ) then 
		counts = counts + 1
	elseif ( not counts ) then 
		counts = 1
	end
	local offenceName = offences[offenceIndex][1] 
	local playerOffenceTable  [ offenceName ] =  {counts} ---------------
	local offenceLog [ player ] = playerOffenceTable
	JSONOffenceLog =  toJSON ( offenceLog ) ]]
	return true
end
addEventHandler("onPlayerOffence", root, addOffence)

--Export to get the player's offence log
function getPlayerOffenceLog (player)
	local offenceLog = fromJSON(JSONOffenceLog[player])
	if ( offenceLog ) then return offenceLog else return false end
end

