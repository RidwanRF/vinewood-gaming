-- Get the screen size
local sx, sy = guiGetScreenSize()
local selectedItem = false
local isShowing = false
local iter = 1

-- Some variables
local credits = 0

-- Table with all the information for the items
local aTable = {
	{ "10 Hours VIP", "Enjoy VG even more, become a VIP and get lots\nof extras, just for VIPS. Check negmta.net!", 2, "VIP1" },
	{ "20 Hours VIP", "Enjoy VG even more, become a VIP and get lots\nof extras, just for VIPS. Check negmta.net!", 4, "VIP2" },
	{ "60 Hours VIP", "Enjoy VG even more, become a VIP and get lots\nof extras, just for VIPS. Check negmta.net!", 10, "VIP3" },
	{ "150 Hours VIP", "Enjoy VG even more, become a VIP and get lots\nof extras, just for VIPS. Check negmta.net!", 20, "VIP4" },
	{ "12 Extra Inventory Slots", "Get 12 more inventory slots!\nNon-VIPS can only hold 12 items but you up to 24!", 4, "Inventory" },
	{ "10 Extra Vehicle Slosts", "Get 10 extra vehicle slots!\nYou can now hold 15 personal vehicles instead of 5!", 6, "Vehicle" },
	{ "Free Modding, FOR EVER!", "Mod your vehicle for free, FOR EVER!\nWith this package you'll never need to pay again!", 10, "Modding" },
	{ "Disco Headlights", "Flashing headlights for your vehicles!\nYour vehicle headlights flash in random colors!", 5, "Headlights" },
	{ "Personal Stereo", "A stereo for in your hand or for your vehicle!\nLet people very close to you enjoy your stereo music!", 10, "Stereo" },
}

