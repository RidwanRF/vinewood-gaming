
local table = table


local tostring = tostring
local tonumber = tonumber

-- Table with the ammo stored
local ammoTable = {}

-- Event on the start of the resource
addEventHandler( "onResourceStart", root,
	function ()
		for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
			if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
				if ( fromJSON( exports.VGaccounts:getPlayerAccountData( thePlayer, "ammostring" ) ) ) then
					ammoTable[ thePlayer ] = fromJSON( exports.VGaccounts:getPlayerAccountData( thePlayer, "ammostring" ) )
				end
			end
		end
	end
)

-- Event for when the player does login
addEvent( "onServerPlayerSpawned" )
addEventHandler( "onServerPlayerSpawned", root,
	function ( username, aTable )
		if ( fromJSON( aTable.ammostring ) ) then
			local tableA = fromJSON( aTable.ammostring )
			local tableB = fromJSON( aTable.weaponstring )
			
			-- Return the player weapons
			if ( tableB ) then
				ammoTable[ source ] = tableA
				for i, weapon in ipairs( tableB ) do
					if ( tableA[ tostring( weapon ) ] ) and ( tableA[ tostring( weapon ) ] > 0 ) then
						giveWeapon ( source, tonumber( weapon ), tableA[ tostring( weapon ) ] )
					end
				end
			end
		end
	end
)

-- function that syncs the weapon with the table
function updatePlayerWeaponTable( thePlayer )
	if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) and ( ammoTable[ thePlayer ] ) then
		for weapon, ammo in pairs ( ammoTable[ thePlayer ] ) do
			if ( getSlotFromWeapon( tonumber( weapon ) ) ) and ( tostring( getPedWeapon ( thePlayer, getSlotFromWeapon( tonumber( weapon ) ) ) ) == tostring( weapon ) ) then
				ammoTable[ thePlayer ] [ tostring( weapon ) ] = getPedTotalAmmo( thePlayer, getSlotFromWeapon( tonumber( weapon ) ) )
			end
		end
	end
end

-- Function that saves the player weapons
function savePlayerWeaponTable( thePlayer, wastedCheck )
	-- First do a loop thru all the weapons and make sure we've got the most up-to-date weapons
	updatePlayerWeaponTable( thePlayer )

	-- Some checks if we want to abort the saving
	if ( wastedCheck ) and ( isPedDead( source ) ) then
		return
	end
	
	-- Is the player loggedin
	if not ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
		return
	end
	
	-- Local function to get the weapon JSON
	local function getWeaponsJSON( thePlayer )
		local aTable = {}
		for slot = 0, 12 do
			if ( getPedWeapon( thePlayer, slot ) ) and ( getPedWeapon( thePlayer, slot ) > 0 ) then
				table.insert( aTable, getPedWeapon( thePlayer, slot ) )
			end
		end
		if ( toJSON( aTable ) ) then return toJSON( aTable ) else return "" end
	end
		
	-- Set the data
	if ( ammoTable[ source ] ) then exports.VGaccounts:setPlayerAccountData( source, "ammostring", toJSON( ammoTable[ source ] ) ) end
	exports.VGaccounts:setPlayerAccountData( source, "weaponstring", getWeaponsJSON( source ) )
end

-- When a player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		savePlayerWeaponTable( source, true )
	end
)

-- When a player dies
addEventHandler( "onPlayerWasted", root,
	function ()
		if not ( getElementData( source, "JoinTick" ) ) or ( getTickCount() - getElementData( source, "JoinTick" ) > 12000 ) then
			savePlayerWeaponTable( source )
		end
	end
)

-- When player switches weapon
addEventHandler ( 'onPlayerWeaponSwitch', root,
	function ()
		updatePlayerWeaponTable( source )
	end
)

-- Function that restores the player weapons
function restorePlayerWeapons( thePlayer )
	local tableA = fromJSON( exports.VGaccounts:getPlayerAccountData( thePlayer, "weaponstring" ) )
	-- Return the player weapons
	if ( tableA ) then
		for i, weapon in ipairs( tableA ) do
			if ( ammoTable[ thePlayer ][ tostring( weapon ) ] ) and ( ammoTable[ thePlayer ][ tostring( weapon ) ] > 0 ) then
				giveWeapon ( thePlayer, tonumber( weapon ), ammoTable[ thePlayer ][ tostring( weapon ) ] )
			end
		end
	end
end

-- Function that gives the player a weapon
function givePlayerWeapon ( thePlayer, weapon, ammo, current )
	if ( isElement( thePlayer ) ) and ( weapon ) and ( ammo ) and ( ammoTable[ thePlayer ][ tostring( weapon ) ] ) then
		updatePlayerWeaponTable( thePlayer )
		local stock = ammoTable[ thePlayer ][ tostring( weapon ) ] or 0
		takeWeapon( thePlayer, weapon )
		giveWeapon( thePlayer, weapon, ammo + stock, current )
		return true
	else
		return false
	end
end

-- Function to take a weapon
addEvent( "onServerTakeWeapon", true )
addEventHandler( "onServerTakeWeapon", root,
	function ( weapon )
		takeWeapon ( source, weapon )
	end
)