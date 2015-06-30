


-- Check if the draw element is selected
--[[function createButton ( x, y, width, height, text, font)
	if (isDrawElementSelected ( sx*(513/1440), sy*(670/900), sx*(134/1440)+sx*(513/1440), sy*(28/900)+sy*(670/900) ) ) then a = 100 else a = 143 end -- Hover effect
	dxDrawRectangle(sx*(x/1440), sy*(y/900), sx*(width/1440), sy*(height/900), tocolor(0, 0, 0, 143))
	dxDrawRectangle(sx*(x+3/1440), sy*(y+3/900), sx*(width-6/1440), sy*(height-6/900), tocolor(217, 162, 29, a))
	dxDrawBorderedText(text, sx*(x/1440), sy*(y/900), sx*(width/1440), sy*(height/900), tocolor(255, 255, 255, 255), 1.0, font, "center", "center" )
end]] --nvm this, I just noticed you want to do it with gui elements masked :) 