-- Function that draws the shop
function drawDonatorsStore ()
	-- Normal DX stuff
	dxDrawImage(sx*(728/1440), sy*(216/900), sx*(141/1440), sy*(136/900), "images/coins.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(sx*(320/1440), sy*(127/900), sx*(143/1440), sy*(127/900), "images/money.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	exports.VGdrawing:dxDrawBorderedText("Donators Store", sx*(334/1440), sy*(220/900), sx*(845/1440), sy*(295/900), tocolor(255, 255, 255, 255), 2.0, "pricedown", "left", "top", false, false, false, false, false)
	dxDrawImage(sx*(464/1440), sy*(189/900), sx*(47/1440), sy*(40/900), "images/PP.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(sx*(513/1440), sy*(189/900), sx*(47/1440), sy*(40/900), "images/VI.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(sx*(563/1440), sy*(189/900), sx*(47/1440), sy*(40/900), "images/MC.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(sx*(614/1440), sy*(189/900), sx*(47/1440), sy*(40/900), "images/AE.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	exports.VGdrawing:dxDrawBorderedText(credits.." Credits", sx*(664/1440), sy*(177/900), sx*(962/1440), sy*(228/900), tocolor(235, 131, 19, 255), 2.20, "pricedown", "right", "top", false, false, false, false, false)
	exports.VGdrawing:dxDrawBorderedText("Welcome to the donators store!\n\nHere you can spent the credits you've recieved for your donation.\nIf you want more information about credits and how to donate\nvisit our forum, vinewoodgaming.com\n\nAll these items are account bound and can't be transferd.\nHowever you can transfer VIP hours and credits!\n\nEach credit equals 50 Euro cents.\n\nFor a more detailed information about all these items check the forum!", sx*(729/1440), sy*(354/900), sx*(962/1440), sy*(653/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)

	-- The loop
	local loopI = -1
	
	selectedItem = false
	
	-- Check needed to loop proper
	local iters = #aTable
	if ( #aTable > 5 ) then
		iters = iter + 4
	elseif ( #aTable <= 5 ) then
		iter = 1
	end
	
	for i = iter, iters do
		local theTable = aTable[ i ]
		loopI = loopI + 1
		local A, B, C = sy*(55/900), sy*(54.6/900), sy*(54/900)
		dxDrawRectangle(sx*(325/1440), sy*(300/900)+(loopI*A), sx*(401/1440), sy*(51/900), tocolor(0, 0, 0, 145), false)
		dxDrawBorderedRectangle(sx*(325/1440), sy*(300/900)+(loopI*A), sx*(401/1440), sy*(51/900), tocolor(0, 0, 0, 255), false)
		exports.VGdrawing:dxDrawBorderedText(theTable[1], sx*(332/1440), sy*(304/900)+(loopI*B), sx*(633/1440), sy*(321/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, false, false, false)
		if ( isDrawElementSelected ( sx*(636/1440), sy*(302/900)+(loopI*A), sx*(636/1440)+sx*(87/1440), sy*(302/900)+(loopI*A)+sy*(47/900) ) ) then color = tocolor(10, 108, 16, 145) selectedItem = theTable[4] else color = tocolor(10, 138, 16, 145) end
		dxDrawRectangle(sx*(637/1440), sy*(301/900)+(loopI*A), sx*(89/1440), sy*(49/900), tocolor(0, 0, 0, 255), false)
		dxDrawRectangle(sx*(638/1440), sy*(302/900)+(loopI*A), sx*(87/1440), sy*(47/900), color, false)
		exports.VGdrawing:dxDrawBorderedText("Buy", sx*(652/1440), sy*(301/900)+(loopI*B), sx*(715/1440), sy*(330/900)+(loopI*B), tocolor(255, 255, 255, 255), 1.0, "bankgothic", "center", "center", false, false, false, false, false)
		if ( theTable[3] == 1 ) then aType = "Credit" else aType = "Credits" end
		exports.VGdrawing:dxDrawBorderedText(theTable[3].." " .. aType .. "", sx*(639/1440), sy*(327/900)+(loopI*B), sx*(719/1440), sy*(338/900)+(loopI*B), tocolor(255, 255, 255, 255), 0.45, "bankgothic", "center", "center", false, false, false, false, false)
		exports.VGdrawing:dxDrawBorderedText(theTable[2], sx*(332/1440), sy*(321/900)+(loopI*C), sx*(633/1440), sy*(348/900), tocolor(255, 255, 255, 255), 0.90, "clear", "left", "top", false, false, false, false, false)
	end
end

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end

-- Key to open up the window
bindKey( "F10", "down",
	function ()
		if ( isShowing ) then
			showPlayerDonatorsWindow ( false )
			exports.VGvehiclemisc:setVehicleHudEnabled( "all", true )
		else
			showPlayerDonatorsWindow ( true )
			exports.VGvehiclemisc:setVehicleHudEnabled( "all", false )
		end
	end
)

-- Function that either hides or shows the gui
function showPlayerDonatorsWindow ( bool )
	if ( bool ) then
		if not ( isShowing ) then
			showCursor( true )
			exports.VGdrawing:dxStopScreenRendering()
			addEventHandler( "onClientRender", root, drawDonatorsStore )
			showChat( false ) showPlayerHudComponent ( "all", false )
			exports.VGblur:setBlurEnabled()
			credits = exports.VGaccounts:getPlayerAccountData( "credits" ) or 0
			isShowing = true
		end
	else
		if ( isShowing ) then
			showCursor( false )
			removeEventHandler( "onClientRender", root, drawDonatorsStore )
			showChat( true ) showPlayerHudComponent ( "all", true )
			exports.VGblur:setBlurDisabled()
			isShowing = false
		end
	end
end

-- Check if the draw element is selected
function isDrawElementSelected ( minX, minY, maxX, maxY )
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

-- When the player scrols the mouse
addEventHandler( "onClientKey", root,
    function ( type )
		if ( isShowing ) then
			-- If table amount is < 5 then return
			local i = #aTable
			if ( i < 5 ) then return end
			
			-- Do the 'math'
			if ( type == 'mouse_wheel_up' ) then
				if not ( aTable[ iter -1 ] ) then return end
				iter = iter -1
			elseif ( type == 'mouse_wheel_down' ) then
				if ( ( iter +1 ) + 4 > i ) then return end
				iter = iter +1
			end
		end
    end
)

-- When the person clicks on a item
addEventHandler ( "onClientClick", root,
	function ( button, state )
		if ( isShowing ) and ( button == "left" ) and ( selectedItem ) and ( state == "up" ) then
			
		end
	end
)