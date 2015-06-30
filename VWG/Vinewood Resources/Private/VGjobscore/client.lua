local sx, sy = guiGetScreenSize()
local scrollState = 0 
local gridStartx, gridStarty = sx*(62/1440), sy*(345/900)


function openJobGUI (hitElement, md)
	if ( hitElement == localPlayer ) and ( md ) and not ( isPedInVehicle(localPlayer) ) then
		job = jobMarkers[source]
		isJobGUI1Showing = true
		showCursor(true)
		addEventHandler("onClientRender", root, drawJobGUI)
			function clickHandler(btn, state)
				if ( btn == "left" ) and ( state == "down" ) then
					if ( isJobGUI1Showing ) then--Information window btns
						if (isDrawElementSelected ( sx*(778/1440), sy*(670/900), sx*(134/1440)+sx*(778/1440), sy*(28/900)+sy*(670/900) ) )  then isJobGUI2Showing = true isJobGUI1Showing = false checkRequirements(job) end --next btn
						if (isDrawElementSelected ( sx*(503/1440), sy*(670/900), sx*(134/1440)+sx*(503/1440), sy*(28/900)+sy*(670/900) ) )  then closeJobGUI ( localPlayer ) end --close job gui btn
					elseif ( isJobGUI2Showing ) then--Requirements window btns
						if (isDrawElementSelected ( sx*(778/1440), sy*(670/900), sx*(134/1440)+sx*(778/1440), sy*(28/900)+sy*(670/900) ) )  and ( reqAreMet ) then isJobGUI2Showing = false isJobGUI3Showing = true skinSelected = false showChat(false) originalSkin = getElementModel(localPlayer) end --next btn
						if (isDrawElementSelected ( sx*(503/1440), sy*(670/900), sx*(134/1440)+sx*(503/1440), sy*(28/900)+sy*(670/900) ) )  then closeJobGUI ( localPlayer ) end --close job gui btn
					elseif ( isJobGUI3Showing ) then--Skins window btns
						if (isDrawElementSelected ( sx*(331/1440), sy*(670/900), sx*(134/1440)+sx*(331/1440), sy*(28/900)+sy*(670/900) ) )  and ( skinSelected ) then takeJob (localPlayer, job) end --Take job btn
						if (isDrawElementSelected ( sx*(66/1440), sy*(670/900), sx*(134/1440)+sx*(66/1440), sy*(28/900)+sy*(670/900) ) )  then closeJobGUI ( localPlayer ) end --close job gui btn
					end
				end
			end
			addEventHandler("onClientClick", root, clickHandler)
	end
end


function closeJobGUI (hitElement, md)
	if ( hitElement == localPlayer ) and ( ( isJobGUI1Showing ) or ( isJobGUI2Showing ) or ( isJobGUI3Showing ) ) then
		removeEventHandler("onClientClick", root, clickHandler)
		showCursor(false)
		if ( isJobGUI3Showing ) then--re set the old skin
			setElementModel(localPlayer, originalSkin)
		end
		isJobGUI1Showing = false
		isJobGUI2Showing = false
		isJobGUI3Showing = false
		showChat(true)
		removeEventHandler("onClientRender", root, drawJobGUI)
	end
end


--function that is triggered when the player clicks the take job button
function takeJob (thePlayer, job)
	local theOccupation = jobSettingsTable[job].occupationName
	local theTeam = jobSettingsTable[job].occupationTeam
	local skins = jobSettingsTable[job].skins
	local weaponToGive = jobSettingsTable[job].weapon
	if ( theOccupation ) and ( theTeam ) then--send the info to the server
		triggerServerEvent("onPlayerTakeJob", localPlayer, theTeam, theOccupation, weaponToGive, skins[skinSelected])
	end
	closeJobGUI(localPlayer)
end


-- Check the the draw element is selected
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

