 
local tonumber = tonumber


function onMarkerHit (player, md)
	if not ( isElement ( player ) ) or ( getElementType ( player ) ~= "player" ) then return end
	if ( player ~= localPlayer ) then return end
	if ( not md ) or ( isPedInVehicle ( player ) ) or ( doesPedHaveJetPack ( player ) ) or ( not isPedOnGround ( player ) ) or ( getControlState ( "aim_weapon" ) ) or ( blockPlayer ) then return end

	if not ( getElementData( localPlayer, "isPlayerInInterior" ) ) then
		local x, y, z, int, dim, intName  = getElementData( source, "x" ), getElementData( source, "y" ), getElementData( source, "z" ), getElementData( source, "int" ), getElementData( source, "dim" ), getElementData(source, "intName")
		local wx, wy, wz = getElementPosition ( source )
		
		toggleAllControls ( false, true, false )
		fadeCamera ( false, 1.0 )
		setTimer ( setPlayerInsideInterior, 1000, 1, localPlayer,  int, dim, x, y, z, wx, wy, wz , intName)
		blockPlayer = true
		setTimer ( function() blockPlayer = nil end, 3500, 1 )
		
		
		
	else
		local x, y, z, rot = getElementData( source, "x" ), getElementData( source, "y" ), getElementData( source, "z" ), getElementData( source, "rot" )
		
		toggleAllControls ( false, true, false )
		fadeCamera ( false, 1.0 )
		setTimer ( setPlayerOutsideInterior, 1000, 1,localPlayer, rot, x, y, z )
		blockPlayer = true
		setTimer ( function() blockPlayer = nil end, 3500, 1 )
		
	end
end


function setPlayerInsideInterior ( player, int, dim, x, y, z, wx, wy, wz, intName )
	setElementData( player, "isPlayerInInterior", true )
	setElementData( player, "playerInteriorName", intName )
	setElementData( player, "playerPositionOnWorldX", wx )
	setElementData( player, "playerPositionOnWorldY", wy )

	exports.VGplayers:setClientElementInterior ( player, int )
	setCameraInterior ( int )
	exports.VGplayers:setClientElementDimension ( player, dim )
	setTimer ( function(p) if ( isElement(p) ) then setCameraTarget(p) end end, 200,1, player )
	setElementPosition ( player, x, y, z+1 )

	toggleAllControls ( true, true, false )
	setTimer ( fadeCamera, 500, 1, true, 1.0 )
	
	showPlayerHudComponent("radar", false)
	
end

function setPlayerOutsideInterior ( player, rot, x, y, z )
	setElementData( player, "isPlayerInInterior", false )
	setElementData( player, "playerInteriorName", false )
	setElementData( player, "playerPositionOnWorldX", false )
	setElementData( player, "playerPositionOnWorldY", false )

	exports.VGplayers:setClientElementInterior ( player, 0 )
	setCameraInterior ( 0 )
	exports.VGplayers:setClientElementDimension ( player, 0 )
	setTimer ( function(p) if ( isElement(p) ) then setCameraTarget(p) end end, 200,1, player )
	setElementPosition ( player, x, y, z+1 )
	setElementRotation ( player, 0, 0, rot )

	toggleAllControls ( true, true, false )
	setTimer ( fadeCamera, 500, 1, true, 1.0 )
	
	showPlayerHudComponent("radar", true)

end

function onPlayerDead ()
	if ( source ~= localPlayer ) then return end
	setElementData( source, "isPlayerInInterior", false )
	setElementData( source, "playerInteriorName", false )
	setElementData( source, "playerPositionOnWorldX", false )
	setElementData( source, "playerPositionOnWorldY", false )
end
addEventHandler ( "onClientPlayerWasted", root, onPlayerDead )


function createWarps ()
	local interiors = exports.VGtables:getTable('interiors')
	for i=1, #interiors do
		local name, eX, eY, eZ, eRot, iX, iY, iZ, dim, int = interiors[i].name, interiors[i].exteriorX, interiors[i].exteriorY, interiors[i].exteriorZ, interiors[i].exteriorRot, interiors[i].interiorX, interiors[i].interiorY, interiors[i].interiorZ, interiors[i].interiorDim, interiors[i].interiorInt
		local exteriorMarker = createMarker(eX, eY, eZ+2.2, "arrow", 2, 255, 80, 0, 200)
		setElementData(exteriorMarker, "x", iX)
		setElementData(exteriorMarker, "y", iY)
		setElementData(exteriorMarker, "z", iZ)
		setElementData(exteriorMarker, "dim", dim)
		setElementData(exteriorMarker, "int", int)
		setElementData(exteriorMarker, "intName", name)
		addEventHandler("onClientMarkerHit", exteriorMarker, onMarkerHit)
		
		local interiorMarker = createMarker(iX, iY, iZ+2.2, "arrow", 2, 255, 80, 0, 200)
		setElementInterior(interiorMarker, int)
		setElementDimension(interiorMarker, dim)
		setElementData(interiorMarker, "x", eX)
		setElementData(interiorMarker, "y", eY)
		setElementData(interiorMarker, "z", eZ)
		setElementData(interiorMarker, "rot", eRot)
		addEventHandler("onClientMarkerHit", interiorMarker, onMarkerHit)

	end
end
createWarps ()