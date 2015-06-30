
local table = table



-- Table with the texts in it
local textsToDraw = {}

-- Event to show a message above the head
addEvent( "onClientChatBubble", true )
addEventHandler( "onClientChatBubble", root,
	function ( thePlayer, message, carchat )
		if ( thePlayer ~= localPlayer ) then
			if ( message ) then
				addText( thePlayer, message, carchat or false )
			else
				return
			end
		end
	end
)

-- Function to add a text
function addText(source,message,carchat)
	local notfirst = false
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			v[4] = v[4] + 1
			notfirst = true
		end
	end
	local infotable = {source,message,0,0,carchat}
	table.insert(textsToDraw,infotable)
	if not notfirst then
		setTimer(removeText,10000 + (#message * 50),1,infotable)
	end
end

-- Function to remove a text
function removeText( infotable )
	for i,v in ipairs(textsToDraw) do
		if v[1] == infotable[1] and v[2] == infotable[2] then
			for i2,v2 in ipairs(textsToDraw) do
				if v2[1] == v[1] and v[4] - v2[4] == 1 then
					setTimer(removeText,10000 + (#v2[2] * 50),1,v2)
				end
			end
			table.remove(textsToDraw,i)
			break
		end
	end
end

-- When a player quits remove the messages
addEventHandler( "onClientPlayerQuit", root,
	function ()
		for i,v in ipairs( textsToDraw ) do
			if v[1] == source then
				removeText(v)
			end
		end
	end
)

-- Draw the texts
addEventHandler( "onClientRender", root,
	function ()
		for i,v in ipairs(textsToDraw) do
			if isElement(v[1]) then
				if getElementHealth(v[1]) > 0 then
					local camPosXl, camPosYl, camPosZl = getPedBonePosition (v[1], 6)
					local camPosXr, camPosYr, camPosZr = getPedBonePosition (v[1], 7)
					local x,y,z = (camPosXl + camPosXr) / 2, (camPosYl + camPosYr) / 2, (camPosZl + camPosZr) / 2
					local cx,cy,cz = getCameraMatrix()
					local px,py,pz = getElementPosition(v[1])
					local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
					local posx,posy = getScreenFromWorldPosition(x,y,z+0.020*distance+0.10)
					local elementtoignore1 = getPedOccupiedVehicle(localPlayer) or localPlayer
					local elementtoignore2 = getPedOccupiedVehicle(v[1]) or v[1]
					if posx and distance <= 45 and ( isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true,elementtoignore1) or isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true,elementtoignore2) ) and ( v[4] < 3 ) then -- change this when multiple ignored elements can be specified
						local width = dxGetTextWidth(v[2],1,"default")
						
						dxDrawRectangle(posx - (3 + (0.5 * width)),posy - (2 + (v[4] * 20)),width + 5,19,tocolor(0,0,0,180))
						dxDrawRectangle(posx - (6 + (0.5 * width)),posy - (2 + (v[4] * 20)),width + 11,19,tocolor(0,0,0,0))
						dxDrawRectangle(posx - (8 + (0.5 * width)),posy - (1 + (v[4] * 20)),width + 15,17,tocolor(0,0,0,180))
						dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (1 + (v[4] * 20)),width + 19,17,tocolor(0,0,0,0))
						dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (v[4] * 20) + 1,width + 19,13,tocolor(0,0,0,180))
						dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (v[4] * 20) + 1,width + 23,13,tocolor(0,0,0,0))
						dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (v[4] * 20) + 4,width + 23,7,tocolor(0,0,0,180))
						
						local r,g,b = 255, 255, 255
						if v[5] == true then
							r,g,b = 255, 69, 0
						end
						
						dxDrawText(v[2],posx - (0.5 * width),posy - (v[4] * 20),posx - (0.5 * width),posy - (v[4] * 20),tocolor(r,g,b,255),1,"default","left","top",false,false,false)
					end
				end
			end
		end
	end
)