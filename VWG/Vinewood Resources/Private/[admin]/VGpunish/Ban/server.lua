-- All the bans are here
local banTable = {}

-- Function for when the resource start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		local tbl = exports.VGcache:getTemporaryData( "banTable" )
		if ( tbl ) then banTable = tbl end
	end
)

-- Function for when the resource stops
addEventHandler( "onResourceStop", resourceRoot,
	function ()
		exports.VGcache:setTemporaryData( "banTable", banTable )
	end
)

-- Function that bans a player
function banPlayer( admin, reason, time, account, serial, ip, player )
	if not ( account ) and not ( serial ) and not ( ip ) then
		return false
	end

	if ( isElement( admin ) ) and not ( empty( reason ) ) and ( time ) and ( isElement( player ) ) then
		local hash = md5( getTickCount() + math.random() )

		exec( "mtasa", "INSERT INTO bans SET nick = ?, account = ?, serial = ?, ip = ?, reason = ?, timestamp = ?, admin = ?, hash = ?",
			getPlayerName( player ),
			account or "",
			serial or "",
			ip or "",
			reason,
			time,
			getPlayerName( admin ),
			hash
		)

		for _, elm in ipairs( getElementsByType( "player" ) ) do
			if ( getPlayerIP( elm ) == ip ) or ( getPlayerSerial( elm ) == serial ) then
				redirectPlayer( elm, "", 0, getServerPassword() )
			end
		end

		query( "mtasa",
			function( res, _ ) 
				if ( res ) then
					table.insert( bansTable, res )
					resentAdminTable ()
				end
			end, {}, "SELECT * bans WHERE hash = ?", hash
		)

		return true
	end

	return false
end

-- Function to add a ban
function addBan ( theReason, theTime, theAccount, theSerial, theIP, theAdmin, thePlayer )
	-- Is there data send?
	if not ( theAccount ) and not ( theSerial ) and not ( theIP ) then
		return false
	elseif not ( theReason ) or not ( theTime ) then
		return false
	end
		
	-- Check if there's already a ban with the same IP, Account or Serial
	for i=1,#banTable do
		if ( banTable[ i ].accountname == theAccount ) then
			return false, "Account already banned!"
		elseif ( banTable[ i ].serial == theSerial ) then
			return false, "Serial already banned!"
		elseif ( banTable[ i ].ip == theIP ) then
			return false, "IP already banned!"
		end
	end
	
	-- Check if a player matches any of the enterd ban variables
	if not ( thePlayer ) then
		for _, aPlayer in ipairs ( getElementsByType( "player" ) ) do
			if ( theSerial ) and ( string.lower( getPlayerSerial( aPlayer ) ) == string.lower( theSerial ) ) then
				thePlayer = aPlayer
				break
			elseif ( theIP ) and ( getPlayerIP( aPlayer ) == theIP ) then
				thePlayer = aPlayer
				break
			elseif ( theAccount ) and ( string.lower( exports.VGaccounts:getPlayerAccountName( aPlayer ) ) == string.lower( theAccount ) ) then
				thePlayer = aPlayer
				break
			end
		end
	end
	
	-- If not we can go further
	if ( isElement( thePlayer ) ) then nickname = getPlayerName( thePlayer ) else nickname = "" end
	local uniquetick = getTickCount() + math.random( 11111, 99999 )
	exports.VGmysql:exec( "GEW783UH230WEGE978GW", "INSERT INTO bans SET nickname=?, accountname=?, serial=?, ip=?, reason=?, banstamp=?, admin=?, uniquetick=?"
		, nickname
		, theAccount or ""
		, theSerial or ""
		, theIP or ""
		, theReason or ""
		, theTime or 0
		, theAdmin or "Console"
		, uniquetick
	)
	
	-- Get the ban
	local banData = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM bans WHERE uniquetick=?", uniquetick )
	if ( banData ) then table.insert( banTable, banData ) end
		
	-- If there's a player specified
	if ( isElement( thePlayer ) ) then
		kickPlayer( thePlayer, "You have been banned!" )
	end
	
	-- Sent the table to all admins
	resentAdminTable ()
	
	return true, banData.banid
end

-- Function to remove a ban
function removeBan ( id )
	if ( id ) then
		if ( exports.VGmysql:exec( "GEW783UH230WEGE978GW", "UPDATE bans SET active=? WHERE banid=?", 0, id ) ) then
			for i=1,#banTable do
				if ( banTable[ i ].banid == id ) then
					banTable[ i ] = nil
					resentAdminTable ()
					return true
				end
			end
		else
			for i=1,#banTable do
				if ( banTable[ i ].banid == id ) then
					banTable[ i ] = nil
					resentAdminTable ()
					return true
				end
			end
			return false
		end
	else
		return false
	end
end

-- Function that gets all the server bans
function getServerBans ( force )
	if ( banTable ) and not ( force ) then
		return banTable
	else
		local table = exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM bans WHERE active=?", 1 )
		if ( table ) then 
			banTable = table
			return banTable
		else
			banTable = {}
			return banTable
		end
	end
end

-- Function that sends the admin panel to all admins
function resentAdminTable()
	for _, thePlayer in pairs ( exports.VGadmin:getOnlineAdmins () ) do
		if ( isElement( thePlayer ) ) then
			triggerClientEvent( thePlayer, "onClientSendAdminTable", thePlayer, banTable )
		end
	end
end