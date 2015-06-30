-- Table with peds in it
local peds = {}

-- Function to create a static ped
function createStaticPed( id, x, y, z, rot )
	local thePed = createPed ( id, x, y, z, rot, false )
	if ( thePed ) then
		peds[ thePed ] = thePed
		return thePed
	else
		return false
	end
end

-- Cancel the damage of the static pet
addEventHandler ( "onClientPedDamage", root,
	function ()
		if ( peds[ source ] ) then
			cancelEvent()
		end
	end
)