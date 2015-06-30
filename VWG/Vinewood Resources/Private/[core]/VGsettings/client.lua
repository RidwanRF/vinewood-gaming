
local tostring = tostring

-- Get the screen size
local screenWidth, screenHeight = guiGetScreenSize()

-- Some settings
local isEnabled = false
local lastTick = getTickCount()
local framesRendered = 0
local FPS = 0

-- On setting change check if we should toggle or hide it
addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "blur" ) then
			if ( newValue ) then setBlurLevel ( 36 ) else setBlurLevel ( 0 ) end
		elseif ( setting == "clouds" ) then
			setCloudsEnabled ( newValue )
		elseif ( setting == "fpsmeter" ) then
			if ( newValue ) and not ( isEnabled ) then addEventHandler( "onClientRender", root, onClientDrawMeterFPS ) else removeEventHandler( "onClientRender", root, onClientDrawMeterFPS ) end
		elseif ( setting == "sms" ) then
			-- To Do
		end
	end
)

-- Check on the start of the resource of we should hide or show it
addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if not ( getPlayerSetting( "blur" ) ) then
			setBlurLevel ( 0 )
		end
		if not ( getPlayerSetting( "clouds" ) ) then
			setCloudsEnabled ( false )
		end
		if ( getPlayerSetting( "fpsmeter" ) ) then
			addEventHandler( "onClientRender", root, onClientDrawMeterFPS )
		end
		if ( getPlayerSetting( "sms" ) ) then
			-- To Do
		end
	end
)

-- Function to draw the FPS meter
function onClientDrawMeterFPS ()
	local currentTick = getTickCount()
	local elapsedTime = currentTick - lastTick
	
	if elapsedTime >= 1000 then
		FPS = framesRendered
		lastTick = currentTick
		framesRendered = 0
	else
		framesRendered = framesRendered + 1
	end
	
	if FPS == 20 then
		FPSColor = tocolor( 238, 0, 0, 255 )
	elseif FPS < 20 then
		FPSColor = tocolor( 238, 0, 0, 255 )
	elseif FPS >20 then
		FPSColor = tocolor( 0, 205, 0, 255 )
	end
	
	exports.VGdrawing:dxDrawBorderedText(tostring(FPS), 0, 0, screenWidth - 5, screenHeight - 5, FPSColor, 1, "bankgothic", "right")
end