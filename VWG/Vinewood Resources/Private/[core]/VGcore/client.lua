


local tostring = tostring
local tonumber = tonumber

-- Table with the ban data
local banData = nil

-- The movement view
local cameraMovement = {}
local cameraPositions = {
	{ sx = -2600.38, sy = 2600.06, sz = 100.12, ex = -2235.21, ey = 2054.00, ez = 60 },
	{ sx = 100, sy = 2606.71, sz = 45, ex = 473.29, ey = 2515.49, ez = 28.87 },
	{ sx = 700.04, sy = -1800.82, sz = 40, ex = 443.90, ey = -1680.15, ez = 25.08 },
	{ sx = -1500, sy = -300, sz = 40, ex = 100.00, ey = 100, ez = 90 },
	{ sx = 600, sy = -1800, sz = 60, ex = 1000, ey = 1500, ez = 28.0 },
	{ sx = -1142.81, sy = 855.058, sz = 84.00, ex = -1780, ey = 790, ez = 70 }, 
	{ sx = -300, sy = 2100.54, sz = 131.93, ex = -816.23, ey = 2000.05, ez = 7.0 }, 
	{ sx = 816.19, sy = -1278.46, sz = 39.33, ex = 911.66, ey = -864.66, ez = 83.18 },
	{ sx = -100.56, sy = -1414.22, sz = 30.04, ex = -340.46, ey = -1836.81, ez = 2.6 },
	{ sx = 2643.706, sy = -978.581, sz = 95.3, ex = 2299.454, ey = -1236.496, ez = 28 },
}

-- Get the screen size
local sx, sy = guiGetScreenSize()

-- When the client resource is done loading
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		if not ( exports.VGaccounts:getPlayerAccountName ( localPlayer ) ) then
			local x, y = guiGetScreenSize()
			triggerServerEvent( "onClientDownloadReady", localPlayer, x, y )
			setLoginWindowVisable ( false )
		end
	end
)

-- Function the triggers when a player joined
addEvent( "onPlayerClientJoined", true )
addEventHandler( "onPlayerClientJoined", root,
	function ( isPlayerBanned, table, stamp )
		-- exports.VGblur:setBlurEnabled()
		addEventHandler( "onClientRender", root, onStreamIntoViews )
		setWeather( 1 )
		-- Check if a player is banned or not, if he's banned the table contains the ban data
		if ( isPlayerBanned ) then
			banData = table
			banData.alpha = 0
			banData.serverstamp = stamp
			addEventHandler( "onClientRender", root, dxDrawBanScreen )
			setTimer( decreaseServerStamp, 1000, 0 )
		else
			setLoginWindowVisable ( true )
			showCursor( true )
		end
	end
)

