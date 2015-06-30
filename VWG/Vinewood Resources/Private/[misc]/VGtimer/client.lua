
local type = type

-- Variables
local sx, sy = guiGetScreenSize()
local time = 0
local isDrawing = false
local timeTimer = false
local timeEvent = nil

-- Create a new timer
function createMissionTimer( theTime, event )
	if ( theTime ) and ( event ) and not ( isDrawing ) and ( type( theTime ) == "number" ) and ( type( event ) == "string" ) then
		addEventHandler( "onClientRender", root, dxRenderTimeFrame )
		timeTimer = setTimer( takeTimerTime, 1000, 0 )
		time = theTime timeEvent = event isDrawing = true
		return true
	end
end

-- Destroy the timer
function destroyMissionTimer()
	if ( isDrawing ) then
		if ( isTimer( timeTimer ) ) then killTimer( timeTimer ) end
		removeEventHandler( "onClientRender", root, dxRenderTimeFrame )
		isDrawing = false timeTimer = false time = 0 timeEvent = nil
		return true
	else
		return false
	end
end

-- Change the time of the timer
function setMissionTimerTime( theTime )
	if ( theTime ) and ( isDrawing ) and ( time ) then
		time = theTime
		return true
	end
end

-- Get the mission timer time
function getMissionTimerTime()
	if ( isDrawing ) then
		return time
	end
end

-- Function that draws the timer
function dxRenderTimeFrame ()
	if ( isDrawing ) and ( time ) then
		dxSetAspectRatioAdjustmentEnabled( true )
		if ( time <= 10 ) then color = tocolor(225, 0, 0, 255) else color = tocolor(225, 225, 225, 255) end
		if ( getPlayerWantedLevel() == 0 ) then
			dxDrawImage(sx*(1160.0/1440),sy*(203.0/900),sx*(186.0/1440),sy*(30.0/900), "background.png", 0, 0, 0, tocolor(0, 0, 0, 255), false)
			exports.VGdrawing:dxDrawBorderedText(time.." seconds", sx*(1160.0/1440),sy*(204.0/900),sx*(1346.0/1440),sy*(231.0/900), color, sx*(1.0/1440), "pricedown", "center", "top", false, false, false, false, false)
		else
			dxDrawImage(sx*(1160.0/1440),sy*(255.0/900),sx*(186.0/1440),sy*(30.0/900), "background.png", 0, 0, 0, tocolor(0, 0, 0, 255), false)
			exports.VGdrawing:dxDrawBorderedText(time.." seconds", sx*(1160.0/1440),sy*(256.0/900),sx*(1346.0/1440),sy*(283.0/900), color, sx*(1.0/1440), "pricedown", "center", "top", false, false, false, false, false)
		end
	end
end 

-- Function to freeze a mission timer
function setMissionTimerFrozen ( bool )
	if ( isDrawing ) and ( time ) then
		if ( bool ) then
			if ( isTimer( timeTimer ) ) then killTimer( timeTimer ) return true end
			return false
		else
			if not ( isTimer( timeTimer ) ) then timeTimer = setTimer( takeTimerTime, 1000, 0 ) return true end
			return false
		end
	else
		return false
	end
end

-- Function that takes the time from the timer
function takeTimerTime ()
	if ( time ) then
		if ( time <= 0 ) then
			triggerEvent( timeEvent, root )
			destroyMissionTimer()
		else
			time = time - 1
		end
	end
end