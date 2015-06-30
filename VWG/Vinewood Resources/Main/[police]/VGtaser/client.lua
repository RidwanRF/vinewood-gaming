--TASER
function onStart ()
	txd = engineLoadTXD ( "taser.txd" )
	engineImportTXD ( txd, 347 )
	dff = engineLoadDFF ( "taser.dff", 347 )
	engineReplaceModel ( dff, 347 )
end


function playTaserSound ( weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	if ( weapon == 23 ) and ( hitElement ) and ( getElementType ( hitElement ) == "player" ) and ( exports.VGplayers:getPlayerWantedPoints ( hitElement ) >10 ) and ( exports.VGlaw:isPlayerLaw ( source ) ) then
		local x,y,z = getElementPosition(source)
		if ( getDistanceBetweenPoints3D ( x, y, z, hitX, hitY, hitZ ) < 10 ) then
			local sound = playSound3D( "taser.wav", hitX, hitY, hitZ, true )
			setSoundMaxDistance( sound,100 )
			setSoundVolume( sound, 1 )
			setTimer( destroyElement, 2000, 1, sound )
			triggerServerEvent( "onPlayerTased", hitElement )
		end
	end
end
addEventHandler( "onClientPlayerWeaponFire", root, playTaserSound )

function shootsHandler ( attacker, weapon )
	if ( weapon == 23 ) then
		cancelEvent()
	end
end
addEventHandler( "onClientPlayerDamage", root,  shootsHandler )

onStart ()