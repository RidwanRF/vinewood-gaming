-- Sum variables
local tickCount = nil
isInventoryShowing = false
selectedItem = false

-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Function that draws the inventory UI
function drawInventoryWindow ()
	-- Reset selected item
	selectedItem = false
	
	-- Draw the text and line
	dxDrawRectangle(sx*(326.0/1440),sy*(236.0/900),sx*(767.0/1440),sy*(3.0/900), tocolor(0, 0, 0, 184), false)
	dxDrawLine(sx*(326.0/1440),sy*(237.0/900),sx*(1092.0/1440),sy*(237.0/900), tocolor(255, 255, 255, 255), sx*(1.0/1440), false)
	dxDrawBorderedText("Your Inventory", sx*(328.0/1440),sy*(176.0/900),sx*(832.0/1440),sy*(234.0/900), tocolor(255, 255, 255, 255), 2.0, "bankgothic", "left", "top", false, false, false, false, false)
	
	-- If the table is empty
	local hasItem = false
	for a, b in pairs( inventoryTable ) do if ( b ) then hasItem = true break; end end
	if not ( hasItem ) then
		dxDrawBorderedText("You have no items!", sx*(328.0/1440),sy*(241.0/900),sx*(832.0/1440),sy*(299.0/900), tocolor(255, 255, 255, 255), 1.0, "bankgothic", "left", "top", false, false, false, false, false)
	else
		dxDrawBorderedText("Double click left to use an item or double click right to drop an item", sx*(328.0/1440),sy*(242.0/900),sx*(494.0/1440),sy*(256.0/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, true, false, false)
	end

	-- Draw the items
	local iter1, iter2, iter3, iter4 = 0, 0, 0, 0
	local iter = 0
	for item, amount in pairs( inventoryTable ) do
		if ( amount ) then
			iter = iter + 1
			if ( iter <= 6 ) then
				iter1 = iter1 +1
				local h1, w1, x1, y1, at = sx*(197.0/1440),sy*(261.0/900),sx*(109.0/1440),sy*(91.0/900), sx*(128.0/1440)
				local h2, w2, x2, y2, it = sx*(410.0/1440),sy*(339.0/900),sx*(308.0/1440),sy*(350.0/900), sx*(126.0/1440)
				if ( isDrawElementSelected ( h1+(iter1*at), w1, h1+(iter1*at)+x1, w1+y1 ) ) then alpha = 200 drawItemInformation( itemTable[ string.lower( item ) ][ 1 ] ) selectedItem = item else alpha = 145 end
				dxDrawRectangle(h1+(iter1*at), w1, x1, y1, tocolor(0, 0, 0, alpha), false)
				dxDrawBorderedRectangle( h1+(iter1*at), w1, x1, y1, tocolor(0, 0, 0, 255), false )
				dxDrawImage (h1+(iter1*at), w1, x1, y1, itemTable[ string.lower( item ) ][ 2 ] )
				dxDrawBorderedText("x"..amount, h2, w2, x2+(iter1*it)+(iter1*1.6), y2, tocolor(255, 255, 255, 255), 1.0, "default-bold", "right", "top", false, false, false, false, false)
			elseif ( iter > 6 ) and ( iter <= 12 ) then
				iter2 = iter2 +1
				local h1, w1, x1, y1, at = sx*(197.0/1440),sy*(371.0/900),sx*(109.0/1440),sy*(91.0/900), sx*(128.0/1440)
				local h2, w2, x2, y2, it = sx*(410.0/1440),sy*(449.0/900),sx*(308.0/1440),sy*(350.0/900), sx*(126.0/1440)
				if ( isDrawElementSelected ( h1+(iter2*at), w1, h1+(iter2*at)+x1, w1+y1 ) ) then alpha = 200 drawItemInformation( itemTable[ string.lower( item ) ][ 1 ] ) selectedItem = item else alpha = 145 end
				dxDrawRectangle(h1+(iter2*at), w1, x1, y1, tocolor(0, 0, 0, alpha), false)
				dxDrawBorderedRectangle( h1+(iter2*at), w1, x1, y1, tocolor(0, 0, 0, 255), false )
				dxDrawImage (h1+(iter2*at), w1, x1, y1, itemTable[ string.lower( item ) ][ 2 ] )
				dxDrawBorderedText("x"..amount, h2, w2, x2+(iter2*it)+(iter2*1.6), y2, tocolor(255, 255, 255, 255), 1.0, "default-bold", "right", "top", false, false, false, false, false)
			elseif ( iter > 12 ) and ( iter <= 18 ) then
				iter3 = iter3 +1
				local h1, w1, x1, y1, at = sx*(197.0/1440),sy*(481.0/900),sx*(109.0/1440),sy*(91.0/900), sx*(128.0/1440)
				local h2, w2, x2, y2, it = sx*(410.0/1440),sy*(559.0/900),sx*(308.0/1440),sy*(350.0/900), sx*(126.0/1440)
				if ( isDrawElementSelected ( h1+(iter3*at), w1, h1+(iter3*at)+x1, w1+y1 ) ) then alpha = 200 drawItemInformation( itemTable[ string.lower( item ) ][ 1 ] ) selectedItem = item else alpha = 145 end
				dxDrawRectangle(h1+(iter3*at), w1, x1, y1, tocolor(0, 0, 0, alpha), false)
				dxDrawBorderedRectangle( h1+(iter3*at), w1, x1, y1, tocolor(0, 0, 0, 255), false )
				dxDrawImage (h1+(iter3*at), w1, x1, y1, itemTable[ string.lower( item ) ][ 2 ] )
				dxDrawBorderedText("x"..amount, h2, w2, x2+(iter3*it)+(iter3*1.6), y2, tocolor(255, 255, 255, 255), 1.0, "default-bold", "right", "top", false, false, false, false, false)
			elseif ( iter > 18 ) and ( iter <= 24 ) then
				iter4 = iter4 +1
				local h1, w1, x1, y1, at = sx*(197.0/1440),sy*(591.0/900),sx*(109.0/1440),sy*(91.0/900), sx*(128.0/1440)
				local h2, w2, x2, y2, it = sx*(410.0/1440),sy*(669.0/900),sx*(308.0/1440),sy*(350.0/900), sx*(126.0/1440)
				if ( isDrawElementSelected ( h1+(iter4*at), w1, h1+(iter4*at)+x1, w1+y1 ) ) then alpha = 200 drawItemInformation( itemTable[ string.lower( item ) ][ 1 ] ) selectedItem = item else alpha = 145 end
				dxDrawRectangle(h1+(iter4*at), w1, x1, y1, tocolor(0, 0, 0, alpha), false)
				dxDrawBorderedRectangle( h1+(iter4*at), w1, x1, y1, tocolor(0, 0, 0, 255), false )
				dxDrawImage (h1+(iter4*at), w1, x1, y1, itemTable[ string.lower( item ) ][ 2 ] )
				dxDrawBorderedText("x"..amount, h2, w2, x2+(iter4*it)+(iter4*1.6), y2, tocolor(255, 255, 255, 255), 1.0, "default-bold", "right", "top", false, false, false, false, false)
			end
		end
	end
end

-- Draw the information text
function drawItemInformation( text )
	dxDrawBorderedText(text, sx*(328.0/1440),sy*(140.0/900),sx*(832.0/1440),sy*(198.0/900), tocolor(255, 255, 255, 255), 0.8, "bankgothic", "left", "top", false, false, true, false, false)
end

-- Check the the draw element is selected
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

-- Function to draw borderd text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, false, false, false, false, false )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, false, false, false, false, false )
end

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end

