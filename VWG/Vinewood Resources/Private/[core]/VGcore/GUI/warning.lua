-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Table with the DX Elements
local drawText = ""
local alpha = 0
local state = "normal"

--Change the text in the message
addEvent( "setWarningBoxText", true )
function setWarningBoxVisable ( text )
	if ( isTimer( startFadeOut) ) then 
		killTimer ( startFadeOut ) 
		state = "fadingOutFast"
		drawText = text
	elseif ( state == "normal" ) then
		state = "fadingIn" 
		drawText = text
	elseif ( state == "fadingOut" ) or ( state == "fadingIn" ) then
		state = "fadingOutFast"
		drawText = text
	end
	removeEventHandler("onClientRender", root, warningMessage)
	addEventHandler( "onClientRender", root, warningMessage)
end
addEventHandler( "setWarningBoxText", root, setWarningBoxVisable )

-- Draw the text GUI
function warningMessage ()
	if ( exports.VGaccounts:isPlayerLoggedIn( localPlayer ) ) then return end
	if (state == "normal") then
		dxDrawRectangle(sx*(532.0/1440),sy*(335.0/900),sx*(220.0/1440),sy*(28.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawRectangle(sx*(535.0/1440),sy*(337.0/900),sx*(215.0/1440),sy*(24.0/900), tocolor(255, 3, 3, alpha), false)
		dxDrawImage(sx*(534.0/1440),sy*(337.0/900),sx*(29.0/1440),sy*(26.0/900), "images/sign.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
		exports.VGdrawing:dxDrawBorderedText(drawText, sx*(564.0/1440),sy*(341.0/900),sx*(748.0/1440),sy*(362.0/900), tocolor(255, 255, 255, alpha), 1.0, "default", "left", "top", false, false, false, false, false)
	elseif (state == "fadingIn") then
		dxDrawRectangle(sx*(532.0/1440),sy*(335.0/900),sx*(220.0/1440),sy*(28.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawRectangle(sx*(535.0/1440),sy*(337.0/900),sx*(215.0/1440),sy*(24.0/900), tocolor(255, 3, 3, alpha), false)
		dxDrawImage(sx*(534.0/1440),sy*(337.0/900),sx*(29.0/1440),sy*(26.0/900), "images/sign.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
		exports.VGdrawing:dxDrawBorderedText(drawText, sx*(564.0/1440),sy*(341.0/900),sx*(748.0/1440),sy*(362.0/900), tocolor(255, 255, 255, alpha), 1.0, "default", "left", "top", false, false, false, false, false)
		if ( alpha == 100 ) then  
			state = "normal" 
			startFadeOut = setTimer(function () state = "fadingOut" end, 5000, 1 ) 
			return 
		end 
		alpha = alpha + 10
	elseif (state == "fadingOut") then
		dxDrawRectangle(sx*(532.0/1440),sy*(335.0/900),sx*(220.0/1440),sy*(28.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawRectangle(sx*(535.0/1440),sy*(337.0/900),sx*(215.0/1440),sy*(24.0/900), tocolor(255, 3, 3, alpha), false)
		dxDrawImage(sx*(534.0/1440),sy*(337.0/900),sx*(29.0/1440),sy*(26.0/900), "images/sign.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
		exports.VGdrawing:dxDrawBorderedText(drawText, sx*(564.0/1440),sy*(341.0/900),sx*(748.0/1440),sy*(362.0/900), tocolor(255, 255, 255, alpha), 1.0, "default", "left", "top", false, false, false, false, false)
		if ( alpha == 0 ) then  state = "normal" removeEventHandler("onClientRender", root, warningMessage) return end 
		alpha = alpha - 2
	elseif (state == "fadingOutFast") then
		dxDrawRectangle(sx*(532.0/1440),sy*(335.0/900),sx*(220.0/1440),sy*(28.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawRectangle(sx*(535.0/1440),sy*(337.0/900),sx*(215.0/1440),sy*(24.0/900), tocolor(255, 3, 3, alpha), false)
		dxDrawImage(sx*(534.0/1440),sy*(337.0/900),sx*(29.0/1440),sy*(26.0/900), "images/sign.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
		exports.VGdrawing:dxDrawBorderedText(drawText, sx*(564.0/1440),sy*(341.0/900),sx*(748.0/1440),sy*(362.0/900), tocolor(255, 255, 255, alpha), 1.0, "default", "left", "top", false, false, false, false, false)
		if ( alpha == 0 ) then 
			state = "fadingIn" 
		end 
	alpha = alpha - 20
	end
	if ( alpha < 0 ) then alpha = 0 end
	if ( alpha > 255 ) then alpha = 255 end
end