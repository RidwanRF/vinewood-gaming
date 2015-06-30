-- Check the whitelist
addEventHandler( "onPlayerConnect", root,
	function ( _, _, _, serial )
		if not ( exports.VGmysql:querySingle( "GEW783UH230WEGE978GW", "SELECT * FROM whitelist WHERE serial=?", serial ) ) then
			cancelEvent( true, "This serial has not yet been activated for the BETA release!" )
		end
	end
)