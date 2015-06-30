loadstring( exports.VGshortcuts:load( 'dx' ) )()

screenW, screenH = guiGetScreenSize()

EditBox = {}

function createEditBox( x, y, width, height, text, masked )
	table.insert( EditBox, { caret = 0, x = x, y = y, width = width, height = height, text = text, masked = masked, visible = true, selected = false } )
	return #EditBox
end

function render( )
	for i, k in ipairs( EditBox ) do
		if ( k.visible ) then
			k.pointedAt = false

			if ( isDrawElementSelected( k.x, k.y, k.width, k.height ) ) then
				k.pointedAt = true
			end

			local text = k.text
			if ( k.masked ) then text = string.rep( "*", #text ) end

			dxDrawImage( k.x, k.y, k.width, k.height, "images/edit_field.png", 0, 0, 0, tocolor( 255, 255, 255, 255 ), false )
			dxDrawText( text, k.x + 4, k.y, k.x + k.width - 4, k.y + k.height, tocolor ( 0, 0, 0, 255 ), 1, "default", "left", "center", true, false, false )

			local textWidthBeforeCaret = dxGetTextWidth( k.text:sub( 1, k.caret ) )
			dxDrawLine( k.x + 4 + textWidthBeforeCaret, k.y + 2, k.x + 4 + textWidthBeforeCaret, k.y + 24, tocolor( 0, 0, 0 ), 2, true )
		end
	end
end

addEventHandler( "onClientClick", root,
	function ( button, state )
		if ( button == "left" ) and ( state == "down" ) then
			for i, k in ipairs( EditBox ) do
				if ( k.pointedAt ) then
					EditBox[i].selected = true
				end
			end
		end
	end
)

addEventHandler( "onClientKey", root,
	function ( button, state )
		if ( button == "arrow_l" ) and not ( state ) then
			for i, k in ipairs( EditBox ) do
				if ( k.selected ) then
					EditBox[i].caret = ( EditBox[i].caret == 0 ) and 0 or EditBox[i].caret - 1
				end
			end
		elseif ( button == "arrow_r" ) and not ( state ) then
			for i, k in ipairs( EditBox ) do
				if ( k.selected ) then
					EditBox[i].caret = ( EditBox[i].caret == 100 ) and 0 or EditBox[i].caret + 1
				end
			end
		end
	end
)

addEventHandler( "onClientRender", root, render )
createEditBox( 676, 390, 248, 27, "Test" )