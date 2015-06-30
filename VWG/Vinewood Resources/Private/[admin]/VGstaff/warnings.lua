


-- Output a staff message
function createNewAdminDxMessage ( theMessage, r, g, b )
	for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
		if ( exports.VGadmin:isPlayerAdmin( thePlayer ) ) then
			exports.killmessages:outputMessage( theMessage, thePlayer, r, g, b )
		end
	end
end