addEvent("onPlayerJobResign", true)
function resignJob ()
	local oldTeam = getPlayerTeam(client)
	local team = getTeamFromName("Unemployed")
	setPlayerTeam(client, team)
	setElementData(client, "Occupation", "Unemployed" )
	exports.VGaccounts:setPlayerAccountData( client, "occupation", "Unemployed" )
end
addEventHandler("onPlayerJobResign", root, resignJob)



addEvent("onPlayerTakeJob", true)
function takeJob (theTeam, theOccupation, weaponToGive, skin)
	local team = getTeamFromName(theTeam)
	setPlayerTeam(client, team)
	setElementModel(client, skin)
	if ( weaponToGive ) then
		exports.VGweaponsync:givePlayerWeapon( client, weaponToGive, 99999, true ) 
	end
	setElementData(client, "Occupation", theOccupation )
	exports.VGaccounts:setPlayerAccountData( client, "occupation", theOccupation )
	
	--triggerEvent so that other resources know the player joined this job
	triggerEvent("onPlayerJobTaken", client, theOccupation)
	triggerClientEvent("onPlayerJobTaken", client, root, theOccupation)
end
addEventHandler("onPlayerTakeJob", root, takeJob)