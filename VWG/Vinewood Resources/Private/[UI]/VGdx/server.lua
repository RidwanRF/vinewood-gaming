-- Send a hud message
function showHudMessageDX ( thePlayer, theMessage, R, G, B, showTime )
	if not ( thePlayer ) or not ( theMessage ) or not ( R ) or not ( G ) or not ( B ) then
		if not ( thePlayer == root ) and not ( isElement( thePlayer ) ) then return false, "Invalid player" end
		return false, "Wrong format"
	else
		triggerClientEvent ( thePlayer, "onClientShowHudMessageDX", thePlayer, theMessage, R, G, B, showTime )
	end
end

-- Send a normal message
function showMessageDX ( thePlayer, theMessage, R, G, B, showTime )
	if not ( thePlayer ) or not ( theMessage ) or not ( R ) or not ( G ) or not ( B ) then
		return false, "Wrong format"
	else
		if not ( thePlayer == root ) and not ( isElement( thePlayer ) ) then return false, "Invalid player" end
		triggerClientEvent ( thePlayer, "onClientShowMessageDX", thePlayer, theMessage, R, G, B, showTime )
	end
end