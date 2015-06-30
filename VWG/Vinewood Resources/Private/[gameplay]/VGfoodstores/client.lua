-- Get the screen size
local sx, sy = guiGetScreenSize()

-- Some Variables
local storename
local storetype
local isFoodStoreShowing = false
local selectedItem = false

-- Products
local products = {
	{
		{ "burger", 6, "burger.png", 5 },
		{ "salad", 5, "salad.png", 6 },
		{ "coke", 2, "coke.png", 3 },
		{ "icecream", 4, "ice.png", 6 },
	},
	{
		{ "chicken", 6, "chicken.png", 6 },
		{ "salad", 5, "salad.png", 6 },
		{ "coke", 2, "coke.png", 3 },
		{ "icecream", 4, "ice.png", 6 },
	},
	{
		{ "pizza", 6, "pizza.png", 5 },
		{ "salad", 5, "salad.png", 6 },
		{ "coke", 2, "coke.png", 3 },
		{ "icecream", 4, "ice.png", 6 },
	},
	{
		{ "donut1", 6, "donut1.png", 6 },
		{ "donut2", 6, "donut2.png", 6 },
		{ "pie", 2, "pie.png", 3 },
		{ "coke", 4, "coke.png", 3 },
	},
}

-- Table with the positions
local positions = exports.VGtables:getTable('foodstores')

-- Table that holds the markers
local markers = {}

-- When the player hits the food marker
function onFoodMarkerHit( hitElement, matchingDimension )
	if ( hitElement == localPlayer ) and ( matchingDimension ) then
		if ( markers[ source ] == "Burger" ) then
			setStoreWindowVisable ( "Burger Shot" )
		elseif ( markers[ source ] == "Chicken" ) then
			setStoreWindowVisable ( "Cluckin' Bell" )
		elseif ( markers[ source ] == "Pizza" ) then
			setStoreWindowVisable ( "Well Stacked Pizza" )
		elseif ( markers[ source ] == "Donut" ) then
			setStoreWindowVisable ( "Jim's Sticky Rings" )
		end
	end
end

-- Create the markers
for _, tbl in ipairs ( positions ) do
	local theMarker = createMarker( tbl.x, tbl.y, tbl.Z -1, "cylinder", 1.0, 225, 0, 0 )
	local thePed = exports.VGpeds:createStaticPed ( tbl.model, tbl.px, tbl.py, tbl.pz, tbl.pr )
	if ( thePed ) and ( theMarker ) then
		setElementDimension( theMarker, tbl.dim )
		setElementDimension( thePed, tbl.dim )
		setElementInterior( theMarker, tbl.int )
		setElementInterior( thePed, tbl.int )
		markers[ theMarker ] = tbl.tp
		addEventHandler( "onClientMarkerHit", theMarker, onFoodMarkerHit )
	end
end

