local sx, sy = guiGetScreenSize()

local preR, preG, preB = 255, 0, 0

function drawColorpicker ()
	dxDrawRectangle(startX, startY, sx*(462/1440), sy*(284/900), tocolor(0, 0, 0, 135))
	dxDrawBorderedRectangle(startX, startY, sx*(462/1440), sy*(284/900), tocolor(0, 0, 0, 255), false)

	dxDrawImage(startX+sx*(8/1440), startY+sy*(8/900), sx*(32/1440), sy*(256/900), "images/blank.png")
	dxDrawImage(startX+sx*(8/1440), startY+sy*(8/900), sx*(32/1440), sy*(256/900), "images/rgbPallete.png") --RGB Pallete
	dxDrawImageSection(startX+sx*(-3/1440),startY+sy*(8/900)+rgbMarkerPosition-10, 48, 16, 16, 0, 48, 16, "images/markers.png")
	
	dxDrawImage(startX+sx*(58/1440), startY+sy*(8/900), sx*(256/1440), sy*(256/900), "images/blank.png") 
	dxDrawImage(startX+sx*(58/1440), startY+sy*(8/900), sx*(256/1440), sy*(256/900), "images/hsvPallete.png", 0, 0, 0, tocolor(preR, preG, preB)) --HSV Pallete
	dxDrawImageSection(startX+sx*(58/1440)+hsvMarkerX, startY+sy*(8/900)+hsvMarkerY, 16, 16, 3, 3, 13, 13, "images/markers.png")

	local h, s, v = getSelectedHSV ()
	R, B, G = HSVtoRGB(h, s, v)
	
	if ( oldR ~= R ) or ( oldG ~= G ) or ( oldB ~= B ) then
		triggerEvent("onColorPickerPreChange", localPlayer, R, G, B)
	end
	oldR, oldG, oldG = R, G, B
	getSelectedRGB ()
	
	dxDrawBorderedText("R: "..R.."\nG: "..G.."\nB: "..B.."\nFinal Color:", startX+sx*(328/1440), startY+sy*(8/900), 40, 60, tocolor(255, 255, 255), sx*(2/1440), "default", "left", "top" )
	dxDrawRectangle(startX+sx*(328/1440), startY+sy*(113/900), sx*(125/1440), sy*(50/900), tocolor(R, G, B))

	if (isDrawElementSelected ( startX+sx*(328/1440), startY+sy*(183/900), sx*(124/1440)+(startX+sx*(328/1440)), sy*(28/900)+(startY+sy*(183/900) ) ) ) then a =100 else a = 143 end 
	dxDrawRectangle(startX+sx*(325/1440), startY+sy*(180/900), sx*(130/1440), sy*(34/900), tocolor(0, 0, 0, 143))
	dxDrawRectangle(startX+sx*(328/1440), startY+sy*(183/900), sx*(124/1440), sy*(28/900), tocolor(217, 162, 29, a))
	dxDrawBorderedText("Ok", startX+sx*(328/1440), startY+sy*(183/900), startX+sx*(328/1440)+(sx*(124/1440)), startY+sy*(183/900)+(sy*(28/900)), tocolor(255, 255, 255, 255), sx*(1.00/1152), "default-bold", "center", "center" )
	
	if (isDrawElementSelected ( startX+sx*(328/1440), startY+sy*(223/900), sx*(124/1440)+(startX+sx*(328/1440)), sy*(28/900)+(startY+sy*(223/900) ) ) ) then a =100 else a = 143 end 
	dxDrawRectangle(startX+sx*(325/1440), startY+sy*(220/900), sx*(130/1440), sy*(34/900), tocolor(0, 0, 0, 143))
	dxDrawRectangle(startX+sx*(328/1440), startY+sy*(223/900), sx*(124/1440), sy*(28/900), tocolor(217, 162, 29, a))
	dxDrawBorderedText("Close Window", startX+sx*(328/1440), startY+sy*(223/900), startX+sx*(328/1440)+(sx*(124/1440)), startY+sy*(223/900)+(sy*(28/900)), tocolor(255, 255, 255, 255), sx*(1.00/1152), "default-bold", "center", "center" )

end