--function to check whether the player fullfills the requirements to take the job or not
function checkRequirements (job)
	local reqGunCertif = jobSettingsTable[job].gunLicense
	local reqArrests = jobSettingsTable[job].arrests 
	local reqHours = jobSettingsTable[job].hours
	if not ( jobSettingsTable[job].requirements ) then
		reqAreMet = true isJobGUI2Showing = false isJobGUI3Showing = true skinSelected = false showChat(false) originalSkin = getElementModel(localPlayer)
	end
	--local playerGunCertif = ---------------------<------------
	local playerArrests = 0 ----------------<------------
	local playerHours = ( getElementData(localPlayer, "Playtime") / 60 )
	reqString = ""
	reqAreMet = false
	
	--hours
	if ( reqHours ~= 0 ) then -- if there is no minimum hours required dont show the requirement
		if ( playerHours >= reqHours ) then
			reqString = reqString.."#33CC00"..reqHours.." hours of playtime;\n\n" -- met (green)
			hoursMet = true
		else
			reqString = reqString.."#FF0000"..reqHours.." hours of playtime;\n\n" --not met (red)
		end
	else 
		hoursMet = true 
	end
	--arrests
	if ( reqArrests ~= 0 ) then -- if there is no minimum hours required dont show the requirement
		if ( playerArrests >= reqArrests ) then
			reqString = reqString.."#33CC00"..reqArrests.." suspects arrested;\n\n" -- met (green)
			arrestsMet = true
		else
			reqString = reqString.."#FF0000"..reqArrests.." suspects arrested;\n\n" -- not met (red)
		end
	else 
		arrestsMet = true
	end
	--gun certif (just for law)
	if ( reqGunCertif ) then -- if there is no minimum hours required dont show the requirement
		if ( playerGunCertif ) then
			reqString = reqString.."#33CC00 You have a Gun Certificate;\n\n" -- met (green)
			gunCertif = true
		else
			reqString = reqString.."#FF0000 You don't have a Gun Certificate;\n\n" -- not met (red)
		end
	else 
		gunCertif = true
	end
	
	if ( hoursMet ) and ( arrestsMet ) and ( gunCertif ) then --final check to whether the reqs were all fullfilled
		reqAreMet = true 
		reqString = reqString.."#33CC00All requirements are met." 
	end 
end

