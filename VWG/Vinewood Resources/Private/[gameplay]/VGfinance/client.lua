-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Some Variables

--Pre-settings
setPlayerHudComponentVisible("money", false)

addEventHandler("onClientRender", root, 
	function ()
		if not ( exports.VGaccounts:isPlayerLoggedIn (localPlayer) ) then return end
		local playerMoney = getPlayerMoney () 
		--[[local i = string.len(tostring(playerMoney))
		local i = 7 - i
		s=""
		for n=i,0,-1 do 
			s = s .."0" 
			i= i-1 
		end
		dxDrawText ( "$"..s..playerMoney/100, sx*(994/1290), sy*(164/1024), sx*(1229/1290), sy*(214/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		dxDrawText ( "$"..s..playerMoney/100, sx*(994/1290), sy*(156/1024), sx*(1221/1290), sy*(206/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		dxDrawText ( "$"..s..playerMoney/100, sx*(986/1290), sy*(156/1024), sx*(1221/1290), sy*(206/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		dxDrawText ( "$"..s..playerMoney/100, sx*(986/1290), sy*(164/1024), sx*(1229/1290), sy*(214/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )

		dxDrawText ( "$"..s..playerMoney/100, sx*(994/1290), sy*(160/1024), sx*(1229/1290), sy*(210/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		dxDrawText ( "$"..s..playerMoney/100, sx*(986/1290), sy*(160/1024), sx*(1221/1290), sy*(210/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		dxDrawText ( "$"..s..playerMoney/100, sx*(990/1290), sy*(164/1024), sx*(1225/1290), sy*(214/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		dxDrawText ( "$"..s..playerMoney/100, sx*(990/1290), sy*(156/1024), sx*(1225/1290), sy*(206/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right" )
		
		dxDrawText ( "$"..s..playerMoney/100, sx*(990/1290), sy*(160/1024), sx*(1225/1290), sy*(210/1024), tocolor ( 47, 90, 38, 255 ), sx*(1.875/1290), "pricedown", "right" )
]]

		dxDrawText ( "$"..playerMoney/100, sx*(994/1290), sy*(164/1024), sx*(1229/1290), sy*(214/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		dxDrawText ( "$"..playerMoney/100, sx*(994/1290), sy*(156/1024), sx*(1221/1290), sy*(206/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		dxDrawText ( "$"..playerMoney/100, sx*(986/1290), sy*(156/1024), sx*(1221/1290), sy*(206/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		dxDrawText ( "$"..playerMoney/100, sx*(986/1290), sy*(164/1024), sx*(1229/1290), sy*(214/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )

		dxDrawText ( "$"..playerMoney/100, sx*(994/1290), sy*(160/1024), sx*(1229/1290), sy*(210/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		dxDrawText ( "$"..playerMoney/100, sx*(986/1290), sy*(160/1024), sx*(1221/1290), sy*(210/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		dxDrawText ( "$"..playerMoney/100, sx*(990/1290), sy*(164/1024), sx*(1225/1290), sy*(214/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		dxDrawText ( "$"..playerMoney/100, sx*(990/1290), sy*(156/1024), sx*(1225/1290), sy*(206/1024), tocolor ( 0, 0, 0, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )
		
		dxDrawText ( "$"..playerMoney/100, sx*(990/1290), sy*(160/1024), sx*(1225/1290), sy*(210/1024), tocolor ( 47, 90, 38, 255 ), sx*(1.875/1290), "pricedown", "right", "center" )

	end
)