function openColorpicker(x, y, startR, startG, startB)
	if not ( startB ) then startR = 255 startG = 0 startB = 0 end
	startX, startY = x, y
	local startH, startS, startV = RGBtoHSV(startR, startG, startB)
	setInitialPositions(startH, startS, startV)
	addEventHandler("onClientRender", root, drawColorpicker)
	showCursor(true)
	addEventHandler("onClientClick", root, rgbPalleteClickHandler)
	addEventHandler("onClientClick", root, hsvPalleteClickHandler)
	addEventHandler("onClientClick", root, clickHandler)
	return true
end	

function setColorpickerColor(R, G, B)
	startH, startS, startV = RGBtoHSV(R, G, B)
	setInitialPositions(startH, startS, startV)
end

function closeColorpicker ()
		removeEventHandler("onClientRender", root, drawColorpicker)
		removeEventHandler("onClientClick", root, rgbPalleteClickHandler)
		removeEventHandler("onClientClick", root, hsvPalleteClickHandler)
		removeEventHandler("onClientClick", root, clickHandler)
		showCursor(false)
		isShowing = false
		return true
end

--Handle the clicks on the buttons
function clickHandler(btn, state)
	if ( btn == "left" ) and ( state == "down" ) then
		if (isDrawElementSelected ( startX+sx*(328/1440), startY+sy*(183/900), sx*(124/1440)+(startX+sx*(328/1440)), sy*(28/900)+(startY+sy*(183/900) ) ) ) then triggerEvent("onColorPickerChange", localPlayer, R, G, B) end -- OK button
		if (isDrawElementSelected ( startX+sx*(328/1440), startY+sy*(223/900), sx*(124/1440)+(startX+sx*(328/1440)), sy*(28/900)+(startY+sy*(223/900) ) ) ) then closeColorpicker() triggerEvent("onColorPickerClosedByPlayer", localPlayer, localPlayer) end -- Close window button
	end
end

function setInitialPositions (H, S, V)
	-- Determining rgbMarkerPosition
	rgbMarkerPosition = H*(sy*(256/900))/360

	-- Determining hsvMarkerX
	hsvMarkerX = - (S - 1) * (sx*(246/1440))
	-- Determining hsvMarkerY
	hsvMarkerY = -(V - 1) * (sy*(246/900))
end
------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------RGB---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--Function to handle the clicks on the RGB Pallete
function rgbPalleteClickHandler (btn, state, clickX, clickY)
	if ( isDrawElementSelected ( startX+sx*(8/1440), startY+sy*(8/900), startX+sx*(8/1440)+sx*(32/1440), startY+sy*(8/900)+sy*(256/900) ) ) and ( btn == "left" ) and ( state == "down" ) then
		rgbMarkerPosition = clickY-( startY+sy*(8/900) )		
		addEventHandler ( "onClientCursorMove", root, rgbPalleteMouseMoveHandler)
	elseif (btn == "left") and (state == "up") then
		removeEventHandler ( "onClientCursorMove", root, rgbPalleteMouseMoveHandler)
	end
end

-- Function that handles mouse moves on the RGB pallete
function rgbPalleteMouseMoveHandler (relativeX, relativeY, x, y)
	local tempY = y-( startY+sy*(8/900) )
	if ( tempY < 0 ) then
		rgbMarkerPosition = 0
	elseif ( tempY > (sy*(256/900)) ) then
		rgbMarkerPosition = (sy*(256/900))
	else
		rgbMarkerPosition = tempY
	end
end