--Function that is triggered onClientRender and draws the job dx GUI
function drawJobGUI ()
	if not ( isJobGUI3Showing ) then
		-- dxDrawRectangle(sx*(447/1440), sy*(169/900), sx*(547/1440), sy*(600/900), tocolor(0, 0, 0, 61))
		dxDrawRectangle(sx*(489/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 135))
		dxDrawBorderedRectangle(sx*(489/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 255), false)
		dxDrawImage(sx*(449/1440), sy*(170/900), sx*(150/1440), sy*(150/900), "imgs/jobIcon.png", 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawBorderedText(job, sx*(600/1440), sy*(250/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.0, "default", "center", "top")	
		
		if (isDrawElementSelected ( sx*(513/1440), sy*(670/900), sx*(134/1440)+sx*(513/1440), sy*(28/900)+sy*(670/900) ) ) then a = 100 else a = 143 end 
		dxDrawRectangle(sx*(510/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
		dxDrawRectangle(sx*(513/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
		dxDrawBorderedText("Close Window", sx*(513/1440), sy*(670/900), sx*(647/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center" )
	end
	
	if ( isJobGUI1Showing ) then --INFORMATION PANEL
		dxDrawBorderedText("Information:", sx*(600/1440), sy*(300/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.00, "default", "center", "top")	

		dxDrawRectangle(sx*(500/1440), sy*(320/900), sx*(431/1440), sy*(300/900), tocolor(0, 0, 0, 255))
		dxDrawRectangle(sx*(505/1440), sy*(325/900), sx*(421/1440), sy*(290/900), tocolor(255, 255, 255, 200))
		dxDrawText(jobSettingsTable[job].desc, sx*(508/1440), sy*(328/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1.0, "default", "left", "top", true, true)
		
		if (isDrawElementSelected ( sx*(778/1440), sy*(670/900), sx*(134/1440)+sx*(778/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
		dxDrawRectangle(sx*(775/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
		dxDrawRectangle(sx*(778/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(231, 172, 27, a))
		dxDrawBorderedText("Next", sx*(778/1440), sy*(670/900), sx*(916/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")
	
	elseif (isJobGUI2Showing) then --REQUIREMENTS PANEL
		dxDrawBorderedText("Requirements:", sx*(600/1440), sy*(300/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.00, "default", "center", "top")	

		dxDrawRectangle(sx*(500/1440), sy*(320/900), sx*(431/1440), sy*(300/900), tocolor(0, 0, 0, 255))
		dxDrawRectangle(sx*(505/1440), sy*(325/900), sx*(421/1440), sy*(290/900), tocolor(255, 255, 255, 200))
		dxDrawText(reqString, sx*(508/1440), sy*(328/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1.00, "default", "center", "center", true, true, false, true )
		
	
		if ( reqAreMet ) then--enable button
			if (isDrawElementSelected ( sx*(778/1440), sy*(670/900), sx*(134/1440)+sx*(778/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
			dxDrawRectangle(sx*(775/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(778/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(231, 172, 27, a))
			dxDrawBorderedText("Next", sx*(778/1440), sy*(670/900), sx*(916/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")
		else --disable button
			dxDrawRectangle(sx*(775/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(778/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(231, 172, 27, 50))
			dxDrawBorderedText("Next", sx*(778/1440), sy*(670/900), sx*(916/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center")
		end
			
			
	elseif (isJobGUI3Showing) then --SKINS PANEL
		-- dxDrawRectangle(sx*(0/1440), sy*(169/900), sx*(547/1440), sy*(600/900), tocolor(0, 0, 0, 61))
		dxDrawRectangle(sx*(42/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 135))
		dxDrawBorderedRectangle(sx*(42/1440), sy*(196/900), sx*(452/1440), sy*(528/900), tocolor(0, 0, 0, 255), false)
		dxDrawImage(sx*(2/1440), sy*(170/900), sx*(150/1440), sy*(150/900), "imgs/jobIcon.png", 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawBorderedText(job, sx*(153/1440), sy*(250/900), sx*(400/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.0, "default", "center", "top")	
	
		dxDrawBorderedText("Skins:", sx*(153/1440), sy*(300/900), sx*(400/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.0, "default", "center", "top")	

		dxDrawRectangle(sx*(57/1440), sy*(320/900), sx*(431/1440), sy*(300/900), tocolor(0, 0, 0, 255)) --Grid list code starts here
		dxDrawRectangle(sx*(62/1440), sy*(325/900), sx*(421/1440), sy*(290/900), tocolor(255, 255, 255, 200)) 
		local skins = jobSettingsTable[job].skins
		local skinColor = jobSettingsTable[job].blipColor
		dxDrawRectangle(gridStartx, gridStarty-20, sx*(421.0/1440), sy*(20.0/900),  tocolor(255,255,255,50))
		dxDrawBorderedText("ID:", gridStartx+(sx*(70/1440)), gridStarty+5-20, sx, sy, tocolor(255, 255, 255, 255 ), 1.0, "default", "left", "top" )
		dxDrawBorderedText("Name:", gridStartx+(sx*(200/1440)), gridStarty+5-20, sx, sy, tocolor(255, 255, 255, 255 ), 1.0, "default", "left", "top" )
		
		for i=1, #skins do
				local x, y = gridStartx, gridStarty + ( sy*(32/960) * (i-1) + ( scrollState * sy*(32/960) ) )
				--Create the row
				if ( isDrawElementSelected ( x, y, x+sx*(421/1440),y + sy*(32.0/900) ) ) then hoveredY, hoveredIndex, color = y, i, tocolor(255, 255, 255, 100)  else color =  tocolor(255,255,255,50) end
				if ( i == selectedIndex ) then color = tocolor(255, 255, 255,100) end
				dxDrawRectangle(x, y, sx*(421.0/1440), sy*(32.0/900),  color)
				dxDrawImage(x+5, y, sx*(32.0/1440), sy*(32.0/900), skinColors[skinColor])
				dxDrawBorderedText(skins[i], x+(sx*(70/1440)), y+8, sx, sy, tocolor(255, 255, 255, 255 ), 1.0, "default", "left", "top" )
				dxDrawBorderedText("Skin "..i, x+(sx*(200/1440)), y+8, sx, sy, tocolor(255, 255, 255, 255 ), 1.0, "default", "left", "top" )
		end
		
		if (isDrawElementSelected ( sx*(66/1440), sy*(670/900), sx*(134/1440)+sx*(66/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
		dxDrawRectangle(sx*(63/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
		dxDrawRectangle(sx*(66/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(217, 162, 29, a))
		dxDrawBorderedText("Close Window", sx*(66/1440), sy*(670/900), sx*(200/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center" )

		if ( skinSelected ) then
			if (isDrawElementSelected ( sx*(331/1440), sy*(670/900), sx*(134/1440)+sx*(331/1440), sy*(28/900)+sy*(670/900) ) ) then a =100 else a = 143 end 
			dxDrawRectangle(sx*(328/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(331/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(231, 172, 27, a))
			dxDrawBorderedText("Take job", sx*(331/1440), sy*(670/900), sx*(465/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center" )
		else 
			dxDrawRectangle(sx*(328/1440), sy*(667/900), sx*(140/1440), sy*(34/900), tocolor(0, 0, 0, 143))
			dxDrawRectangle(sx*(331/1440), sy*(670/900), sx*(134/1440), sy*(28/900), tocolor(231, 172, 27, 50))
			dxDrawBorderedText("Take job", sx*(331/1440), sy*(670/900), sx*(465/1440), sy*(698/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center" )
		end
	end
end

--Function to handle the clicks on the skin's gridlist
addEventHandler("onClientClick", root, 
	function (btn, state)
		if ( btn == "left" ) and ( state == "down" ) then
			if ( isJobGUI3Showing ) and (hoveredY) then
				if ( isDrawElementSelected (  gridStartx, hoveredY, gridStartx+sx*(421.0/1440), hoveredY+sy*(32.0/900) ) ) then 
					selectedIndex = hoveredIndex 
					skinSelected = selectedIndex 
					local skins = jobSettingsTable[job].skins
					setElementModel(localPlayer, skins[skinSelected] )
				end
			end
		end
	end
)

-- Function to draw borderd text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false)
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false)
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, false, false, false, false )
end

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end

addEvent("onPlayerJobTaken", true )
addEventHandler("onPlayerJobTaken", root, 
function ()
--to stop the debug spam saying the event is not added client side. remove later on
end
)