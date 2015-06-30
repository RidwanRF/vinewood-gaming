--------------------------------
-- Switch effect on or off
--------------------------------
function toggleContrastShader ( bool )
	if ( bool ) then
		enableContrast()
	else
		disableContrast()
	end
end

addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "shader4" ) then
			toggleContrastShader( newValue )
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if ( exports.VGsettings:getPlayerSetting( "shader4" ) ) then
			toggleContrastShader( true )
		end
	end
)