-- Bind the key
bindKey( "f2", "down",
	function ()
		if ( isInventoryShowing ) then
			showPlayerInventoryWindow( false )
		else
			showPlayerInventoryWindow( true )
		end
	end
)

-- Function that toggles the window
function showPlayerInventoryWindow( state )
	if ( state ) then
		if not ( isInventoryShowing ) then
			exports.VGdrawing:dxStopScreenRendering()
			isInventoryShowing = true
			addEventHandler( "onClientRender", root, drawInventoryWindow )
			showCursor( true ) showChat( false ) showPlayerHudComponent ( "all", false )
			exports.VGblur:setBlurEnabled()
		end
	else
		if ( isInventoryShowing ) then
			isInventoryShowing = false
			removeEventHandler( "onClientRender", root, drawInventoryWindow )
			showCursor( false ) showChat( true ) showPlayerHudComponent ( "all", true )
			exports.VGblur:setBlurDisabled()
		end
	end
end

-- When the person clicks on a item
addEventHandler ( "onClientDoubleClick", root,
	function ( button )
		-- Check for anti spam
		if ( tickCount ) and ( getTickCount()-tickCount <= 5000 ) then return false end
		
		-- Take the item
		if ( isInventoryShowing ) and ( button == "left" ) then
			if ( selectedItem ) and ( inventoryTable[ selectedItem ] ) then
				if ( inventoryTable[ selectedItem ] == 1 ) then
					tickCount = getTickCount()
					triggerEvent( "onClientInventoryItemUse", localPlayer, selectedItem )
					
					-- Check if the event was canceled, if yes then we don't take the item
					if not ( wasEventCancelled() ) then
						triggerServerEvent( "serverInventoryItemUse", localPlayer, selectedItem )
						inventoryTable[ selectedItem ] = nil
					end
				else
					tickCount = getTickCount()
					triggerEvent( "onClientInventoryItemUse", localPlayer, selectedItem )
					
					-- Check if the event was canceled, if yes then we don't take the item
					if not ( wasEventCancelled() ) then
						triggerServerEvent( "serverInventoryItemUse", localPlayer, selectedItem )
						inventoryTable[ selectedItem ] = inventoryTable[ selectedItem ] -1
					end
				end
			end
		elseif ( isInventoryShowing ) and ( button == "right" ) then
			if ( selectedItem ) and ( inventoryTable[ selectedItem ] ) then
				if ( inventoryTable[ selectedItem ] == 1 ) then
					tickCount = getTickCount()
					triggerEvent( "onClientInventoryItemDrop", localPlayer, selectedItem )
					
					-- Check if the event was canceled, if yes then we don't take the item
					if not ( wasEventCancelled() ) then
						triggerServerEvent( "serverInventoryItemDrop", localPlayer, selectedItem )
						inventoryTable[ selectedItem ] = nil
					end
				else
					tickCount = getTickCount()
					triggerEvent( "onClientInventoryItemDrop", localPlayer, selectedItem )
					
					-- Check if the event was canceled, if yes then we don't take the item
					if not ( wasEventCancelled() ) then
						triggerServerEvent( "serverInventoryItemDrop", localPlayer, selectedItem )
						inventoryTable[ selectedItem ] = inventoryTable[ selectedItem ] -1
					end
				end
			end
		end
	end
)