-- Table with data
local data = {}
local sx, sy = guiGetScreenSize()

-- Draws the information windows of houses
function drawHouseInformation ()
	if ( data.draw ) and ( data.isDrawing ) then
		dxDrawRectangle(sx*(489/1440), sy*(186/900), sx*(452/1440), sy*(208/900), tocolor(0, 0, 0, 135))
		exports.VGdrawing:dxDrawBorderedRectangle(sx*(489/1440), sy*(186/900), sx*(452/1440), sy*(208/900), tocolor(0, 0, 0, 255), false)
		exports.VGdrawing:dxDrawBorderedText("Information window:", sx*(600/1440), sy*(210/900), sx*(840/1440), sy*(200/900), tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "top")	
		dxDrawRectangle(sx*(500/1440), sy*(230/900), sx*(431/1440), sy*(130/900), tocolor(0, 0, 0, 255))
		dxDrawRectangle(sx*(505/1440), sy*(235/900), sx*(421/1440), sy*(120/900), tocolor(255, 255, 255, 200))
		dxDrawText(data.draw, sx*(508/1440), sy*(245/900), sx*(923/1440), sy*(612/900), tocolor(0,0,0,255), 1.0, "default-bold", "center", "top", true, true)
	end
end

-- Event when the player hits or leaves the pickups of the house
addEvent( "toggleHouseInformationWindow", true )
addEventHandler( "toggleHouseInformationWindow", root,
	function ( state, aTable )
		if ( state ) and ( aTable ) and not ( data.isDrawing ) then
			local houseid = aTable.houseid
			local price = aTable.houseprice
			local interior = aTable.interior
			local housemapper = aTable.housemapper
			data.draw = "House ID: " .. houseid .. "\n\nHouse Price: $" .. exports.VGutils:convertNumber( price ) .. "\nHouse Interior: " .. interior .. "\nInterior name: " .. houseNames[ interior ][ 1 ] .. "\nHouse Mapper: " .. housemapper .. "\n"
			data.isDrawing = true
			addEventHandler( "onClientRender", root, drawHouseInformation )
		else
			removeEventHandler( "onClientRender", root, drawHouseInformation )
			data.isDrawing = false
		end
	end
)