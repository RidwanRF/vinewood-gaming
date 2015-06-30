
local table = table



-- Function that holds the edit boxes
local edit = {}

-- Function to create a edit box
function createEditBox( x, y, w, h, msk )
	if not ( x ) or not ( y ) or not ( w ) or not ( h ) then
		return false
	else
		local tbl = {}
		tbl.lbl = guiCreateLabel( x+9, y+9, w-18, h+5, "", false )
		tbl.lbt = guiCreateLabel( x+9, y+9, w-18, h+5, "", false )
		tbl.elm = guiCreateEdit( x+2, y, w+1, h+2, "", false )
		guiSetProperty ( tbl.elm, "AlwaysOnTop", "true" )
		guiEditSetMasked( tbl.elm, msk or false )
        guiLabelSetColor( tbl.lbl, 0, 0, 0 )
		addEventHandler( "onClientGUIChanged", tbl.elm, onEditBoxChange )
		guiSetAlpha( tbl.elm, 0.00 )
		guiSetAlpha( tbl.lbt, 0.00 )
		tbl.x = x
		tbl.y = y
		tbl.w = w
		tbl.h = h
		tbl.msk = msk
		tbl.draw = true
		tbl.text = ""
		table.insert( edit, tbl )
		return tbl.elm
	end
end

-- Render the editfield image
addEventHandler( "onClientRender", root,
    function()
		for _, tbl in ipairs( edit ) do
			if ( tbl.draw ) and ( isElement( tbl.elm ) ) and ( guiGetVisible( tbl.elm ) ) then
				dxDrawImage( tbl.x, tbl.y, tbl.w, tbl.h, "images/edit_field.png", 0, 0, 0, tocolor( 255, 255, 255, 255 ), false )
			end
		end
    end
)

-- When the text is being edited
function onEditBoxChange ( )
	local txt = guiGetText( source ) 
	for _, tbl in ipairs( edit ) do
		if ( isElement( tbl.elm ) ) and ( tbl.elm == source ) then
			if ( tbl.msk ) then guiSetText( tbl.lbt, string.rep( "*", string.len( txt ) ) ) else guiSetText( tbl.lbt, txt ) end
			if ( guiLabelGetTextExtent ( tbl.lbt ) >= ( tbl.w - 18 ) - 4 ) then
				tbl.text = txt
				local txt = string.sub(txt, 2)
				guiSetText( tbl.lbl, txt )
			else
				tbl.text = txt
				if ( tbl.msk ) then guiSetText( tbl.lbl, string.rep( "*", string.len( txt ) ) ) else guiSetText( tbl.lbl, txt ) end
			end
		end
	end
end
--[[
function onEditBoxChange ( )
	local txt = guiGetText( source )
	for _, tbl in ipairs( edit ) do
		if ( isElement( tbl.elm ) ) and ( tbl.elm == source ) then
			if ( tbl.msk ) then guiSetText( tbl.lbt, string.rep( "*", string.len( txt ) ) ) else guiSetText( tbl.lbt, txt ) end
			if ( guiLabelGetTextExtent ( tbl.lbt ) >= ( tbl.w - 18 ) - 4 ) then
				guiSetText( source, tbl.text )
			else
				tbl.text = txt
				if ( tbl.msk ) then guiSetText( tbl.lbl, string.rep( "*", string.len( txt ) ) ) else guiSetText( tbl.lbl, txt ) end
			end
		end
	end
end
]]
-- Function to set a editbox visable
function setEditBoxVisible( elmt, state )
	for k, tbl in ipairs( edit ) do
		if ( isElement( tbl.elm ) ) and ( tbl.elm == elmt ) then
			if ( state ) then
				edit[ k ].draw = true
				guiSetAlpha( tbl.lbl, 1.00 )
				guiSetVisible( tbl.lbl, true )
				guiSetVisible( tbl.lbt, true )
				guiSetVisible( tbl.elm, true )
				return true
			else
				edit[ k ].draw = false
				guiSetAlpha( tbl.lbl, 0.00 )
				guiSetVisible( tbl.lbl, false )
				guiSetVisible( tbl.lbt, false )
				guiSetVisible( tbl.elm, false )
				return true
			end
		end
	end
	return false
end