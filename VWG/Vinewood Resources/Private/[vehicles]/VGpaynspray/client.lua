-- Create the shader
local washTable = {}
local aShader = dxCreateShader( "shader/shader.fx" )

-- Function that applies the car cleaning to a car
function setVehicleDirtEnabled( theVehicle, bool )
	if ( aShader ) then
		if ( bool ) then
			engineRemoveShaderFromWorldTexture( aShader, "vehiclegrunge256", theVehicle )
			engineRemoveShaderFromWorldTexture( aShader, "?emap*", theVehicle )
			return true
		else
			engineApplyShaderToWorldTexture( aShader, "vehiclegrunge256", theVehicle )
			engineApplyShaderToWorldTexture( aShader, "?emap*", theVehicle )
			return true
		end
	else
		return false
	end
end

-- Event that changes the vehicle's dirt level
addEvent( "onChangeVehicleDirtLevel", true )
addEventHandler( "onChangeVehicleDirtLevel", root,
	function ( theVehicle )
		setVehicleDirtEnabled( theVehicle, bool )
	end
)

-- Delete the shader
fileDelete( "shader/shader.fx" )

-- Carwash sound
addEvent( "onClientPlayerCarwashSound", true )
addEventHandler( "onClientPlayerCarwashSound", root,
	function ( )
		playSound( "carwash.mp3" )
	end
)