--Get the color selected on the RGB pallete 
function getSelectedRGB ()
	if ( rgbMarkerPosition < sy*(43/900) ) then
		preR, preG, preB = 255, 0, math.floor( (255/(sy*(43/900)) ) * rgbMarkerPosition )-- + B
	elseif ( rgbMarkerPosition < sy*(86/900) ) then
		preR, preG, preB = math.floor( (255/(sy*(43/900))) * ((sy*(43/900))-(rgbMarkerPosition-(sy*(43/900)))) ), 0, 255 -- - R
	elseif ( rgbMarkerPosition < sy*(128/900) ) then
		preR, preG, preB = 0, math.floor( (255/(sy*(43/900))) * (rgbMarkerPosition-(sy*(86/900))) ), 255 -- + G
	elseif ( rgbMarkerPosition < sy*(171/900) ) then
		preR, preG, preB = 0, 255, math.floor( (255/(sy*(43/900))) * ((sy*(43/900))-(rgbMarkerPosition-(sy*(128/900)))) ) -- - B
	elseif ( rgbMarkerPosition < sy*(214/900) ) then
		preR, preG, preB = math.floor( (255/(sy*(43/900))) * (rgbMarkerPosition-(sy*(171/900))) ), 255, 0 -- + R
	elseif ( rgbMarkerPosition < sy*(256/900) ) then
		preR, preG, preB = 255, math.floor( (255/(sy*(43/900))) * ((sy*(43/900))-(rgbMarkerPosition-(sy*(214/900)))) ), 0 -- - G
	elseif ( rgbMarkerPosition == sy*(256/900) ) then
		preR, preG, preB = 255, 0, 0
	end
end


------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------HSV---------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--Function to handle the clicks on the hsv Pallete
function hsvPalleteClickHandler (btn, state, clickX, clickY)
	if ( isDrawElementSelected ( startX+sx*(58/1440), startY+sy*(8/900), startX+sx*(58/1440)+sx*(256/1440), startY+sy*(8/900)+sy*(256/900) ) ) and ( btn == "left" ) and ( state == "down" ) then
		hsvMarkerX, hsvMarkerY = clickX-( startX+sx*(58/1440) )-4, clickY-( startY+sy*(8/900) )-4
		addEventHandler ( "onClientCursorMove", root, hsvPalleteMouseMoveHandler)
	elseif (btn == "left") and (state == "up") then
		removeEventHandler ( "onClientCursorMove", root, hsvPalleteMouseMoveHandler)
	end
end

-- Function that handles mouse moves on the HSV pallete
function hsvPalleteMouseMoveHandler (relativeX, relativeY, x, y)
	local tempX, tempY = x-(startX+sx*(58/1440) ), y-( startY+sy*(8/900) )
	if ( tempY < 0 ) then
		hsvMarkerY = 0
	elseif ( tempY > (sy*(246/900)) ) then
		hsvMarkerY = (sy*(246/900))
	elseif ( tempX < 0 ) then
		hsvMarkerX = 0
	elseif ( tempX > (sx*(246/1440)) ) then
		hsvMarkerX = (sx*(246/1440))
	else
		hsvMarkerX, hsvMarkerY = tempX, tempY
	end
end

--Get the selected color in HSV format
function getSelectedHSV ()
	--Determining H
	local H = math.floor( (rgbMarkerPosition*360)/(sy*(256/900)) )
	
	--Determining S
	local S = 1-( (hsvMarkerX)/(sx*(246/1440)) )
	
	--Determining V
	local V = 1-( (hsvMarkerY)/(sy*(246/900)) )
	
	return H, S, V
end

--Function that converts the HSV color code to RGB colorcode that can be used by MTA
function HSVtoRGB(h, s, v)
	local r, g, b
	local i = math.floor(h/60)
	local f = (h/60) - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	local switch = i % 6
	if switch == 0 then
		r = v g = t b = p
	elseif switch == 1 then
		r = q g = v b = p
	elseif switch == 2 then
		r = p g = v b = t
	elseif switch == 3 then
		r = p g = q b = v
	elseif switch == 4 then
		r = t g = p b = v
	elseif switch == 5 then
		r = v g = p b = q
	  end
	  return math.floor(r*255), math.floor(g*255), math.floor(b*255) --I cant figure out why but the green is comming out as the blue and the blue as the green.
end

--Function that converts the RGB color code to HSV colorcode
function RGBtoHSV(r, g, b)
  r, g, b = r/255, g/255, b/255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s 
  local v = max
  local d = max - min
  s = max == 0 and 0 or d/max
  if max == min then 
    h = 0
  elseif max == r then 
    h = (g - b) / d + (g < b and 6 or 0)
  elseif max == g then 
    h = (b - r) / d + 2
  elseif max == b then 
    h = (r - g) / d + 4
  end
  h = h/6
  return h, s, v
end


------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------Utility functions----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
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

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end