
local table = table




-- Color codes
local colorTable = {
	[ "#black" ]    = "#000000",
	[ "#red" ]      = "#FF0000",
	[ "#blue" ]     = "#0000FF",
	[ "#yellow" ]   = "#FFFF00",
	[ "#pink" ]     = "#FF00FF",
	[ "#gray" ]     = "#C0C0C0",
	[ "#orange" ]   = "#FF6600",
	[ "#brown" ]    = "#A52A2A",
	[ "#cyan " ]    = "#00FFFF",
	[ "#gold " ]    = "#FFD700",
	[ "#green" ]    = "#008000",
	[ "#lime" ]     = "#00FF00",
	[ "#purple " ]  = "#800080",
	[ "#silver" ]   = "#C0C0C0",
	[ "#violet " ]  = "#EE82EE",
	[ "#white" ]    = "#FFFFFF",
	[ "#purple " ]  = "#800080",
	[ "#silver" ]   = "#C0C0C0",
	[ "#metallic" ] = "#37FDFC",
	[ "#teal" ]     = "#008080",
}

-- Colors of the chat
local chatColor = {
	[ "Support" ] = { 56, 142, 142 }
}

-- The languages
local languages = {
	[ "NL" ] = { "Dutch" },
	[ "BE" ] = { "Dutch" },
	[ "DE" ] = { "German" },
	[ "BY" ] = { "Belarusian" },
	[ "EG" ] = { "Arabic", },
	[ "TN" ] = { "Arabic", },
	[ "TR" ] = { "Turkish", },
	[ "SE" ] = { "Swedish" },
	[ "FI" ] = { "Finnish " },
	[ "RU" ] = { "Russian" },
	[ "PL" ] = { "Polish" },
	[ "IN" ] = { "Hindi" },
	[ "GR" ] = { "Greek" },
	[ "AL" ] = { "Albanian" },
	[ "RU" ] = { "Russian" },
	[ "HR" ] = { "Croation" },
	[ "SI" ] = { "Slovenian" },
}

-- Table with the chats
local chats = { "Support", "Main", "Team", "Local", "CC", "Law" }

-- Some Variables
local isCityChatEnabled = false

-- Table for the anti spam protections
local spam = { localchat = {}, teamchat = {}, mechat = {}, mainchat = {}, carchat = {}, lawchat = {}, otherchat = {} }

-- When a player joins bind the key
addEventHandler ( "onPlayerJoin", root,
	function ()
		bindKey ( source, "u", "down", "chatbox", "local" )
		bindKey ( source, "l", "down", "chatbox", "language" )
	end
)

-- When the resource starts bind the key
addEventHandler ( "onResourceStart", resourceRoot,
	function ()
		for index, thePlayer in ipairs ( getElementsByType ( "player" ) ) do
			bindKey ( thePlayer, "u", "down", "chatbox", "local" )
			bindKey ( thePlayer, "l", "down", "chatbox", "language" )
		end
	end
)

-- Get the chatzone of a player
function getPlayerChatZone( thePlayer )
	local x, y, z = getElementPosition( thePlayer )
	if ( x < -920 ) then
		return "SF"
	elseif ( y < 420 ) then
		return "LS"
	else
		return "LV"
	end
end

