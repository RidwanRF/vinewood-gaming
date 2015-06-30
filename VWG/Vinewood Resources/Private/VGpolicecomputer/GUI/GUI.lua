


-- Variable global
isPCShowing = false
pendWarrantsVisible = false
dispLogVisible = false
reqBackupVisible = false
invPlayerVisible = false
menuVisible = true
selectedIndex = 1

dispLogText = ""

clickedBoxY = 490 --Default selection is "all"
minWP = 10

isPlayerAllowedToRequestBackup = true
notificationWindowFrame = 0
notificationWindowAlpha = 255
-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Function that draws the police computer
function drawPoliceComputerWindow ()	
	dxDrawRectangle(sx*(0/1440),sy*(0.0/900),sx*(1500.0/1440),sy*(1000.0/900), tocolor(0, 1, 47, 255), false)
	dxDrawRectangle(sx*(-24/1440),sy*(141.0/900),sx*(1439.0/1440),sy*(8.0/900), tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(sx*(-20/1440),sy*(743.0/900),sx*(1440.0/1440),sy*(8.0/900), tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(sx*(0/1440),sy*(143.0/900),sx*(1439.0/1440),sy*(4.0/900), tocolor(157, 119, 1, 255), false)
	dxDrawRectangle(sx*(1/1440),sy*(745.0/900),sx*(1439.0/1440),sy*(4.0/900), tocolor(183, 134, 6, 255), false)
	dxDrawImage(sx*(23/1440),sy*(35.0/900),sx*(221.0/1440),sy*(184.0/900), "GUI/sapd.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText("Police Computer", sx*(731/1440),sy*(25.0/900),sx*(1451.0/1440),sy*(122.0/900), tocolor(255, 255, 255, 255), sx*(3/1440), "pricedown", "left", "top", false, false, false, false, false)
	
	if ( menuVisible ) then --Main menu
		
		if ( isDrawElementSelected ( sx*(200/1440),sy*(190.0/900), sx*(200/1440)+sx*(632.0/1440),sy*(190.0/900)+sy*(50.0/900) ) ) then textColor = tocolor(150, 150, 150, 255)	else textColor = tocolor(255,255,255,255) end
		dxDrawBorderedText("Pending warrants", sx*(200/1440),sy*(190.0/900),sx*(832.0/1440),sy*(234.0/900), textColor, sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		
		if ( isDrawElementSelected (  sx*(200/1440),sy*(290.0/900), sx*(200/1440)+sx*(892.0/1440),sy*(290.0/900)+sy*(50.0/900)) ) then textColor = tocolor(150, 150, 150, 255) else textColor = tocolor(255,255,255,255) end
		dxDrawBorderedText("Investigate player", sx*(200/1440),sy*(290.0/900),sx*(852.0/1440),sy*(234.0/900), textColor, sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		
		if ( isDrawElementSelected ( sx*(200/1440),sy*(390.0/900), sx*(200/1440)+sx*(492.0/1440),sy*(390.0/900)+sy*(50.0/900) ) ) then textColor = tocolor(150, 150, 150, 255)	else textColor = tocolor(255,255,255,255) end
		dxDrawBorderedText("Dispatch log", sx*(200/1440),sy*(390.0/900),sx*(832.0/1440),sy*(234.0/900), textColor, sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		
		if ( isDrawElementSelected ( sx*(200/1440),sy*(490.0/900), sx*(200/1440)+sx*(602.0/1440),sy*(490.0/900)+sy*(50.0/900) ) ) then textColor = tocolor(150, 150, 150, 255)	else textColor = tocolor(255,255,255,255) end
		dxDrawBorderedText("Request backup", sx*(200/1440),sy*(490.0/900),sx*(832.0/1440),sy*(234.0/900), textColor, sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
	
	elseif ( pendWarrantsVisible ) then --Page to see currently wanted players
		showWarrantsList()

		dxDrawText("Police Computer", sx*(731/1440),sy*(25.0/900),sx*(1451.0/1440),sy*(122.0/900), tocolor(255, 255, 255, 255), sx*(3/1440), "pricedown", "left", "top", false, false, false, false, false)
		dxDrawBorderedText("Current active warrants", sx*(310/1440),sy*(145.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawRectangle(sx*(250/1440),sy*(143.0/900),sx*(1439.0/1440),sy*(4.0/900), tocolor(157, 119, 1, 255), false)
		dxDrawRectangle(sx*(250/1440),sy*(745.0/900),sx*(1439.0/1440),sy*(4.0/900), tocolor(183, 134, 6, 255), false)
		
		
		dxDrawBorderedText("Show players with:", sx*(20/1440),sy*(250.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawImage(sx*(20/1440),sy*(290.0/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_empty.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("60+ Wanted Points", sx*(50/1440),sy*(290.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawImage(sx*(20/1440),sy*(330.0/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_empty.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("50+ Wanted Points", sx*(50/1440),sy*(330.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawImage(sx*(20/1440),sy*(370.0/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_empty.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("40+ Wanted Points", sx*(50/1440),sy*(370.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawImage(sx*(20/1440),sy*(410.0/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_empty.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("30+ Wanted Points", sx*(50/1440),sy*(410.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawImage(sx*(20/1440),sy*(450.0/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_empty.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("20+ Wanted Points", sx*(50/1440),sy*(450.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawImage(sx*(20/1440),sy*(490.0/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_empty.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("All", sx*(50/1440),sy*(490.0/900),sx*(932.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 

		dxDrawImage(sx*(20/1440),sy*(clickedBoxY/900),sx*(16.0/1440),sy*(16.0/900), "GUI/box_clicked.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
		if ( isDrawElementSelected ( sx*(300/1440),sy*(620/900), sx*(300/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(300/1440),sy*(620/900),sx*(191/1440),sy*(61.0/900), "GUI/refresh.png", 0, 0, 0, textColor, false)
		
		if ( isDrawElementSelected ( sx*(500/1440),sy*(620/900), sx*(500/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(500/1440),sy*(620/900),sx*(191/1440),sy*(61.0/900), "GUI/pin_player.png", 0, 0, 0, textColor, false)
		
		if ( isDrawElementSelected ( sx*(700/1440),sy*(620/900), sx*(700/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(700/1440),sy*(620/900),sx*(191/1440),sy*(61.0/900), "GUI/pin_players.png", 0, 0, 0, textColor, false)
		
		if ( isDrawElementSelected ( sx*(900/1440),sy*(620/900), sx*(900/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(900/1440),sy*(620/900),sx*(191/1440),sy*(61.0/900), "GUI/unpin_all.png", 0, 0, 0, textColor, false)
		
		if ( isDrawElementSelected ( sx*(1100/1440),sy*(620/900), sx*(1100/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(1100/1440),sy*(620/900),sx*(191/1440),sy*(61.0/900), "GUI/details.png", 0, 0, 0, textColor, false)		
		
	elseif ( dispLogVisible ) then -- Page to check the last backup requests
		
		dxDrawBorderedText("Dispatch log", sx*(250/1440),sy*(145.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		
		drawDispatchLog()
		
		if ( isDrawElementSelected ( sx*(300/1440),sy*(670/900), sx*(300/1440)+sx*(191/1440),sy*(670/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(300/1440),sy*(670/900),sx*(191/1440),sy*(61.0/900), "GUI/refresh.png", 0, 0, 0, textColor, false)
		
	elseif ( reqBackupVisible ) then -- Page to request backup
		
		dxDrawBorderedText("Request backup", sx*(250/1440),sy*(145.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		
		if ( isDrawElementSelected ( sx*(300/1440),sy*(300/900), sx*(300/1440)+sx*(600/1440),sy*(300/900)+sy*(25/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawBorderedText("-Request Police backup", sx*(300/1440),sy*(300.0/900),sx*(832.0/1440),sy*(234.0/900), textColor, sx*(1.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawBorderedText("Request more police officers if you are outnumbered or facing a dangerous suspect.", sx*(350/1440),sy*(340.0/900),sx*(500.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 

		if ( isDrawElementSelected ( sx*(300/1440),sy*(400/900), sx*(300/1440)+sx*(600/1440),sy*(400/900)+sy*(25/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawBorderedText("-Request a SWAT unit", sx*(300/1440),sy*(400.0/900),sx*(832.0/1440),sy*(234.0/900), textColor, sx*(1.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawBorderedText("Request SWAT assistance if you need to breach into a building that is locked or if you are in a riot situation.", sx*(350/1440),sy*(440.0/900),sx*(500.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 

		if ( isDrawElementSelected ( sx*(300/1440),sy*(500/900), sx*(300/1440)+sx*(850/1440),sy*(500/900)+sy*(25/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end		
		dxDrawBorderedText("-Request a Military Forces unit", sx*(300/1440),sy*(500.0/900),sx*(832.0/1440),sy*(234.0/900), textColor, sx*(1.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 
		dxDrawBorderedText("Request military support if you are chasing an highly wanted and dangerous suspect(s).", sx*(350/1440),sy*(540.0/900),sx*(500.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(0.5/1440), "bankgothic", "left", "top", false, false, false, false, false) 

		
	elseif ( invPlayerVisible ) then --Page to investigate a player name (only on line players)
	
		dxDrawBorderedText("Investigate player", sx*(250/1440),sy*(145.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255,255,255,255), sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false) 

		if ( not guiGetVisible(investigatePlayerName) ) then guiSetVisible(investigatePlayerName, true) end
		
		if ( isDrawElementSelected ( sx*(720/1440),sy*(250.0/900), sx*(720/1440)+sx*(95/1440),sy*(250/900)+sy*(30.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(720/1440),sy*(250.0/900),sx*(95.0/1440),sy*(30.0/900), "GUI/Search.png", 0, 0, 0, textColor, false)
		
		if ( investigatedPlayer ) then
			investigatedPlayerInfo = "Player Name: " .. getPlayerName(investigatedPlayer[1][1]) .. "\nWanted Points: " .. investigatedPlayer[1][2] .."\nGroup: ".. investigatedPlayer[1][3] .. "\nOccupation: " .. investigatedPlayer[1][4]
			
			dxDrawText(investigatedPlayerInfo, sx*(300/1440),sy*(300.0/900),sx*(1000.0/1440),sy*(700.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "left", "top", false, true, false, false, false) 

		
		
		end
	
	end
	
	if ( not menuVisible ) then
		if ( isDrawElementSelected ( sx*(1229/1440),sy*(819/900), sx*(1229/1440)+sx*(191/1440),sy*(819/900)+sy*(61.0/900)) ) then textColor = tocolor(255, 255, 255, 150) else textColor = tocolor(255, 255, 255, 255) end
		dxDrawImage(sx*(1229/1440),sy*(819/900),sx*(191/1440),sy*(61.0/900), "GUI/back.png", 0, 0, 0, textColor, false)
	end
	if ( guiGetVisible(investigatePlayerName) ) and ( not invPlayerVisible ) then guiSetVisible(investigatePlayerName, false) end
end

--Function that creates the gui elements from the police computer
function createGUIElements ()
	--Investigate page
	investigatePlayerName = guiCreateEdit(sx*(300/1440),sy*(250.0/900),sx*(400.0/1440),sy*(30.0/900), "Player Name", false)
	guiSetVisible(investigatePlayerName, false)	
end
createGUIElements()

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

-- Function to draw borderd text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, false, false, false, false, false )
end

-- Bind the key
bindKey( "f5", "down",
	function ()
		if ( isPCShowing ) then --and (exports.VGlaw:isPlayerLaw ( localPlayer ) ) then
			showPoliceComputer ( false )
		else--if (exports.VGlaw:isPlayerLaw ( localPlayer ) ) then
			showPoliceComputer ( true )
 		end
	end
)

--Function (export) that hides/show the police computer
function showPoliceComputer ( show )
	if ( show ) and ( not isPCShowing ) then --and (exports.VGlaw:isPlayerLaw ( localPlayer ) ) then 
		exports.VGdrawing:dxStopScreenRendering()
		isPCShowing = true
		addEventHandler( "onClientRender", root, drawPoliceComputerWindow )
		showCursor( true ) showChat( false ) showPlayerHudComponent ( "all", false )
	elseif ( isPCShowing ) then
		isPCShowing = false
		removeEventHandler( "onClientRender", root, drawPoliceComputerWindow )
		showCursor( false ) showChat( true ) showPlayerHudComponent ( "all", true )
		guiSetVisible(investigatePlayerName, false)
	end
end

--Function to handle all clicks on the police computer
addEventHandler("onClientClick", root, 
	function (btn, state)
		if ( btn == "left" ) and ( state == "down" ) and ( isPCShowing ) then
			if ( menuVisible ) then
				if ( isDrawElementSelected ( sx*(200/1440),sy*(190.0/900), sx*(200/1440)+sx*(632.0/1440),sy*(190.0/900)+sy*(50.0/900) ) ) then menuVisible = false pendWarrantsVisible = true end
				if ( isDrawElementSelected (  sx*(200/1440),sy*(290.0/900), sx*(200/1440)+sx*(892.0/1440),sy*(290.0/900)+sy*(50.0/900) ) ) then menuVisible = false invPlayerVisible = true end
				if ( isDrawElementSelected (  sx*(200/1440),sy*(390.0/900), sx*(200/1440)+sx*(492.0/1440),sy*(390.0/900)+sy*(50.0/900) ) ) then menuVisible = false dispLogVisible = true end
				if ( isDrawElementSelected (  sx*(200/1440),sy*(490.0/900), sx*(200/1440)+sx*(602.0/1440),sy*(490.0/900)+sy*(50.0/900) ) ) then menuVisible = false reqBackupVisible = true end
				
			elseif ( pendWarrantsVisible ) then
				if ( isDrawElementSelected (  sx*(1229/1440),sy*(819/900), sx*(1229/1440)+sx*(191/1440),sy*(819/900)+sy*(61.0/900) ) ) then menuVisible = true pendWarrantsVisible = false end--back btn
				if ( isDrawElementSelected (  sx*(20/1440),sy*(290.0/900), sx*(20/1440)+sx*(16/1440),sy*(290/900)+sy*(16.0/900) ) ) then clickedBoxY = 290 minWP = 60 end --Min 60+
				if ( isDrawElementSelected (  sx*(20/1440),sy*(330.0/900), sx*(20/1440)+sx*(16/1440),sy*(330/900)+sy*(16.0/900) ) ) then clickedBoxY = 330 minWP = 50 end --Min 50+
				if ( isDrawElementSelected (  sx*(20/1440),sy*(370.0/900), sx*(20/1440)+sx*(16/1440),sy*(370/900)+sy*(16.0/900) ) ) then clickedBoxY = 370 minWP = 40 end --Min 40+
				if ( isDrawElementSelected (  sx*(20/1440),sy*(410.0/900), sx*(20/1440)+sx*(16/1440),sy*(410/900)+sy*(16.0/900) ) ) then clickedBoxY = 410 minWP = 30 end --Min 30+
				if ( isDrawElementSelected (  sx*(20/1440),sy*(450.0/900), sx*(20/1440)+sx*(16/1440),sy*(450/900)+sy*(16.0/900) ) ) then clickedBoxY = 450 minWP = 20 end --Min 20+
				if ( isDrawElementSelected (  sx*(20/1440),sy*(490.0/900), sx*(20/1440)+sx*(16/1440),sy*(490/900)+sy*(16.0/900) ) ) then clickedBoxY = 490 minWP = 10 end --All
				if ( isDrawElementSelected ( sx*(300/1440),sy*(620/900), sx*(300/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then refreshWarrantsList() end --refresh btn
				if ( isDrawElementSelected ( sx*(500/1440),sy*(620/900), sx*(500/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then pinPlayer() end --pin player btn
				if ( isDrawElementSelected ( sx*(700/1440),sy*(620/900), sx*(700/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then pinAllPlayers() end --pin players btn
				if ( isDrawElementSelected ( sx*(900/1440),sy*(620/900), sx*(900/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) then unpinAllPlayers() end -- unpin all players btn
				if ( isDrawElementSelected ( sx*(1100/1440),sy*(620/900), sx*(1100/1440)+sx*(191/1440),sy*(620/900)+sy*(61.0/900)) ) and ( wantedPlayers[selectedIndex][1] ) then pendWarrantsVisible = false invPlayerVisible = true guiSetText(investigatePlayerName, wantedPlayers[selectedIndex][1]) searchPlayer ( guiGetText ( investigatePlayerName ) )end -- details button
				
			elseif ( invPlayerVisible ) then
				if ( isDrawElementSelected ( sx*(720/1440),sy*(250.0/900), sx*(720/1440)+sx*(95/1440),sy*(250/900)+sy*(30.0/900)) ) then searchPlayer(guiGetText(investigatePlayerName)) end --Search button
				if ( isDrawElementSelected (  sx*(1229/1440),sy*(819/900), sx*(1229/1440)+sx*(191/1440),sy*(819/900)+sy*(61.0/900) ) ) then menuVisible = true invPlayerVisible = false end --back btn
				
			elseif ( dispLogVisible ) then
				if ( isDrawElementSelected (  sx*(1229/1440),sy*(819/900), sx*(1229/1440)+sx*(191/1440),sy*(819/900)+sy*(61.0/900) ) ) then menuVisible = true dispLogVisible = false end--back btn
				if ( isDrawElementSelected ( sx*(300/1440),sy*(670/900), sx*(300/1440)+sx*(191/1440),sy*(670/900)+sy*(61.0/900)) ) then triggerServerEvent("requestDispatchLog", localPlayer) end--refresh btn
			
			elseif ( reqBackupVisible ) then
				if ( isDrawElementSelected (  sx*(1229/1440),sy*(819/900), sx*(1229/1440)+sx*(191/1440),sy*(819/900)+sy*(61.0/900) ) ) then menuVisible = true reqBackupVisible = false end--back btn
				if ( isDrawElementSelected ( sx*(300/1440),sy*(300/900), sx*(300/1440)+sx*(600/1440),sy*(300/900)+sy*(25/900)) ) and ( isPlayerAllowedToRequestBackup ) then triggerServerEvent("requestBackup", localPlayer, "police") menuVisible = true reqBackupVisible = false createNotificationWindow ("Your request has been sent to all available officers!", 50, 1) isPlayerAllowedToRequestBackup = false setTimer(function () isPlayerAllowedToRequestBackup = true end, 30000, 1) end --request police backup btn
				if ( isDrawElementSelected ( sx*(300/1440),sy*(400/900), sx*(300/1440)+sx*(600/1440),sy*(400/900)+sy*(25/900)) ) and ( isPlayerAllowedToRequestBackup ) then triggerServerEvent("requestBackup", localPlayer, "swat") menuVisible = true reqBackupVisible = false createNotificationWindow ("Your request has been sent to all available officers!", 50, 1) isPlayerAllowedToRequestBackup = false setTimer(function () isPlayerAllowedToRequestBackup = true end, 30000, 1) end -- request swat backup btn
				if ( isDrawElementSelected ( sx*(300/1440),sy*(500/900), sx*(300/1440)+sx*(850/1440),sy*(500/900)+sy*(25/900)) ) and ( isPlayerAllowedToRequestBackup ) then triggerServerEvent("requestBackup", localPlayer, "military") menuVisible = true reqBackupVisible = false createNotificationWindow ("Your request has been sent to all available officers!", 50, 1) isPlayerAllowedToRequestBackup = false setTimer(function () isPlayerAllowedToRequestBackup = true end, 30000, 1) end --request military backup btn

			end
		end
	end
)


function createNotificationWindow (text, frozenUntilFrame, alphaDecreaseRate)
	notificationWindowFrame = 0 
	notificationWindowAlpha = 255
	function drawNotificationWindow ()
		notificationWindowFrame = notificationWindowFrame + 1
		if ( notificationWindowFrame < frozenUntilFrame ) then
		
			dxDrawRectangle(sx*(468/1440),sy*(348.0/900),sx*(504.0/1440),sy*(204.0/900), tocolor(0, 0, 0, 255), false)
			dxDrawRectangle(sx*(470/1440),sy*(350.0/900),sx*(500.0/1440),sy*(200.0/900), tocolor(20, 20, 20, 255), false)

			dxDrawText(text, sx*(480/1440),sy*(360.0/900),sx*(960.0/1440),sy*(540.0/900), tocolor(255,255,255,255), sx*(0.7/1440), "bankgothic", "center", "center", false, true, false, false, false) 
		elseif ( notificationWindowFrame  >= frozenUntilFrame ) and ( notificationWindowAlpha > alphaDecreaseRate ) then
			notificationWindowAlpha = notificationWindowAlpha - alphaDecreaseRate 
			
			dxDrawRectangle(sx*(468/1440),sy*(348.0/900),sx*(504.0/1440),sy*(204.0/900), tocolor(0, 0, 0, notificationWindowAlpha), false)
			dxDrawRectangle(sx*(470/1440),sy*(350.0/900),sx*(500.0/1440),sy*(200.0/900), tocolor(20, 20, 20, notificationWindowAlpha), false)

			dxDrawText(text, sx*(480/1440),sy*(360.0/900),sx*(960.0/1440),sy*(540.0/900), tocolor(255,255,255,notificationWindowAlpha), sx*(0.7/1440), "bankgothic", "center", "center", false, true, false, false, false) 
		else
			removeEventHandler("onClientRender", root, drawNotificationWindow)
		end
	end
	addEventHandler("onClientRender", root, drawNotificationWindow)
end


--If the player stops being a law member, close the computer
function checkOccupation ( key, oldValue )
	if ( key == "Occupation" ) then
		if not ( exports.VGlaw:isPlayerLaw ( thePlayer )  ) then
			showPoliceComputer( false )
		end
	end
end
addEventHandler( "onElementDataChange", root, checkOccupation )