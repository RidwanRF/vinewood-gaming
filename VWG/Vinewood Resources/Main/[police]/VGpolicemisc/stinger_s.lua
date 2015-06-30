addEvent( "onCreateStinger", true )
addEventHandler( "onCreateStinger", root,
	function ( x, y, z, rx, ry, rz )
		if not ( playerStinger[source] ) then
			local theStinger = createObject( 2899, x, y, z+0.1, rx, ry, rz )
			playerStinger[source] = theStinger
			setTimer( destroyStinger, 30000, 1, source )
			setElementData( theStinger, "isStinger", true )
			stingerPlant( source )
		end
	end
)

function stingerPlant( thePlayer )
	setPedAnimation( thePlayer, "BOMBER", "BOM_plant", 3000, false, false, false )
	setTimer( setPedAnimation, 2000, 1, thePlayer )
end

function destroyStinger ( thePlayer )
	if ( playerStinger[thePlayer] ) then
		destroyElement( playerStinger[thePlayer] )
		playerStinger[thePlayer] = false
	end
end