-- Localchat function
function sendPlayerLocalChatMessage ( thePlayer, theMessage )
	if ( exports.VGaccounts:isPlayerLoggedIn ( thePlayer ) ) then
		local r, g, b = getPlayerNametagColor ( thePlayer )
		local isMuted, muteType = exports.VGpunish:isPlayerMuted( thePlayer )
		if ( isMuted ) and ( muteType == "Global" ) then
			exports.VGdx:showMessageDX( thePlayer, "You are muted!", 225, 0, 0 )
		elseif ( string.match( theMessage, "^%s*$" ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
		elseif ( spam.localchat[ thePlayer ] ) and ( getTickCount()-spam.localchat[ thePlayer ] < 1000 ) then
			exports.VGdx:showMessageDX( thePlayer, "Please refrain from spamming the chats!", 225, 0, 0 )
		else
			spam.localchat[ thePlayer ] = getTickCount()
			local table = getPlayersNearby ( thePlayer )
			for i, aPlayer in ipairs ( table ) do
				if ( getElementData( aPlayer, "chatLocal" ) ) then
					local theMessage = checkStringForColorCodes ( theMessage )
					outputChatBox ( "(Local) [".. ( #table - 1 ) .."] ".. getPlayerName ( thePlayer ) ..": #ffffff".. theMessage, aPlayer, r, g, b, true )
					local sLen = string.len( "(Local) [".. ( #table - 1 ) .."] ".. getPlayerName ( thePlayer ) ..": #ffffff".. theMessage )
					if ( sLen ) and ( sLen <= 128 ) then triggerClientEvent( aPlayer, "onClientChatBubble", aPlayer, thePlayer, string.gsub( theMessage,"#%x%x%x%x%x%x", "" ) ) end
				end
			end
			exports.VGlogging:log( 'chat', thePlayer, 'local', theMessage )
			triggerClientEvent( "onClientSendMessageToGUI", root, thePlayer, theMessage, "Local" )
		end
	end
end

-- Function for teamchat
function sendPlayerTeamChatMessage( thePlayer, theMessage )
	if ( exports.VGaccounts:isPlayerLoggedIn ( thePlayer ) ) then
		local r, g, b = getPlayerNametagColor ( source )
		local isMuted, muteType = exports.VGpunish:isPlayerMuted( thePlayer )
		if ( isMuted ) and ( muteType == "Global" ) then
			exports.VGdx:showMessageDX( thePlayer, "You are muted!", 225, 0, 0 )
		elseif ( string.match( theMessage, "^%s*$" ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
		elseif ( spam.teamchat[ thePlayer ] ) and ( getTickCount()-spam.teamchat[ thePlayer ] < 1000 ) then
			exports.VGdx:showMessageDX( thePlayer, "Please refrain from spamming the chats!", 225, 0, 0 )
		else
			if ( getPlayerTeam ( thePlayer ) ) then
				spam.teamchat[ thePlayer ] = getTickCount()
				for index, player in ipairs ( getPlayersInTeam ( getPlayerTeam ( thePlayer ) ) ) do
					outputChatBox ( "(TEAM) ".. getPlayerName ( thePlayer ) ..": #FFFFFF".. string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), player, r, g, b, true )
				end
				exports.VGlogging:log( 'chat', thePlayer, 'team', theMessage, getTeamName( getPlayerTeam( thePlayer ) ) )
				triggerClientEvent( "onClientSendMessageToGUI", root, thePlayer, theMessage, "Team" )
			end
		end
	end
end

-- Function for the mechat
function sendPlayerMeChatMessage( thePlayer, theMessage )
	if ( exports.VGaccounts:isPlayerLoggedIn ( thePlayer ) ) then
		local r, g, b = getPlayerNametagColor ( source )
		local isMuted, muteType = exports.VGpunish:isPlayerMuted( thePlayer )
		if ( isMuted ) and ( muteType == "Global" ) then
			exports.VGdx:showMessageDX( thePlayer, "You are muted!", 225, 0, 0 )
		elseif ( string.match( theMessage, "^%s*$" ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
		elseif ( spam.mechat[ thePlayer ] ) and ( getTickCount()-spam.mechat[ thePlayer ] < 1000 ) then
			exports.VGdx:showMessageDX( thePlayer, "Please refrain from spamming the chats!", 225, 0, 0 )
		else
			spam.mechat[ thePlayer ] = getTickCount()
			for i, aPlayer in ipairs ( getPlayersNearby ( thePlayer ) ) do
				outputChatBox ( "* ".. getPlayerName( thePlayer ) ..": ".. theMessage, aPlayer, 255, 0, 255 )
			end
			exports.VGlogging:log( 'chat', thePlayer, 'me', theMessage )
		end
	end
end

-- Function for the mainchat
function sendPlayerMainChatMessage( thePlayer, theMessage )
	-- Check if we want a city chat or a normal chat
	local function checkChatType ()
		if not ( isCityChatEnabled ) and ( getPlayerCount() >= 130 ) then
			isCityChatEnabled = true
		elseif ( isCityChatEnabled ) and ( getPlayerCount() <= 115 ) then
			isCityChatEnabled = false
		end
	end
	
	-- The chat
	if ( exports.VGaccounts:isPlayerLoggedIn ( thePlayer ) ) then
		local r, g, b = getPlayerNametagColor ( thePlayer )
		local isMuted, muteType = exports.VGpunish:isPlayerMuted( thePlayer )
		if ( isMuted ) and ( muteType == "Global" ) or ( muteType == "Main" ) then
			exports.VGdx:showMessageDX( thePlayer, "You are muted!", 225, 0, 0 )
		elseif ( string.match( theMessage, "^%s*$" ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
		elseif ( spam.mainchat[ thePlayer ] ) and ( getTickCount()-spam.mainchat[ thePlayer ] < 4000 ) and not ( exports.VGadmin:isPlayerAdmin( thePlayer ) )then
			exports.VGdx:showMessageDX( thePlayer, "Please refrain from spamming the chats!", 225, 0, 0 )
		else
			checkChatType()
			spam.mainchat[ thePlayer ] = getTickCount()
			if ( isCityChatEnabled ) then
				local r, g, b = getPlayerNametagColor ( thePlayer )
				local playerZone = getPlayerChatZone( thePlayer )
				local chatzoneTable = {}
				for i, thePlayer in ipairs ( getElementsByType ( "player" ) ) do
					if ( getPlayerChatZone( thePlayer ) == playerZone ) then
						table.insert( chatzoneTable, thePlayer )
					end
				end
						
				for i, aPlayer in ipairs ( chatzoneTable ) do
					if ( getElementData( aPlayer, "chatMain" ) ) then
						outputChatBox( "(".. playerZone ..") ".. getPlayerName( thePlayer ) ..": #FFFFFF".. string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), aPlayer, r, g, b, true )
					end
				end
				triggerClientEvent( "onClientSendMessageToGUI", root, thePlayer, "(".. playerZone ..") "..theMessage, "Main" )
				exports.VGlogging:log( 'chat', thePlayer, 'main', theMessage, playerZone )
			else
				local r, g, b = getPlayerNametagColor ( thePlayer )
				local playerZone = getPlayerChatZone( thePlayer )
				for i, aPlayer in ipairs ( getElementsByType( "player" ) ) do
					if ( getElementData( aPlayer, "chatMain" ) ) then
						outputChatBox( "(".. playerZone ..") ".. getPlayerName( thePlayer ) ..": #FFFFFF".. string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), aPlayer, r, g, b, true )
					end
				end
				triggerClientEvent( "onClientSendMessageToGUI", root, thePlayer, "(".. playerZone ..") "..theMessage, "Main" )
				exports.VGlogging:log( 'chat', thePlayer, 'main', theMessage, playerZone )
			end
		end
	end
end

-- Function for the car chat
function sendPlayerCarChatMessage( thePlayer, theMessage )
	if ( exports.VGaccounts:isPlayerLoggedIn ( thePlayer ) ) then
		local isMuted, muteType = exports.VGpunish:isPlayerMuted( thePlayer )
		if ( isMuted ) and ( muteType == "Global" ) then
			exports.VGdx:showMessageDX( thePlayer, "You are muted!", 225, 0, 0 )
		elseif ( string.match( theMessage, "^%s*$" ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
		elseif ( spam.carchat[ thePlayer ] ) and ( getTickCount()-spam.carchat[ thePlayer ] < 1000 ) then
			exports.VGdx:showMessageDX( thePlayer, "Please refrain from spamming the chats!", 225, 0, 0 )
		elseif not ( getPedOccupiedVehicle( thePlayer ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You are not in a vehicle!", 225, 0, 0 )
		else
			spam.carchat[ thePlayer ] = getTickCount()
			local nick = getPlayerName( thePlayer )
			local vehicle = getPedOccupiedVehicle( thePlayer )
			local occupants = getVehicleOccupants( vehicle )
			local seats = getVehicleMaxPassengers( vehicle )
			
			for seat = 0, seats do
				local occupant = occupants[seat]
				if ( isElement( occupant ) ) and ( getElementType( occupant) == "player" ) then
					outputChatBox( "#FF4500(CAR) ".. nick ..": #FFFFFF".. string.gsub( theMessage,"#%x%x%x%x%x%x", "" ) .."", occupant, 255, 69, 0, true )
					local sLen = string.len( "#FF4500(CAR) ".. nick ..": #FFFFFF".. string.gsub( theMessage,"#%x%x%x%x%x%x", "" ) .."" )
					if ( sLen ) and ( sLen <= 128 ) then triggerClientEvent( occupant, "onClientChatBubble", occupant, thePlayer, string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), true ) end
				end
			end
			exports.VGlogging:log( 'chat', thePlayer, 'car', theMessage )
		end
    end
end

-- Function for the lawchat
function sendPlayerLawChatMessage( thePlayer, theMessage )
	if ( exports.VGaccounts:isPlayerLoggedIn ( thePlayer ) ) then
		local isMuted, muteType = exports.VGpunish:isPlayerMuted( thePlayer )
		if ( isMuted ) and ( muteType == "Global" ) then
			exports.VGdx:showMessageDX( thePlayer, "You are muted!", 225, 0, 0 )
		elseif ( string.match( theMessage, "^%s*$" ) ) then
			exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
		elseif ( spam.lawchat[ thePlayer ] ) and ( getTickCount()-spam.lawchat[ thePlayer ] < 1000 ) then
			exports.VGdx:showMessageDX( thePlayer, "Please refrain from spamming the chats!", 225, 0, 0 )
		elseif not ( exports.VGlaw:isPlayerLaw( thePlayer ) ) then
			exports.VGdx:showMessageDX( thePlayer, "Only law officers can use this command!", 225, 0, 0 )
		else
			spam.lawchat[ thePlayer ] = getTickCount()
			for i,aPlayer in ipairs( getElementsByType("player") ) do
				if ( getPlayerTeam( aPlayer ) ) then
					if ( exports.VGlaw:isPlayerLaw( aPlayer ) ) then
						outputChatBox("(LAW) " .. getPlayerName( aPlayer ) .. ": #ffffff"..string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), aPlayer, 67, 156, 252, true)
					end
				end
			end
			exports.VGlogging:log( 'chat', thePlayer, 'law', theMessage )
		end
	end
end

-- Function for the teamchat
addEventHandler ( "onPlayerChat", root,
	function ( theMessage, msgType )
		cancelEvent ()
		if ( msgType == 0 ) then
			sendPlayerMainChatMessage( source, theMessage )
		elseif ( msgType == 1 ) then
			sendPlayerMeChatMessage( source, theMessage )
		elseif ( msgType == 2 ) then
			sendPlayerTeamChatMessage( source, theMessage )
		end
	end
)

-- Get all nearby players
function getPlayersNearby ( thePlayer )
	local thePlayers = { }
	local x, y, z = getElementPosition ( thePlayer )
	for i, thePlayer in ipairs ( getElementsByType ( "player" ) ) do
		if ( isPlayerInRangeOfPoint ( thePlayer, x, y, z, 100 ) ) then
			if ( getElementInterior ( thePlayer ) == getElementInterior ( thePlayer ) ) and ( getElementDimension ( thePlayer ) == getElementDimension ( thePlayer ) ) then
				table.insert ( thePlayers, thePlayer )
			end
		end
	end
	return thePlayers
end

-- Get if a player is in a rage of a certain point
function isPlayerInRangeOfPoint ( thePlayer, x, y, z, range )
	if ( thePlayer ) then
		local px, py, pz = getElementPosition ( thePlayer )
		return ( ( ( x - px ) ^ 2 + ( y - py ) ^ 2 + ( z - pz ) ^ 2 ) ^ 0.5 <= range )
	else
		return false
	end
end

-- Chat for the commands
function onChatSystemCommandChat( thePlayer, cmd, ... )
	if( cmd == "cc" ) then theChat = string.upper( cmd ) else theChat = cmd:gsub( "^%l", string.upper ) end
	local theMessage = table.concat({...}, " ")
	if ( string.match( theMessage, "^%s*$" ) ) then
		exports.VGdx:showMessageDX( thePlayer, "You didn't enter a message!", 225, 0, 0 )
	else
		onChatSystemChat ( theMessage, theChat, thePlayer )
	end
end

-- Command to bind all the chats
for i=1,#chats do
	if ( chats[i] ~= "Main" ) or ( chats[i] ~= "Team" ) then
		addCommandHandler( string.lower( chats[i] ), onChatSystemCommandChat )
	end
end

-- Language chat command
addCommandHandler( "language", 
	function ( thePlayer, _, ... )
		if ( languages[ getElementData( thePlayer, "Country" ) ] ) then
			local theMessage = table.concat( {...}, " " )
			onChatSystemChat ( theMessage, languages[ getElementData( thePlayer, "Country" ) ][ 1 ], thePlayer )
		end
	end
)

-- Event that sends the messages
addEvent( "onServerGUIChatMessage", true )
function onChatSystemChat ( theMessage, theChat, thePlayer )
	local client = client or thePlayer
	if ( exports.VGaccounts:isPlayerLoggedIn ( client ) ) then
		if ( theMessage ) and ( theChat ) then
			if ( theChat == "Local" ) then
				sendPlayerLocalChatMessage ( client, theMessage )
			elseif ( theChat == "Team" ) then
				sendPlayerTeamChatMessage( client, theMessage )
			elseif ( theChat == "Main" ) then
				sendPlayerMainChatMessage( client, theMessage )
			elseif ( theChat == "CC" ) then
				sendPlayerCarChatMessage( client, theMessage )
			elseif ( theChat == "Law" ) then
				sendPlayerLawChatMessage( client, theMessage )
			else
				if ( string.match( theMessage, "^%s*$" ) ) then
					exports.VGdx:showMessageDX( client, "You didn't enter a message!", 225, 0, 0 )
				elseif ( spam.otherchat[ client ] ) and ( getTickCount()-spam.otherchat[ client ] < 1000 ) then
					exports.VGdx:showMessageDX( client, "Please refrain from spamming the chats!", 225, 0, 0 )
				else
					-- Check if the player is muted
					local isMuted, muteType = exports.VGpunish:isPlayerMuted( client )
					if ( isMuted ) and ( muteType == "Global" ) then
						exports.VGdx:showMessageDX( client, "You are muted!", 225, 0, 0 )
						return
					elseif ( isMuted ) and ( theChat == "Support" ) and (  muteType == "Support" ) then
						exports.VGdx:showMessageDX( client, "You are muted!", 225, 0, 0 )
						return
					end
					
					spam.otherchat[ client ] = getTickCount()
					for k, aPlayer in ipairs( getElementsByType( "player" ) ) do
						if ( getElementData( aPlayer, "chat"..theChat ) ) then
							local R, G, B = 139, 69, 0
							if ( chatColor[theChat] ) then R, G, B = chatColor[theChat][1], chatColor[theChat][2], chatColor[theChat][3] end
							outputChatBox("("..theChat..") " .. getPlayerName( client ) .. ": #ffffff"..string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), aPlayer, R, G, B, true)
						end
					end
					
					-- The logging part
					if ( theChat == "Support" ) then
						exports.VGlogging:log( 'chat', client, 'support', theMessage )
					else
						exports.VGlogging:log( 'chat', client, 'language', theMessage, theChat )
					end
					
					-- Send the message to the client
					triggerClientEvent( "onClientSendMessageToGUI", root, client, string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), theChat  )
				end
			end
		end
	end
end
addEventHandler( "onServerGUIChatMessage", root, onChatSystemChat )

-- Check the message string for color codes and replace them
function checkStringForColorCodes ( string )
	for word, hex in pairs ( colorTable ) do
		if ( string:lower( ):match ( word .. " " ) ) then
			string = string.gsub( string, word .. " ", hex )
		end
	end
	return string
end

-- Staff chat
addCommandHandler( "vg",
	function ( thePlayer, _, ... )
		local theMessage = table.concat( {...}, " " )
		for _, aPlayer in pairs ( exports.VGadmin:getOnlineAdmins() ) do
			if ( isElement( aPlayer ) ) then
				outputChatBox( "(VG) " .. getPlayerName( thePlayer ) .. ": #ffffff"..string.gsub( theMessage,"#%x%x%x%x%x%x", "" ), aPlayer, 225, 0, 0, true )
			end
		end

		exports.VGlogging:log( 'chat', thePlayer, 'staff', theMessage )
	end
)