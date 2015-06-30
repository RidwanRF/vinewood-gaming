--Optimization



local speechLinesNormal = { 
{ "Please, just take the money!" },
{ "Don't shoot me, just get what you need!" },
{ "Ok, ok, calm down!" },
{ "Don't kill me, I have a wife and kids!" },
{ "There is no need for this!" },
{ "I'm sure we can work this out!" },
{ "Don't.. please, just put that gun away!" },
{ "The police will get you, criminal scum!" },
{ "How dare you rob my store?!" },
{ "The police will catch you!" },
{ "You will not get away with this, mark my words!" },
{ "My cousin is a police officer, he will hunt you down!" },
{ "I thought I could run a fair business here!" },
{ "That's it.. I'm leaving this damn country!" },
{ "What?! Oh.. not again!" },
{ "I can't make a decent living here!" },
{ "Why does this always happen to me!" },
{ "I should have stayed in Liberty City!" },
{ "You will feel sorry for this!" },
{ "You can run, but.. oh.. what am I saying... just take the money..." },
}

local speechLinesAN = { 
{ "Wrong move partner! Prepare to meet your maker!" },
{ "Whahaha, really? Kish my iron baby, scum!" },
{ "Didn't I sell you that piece of equipment? Get out of my store, NOW!" },
{ "What were you even thinking? Get lost!" },
{ "I'm not sure if I should laugh or blow your brains out.. I think I'm going with the second option!" },
}

local robs = { }

addEvent("syncPeds", true)
function setPeds ( peds )
	for i, v in ipairs ( peds ) do
		addEventHandler("onClientPedDamage", v, function () cancelEvent() end )
	end
end
addEventHandler("syncPeds", root, setPeds)

addEvent("checkForPlayerAim", true)
function checkAim ( actionType, ped )
	if ( source ~= localPlayer ) then return end
	if not ( isPedAiming ( source ) ) then return end
	if ( actionType == "newRob" ) then
		triggerServerEvent( "startStoreRob", localPlayer, ped )
	elseif ( actionType == "joinRob" ) then
		triggerServerEvent( "addPlayerToStoreRob", localPlayer, ped )
	end
end
addEventHandler("checkForPlayerAim", root, checkAim)



addEvent("startStoreRob", true)
function startStoreRob ( player, ped )
	-- Tell the player he started a store rob
	if ( localPlayer == player ) then
		exports.VGdx:showHudMessageDX ( "Hurry up, the police is on the way!" , 255, 0, 0, 10000 )
		exports.VGdx:showHudMessageDX ( "Stay alert while you wait for the cashier to take the money out of the register!" , 255, 0, 0, 10000 )
	end
	
	-- Warn the police
	if ( exports.VGlaw:isPlayerLaw ( localPlayer ) ) then
		exports.VGdx:showHudMessageDX ( "A(n) "..getElementData(player, "playerInteriorName").." in "..getZoneName(	getElementData( player, "playerPositionOnWorldX"), getElementData( player, "playerPositionOnWorldY"), 0 ) .." is being robbed! Please respond!" , 0, 0, 255, 10000 )
	end
	
	
	robs [#robs +1 ] = { ped, math.random ( #speechLinesNormal ) }
	
	setHandsUpAnimation ( ped )
	addEventHandler( "onClientElementStreamIn", ped, setHandsUpAnimation )

	setTimer ( function () setCoverAnimation(ped) removeEventHandler( "onClientElementStreamIn", ped, setHandsUpAnimation )	addEventHandler( "onClientElementStreamIn", ped, setCoverAnimation ) end, 60000, 1)

	setTimer( function () removeEventHandler( "onClientElementStreamIn", ped, setCoverAnimation ) setPedAnimation ( ped ) robs[#robs] = nil end, 160000, 1)


end
addEventHandler("startStoreRob", root, startStoreRob)

addEvent("addPlayerToStoreRob", true)
function addPlayerToStoreRob ( player, ped )
	-- Tell the player he joined the rob
	if ( player == localPlayer ) then
		exports.VGdx:showMessageDX( "You have joined the robbery!", 255, 0, 0, 10000 )
		exports.VGdx:showHudMessageDX ( "Hurry up, the police is on the way!" , 255, 0, 0, 10000 )
		exports.VGdx:showHudMessageDX ( "Stay alert while you wait for the cashier to take the money out of the register!" , 255, 0, 0, 10000 )
	end
end
addEventHandler("addPlayerToStoreRob", root, addPlayerToStoreRob)


function setHandsUpAnimation ( ped )
	if ( ped ) then 
		setPedAnimation( ped, "ped", "handsup", -1, false, true, false )
	else
		setPedAnimation( source, "ped", "handsup", -1, false, true, false )
	end
end

function setCoverAnimation ( ped )
	if ( ped ) then 
		setPedAnimation( ped, "ON_LOOKERS", "panic_cower", -1, false, false, false )
	else
		setPedAnimation( source, "ON_LOOKERS", "panic_cower", -1, false, false, false )
	end
end


function drawTextBubble () 
	for i=1, #robs do
		drawText (robs[i][1], speechLinesNormal[robs[i][2]][1] ) 
	end
end
addEventHandler( "onClientRender", root,  drawTextBubble  )


function drawText (ped, text)
	if ( isElement( ped ) ) then
		local camPosXl, camPosYl, camPosZl = getPedBonePosition (ped, 6)
		local camPosXr, camPosYr, camPosZr = getPedBonePosition (ped, 7)
		local x,y,z = (camPosXl + camPosXr) / 2, (camPosYl + camPosYr) / 2, (camPosZl + camPosZr) / 2
		local cx,cy,cz = getCameraMatrix()
		local px,py,pz = getElementPosition(ped)
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
		local posx,posy = getScreenFromWorldPosition(x,y,z+0.020*distance+0.10)
		local elementtoignore1 = getPedOccupiedVehicle(localPlayer) or localPlayer
		local elementtoignore2 = getPedOccupiedVehicle(ped) or ped
		if posx and distance <= 45 and ( isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true,elementtoignore1) or isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true,elementtoignore2) ) then -- change this when multiple ignored elements can be specified
			local width = dxGetTextWidth(text,1,"default")
			
			dxDrawRectangle(posx - (3 + (0.5 * width)),posy - (2 + (0 * 20)),width + 5,19,tocolor(0,0,0,180))
			dxDrawRectangle(posx - (6 + (0.5 * width)),posy - (2 + (0 * 20)),width + 11,19,tocolor(0,0,0,0))
			dxDrawRectangle(posx - (8 + (0.5 * width)),posy - (1 + (0 * 20)),width + 15,17,tocolor(0,0,0,180))
			dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (1 + (0 * 20)),width + 19,17,tocolor(0,0,0,0))
			dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (0 * 20) + 1,width + 19,13,tocolor(0,0,0,180))
			dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (0 * 20) + 1,width + 23,13,tocolor(0,0,0,0))
			dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (0 * 20) + 4,width + 23,7,tocolor(0,0,0,180))
			
			local r,g,b = 255, 255, 255
			
			dxDrawText(text,posx - (0.5 * width),posy - (0 * 20),posx - (0.5 * width),posy - (0 * 20),tocolor(r,g,b,255),1,"default","left","top",false,false,false)
		end
	end
end

function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end