-- Function that draw the store window
function drawStoreWindow ()
	if ( storetype ) then
		selectedItem = false
	
		-- Rectangle
		dxDrawRectangle(sx*(514.0/1440),sy*(315.0/900),sx*(563.0/1440),sy*(152.0/900), tocolor(0, 0, 0, 117), false)
		dxDrawBorderedRectangle(sx*(514.0/1440),sy*(315.0/900),sx*(563.0/1440),sy*(152.0/900), tocolor(0, 0, 0, 255), false)
		
		-- Loop thru the products
		local iter = 0
		for _, tbl in ipairs( storetype ) do
			iter = iter + 1
			local x1, y1, w1, h1, z1 = sx*(386.0/1440),sy*(342.0/900),sx*(119.0/1440),sy*(109.0/900),sx*(140.0/1440)
			local x2, y2, w2, h2, z2 = sx*(386.0/1440),sy*(342.0/900),sx*(119.0/1440),sy*(109.0/900),sx*(140.0/1440)
			local x3, y3, w3, h3, z3 = sx*(469.0/1440),sy*(435.0/900),sx*(505.0/1440),sy*(451.0/900),sx*(139.0/1440)
			if ( isDrawElementSelected ( x1+(iter*z1), y1, x1+(iter*z1)+w1, y1+h1 ) ) then alpha = 220 selectedItem = tbl else alpha = 176 end
			dxDrawRectangle(x1+(iter*z1), y1, w1, h1, tocolor(0, 0, 0, alpha), false)
			dxDrawBorderedRectangle(x1+(iter*z1), y1, w1, h1, tocolor(0, 0, 0, 255), false)
			dxDrawImage(x2+(iter*z2), y2, w2, h2, ":VGinventory/images/"..tbl[3], 0, 0, 0, tocolor(255, 255, 255, 255), false)
			exports.VGdrawing:dxDrawBorderedText("$"..tostring(tbl[2]), x3+(iter*z3), y3, w3+(iter*z3), h3, tocolor(23, 128, 4, 255), 1.00, "default-bold", "right", "top", false, false, false, false, false)
		end
		
		-- Store name and the background
		exports.VGdrawing:dxDrawBorderedText(storename or "Unknown Store", sx*(492.0/1440),sy*(282.0/900),sx*(1076.0/1440),sy*(338.0/900), tocolor(255, 255, 255, 255), sx*(2.0/1440), "bankgothic", "left", "top", false, false, false, false, false)
		
		-- Leave button
		if ( isDrawElementSelected ( sx*(969.0/1440), sy*(467.0/900), sx*(969.0/1440)+sx*(108.0/1440), sy*(467.0/900)+sy*(18.0/900) ) ) then alpha = 220 selectedItem = "Close" else alpha = 176 end
		dxDrawRectangle(sx*(969.0/1440),sy*(467.0/900),sx*(108.0/1440),sy*(18.0/900), tocolor(0, 0, 0, alpha), false)
        dxDrawBorderedRectangle(sx*(969.0/1440),sy*(467.0/900),sx*(108.0/1440),sy*(18.0/900), tocolor(0, 0, 0, 255), false)
		exports.VGdrawing:dxDrawBorderedText("Leave Store", sx*(971.0/1440),sy*(468.0/900),sx*(1075.0/1440),sy*(483.0/900), tocolor(255, 255, 255, 255), 1.0, "sans", "center", "center", false, false, false, false, false)
	end
end

-- Function to open the store window
function setStoreWindowVisable ( type )
	-- Function toggles the store
	local function show ( type )
		storename = type
		isFoodStoreShowing = true
		addEventHandler( "onClientRender", root, drawStoreWindow )
		showCursor( true )
	end
	-- Check if we have the correct store
	if ( type == "Burger Shot" ) and not ( isFoodStoreShowing ) then
		show ( type )
		storetype = products[1]
	elseif ( type == "Jim's Sticky Rings" ) and not ( isFoodStoreShowing ) then
		show ( type )
		storetype = products[4]
	elseif ( type == "Well Stacked Pizza" ) and not ( isFoodStoreShowing ) then
		show ( type )
		storetype = products[3]
	elseif ( type == "Cluckin' Bell" ) and not ( isFoodStoreShowing ) then
		show ( type )
		storetype = products[2]
		return true
	elseif not ( type ) then
		isFoodStoreShowing = false
		removeEventHandler( "onClientRender", root, drawStoreWindow )
		showCursor( false )
	else
		return false
	end
end

-- Check the the draw element is selected
function isDrawElementSelected ( minX, minY, maxX, maxY )
	if not ( isCursorShowing() ) then return end
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

-- When the person clicks on a item
addEventHandler ( "onClientClick", root,
	function ( button, state )
		-- Take the item
		if ( isFoodStoreShowing ) and ( button == "left" ) and ( state == "up" ) then
			if ( selectedItem ) then
				if ( selectedItem == "Close" ) then
					isFoodStoreShowing = false
					removeEventHandler( "onClientRender", root, drawStoreWindow )
					showCursor( false )
				elseif ( type( selectedItem ) == "table" ) then
					triggerServerEvent( "onServerPlayerBoughtFood", localPlayer, selectedItem[1] )
				end
			end
		end
	end
)

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end