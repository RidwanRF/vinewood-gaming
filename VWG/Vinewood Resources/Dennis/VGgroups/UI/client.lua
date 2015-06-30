-- The group menu buttons
local menu = {
	"General",
	"News",
	"Roster",
	"Bank",
	"Management",
	"Groups",
	"Shop",
}

-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Function to draw the group window
function drawGroupWindow ()
	-- The base window
	dxDrawRectangle(sx*(647/1920), sy*(347/1080), sx*(635/1920), sy*(322/1080), tocolor(0, 0, 0, 149), false)
	dxDrawImage(sx*(604/1920), sy*(299/1080), sx*(132/1920), sy*(123/1080), "images/icon.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText("Groups System", sx*(747/1920), sy*(326/1080), sx*(1126/1920), sy*(362/1080), tocolor(255, 255, 255, 255), 1.30, "bankgothic", "left", "top", false, false, false, false, false)
	dxDrawRectangle(sx*(516/1920), sy*(416/1080), sx*(131/1920), sy*(22/1080), tocolor(0, 0, 0, 188), false)
	for i, button in ipairs ( menu ) do
		local iter = i - 1
		local adem = sy*(24/1080)
		dxDrawRectangle(sx*(516/1920), sy*(439/1080)+(iter*adem), sx*(131/1920), sy*(22/1080), tocolor(0, 0, 0, 188), false)
		dxDrawText(button, sx*(518/1920), sy*(416/1080)+(iter*adem), sx*(645/1920), sy*(437/1080)+(iter*adem), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
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