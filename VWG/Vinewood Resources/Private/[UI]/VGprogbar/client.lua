
local tostring = tostring
local tonumber = tonumber

-- Table that holds all the data
local dxTable = {}

-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Pregress bar with progress defined by time
function createProgressBar ( timePerPercent, text, eventName, hideWhenDone, R, G, B, R2, G2, B2 )
	if not ( dxTable.isVisableOne ) and not ( dxTable.isVisableTwo ) then
		if not ( timePerPercent ) or ( timePerPercent < 50 ) then return false end
		dxTable.isVisableOne  = true
		addEventHandler( "onClientRender", root, drawTimer )
		dxTable.event = eventName or false
		dxTable.text = text or "Loading..."
		dxTable.percentage = 0
		dxTable.r, dxTable.g, dxTable.b = R or 180, G or 0, B or 0
		dxTable.r2, dxTable.g2, dxTable.b2 = R2 or 225, G2 or 225, B2 or 225
		dxTable.hide = hideWhenDone or true
		dxTable.timer = setTimer( function() dxTable.percentage = math.floor( dxTable.percentage ) + 1 end, timePerPercent, 0 )
		return true
	else
		return false
	end
end

-- Cancel and hide the progress bar
function destroyProgressBar ( doHide )
	if ( dxTable.isVisableOne ) then
		if ( doHide ) then
			dxTable.isVisableOne = false
			removeEventHandler( "onClientRender", root, drawTimer )
		end
		if isTimer( dxTable.timer ) then killTimer ( dxTable.timer ) end
		return true
	elseif ( dxTable.isVisableTwo ) then
		if ( doHide ) then
			dxTable.isVisableTwo = false
			removeEventHandler( "onClientRender", root, drawTimer )
			return true
		end
	else
		return false
	end
end

-- Function to draw the progress bar
function drawTimer ()
	if ( dxTable.isVisableOne ) or ( dxTable.isVisableTwo ) then
		dxDrawRectangle(sx*(538.0/1440),sy*(817.0/900),sx*(476.0/1440),sy*(39.0/900), tocolor(0, 0, 0, 179), false)
		dxDrawRectangle(sx*(541.0/1440),sy*(820.0/900),(sx*(470.0/1440)/100) * dxTable.percentage,sy*(33.0/900), tocolor(dxTable.r, dxTable.g, dxTable.b, 179), false)
		exports.VGdrawing:dxDrawBorderedText(tostring( dxTable.text ).." " ..( dxTable.percentage ).."%", sx*(542.0/1440),sy*(821.0/900),sx*(1010.0/1440),sy*(851.0/900), tocolor(dxTable.r2, dxTable.g2, dxTable.b2, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
		if ( dxTable.percentage == 100 ) then if ( dxTable.event ) then triggerEvent( dxTable.event, localPlayer ) end destroyProgressBar( dxTable.hide )  return end
	end
end

-- Pregress bar with progress defined by script
function dxCreateProgressBar ( text, eventName, hideWhenDone, R, G, B, R2, G2, B2 )
	if not ( dxTable.isVisableTwo ) and not ( dxTable.isVisableOne ) then
		dxTable.isVisableTwo  = true
		addEventHandler( "onClientRender", root, drawTimer )
		dxTable.event = eventName or false
		dxTable.text = text or "Loading..."
		dxTable.percentage = 0
		dxTable.r, dxTable.g, dxTable.b = R or 180, G or 0, B or 0
		dxTable.r2, dxTable.g2, dxTable.b2 = R2 or 225, G2 or 225, B2 or 225
		dxTable.hide = hideWhenDone or true
		return true
	else
		return false
	end
end

-- Add or subtract % to the progress bar, the text can also be optionaly changed (if the scripter wants to), if the text isnt changed it will remain  as it was when the prog bar was created
function dxChangeProgressBarProgress ( change, textChanged )
	if ( dxTable.isVisableTwo ) and ( change ) and ( dxTable.percentage < 100 ) then
		dxTable.percentage = math.floor( dxTable.percentage ) + math.floor( tonumber( change ) )
		if ( dxTable.percentage > 100 ) then dxTable.percentage = 100 end
		if ( textChanged ) then dxTable.text = textChanged end
		return true
	else
		return false
	end
end

-- Retreives the current progress of the progress bar
function dxGetProgressBarProgress ()
	if ( dxTable.isVisableTwo ) then
		return dxTable.percentage
	else
		return false
	end
end