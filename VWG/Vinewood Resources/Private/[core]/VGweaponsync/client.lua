-- Check if the weapon the player fired has still ammo left
addEventHandler( "onClientPlayerWeaponFire", root,
	function ( weapon, ammo, ammoInClip )
		if ( source == localPlayer ) then
			if ( ammo == 0 ) then triggerServerEvent( "onServerTakeWeapon", localPlayer, weapon ) end
		end
	end
)