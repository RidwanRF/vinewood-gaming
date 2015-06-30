--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--



-- Function to warp someone to a certian player
function warpPlayerToPlayer ( thePlayer, toPlayer )
	if ( isElement( thePlayer ) ) and ( isElement( toPlayer ) ) then
		if ( isPedInVehicle( thePlayer ) ) then removePedFromVehicle( thePlayer ) end
		if ( isPedInVehicle ( toPlayer ) ) then
			local vehicle = getPedOccupiedVehicle ( toPlayer )
			local occupants = getVehicleOccupants( vehicle )
			local seats = getVehicleMaxPassengers( vehicle )
			local x, y, z = getElementPosition ( vehicle )
			local isWarped = false
			for seat = 0, seats do
				local occupant = occupants[seat] 
				if not ( occupant ) then
					setTimer ( warpPedIntoVehicle, 1000, 1, thePlayer, vehicle, seat )
					fadeCamera ( thePlayer, false, 1, 0, 0, 0 )
					setTimer ( fadeCamera, 1000, 1, thePlayer, true, 1 )
					setElementDimension ( thePlayer, getElementDimension ( toPlayer ) )
					if ( getElementInterior( thePlayer ) ) ~= ( getElementInterior( toPlayer ) ) then setElementInterior ( thePlayer, getElementInterior ( toPlayer ), getElementPosition( toPlayer ) ) end
					isWarped = true
					return
				end
				if not ( isWarped ) then
					setTimer ( setElementPosition, 1000, 1, thePlayer, x, y, z +1 )
					fadeCamera ( thePlayer, false, 1, 0, 0, 0 )
					setTimer ( fadeCamera, 1000, 1, thePlayer, true, 1 )
					setElementDimension ( thePlayer, getElementDimension ( toPlayer ) )
					if ( getElementInterior( thePlayer ) ) ~= ( getElementInterior( toPlayer ) ) then setElementInterior ( thePlayer, getElementInterior ( toPlayer ), getElementPosition( toPlayer ) ) end
				end
			end
		else				
			local x, y, z = getElementPosition ( toPlayer )
			local r = getPedRotation ( toPlayer )
			x = x - math.sin ( math.rad ( r ) ) * 2
			y = y + math.cos ( math.rad ( r ) ) * 2
			setTimer ( setElementPosition, 1000, 1, thePlayer, x, y, z + 1 )
			fadeCamera ( thePlayer, false, 1, 0, 0, 0 )
			setElementDimension ( thePlayer, getElementDimension ( toPlayer ) )
			if ( getElementInterior( thePlayer ) ) ~= ( getElementInterior( toPlayer ) ) then setElementInterior ( thePlayer, getElementInterior ( toPlayer ) ) end
			setTimer ( fadeCamera, 1000, 1, thePlayer, true, 1 )
		end
	end
end