-- Table with the Lua shortcuts files
local files = {}

-- Grab the Lua shortcut files and store them
function init()
    for _, file in ipairs( { "server", "mandatory_server" } ) do
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
    if not ( bool ) and ( files['mandatory_server'] ) then
        return files['mandatory_server']
    elseif ( files['mandatory_server'] ) and ( files['server'] ) then
        return files['mandatory_server'] .. files['server']
    else
        return false
    end
end

-- Init the script
init()