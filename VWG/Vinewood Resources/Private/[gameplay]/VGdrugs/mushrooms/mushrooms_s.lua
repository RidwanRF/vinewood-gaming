 
 math = math 
 
 local mushroomPos = { 
	{-1446.073, -2043.862, 0.6},
	{-1446.368, -2044.562, 0.5},
	{-1498.615, -2174.431, 0.15},
	{-1500.848, -2172.529, 0.25},
	{-1208.602, -2505.418, 6.436}, 
	{-1207.795, -2516.684, 6.479}, 
	{-1208.15, -2513.369, 5.923},
	{-1208.199, -2512.957, 5.923},
	{-491.022,-1884.868, 5.588},
	{-501.028, -1885.147, 5.597},
	{-520.444, -1905.268, 5.971},
	{-542.767, -1900.501, 5.661}, 
	{-546.968, -1901.486, 6.1},
	{ -551.755, -1881.089, 5.952},
	{-594.617, -1884.821, 5.717}, 
	{-606.629, -1900.267, 5.54},
	{-651.054, -1899.903, 5.674}, 
	{-811.567, -1943.147, 5.505},
	{-818.04, -1952.832, 5.544}, 
	{-756.754, -2059.078, 5.502}, 
	{-750.725, -2062.687, 5.831}, 
	{-742.12, -2062.743, 5.61},
	{928.938, -71.581, 21.103}, 
	{929.483, -71.89, 20.97}, 
	{966.708, -66.816, 26.68},
	{1105.559, -39.133, 23.773},
	{509.164, -290.424, 18.825},
	{504.387, -299.901, 28.251}, 
	{487.168, -283.473, 22.556},
	{463.701, -268.616, 7.86},
 }
 
 local mushroomSpots = { }
 local colShapes = { }
 
 function showMessage ( hitElement, md )
	if ( getElementType ( hitElement ) == "player" ) and ( md ) and not ( isPedInVehicle ( hitElement ) ) then
		triggerClientEvent( "toggleMushroomMessage", hitElement, "on" )
	end
 end
 
 function hideMessage ( hitElement, md )
 	if ( getElementType ( hitElement ) == "player" ) and ( md ) then
		triggerClientEvent( "toggleMushroomMessage", hitElement, "off" )
	end
 end
 
 addEvent("onPlayerPickMushroom", true )
 function pickMushroom ()
	for i=1, #colShapes do
		if ( colShapes[i] ) then
			if ( isElementWithinColShape ( client, colShapes[i] ) ) then
				exports.VGinventory:givePlayerItem ( client, "Mushroom", math.random ( 1, 4 ) )
				local mushroom = mushroomSpots[i]
				if ( isElement ( mushroom ) ) then 
					destroyElement ( mushroom ) 
					destroyElement ( colShapes[i] ) 
					colShapes[i] = false
					mushroomSpots[i] = false
				end
			end
		end
	end
 end
 addEventHandler ( "onPlayerPickMushroom", root, pickMushroom )
 
 
 
 for i=1, #mushroomPos do
	mushroomSpots[i] = false
	colShapes[i] = false
 end
 
 function checkMushrooms ()
	for i = 1, #mushroomSpots do
		local chance = math.random(0, 30)
		if ( chance == 1 ) and not ( mushroomSpots[i] ) then
			local mushroom = createObject ( 1942,  mushroomPos[i][1], mushroomPos[i][2], mushroomPos[i][3] )
			setObjectScale ( mushroom, 0.05 )
			local colShape = createColSphere ( mushroomPos[i][1], mushroomPos[i][2], mushroomPos[i][3], 3 )
			addEventHandler ( "onColShapeHit", colShape, showMessage )
			addEventHandler ( "onColShapeLeave", colShape, hideMessage )
			colShapes[i] = colShape
			mushroomSpots[i] = mushroom
		end
	end
 end
 setTimer(checkMushrooms, 60000, 0)