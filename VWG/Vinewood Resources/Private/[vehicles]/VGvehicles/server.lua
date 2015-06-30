



-- Table with vehicles that are not lockable
local notLockableVehicles = { 
	[594] = true, [606] = true, [607] = true, [611] = true, [584] = true, [608] = true,
	[435] = true, [450] = true, [591] = true, [539] = true, [441] = true, [464] = true, 
	[501] = true, [465] = true, [564] = true, [472] = true, [473] = true, [493] = true, 
	[595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, 
	[454] = true, [581] = true, [509] = true, [481] = true, [462] = true, [521] = true,
	[463] = true, [510] = true, [522] = true, [461] = true, [448] = true, [468] = true, 
	[586] = true, [425] = true, [520] = true, [523] = true,
}

-- When a player login
addEvent( "onServerPlayerLogin" )
addEventHandler( "onServerPlayerLogin", root,
	function ()
		local userID = exports.VGaccounts:getPlayerAccountID( source )
		local table = exports.VGmysql:query( "GEW783UH230WEGE978GW", "SELECT * FROM vehicles WHERE userid = ?", userID )
		exports.VGdata:setPlayerVehicleTable( source, table )
		bindKey( source, "f3", "down", onPlayerShowVehicleWindow )
		exports.VGdata:createPlayerVehicles( source )
	end
)

-- Bind the key on resrouce start
addEventHandler( "onResourceStart", resourceRoot,
	function ()
		for k, thePlayer in ipairs( getElementsByType( "player" ) ) do
			if ( exports.VGaccounts:isPlayerLoggedIn( thePlayer ) ) then
				bindKey( thePlayer, "f3", "down", onPlayerShowVehicleWindow )
			end
		end
	end
)

-- When a player quits
addEventHandler( "onPlayerQuit", root,
	function ()
		if ( exports.VGaccounts:isPlayerLoggedIn( source ) ) then
			savePlayerVehicles( source, true )
		end
	end
)

-- Function that saves the vehicles of a player
function savePlayerVehicles( thePlayer, destroy )
	if ( exports.VGaccounts:getPlayerAccountID( thePlayer ) ) and ( exports.VGdata:getPlayerVehicleTable( thePlayer ) ) then
		local aTable = exports.VGdata:getPlayerVehicleTable( thePlayer )
		for i = 1, #aTable do
			local x, y, z = getElementPosition( aTable[i].vehicle )
			local _, _, rotation = getElementRotation( aTable[i].vehicle )
			local R1, G1, B1, R2, G2, B2 = getVehicleColor( aTable[i].vehicle, true )
			exports.VGmysql:query( "GEW783UH230WEGE978GW", "UPDATE vehicles SET x=?, y=?, z=?, rotation=?, health=?, fuel=?, paintjob=?, color1=?, color2=?, locked=? WHERE vehicleid=?"
				,x
				,y
				,z
				,rotation
				,getElementHealth( aTable[i].vehicle )
				,exports.VGfuel:getVehicleFuel( aTable[ i ].vehicle )
				,getVehiclePaintjob( aTable[i].vehicle )
				,string.format( "#%.2X%.2X%.2X", R1, G1, B1 )
				,string.format( "#%.2X%.2X%.2X", R2, G2, B2 )
				,0
				,aTable[i].vehicleid
			)
			
			-- Do we want to destroy them?
			if ( destroy ) and ( isElement( aTable[i].vehicle ) ) then
				destroyElement( aTable[i].vehicle )
			end
		end
	end
end

-- Show the player's vehicle window
function onPlayerShowVehicleWindow( thePlayer )
	-- Check if the player's vehicles are loaded if not load them
	if not ( exports.VGdata:getPlayerVehicleTable( thePlayer ) ) or ( #exports.VGdata:getPlayerVehicleTable( thePlayer ) == 0 ) then
		local userID = exports.VGaccounts:getPlayerAccountID( thePlayer )
		local table = exports.VGmysql:query( "GEW783UH230WEGE978GW", "SELECT * FROM vehicles WHERE userid = ?", userID )
		exports.VGdata:setPlayerVehicleTable( thePlayer, table )
	end
	
	-- Trigger the event to show the window
	triggerClientEvent( thePlayer, "onClientShowVehicleWindow", thePlayer, exports.VGdata:getPlayerVehicleTable( thePlayer ) )
end