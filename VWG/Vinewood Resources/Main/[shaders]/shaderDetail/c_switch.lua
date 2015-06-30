--------------------------------
-- Switch effect on or off
--------------------------------
function toggleDetailShader( bool )
	if ( bool ) then
		enableDetail()
	else
		disableDetail()
	end
end

addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "shader5" ) then
			toggleDetailShader( newValue )
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if ( exports.VGsettings:getPlayerSetting( "shader5" ) ) then
			toggleDetailShader( true )
		end
	end
)
