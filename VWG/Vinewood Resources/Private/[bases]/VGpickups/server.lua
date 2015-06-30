-- Table with positions
local positionTable = exports.VGtables:getTable('pickups')

-- Table with the pickups
local arr = {}

-- Create the pickups
for i=1,#positionTable do
	arr [ createPickup ( positionTable[i][1], positionTable[i][2], positionTable[i][3], 3, 1242, 0 ) ] = { positionTable[i][4], positionTable[i][5] }
end

-- On pickupt hit
addEventHandler( "onPickupHit", root,
	function ( thePlayer )
		if ( arr[ source ] ) and not ( isPedInVehicle( thePlayer ) ) and ( getPlayerTeam( thePlayer ) ) then
			if ( arr[ source ][2] == getTeamName( getPlayerTeam( thePlayer ) ) ) or ( arr[ source ][2] == "Law" ) and ( exports.VGlaw:isPlayerLaw( thePlayer ) ) then
				if ( arr[ source ][1] == 1 ) then
					setPedArmor( thePlayer, 100 )
				elseif ( arr[ source ][1]  == 2 ) then
					setPedArmor( thePlayer, 100 )
					giveWeapon( thePlayer, 46, 1, true )
				elseif ( arr[ source ][1]  == 3 ) then
					setPedArmor( thePlayer, 100 )
					setElementHealth( thePlayer, 1000 )
					giveWeapon( thePlayer, 46, 1, true )
				end
			else
				cancelEvent()
			end
		end
	end
)