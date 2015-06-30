-- List with the hospitals
local hospitalTable = {
	{ "Los Santos All Saints hospital", 1179.1, -1324.4, 14.15, 270.12222290039, 1215.4975585938, -1343.1850585938, 35.528800964355, 1214.7266845703, -1342.7204589844, 35.093036651611, 0, 70 },
	{ "Los Santos Country Central hospital", 2030.31, -1406.77, 17.2, 178.76403808594, 2012.4608154297, -1440.1544189453, 33.239101409912, 2012.8569335938, -1439.3461914063, 32.803337097168, 0, 70 },
	{ "Los Santos Crippen Memorial hospital", 1245.22, 334.22, 19.55, 335.55230712891, 1275.6314697266, 348.43908691406, 37.013999938965, 1274.9337158203, 347.95013427734, 36.490543365479, 0, 7 },
	{ "Las Venturas Fort Carson hospital", -319.24, 1057.76, 19.74, 343.53948974609, -307.31741333008, 1085.3322753906, 37.267700195313, -307.63153076172, 1084.5151367188, 36.784400939941, 0, 70 },
	{ "Las Venturas General hospital", 1607.87, 1823, 10.82, 1.5188903808594, 1631.53125, 1867.3415527344, 25.293199539185, 1631.1346435547, 1866.4654541016, 25.018928527832, 0, 70 },
	{ "Las Venturas El Quebrados hospital", -1514.85, 2528.23, 55.72, 358.66787719727, -1499.2265625, 2558.5263671875, 66.142501831055, -1499.6668701172, 2557.7001953125, 65.791000366211, 0, 70 },
	{ "San Fierro General hospital", -2647.62, 631.2, 14.45, 176.91278076172, -2627.0493164063, 582.10327148438, 28.898700714111, -2627.5827636719, 582.89117431641, 28.591079711914, 0, 70 },
	{ "San Fierro Angel pine hospital", -2199.24, -2310.78, 30.62, 319.53399658203, -2178.7451171875, -2288.4621582031, 41.820098876953, -2179.4353027344, -2289.0139160156, 41.352130889893, 0, 70 }
}

-- Get the screen size
local sw, sy = guiGetScreenSize()

-- Event triggerd when the player dies
addEventHandler ( "onClientPlayerWasted", localPlayer, 
	function ()
		if not ( getElementHealth( localPlayer ) > 0 ) then
			-- Toggle the shader and give it a nice effect
			addEventHandler( "onClientRender", root, drawWastedSign )
			toggleBlackWhiteShader ()
			setGameSpeed( 0.2 )
			showPlayerHudComponent ( "radar", false )
			
			-- Couple of timers
			setTimer( showPlayerHudComponent, 13000, 1, "radar", true )
			setTimer( toggleBlackWhiteShader, 13000, 1 )
			setTimer( function() removeEventHandler( "onClientRender", root, drawWastedSign ) end, 13000, 1 )
			setTimer( setGameSpeed, 13000, 1, 1 )
			
			-- Sound on dead
			local sound = playSound( "wasted.mp3" )
			setSoundVolume( sound, 0.2 )
			
			-- Find the hospital
			local hospitalDist = false
			local nearestHospital = false
			for i=1,#hospitalTable do
				if not ( getElementData ( localPlayer, "isPlayerInInterior" ) ) then
					px, py, pz = getElementPosition( localPlayer )
				else
					px, py, pz = getElementData ( localPlayer, "playerPositionOnWorldX" ), getElementData ( localPlayer, "playerPositionOnWorldY" ), getElementData ( localPlayer, "playerPositionOnWorldZ" )
				end
				local hx, hy, hz = hospitalTable[i][2], hospitalTable[i][3], hospitalTable[i][4]
				local distance = getDistanceBetweenPoints3D ( px, py, pz, hx, hy, hz )
				if not ( hospitalDist ) or ( distance < hospitalDist ) then
					hospitalDist = distance
					nearestHospital = i
				end
			end
			
			-- If we've got the hospital spawn him there
			if ( nearestHospital ) then
				local ID = nearestHospital
				local hx, hy, hz, rotation, hospitalName = hospitalTable[ID][2], hospitalTable[ID][3], hospitalTable[ID][4], hospitalTable[ID][5], hospitalTable[ID][1]
				local mx, my, mz, lx, ly, lz = hospitalTable[ID][6], hospitalTable[ID][7], hospitalTable[ID][8], hospitalTable[ID][9], hospitalTable[ID][10], hospitalTable[ID][11]
				setTimer( function () triggerServerEvent( "onServerRespawnPlayer", localPlayer, hx, hy, hz, rotation, mx, my, mz, lx, ly, lz, hospitalName ) end, 7000, 1 )
			end
		end
	end
)

-- Draw the wasted text
function drawWastedSign ( )
	exports.VGdrawing:dxDrawBorderedText("WASTED!", 0, 0, sw, sy, tocolor(103, 0, 0, 255), 3.00, "pricedown", "center", "center", false, false, false, false, false)
end