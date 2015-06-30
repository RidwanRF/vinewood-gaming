local timer = nil
local isEnabled = false

function toggleWaterShader ( bool )
	if ( bool ) then
		if not ( isEnabled ) then
			-- Version check
			if getVersion ().sortable < "1.1.0" then
				return
			end

			-- Create shader
			myShader, tec = dxCreateShader ( "water.fx" )

			if myShader then
				-- Set textures
				textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
				textureCube = dxCreateTexture ( "images/cube_env256.dds" );
				dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
				dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );

				-- Apply to global txd 13
				engineApplyShaderToWorldTexture ( myShader, "waterclear256" )

				-- Update water color incase it gets changed by persons unknown
				timer = setTimer(	function()
								if myShader then
									local r,g,b,a = getWaterColor()
									dxSetShaderValue ( myShader, "sWaterColor", r/255, g/255, b/255, a/255 );
								end
							end
							,100,0 )
				isEnabled = true
			end
		end
	else
		if ( isEnabled ) then
			if ( isTimer( timer ) ) then killTimer( timer ) end
			destroyElement( textureVol )
			destroyElement( textureCube )
			engineRemoveShaderFromWorldTexture ( myShader, "waterclear256" )
			isEnabled = false
		end
	end
end

addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "shader2" ) then
			toggleWaterShader( newValue )
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if ( exports.VGsettings:getPlayerSetting( "shader2" ) ) then
			toggleWaterShader( true )
		end
	end
)