-- When the resource starts
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		createTeam( "Staff", 225, 225, 225 )
		createTeam( "SWAT",  61, 89, 251 )
		createTeam( "Military Forces", 0, 100, 0 )
		createTeam( "Civilians", 225, 225, 0 )
		createTeam( "Unemployed Civilians", 106, 90, 255 )
		createTeam( "Unoccupied Civilians", 139, 90, 43 )
		createTeam( "Emergency Services", 0, 225, 225 )
		createTeam( "Police", 67, 156, 252 )
		createTeam( "Criminals", 176, 23, 31 )
		createTeam( "Gangsters", 198, 113, 113 )
		createTeam( "Not Logged In", 225, 225, 225 )
		local tbl = exports.VGcache:getTemporaryData( "teams" )
		if ( tbl ) then setTimer( resetPlayerTeams, 2000, 1, tbl ) end
	end
)

-- When the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		local table = {}
		for _, thePlayer in ipairs( getElementsByType( "player" ) ) do
			if ( getPlayerTeam( thePlayer ) ) then
				table [ thePlayer ] = getTeamName( getPlayerTeam( thePlayer ) )
			end
		end
		exports.VGcache:setTemporaryData( "teams", table )
	end
)

-- Function that puts everybody back into their old team
function resetPlayerTeams ( table )
	for _, thePlayer in ipairs( getElementsByType( "player" ) ) do
		if ( table[ thePlayer ] ) and ( getTeamFromName( table[ thePlayer ] ) ) then
			setPlayerTeam ( thePlayer, nil )
			setPlayerTeam( thePlayer, getTeamFromName( table[ thePlayer ] ) )
		else
			if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
				setPlayerTeam ( thePlayer, nil )
				setPlayerTeam( thePlayer, getTeamFromName( "Unemployed Civilians" ) )
			else
				setPlayerTeam ( thePlayer, nil )
				setPlayerTeam( thePlayer, getTeamFromName( "Not Logged In" ) )
			end
		end
	end
end