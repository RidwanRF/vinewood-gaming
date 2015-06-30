--------------------------------
-- Switch effect on or off
--------------------------------
function toggleBlurShader( bool )
	if ( bool ) then
		enableRadialBlur()
	else
		disableRadialBlur()
	end
end

addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "shader6" ) then
			toggleBlurShader( newValue )
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if ( exports.VGsettings:getPlayerSetting( "shader6" ) ) then
			toggleBlurShader( true )
		end
	end
)