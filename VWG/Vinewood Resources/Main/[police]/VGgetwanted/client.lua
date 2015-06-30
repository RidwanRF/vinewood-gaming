

antiSpamTableAssault = { }
antiSpamTableDestruction = { }
antiSpamTableRecklessDrive = { }
allowSelfDefence = { }

--function that detects: ASSAULT,  ASSAULT TO A LAW OFFICER, ASSAULT WITH A DEADLY WEAPON, ASSAULT WITH INTENT TO MURDER and RECLESS DRIVING
addEventHandler("onClientPlayerDamage", root, 
	function(attacker, weapon, bodypart, loss)
		--Exclude all non player caused situations
		if ( not attacker ) or ( not isElement(attacker) ) then return end

		--to ensure this event only triggers the offence once and not more times on nearby clients
		if ( localPlayer == source ) then
			if ( getElementType(attacker) == "player" ) then
				--If the victim is wanted and the attacker is a law officer then there is no offence
				if ( exports.VGplayers:getPlayerWantedPoints ( source ) >= 10 ) and ( exports.VGlaw:isPlayerLaw( attacker ) ) then return end
				
				--Allow Self defence
				if ( allowSelfDefence[attacker] == source ) then return end
				
				if ( exports.VGadmin:isAdminOnDuty( attacker ) ) then return end
				
				if ( antiSpamTableAssault[attacker] ) then return end
				
				
				if ( exports.VGlaw:isPlayerLaw( source ) ) then 
					addOffence(attacker, 4) --Assault to a law officer
				elseif ( weapon > 15 ) and ( weapon < 40 ) and ( weapon ~= 17 ) then 
					addOffence(attacker, 3)  --Assault with deadly weapon
					allowSelfDefence[source] = attacker
					setTimer( function () allowSelfDefence[source] = null end, 30000, 1)
				else 
					addOffence(attacker, 2)--Assault
					allowSelfDefence[source] = attacker
					setTimer( function () allowSelfDefence[source] = null end, 30000, 1)					
				end
				
				
				if ( getElementHealth(source) < 20 ) then --Assault with intent to murder
					addOffence(attacker, 5) 				
					-- to prevent the player for getting spam charges for successive damages to the victim
					antiSpamTableAssault[attacker] = true
					-- after 1 minute allow the player to be charged with this charges again when attacking this player
					setTimer( function () antiSpamTableAssault[attacker] = false end, 60000, 1) 
				end
				
			elseif ( getElementType(attacker) == "vehicle" ) and ( loss > 5 ) then
				if ( antiSpamTableRecklessDrive[getVehicleOccupant(attacker)] ) then return end

				if exports.VGadmin:isAdminOnDuty( getVehicleOccupant(attacker) ) then return end

				addOffence(getVehicleOccupant(attacker) , 9)--Reckless driving
				
				-- to prevent the player for getting spam charges for successive damages to the victim
				antiSpamTableRecklessDrive[getVehicleOccupant(attacker)] = true
				-- after 1 minute allow the player to be charged with this charges again when attacking this player
				setTimer(function () antiSpamTableRecklessDrive[getVehicleOccupant(attacker)] = false end, 60000, 1) 
			end
		end
	end
)


addEventHandler("onClientPlayerWasted", localPlayer,
	function (killer, weapon, bodypart)
		antiSpamTableDestruction[source] = false
		antiSpamTableAssault[source] = false
		antiSpamTableRecklessDrive[source] = false
		
		if not ( killer ) then return end
		if ( exports.VGadmin:isAdminOnDuty( killer ) ) then return end		
		if ( exports.VGplayers:getPlayerWantedPoints ( source ) >= 10 ) and ( exports.VGlaw:isPlayerLaw( killer ) ) then return end
		addOffence(killer, 1)-- homicide
	end
)

addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weapon, ammo, ammoInClip, fX, fY, fZ, hitElement)
		if ( source == localPlayer )  then
			if ( exports.VGadmin:isAdminOnDuty( source ) ) then return end		
			if ( antiSpamTableDestruction[source] ) then return end
			
			if ( hitElement ) and ( getElementType(hitElement) == "vehicle" ) then
				local passengers = getVehicleOccupants(hitElement)
				for k,v in pairs(passengers) do
					if ( k == source ) then return end
					if ( exports.VGplayers:getPlayerWantedPoints ( v ) >= 10 ) and ( exports.VGlaw:isPlayerLaw( source ) ) then return end
				end
				addOffence(source, 12)--Destruction of property
				-- to prevent the player for getting spam charges for successive damages to the victim
				antiSpamTableDestruction[localPlayer] = true
				-- after 1 minute allow the player to be charged with this charges again when attacking this player
				setTimer(function () antiSpamTableDestruction[localPlayer] = false end, 60000, 1) 	
			end
		end
	end
)

addEventHandler("onClientExplosion", localPlayer,
	function (x,y,z,theType)
		if ( source ) and ( source == localPlayer ) then
			if ( exports.VGadmin:isAdminOnDuty( source ) ) then return end		
			if ( isLawNearby(source) ) then
				if ( not exports.VGlaw:isPlayerLaw( source ) ) and ( ( theType == 0 ) or ( theType == 1 ) or ( theType == 2 ) or ( theType == 3 ) or ( theType == 8 ) ) then
					addOffence(source, 11) --use of illegal explosives
				elseif ( exports.VGlaw:isPlayerLaw( source ) ) and ( ( theType == 0 ) or ( theType == 1 ) or ( theType == 2 ) or ( theType == 3 ) ) then
					addOffence(source, 11) --use of illegal explosives
				end
			end
		end
	end
)


--Function to check if there is any law member near the player
function isLawNearby (thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local col = createColSphere(x,y,z, 50)
	local playersInside = getElementsWithinColShape(col, "player")
	for k, player in ipairs(playersInside) do
		if  ( exports.VGlaw:isPlayerLaw( player ) ) then destroyElement(col) return true end 
	end
	destroyElement(col)
	return false
end


--Function to add the wanted points and the offences record to the criminal
function addOffence (player, offenceIndex) 
	if not ( player ) or not ( offenceIndex ) then return false end

	triggerServerEvent("onPlayerOffence", player, player, offenceIndex)
	return true
end


--Export to report the vehicle stolen
function reportVehicleStolen(vehicle, owner, state)
		triggerServerEvent("onVehicleReportedStolen", vehicle, state)
end