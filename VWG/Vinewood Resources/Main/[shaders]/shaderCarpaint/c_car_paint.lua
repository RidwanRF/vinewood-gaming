--
-- c_car_paint.lua
--

local isEnabled = false

function toggleCarShader ( bool )
	if ( bool ) then
		if not ( isEnabled ) then
			-- Version check
			if getVersion ().sortable < "1.1.0" then
				return
			end

			-- Create shader
			myShader, tec = dxCreateShader ( "car_paint.fx" )

			if myShader then
				-- Set textures
				textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
				textureCube = dxCreateTexture ( "images/cube_env256.dds" );
				dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
				dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );

				-- Apply to world texture
				engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
				engineApplyShaderToWorldTexture ( myShader, "?emap*" )
			end
			
			isEnabled = true
		end
	else
		if ( isEnabled ) then
			destroyElement( textureVol )
			destroyElement( textureCube )
			engineRemoveShaderFromWorldTexture ( myShader, "vehiclegrunge256" )
			engineRemoveShaderFromWorldTexture ( myShader, "?emap*" )
			isEnabled = false
		end
	end
end

addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "shader7" ) then
			toggleCarShader( newValue )
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if ( exports.VGsettings:getPlayerSetting( "shader7" ) ) then
			toggleCarShader( true )
		end
	end
)
