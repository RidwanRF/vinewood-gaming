-- Enable asynchronous model loading
engineSetAsynchronousLoading ( true, true )

-- Garbage table
local arr = {}

-- Check the mods that need to be downloaded
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
        arr.queue = {}
        
		for _, modification in ipairs( downloads ) do
			for _, fileName in ipairs( modification.files ) do
                if not ( fileExists( fileName ) ) and not ( arr.queue[ fileName ] ) then
                    arr.queue[ fileName ] = modification.model
                end
            end
		end

        for fileName, model in pairs( arr.queue ) do
            fetchRemote( "http://www.vinewoodgaming.com:1337/downloads/" .. fileName, onDownloadFinished, "", false, fileName, model )
        end
	end
)

-- Callback function for the fetchRemote
function onDownloadFinished ( data, error, fileName, model )
	if ( error == 0 ) then
		local file = fileCreate( fileName )
		fileWrite( file, data )
		fileFlush( file )
		fileClose( file )	
	else
		outputDebugString( "File download error: " .. error .. " - " .. fileName )
	end
end