-- Table with all the staff ranks
local aTable = {
	[ 1 ] = "Probation Staff",
	[ 2 ] = "Junior Staff",
	[ 3 ] = "Senior Staff",
	[ 4 ] = "Supervising Staff",
	[ 5 ] = "Management Staff",
	[ 6 ] = "Leading Staff",
	[ 0 ] = "Developer",
}

-- Table with girl staff's to make sure they get a girl skin
local adminGirls = {}

-- Command to enter the staff duty
addCommandHandler( "staff",
	function ( thePlayer )
		local isPlayerAdmin, level = exports.VGadmin:isPlayerAdmin( thePlayer )
		if ( isPlayerAdmin ) then
			-- Set the team and occupation
			if ( exports.VGaccounts:isPlayerGuestStaff( thePlayer ) ) then
				setPlayerTeam ( thePlayer, getTeamFromName( "Staff" ) )
				setElementData( thePlayer, "Occupation", "Guest Staff", true )
				exports.VGaccounts:setPlayerAccountData( thePlayer, "occupation", "Guest Staff" )
			else
				setPlayerTeam ( thePlayer, getTeamFromName( "Staff" ) )
				setElementData( thePlayer, "Occupation", aTable[ level ], true )
				exports.VGaccounts:setPlayerAccountData( thePlayer, "occupation", aTable[ level ] )
			end
			
			-- Set the correct skin
			if ( adminGirls[ exports.VGaccounts:getPlayerAccountName( thePlayer ) ] ) then
				setElementModel( thePlayer, 211 )
			else
				setElementModel( thePlayer, 217 )
			end
			
			-- Set health and remove wanted points
			setElementHealth( thePlayer, 100 )
			exports.VGplayers:setPlayerWantedPoints ( thePlayer, 0 )
			exports.VGdx:showMessageDX( thePlayer, "You are now on-duty as staff!", 0, 225, 0 )
			exports.VGlogging:addAdminLogRow ( thePlayer, getPlayerName( thePlayer ) .. " entered the staff job with " .. getPlayerWantedLevel( thePlayer ) .. " stars" )
		end
	end
)

-- Make the car from a staff dmgproof
addCommandHandler( "dmgproof", 
	function ( thePlayer )
		local isPlayerAdmin, level = exports.VGadmin:isPlayerAdmin( thePlayer )
		if ( isPlayerAdmin ) and ( getTeamName( getPlayerTeam( thePlayer ) ) == "Staff" ) then
			local theVehicle = getPedOccupiedVehicle( thePlayer )
			if ( theVehicle ) then
				if ( isVehicleDamageProof( theVehicle ) ) then
					exports.VGdx:showMessageDX( thePlayer, "Your vehicle is no longer damageproof!", 0, 225, 0 )
					setVehicleDamageProof( theVehicle, false )
				else
					exports.VGdx:showMessageDX( thePlayer, "Your vehicle is now damageproof!", 0, 225, 0 )
					setVehicleDamageProof( theVehicle, true )
				end
			end
		end
	end
)

-- Minigun command
addCommandHandler( "minigun",
	function ( thePlayer )
		local isPlayerAdmin, level = exports.VGadmin:isPlayerAdmin( thePlayer )
		if ( isPlayerAdmin ) then
			if ( level >= 5 ) then
				exports.VGweaponsync:givePlayerWeapon( thePlayer, 38, 9000, true )
			end
		end
	end
)

-- Invis command
addCommandHandler( "invis",
	function ( thePlayer )
		local isPlayerAdmin, level = exports.VGadmin:isPlayerAdmin( thePlayer )
		if ( isPlayerAdmin ) and ( getTeamName( getPlayerTeam( thePlayer ) ) == "Staff" ) then
			if ( getElementAlpha( thePlayer ) == 255 ) then
				setElementAlpha( thePlayer, 0 )
				setPlayerNametagShowing ( thePlayer, false )
			else
				setElementAlpha( thePlayer, 255 )
				setPlayerNametagShowing ( thePlayer, true )
			end
		end
	end
)

-- Glue event
addEvent( "gluePlayer", true )
addEventHandler( "gluePlayer", root,
	function ( slot, vehicle, x, y, z, rotX, rotY, rotZ )
		attachElements( source, vehicle, x, y, z, rotX, rotY, rotZ )
		setPedWeaponSlot( source, slot )
	end
)

-- Unglue event
addEvent( "ungluePlayer", true )
addEventHandler( "ungluePlayer", root,
	function ()
		detachElements( source )
	end
)

-- Function that updates the element position
addEvent( "onMovementElementUpdate", true )
addEventHandler( "onMovementElementUpdate", root,
	function ( theElement, x, y, z )
		setElementPosition( theElement, x, y, z )
	end
)

-- Function that freezes the element while moving
addEvent( "onMovementElementStopStart", true )
addEventHandler( "onMovementElementStopStart", root,
	function ( theElement, state )
		if ( state ) then
			setElementFrozen( theElement, true )
			if ( getElementType( theElement ) == "vehicle" ) then setVehicleDamageProof( theElement, true ) end
		else
			setElementFrozen( theElement, false )
			if ( getElementType( theElement ) == "vehicle" ) then setVehicleDamageProof( theElement, false ) end
		end
	end
)