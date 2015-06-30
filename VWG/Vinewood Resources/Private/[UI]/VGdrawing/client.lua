-- Function that hides ALL other custom GUI's
function dxStopScreenRendering ()
	exports.VGinventory:showPlayerInventoryWindow( false )
	exports.VGvehicles:showPlayerVehicleWindow( false )
	exports.VGvip:showPlayerDonatorsWindow( false )
	exports.VGpolicecomputer:showPoliceComputer( false )
	exports.VGfoodstores:setStoreWindowVisable( false )
	return true
end

-- Function that draws a 3D image in the GTA world
function dxDrawImage3D( x, y, z, w, h, m, c, r, ... )
    local lx, ly, lz = x + w, y + h, ( z+ tonumber( r or 0 ) ) or z
	return dxDrawMaterialLine3D( x, y, z, lx, ly, lz, m, h, c or tocolor( 255,255,255,255 ), ... )
end

-- Draw bordered text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor, clip, wordBreak, postGUI )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	return true
end

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end