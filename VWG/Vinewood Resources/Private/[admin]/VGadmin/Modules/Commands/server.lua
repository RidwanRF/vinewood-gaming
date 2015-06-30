--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Note command
addCommandHandler( "note",
	function ( player, cmd, ... )
		local theMessage = table.concat({...}, " ") 
		if ( isPlayerAdmin( player ) )  then
			outputChatBox( "#FF0000(NOTE) "..getPlayerName( player )..": #FFFFFF ".. theMessage, root, 255, 255, 255, true )
			exports.VGlogging:log( 'chat', player, 'note', theMessage, getTeamName( getPlayerTeam( thePlayer ) ) )
		end
	end
)