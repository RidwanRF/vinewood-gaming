-- Table with the Lua shortcuts files
local files = {}

-- Grab the Lua shortcut files and store them
function init()
    for _, file in ipairs( { "client", "mandatory_client", "dx" } ) do
        if ( fileExists( file ) ) then
            local _file = fileOpen( file )
            local buff

            buff = fileRead( _file, fileGetSize( _file ) )

            fileClose( _file )

            files[ file ] = buff
        end
    end
end

-- Get function for the shortcuts
function load( bool )
    if ( bool ) and ( files[ bool ] ) then
        return files[ bool ]
    end

    if not ( bool ) and ( files['mandatory_client'] ) then
        return files['mandatory_client']
    elseif ( files['mandatory_client'] ) and ( files['client'] ) then
        return files['mandatory_client'] .. files['client']
    else
        return false
    end
end

-- Init the script
init()