-- When the player needs a heal
addEvent( "onServerMedicHeal", true )
addEventHandler( "onServerMedicHeal", root,
	function ( attacker, weapon, bodypart, loss, legit )
		if ( attacker ) and ( getElementType( attacker ) == "player" ) and ( weapon == 41 ) then
			if ( getPlayerTeam( attacker ) ) and ( getTeamName( getPlayerTeam( attacker ) ) == "Emergency Services" ) then
				if not ( legit ) and ( getPlayerMoney( client ) < 60 ) then
					exports.VGdx:showMessageDX( attacker, "This player has no money!", 225, 0, 0 )
				else
					if ( getElementHealth( client ) < 100 ) then
						if ( getElementHealth( client ) <= 90 ) then
							setElementHealth( client, getElementHealth( client ) + 10 )
						else
							setElementHealth( client, 100 )
						end
						if not ( legit ) then exports.VGplayers:takePlayerCash( client, 60, "Healed by a Paramedic" ) end
						if not ( legit ) then exports.VGplayers:givePlayerCash( attacker, 60, "Healed a player" ) end
					end
				end
			end
		end	
	end
)

-- Remove the spraycan
addEventHandler( "onElementDataChange", root,
	function ( key, oldValue )
		if ( key == "Occupation" ) and ( oldValue == "Paramedic" ) and ( getElementData( source, "Occupation" ) ~= "Paramedic" ) then
			takeWeapon( source, 41 )
		end
	end
)

