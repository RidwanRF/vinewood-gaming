setWeaponProperty ( 23, "poor", "maximum_clip_ammo", 1 )
setWeaponProperty ( 23, "std", "maximum_clip_ammo", 1 )
setWeaponProperty ( 23, "pro", "maximum_clip_ammo", 1 )

addEvent( "onPlayerTased", true )
function immobilizePlayer ()
	setPedAnimation ( source, "CRACK", "crckdeth2", -1, false )
	setTimer ( setPedAnimation, 2000, 1, source )
end
addEventHandler ( "onPlayerTased", root, immobilizePlayer )