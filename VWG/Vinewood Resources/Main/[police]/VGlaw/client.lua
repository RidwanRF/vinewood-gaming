



-- Function to check if a player is law
function isPlayerLaw ( thePlayer )
	if not ( isElement( thePlayer ) ) then 
		return false
	elseif not ( getPlayerTeam( thePlayer ) ) then 
		return false
	else
		for k, aTeam in ipairs( { "SWAT", "Police", "Military Forces" } ) do
			if ( getPlayerTeam( thePlayer ) ) and ( getTeamName( getPlayerTeam( thePlayer ) ) ) and ( getTeamName( getPlayerTeam( thePlayer ) ) == aTeam ) then
				return aTeam
			end
		end
		return false
	end
end