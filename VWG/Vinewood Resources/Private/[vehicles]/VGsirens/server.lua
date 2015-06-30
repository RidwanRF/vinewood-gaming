addEventHandler( "onVehicleEnter", root,
	function ( p )
		if ( getElementModel( source ) == 596 ) then
			addVehicleSirens ( source, 2, 3, true, false, true, false ) 
			setVehicleSirens ( source, 2, 0.500, -0.400, 0.900, 0, 0, 255, 180, 255 )
			setVehicleSirens ( source, 1, -0.500, -0.400, 0.900, 255, 0, 0, 180, 255 )
		elseif ( getElementModel( source ) == 598 ) then
			addVehicleSirens ( source, 2, 3, true, false, true, false )
			setVehicleSirens ( source, 2, 0.500, -0.300, 0.900, 0, 0, 255, 180, 255 )
			setVehicleSirens ( source, 1, -0.500, -0.300, 0.900, 255, 0, 0, 180, 255 )
		elseif ( getElementModel( source ) == 597 ) then
			addVehicleSirens ( source, 2, 3, true, false, true, false ) 
			setVehicleSirens ( source, 2, 0.500, -0.400, 0.900, 0, 0, 255, 180, 255 )
			setVehicleSirens ( source, 1, -0.500, -0.400, 0.900, 255, 0, 0, 180, 255 )
		elseif ( getElementModel( source ) == 599 ) then
			addVehicleSirens ( source, 2, 3, true, false, true, false ) 
			setVehicleSirens ( source, 2, 0.500, 0.100, 1.200, 0, 0, 255, 180, 255 )
			setVehicleSirens ( source, 1, -0.500, 0.100, 1.200, 255, 0, 0, 180, 255 )
		elseif ( getElementModel( source ) == 416 ) then
			addVehicleSirens ( source, 4, 3, true, false, true, false ) 
			setVehicleSirens ( source, 1, -0.400, 0.800, 1.200, 0, 0, 255, 160, 255 )
			setVehicleSirens ( source, 2, 0.500, 0.800, 1.200, 0, 0, 255, 160, 255 )
			setVehicleSirens ( source, 3, 1.000, -3.800, 1.300, 0, 0, 255, 160, 255 )
			setVehicleSirens ( source, 4, -0.949, -3.800, 1.291, 0, 0, 255, 160, 255 )
		elseif ( getElementModel( source ) == 407 ) then
			addVehicleSirens ( source, 2, 2, true, false, true, false ) 
			setVehicleSirens ( source, 2, -0.600, 3.200, 1.400, 238, 154, 0, 180, 255 )
			setVehicleSirens ( source, 1, 0.600, 3.200, 1.400, 238, 154, 0, 180, 255 )
		elseif ( getElementModel( source ) == 470 ) then
			addVehicleSirens ( source, 2, 3, true, true, true, false ) 
			setVehicleSirens ( source, 1, -0.800, 0.500, 1.100, 255, 0, 0, 65, 65 )
			setVehicleSirens ( source, 2, 0.500, 0.500, 1.100, 0, 0, 255, 65, 65 )
		elseif ( getElementModel( source ) == 525 ) then
			addVehicleSirens ( source, 2, 2, true, false, false, true ) 
			setVehicleSirens ( source, 1, 0.600, -0.500, 1.500, 238, 154, 0, 95, 97 )
			setVehicleSirens ( source, 2, -0.600, -0.500, 1.500, 238, 154, 0, 95, 97 )
		elseif ( getElementModel( source ) == 574 ) then
			addVehicleSirens ( source, 2, 2, true, false, false, true ) 
			setVehicleSirens ( source, 1, 0.300, 0.500, 1.400, 238, 154, 0, 44, 44 )
			setVehicleSirens ( source, 2, -0.300, 0.500, 1.400, 238, 154, 0, 44, 44 )
		elseif ( getElementModel( source ) == 485 ) then
			addVehicleSirens ( source, 1, 2, true, false, true, true ) 
			setVehicleSirens ( source, 1, 0.500, -1.100, 1.100, 238, 154, 0, 54, 54 )
		elseif ( getElementModel( source ) == 428 ) then
			addVehicleSirens ( source, 4, 2, true, false, true, true ) 
			setVehicleSirens ( source, 1, -1.100, 1.400, 1.300, 238, 154, 0, 62, 62 )
			setVehicleSirens ( source, 2, 0.900, 1.400, 1.300, 238, 154, 0, 62, 62 )
			setVehicleSirens ( source, 3, 0.900, -3.000, 1.400, 238, 154, 0, 62, 62 )
			setVehicleSirens ( source, 4, -1.000, -3.000, 1.400, 238, 154, 0, 62, 62 )
		elseif ( getElementModel( source ) == 415 ) then
			if not ( getPlayerTeam( p ) ) or ( getTeamName( getPlayerTeam( p ) ) ~= "SWAT Team" ) then return end
			addVehicleSirens ( source, 2, 2, true, false, true, false )
			setVehicleSirens ( source, 1, 0.400, -0.400, 0.600, 0, 0, 255, 72, 255 )
			setVehicleSirens ( source, 2, -0.400, -0.400, 0.600, 255, 0, 0, 72, 255 )
		end
	end
)