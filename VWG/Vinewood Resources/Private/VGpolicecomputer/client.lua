


--Local variables
local sx, sy = guiGetScreenSize()
local scrollStateWarr = 0 
--Global variables
minWP = 10
wantedPlayers = { }
gridStartx, gridStarty = sx*(300/1440), sy*(225/900)
dispLogString = ""
blips = { }

----------------------------------------------------------------------------------------------------
-------------------------------------------Normal Warrants-------------------------------------
----------------------------------------------------------------------------------------------------
--function to retrieve a table to the normal warrant list
function refreshWarrantsList()
	local players = getElementsByType ( "player" )
	wantedPlayers = { }
	for k, v in ipairs(players) do
		if ( exports.VGaccounts:isPlayerLoggedIn ( v ) ) then
			if ( exports.VGplayers:getPlayerWantedPoints ( v )  >= minWP ) then
				local px, py, pz = getElementPosition(v)
				if ( isPedInVehicle ( v ) ) then transp = "On vehicle" else transp = "On foot" end
				wantedPlayers [ #wantedPlayers + 1 ] = {  getPlayerName( v ) ,  getZoneName ( px, py, pz ) .. " ("..getZoneName(px, py, pz, true)..")" ,exports.VGplayers:getPlayerWantedPoints ( v ), transp } 
			end
		end
	end
end
refreshWarrantsList()

--functions that displays the wanted players on the warrant grid list on the pending warrants page
function showWarrantsList() --on client render(triggers from GUI.lua)
	if ( pendWarrantsVisible ) then
		for i=1, #wantedPlayers do
			local x, y = gridStartx, gridStarty + ( sy*(20/960) * (i-1) + ( scrollStateWarr * sy*(20/960) ) )
			
			--Create the row
			if ( isDrawElementSelected ( x, y, x+sx*(999/1440),y + sy*(20.0/900) ) ) then hoveredY, hoveredIndex, color = y, i, tocolor(255, 255, 255, 100)  else color =  tocolor(255,255,255,50) end
			if ( i == selectedIndex ) then color = tocolor(255, 255, 255,100) end
			dxDrawRectangle(x, y, sx*(1000.0/1440), sy*(20.0/900),  color)
			dxDrawText(wantedPlayers[i][1], x+(sx*(10/1440)), y+5, sx, sy, tocolor(255, 255, 255, 255), sx*(1/1440))
			dxDrawText(wantedPlayers[i][2], x+(sx*(305/1440)), y+5, sx, sy, tocolor(255, 255, 255, 255), sx*(1/1440))
			dxDrawText(wantedPlayers[i][3], x+(sx*(575/1440)), y+5, sx, sy, tocolor(255, 255, 255, 255), sx*(1/1440))
			dxDrawText(wantedPlayers[i][4], x+(sx*(645/1440)), y+5, sx, sy, tocolor(255, 255, 255, 255), sx*(1/1440))
		
		end
		dxDrawRectangle(sx*(300/1440),sy*(0.0/900),sx*(1000.0/1440),sy*(228.0/900), tocolor(0, 1, 47, 255))
		dxDrawRectangle(sx*(300/1440),sy*(200.0/900),sx*(1000.0/1440),sy*(400.0/900), tocolor(0,0,0,100))
		dxDrawBorderedText("Player Name", sx*(303/1440),sy*(202.0/900),sx*(100.0/1440),sy*(40.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawLine(sx*(600/1440),sy*(200.0/900),sx*(600/1440),sy*(200.0/900)+sy*(400.0/900), tocolor(255,255,255,150), 3)
		dxDrawBorderedText("Location", sx*(603/1440),sy*(202.0/900),sx*(100.0/1440),sy*(40.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawLine(sx*(870/1440),sy*(200.0/900),sx*(870/1440),sy*(200.0/900)+sy*(400.0/900), tocolor(255,255,255,150), 3)
		dxDrawBorderedText("WP", sx*(873/1440),sy*(202.0/900),sx*(100.0/1440),sy*(40.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawLine(sx*(930/1440),sy*(200.0/900),sx*(930/1440),sy*(200.0/900)+sy*(400.0/900), tocolor(255,255,255,150), 3)
		dxDrawBorderedText("Transportation", sx*(943/1440),sy*(202.0/900),sx*(100.0/1440),sy*(40.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "left", "top", false, false, false, false, false) 
	
		dxDrawLine(sx*(300/1440),sy*(225.0/900),sx*(1000.0/1440)+sx*(300/1440),sy*(225.0/900), tocolor(255,255,255,150), 3)
		dxDrawRectangle(sx*(300/1440),sy*(600.0/900),sx*(1000.0/1440),sy*(500.0/900), tocolor(0, 1, 47, 255))
	end
end

--Function to handle all clicks on the police computer
addEventHandler("onClientClick", root, 
	function (btn, state)
		if ( btn == "left" ) and ( state == "down" ) then
			if ( pendWarrantsVisible ) and (hoveredY) then
				if ( isDrawElementSelected (  gridStartx, hoveredY, gridStartx+sx*(1000.0/1440), hoveredY+sy*(20.0/900) ) ) then selectedIndex = hoveredIndex end
			end
		end
	end
)
----------------------------------------------------------------------------------------------------
------------------------------------------- Dispatch log-----------------------------------------
----------------------------------------------------------------------------------------------------
--function that retreives the dispatch log from the server side
addEvent("retrieveDispatchLog", true)
function retrieveDispatchLog (dispLogTable)
	dispLogString = ""
	for i = 1, #dispLogTable do
		dispLogString = dispLogString..dispLogTable[i][1] .. "\n"
	end	
end
addEventHandler("retrieveDispatchLog", root, retrieveDispatchLog)

--function that draws the dispatch log, triggered from GUI.lua onClientRender
function drawDispatchLog()
	dxDrawRectangle( sx*(300/1440), sy*(250.0/900),sx*(840.0/1440),sy*(400.0/900), tocolor(255,255,255,255), false )
	dxDrawRectangle( sx*(300/1440)-1, sy*(250.0/900),sx*(840.0/1440)+2,sy*(400.0/900), tocolor(255,255,255,255), false )
	dxDrawRectangle( sx*(300/1440), sy*(250.0/900)-1,sx*(840.0/1440),sy*(400.0/900)+2, tocolor(255,255,255,255), false )
	dxDrawText( dispLogString, sx*(300/1440)+5, sy*(250.0/900)+5,sx*(840.0/1440)-10,sy*(400.0/900)-10, tocolor(0,0,0,255), sx*(0.5/1440), "bankgothic" )
end

----------------------------------------------------------------------------------------------------
------------------------------------------- Investigate player--------------------------------------
----------------------------------------------------------------------------------------------------
function searchPlayer ( name )
	if ( name ) then
		local player = exports.VGutils:getPlayerFromNamePart( name ) 
		if ( player ) then
			investigatedPlayer = { }
			local wantedPoints = exports.VGplayers:getPlayerWantedPoints ( player )
			local group = "none"
			local occupation = getElementData( player, "Occupation")
			
		
		
		
		
		
			investigatedPlayer[1] = {player, wantedPoints, group, occupation }
		else 
			createNotificationWindow ( "Player not found. Please try another name.", 5, 2 )
		end
	else
		createNotificationWindow ( "Please specify a name to search on the police computer.", 5, 2 )
	end
end
--[[
-player name
wanted
-wanted points
current offences
group
occupation
vehicles
houses
]]

----------------------------------------------------------------------------------------------------
-------------------------------------------Global functions--------------------------------------
----------------------------------------------------------------------------------------------------
-- When the player scrols the mouse
addEventHandler( "onClientKey", root,
	function ( type )
		if ( pendWarrantsVisible ) and ( isPCShowing ) then
			-- Do the 'math'
			if ( type == 'mouse_wheel_up' ) then
				if ( scrollStateWarr >= 0 ) then return end
				scrollStateWarr = scrollStateWarr + 1
			elseif ( type == 'mouse_wheel_down' ) then
				if ( -scrollStateWarr >= #wantedPlayers - 20 ) then return end
				scrollStateWarr = scrollStateWarr - 1
			end
        end
	end
)

--Function that pins/unpins the selected player
function pinPlayer()
	if ( pendWarrantsVisible ) and ( isPCShowing ) and ( selectedIndex ) then
		if not ( blips[ wantedPlayers[selectedIndex][1] ] ) then
			local blip = createBlipAttachedTo( getPlayerFromName(wantedPlayers[selectedIndex][1]) , 41 )
			blips[ wantedPlayers[selectedIndex][1] ] =  blip 
		else
			if ( isElement( blips [ wantedPlayers[selectedIndex][1] ] ) ) then 
				destroyElement( blips [ wantedPlayers[selectedIndex][1] ] ) 
				blips [ wantedPlayers[selectedIndex] ] = nil
			end
		end
	end
end


--Function that pins all players on the wantedPlayers table
function pinAllPlayers()
	if ( pendWarrantsVisible ) and ( isPCShowing ) then
		for i=1, #wantedPlayers do
			if not ( blips[ wantedPlayers[i][1] ] ) then
				local blip = createBlipAttachedTo( getPlayerFromName(wantedPlayers[i][1]) , 41 )
				blips[ wantedPlayers[i][1] ] =  blip 
			end
		end
	end
end


--Function to remove the blip  if the player disconnects
addEventHandler("onClientPlayerQuit", root,
	function ()
		local blip = blips[ source ]
		if ( blip and isElement( blip ) ) then 
			destroyElement( blip ) 
			blips [source] = nil
		end 
	end
)

--Function that removes all blips
function unpinAllPlayers()
	for i, v in pairs(blips) do
		if ( isElement ( v ) ) then 
			destroyElement( v ) 
			blips [i] = nil
		end
	end
end


-- Check if the draw element is selected
function isDrawElementSelected ( minX, minY, maxX, maxY )
	if ( isCursorShowing() ) then
		local x, y = getCursorPosition()
		if ( sx*x >= minX ) and ( sx*x <= maxX ) then
			if ( sy*y >= minY ) and ( sy*y <= maxY ) then
				return true
			else
				return false
			end
		else
			return false
		end
	end
end
