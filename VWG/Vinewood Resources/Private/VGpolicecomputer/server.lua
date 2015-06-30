
local table = table


dispatchLogTable = { }
 
--Function that sends the dispactch log to the client in the for of a table
addEvent("requestDispatchLog", true)
addEventHandler("requestDispatchLog", root,
	function ()
		triggerClientEvent("retrieveDispatchLog", source, dispatchLogTable)
	end
)

--Function that is triggered when the player presses one of the 3 buttons on the request backup page of the police computer
addEvent("requestBackup", true)
addEventHandler("requestBackup", root,
	function (typeOfBackup)
		local px, py, pz = getElementPosition(source)
		local h, m = getTime()
		if ( typeOfBackup == "police" ) then
			local players = getElementsByType("player")
			dispatchLogTable[#dispatchLogTable+1] = {"["..h..":"..m.."] Officer "..getPlayerName(source).." requested backup at "..getZoneName(px, py, pz).." ("..getZoneName(px, py, pz, true)..")"}
			if ( #dispatchLogTable > 30 ) then table.remove(dispatchLogTable, 1) end
			for theKey,thePlayer in ipairs(players) do
				if exports.VGlaw:isPlayerLaw(thePlayer) then
					exports.VGdx:showHudMessageDX( thePlayer, "Officer "..getPlayerName(source).." is requesting backup at "..getZoneName(px, py, pz).." ("..getZoneName(px, py, pz, true)..")", 0, 0, 200, 5000 )
				end
			end
			
		elseif ( typeOfBackup == "swat" ) then
			local swatOfficers = getPlayersInTeam(getTeamFromName("SWAT"))
			dispatchLogTable[#dispatchLogTable+1] = { "["..h..":"..m.."] Officer "..getPlayerName(source).." requested SWAT units at "..getZoneName(px, py, pz).." ("..getZoneName(px, py, pz, true)..")"}
			if ( #dispatchLogTable > 30 ) then table.remove(dispatchLogTable, 1) end	
			for theKey,thePlayer in ipairs(swatOfficers) do
				exports.VGdx:showHudMessageDX( thePlayer, "Officer "..getPlayerName(source).." is requesting SWAT backup at "..getZoneName(px, py, pz).." ("..getZoneName(px, py, pz, true)..")", 0, 0, 200, 5000 )		
			end
			
		elseif ( typeOfBackup == "military" ) then
			local militaryOfficers = getPlayersInTeam(getTeamFromName("Military Forces"))
			dispatchLogTable[#dispatchLogTable+1] = { "["..h..":"..m.."] Officer "..getPlayerName(source).." requested military forces at "..getZoneName(px, py, pz).." ("..getZoneName(px, py, pz, true)..")"}
			if ( #dispatchLogTable > 30 ) then table.remove(dispatchLogTable, 1) end	
			for theKey,thePlayer in ipairs(militaryOfficers) do
				exports.VGdx:showHudMessageDX( thePlayer, "Officer "..getPlayerName(source).." is requesting military backup at "..getZoneName(px, py, pz).." ("..getZoneName(px, py, pz, true)..")", 0, 0, 200, 5000 )
			end
		end
	end
)