-- Get the screen size of the player
local w, h = guiGetScreenSize()

-- Check if the shader is enabled
local isShaderEnabled = false

-- The render effect of the shader
function onDxDrawShader( )
	dxSetRenderTarget()
	dxUpdateScreenSource( screenSource )
	dxDrawImage( 0, 0, w, h, screenShader )
end

-- Function to toggle the shader
function toggleBlackWhiteShader ()
	if not ( isShaderEnabled ) then
		isShaderEnabled = true
		screenShader = dxCreateShader( "shader.fx" )
		screenSource = dxCreateScreenSource( w, h )
		if ( screenShader ) and ( screenSource ) then
			dxSetShaderValue( screenShader, "BlackWhiteTexture", screenSource )
			addEventHandler( "onClientHUDRender", root, onDxDrawShader )
		end
	else
		if ( screenShader ) and ( screenSource ) then
			isShaderEnabled = false
			destroyElement( screenShader )
			destroyElement( screenSource )
			screenShader, screenSource = nil, nil
			removeEventHandler( "onClientHUDRender", root, onDxDrawShader )
		end
	end
end