-- Stream the views
function onStreamIntoViews ()
	if not ( cameraMovement.index ) then
		cameraMovement.tick = getTickCount()
		cameraMovement.index = 1
		cameraPoint = exports.VGutils:getTableCopy( cameraPositions[ cameraMovement.index ] )
	end
	
	-- Set the position
	setCameraMatrix(cameraPoint.sx, cameraPoint.sy, cameraPoint.sz, cameraPoint.ex, cameraPoint.ey, cameraPoint.ez)
	
	-- Update the positions
	cameraPoint.sx = cameraPoint.sx - 0.3
	cameraPoint.sy = cameraPoint.sy - 0.3
	
	if ( getTickCount() - cameraMovement.tick >= 10000 ) then
		if not ( cameraMovement.fading ) then
			fadeCamera( false )
			cameraMovement.fading = true
		end
		
		if ( getTickCount() - cameraMovement.tick >= 11100 ) then
			cameraMovement.index = cameraMovement.index + 1
			if ( cameraMovement.index > #cameraPositions ) then cameraMovement.index = 1 end
			cameraMovement.tick = getTickCount()
			cameraPoint = exports.VGutils:getTableCopy( cameraPositions[ cameraMovement.index ] )
			fadeCamera( true )
			cameraMovement.fading = false
		end
	end
end

-- Draw the ban screen
function dxDrawBanScreen ()
	if ( banData ) then
		if ( banData.alpha ) and ( banData.alpha < 255 ) then banData.alpha = banData.alpha + 1 end
		local bandate = string.format ( "%s day(s), %s hour(s), %s min(s), %s sec(s)", convertBanTime ( ( tonumber ( banData.banstamp ) - tonumber ( banData.serverstamp ) ) * 1000 ) )
		if ( tonumber ( banData.serverstamp ) >= tonumber ( banData.banstamp ) ) then bandate = "Ban expired! Please reconnect!" banData.serverstamp = 0 end
        exports.VGdrawing:dxDrawBorderedText("You are banned from Vinewood Gaming!", sx*(366.0/1440),sy*(133.0/900),sx*(1121.0/1440),sy*(196.0/900), tocolor(2, 59, 123, banData.alpha), 2.0, "pricedown", "center", "center", false, false, false, false, false)
        exports.VGdrawing:dxDrawBorderedText("Time left: "..bandate, sx*(366.0/1440),sy*(239.0/900),sx*(1121.0/1440),sy*(302.0/900), tocolor(178, 90, 12, banData.alpha), 1.4, "bankgothic", "center", "center", false, false, false, false, false)
        exports.VGdrawing:dxDrawBorderedText("Banned by: "..banData.admin, sx*(366.0/1440),sy*(328.0/900),sx*(1121.0/1440),sy*(391.0/900), tocolor(159, 7, 7, banData.alpha), 1.4, "bankgothic", "center", "center", false, false, false, false, false)
        exports.VGdrawing:dxDrawBorderedText("Reason: "..banData.reason, sx*(313.0/1440),sy*(413.0/900),sx*(1197.0/1440),sy*(478.0/900), tocolor(203, 142, 11, banData.alpha), 1.4, "bankgothic", "center", "center", false, false, false, false, false)
        exports.VGdrawing:dxDrawBorderedText("Serial: "..banData.serial, sx*(313.0/1440),sy*(522.0/900),sx*(1197.0/1440),sy*(587.0/900), tocolor(13, 144, 156, banData.alpha), 1.4, "bankgothic", "center", "center", false, false, false, false, false)
	end
end

-- Function that does derease the serverstamp
function decreaseServerStamp ()
	if ( banData.serverstamp ) then
		if ( banData.serverstamp == 0 ) then return end
		banData.serverstamp = math.number( banData.serverstamp, 1 )
	end
end

-- Custom math function to take a number from the stamp
function math.number( num, integer )
	if not ( num ) or not ( integer ) then return end

	local function formatNumber( numb )
		if not( numb ) then return end
		local fn = string.sub( tostring( numb ), ( #tostring( numb ) -6 ) )
		return tonumber( fn )
	end
	
	local fn = string.sub( tostring( num ), 1, -8 )..( formatNumber ( num ) ) + integer
	return tonumber( fn )
end

-- Convert a timeStamp to a date
function convertBanTime ( ms )
    local mins = math.floor ( ms / 60000 )
	local hours = math.floor ( mins / 60 )
    local sec = math.floor ( ( ms / 1000 ) % 60 )
	local days = math.floor ( hours / 24 )
    return days, ( hours - days * 24 ), ( mins - hours * 60 ), sec
end

-- Event when the player wants to login
addEvent( "onClientLoginButtonClicked" )
addEventHandler( "onClientLoginButtonClicked", root,
	function ( username, password, usernameTick, passwordTick )
		if not ( string.match( username, "^[%w%s]*%w[%w%s]*$" ) ) or ( string.match( username, "^%s*$" ) )then
			setWarningBoxVisable( "Invalid username enterd!" )
		elseif ( string.match( password, "%s" ) ) or ( password == "" ) then
			setWarningBoxVisable( "Invalid password enterd!" )
		else
			setAccountXMLData( username, password, usernameTick, passwordTick )
			triggerServerEvent( "onServerLoginPlayer", localPlayer, username, password )
		end
	end
)

-- Event to recover the password of the player
addEvent( "onClientPasswordButtonClicked" )
addEventHandler( "onClientPasswordButtonClicked", root,
	function ( username )
		if not ( string.match( username, "^[%w%s]*%w[%w%s]*$" ) ) or ( string.match( username, "%s" ) ) then
			setWarningBoxVisable( "Invalid username enterd!" )
		else
			triggerServerEvent( "onServerRecoverPlayerPassword", localPlayer, username )
		end
	end
)

-- Event from the server when the player loggedin
addEvent( "onClientPlayerLoggedIn", true )
addEventHandler( "onClientPlayerLoggedIn", root,
	function ()
		setTimer( showPlayerHudComponent, 1000, 1, "radar", true )
		triggerEvent( "onClientPlayerLogin", localPlayer, accountname )
		showPlayerHudComponent ( "area_name", true )
		-- exports.VGblur:setBlurDisabled()
		removeEventHandler( "onClientRender", root, onStreamIntoViews )
		setLoginWindowVisable ( false )
		setCameraTarget( source )
		showCursor( false )
		showChat( true )
	end
)