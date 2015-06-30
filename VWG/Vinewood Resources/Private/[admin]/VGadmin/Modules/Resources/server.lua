--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--


local tostring = tostring




-- Event to start the resources window
addEvent( "onServerShowResourcesWindow", true )
addEventHandler( "onServerShowResourcesWindow", root,
	function ()
		if ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( client ) ) ), aclGetGroup( "Developer" ) ) ) then
			local resourceTable = {}
			for k, i in ipairs( getResources() ) do
				resourceTable[k] = { getResourceName( i ), getResourceState ( i ) }
			end
			triggerClientEvent( client, "onOpenResourcesWindow", client, resourceTable )
		end
	end
)

-- Resource event
addEvent ( "onUpdateResourceState", true )
addEventHandler ( "onUpdateResourceState", root,
	function ( theType, theResource, theRow )
		if ( getResourceFromName( theResource ) ) and ( ( isObjectInACLGroup ( "user.".. tostring ( string.lower( exports.VGaccounts:getPlayerAccountName( client ) ) ), aclGetGroup( "Developer" ) ) ) ) then
			if ( theType == "start" ) then
				if ( startResource ( getResourceFromName( theResource ) ) ) then
					outputChatBox( "You started "..theResource, client, 0, 225, 0 )
					triggerClientEvent( client, "setResourceColor", client, theRow, 0, 225, 0 )
				elseif ( getResourceState ( getResourceFromName( theResource ) ) == "running" ) or ( getResourceState ( getResourceFromName( theResource ) ) == "starting" ) then
					outputChatBox( theResource.." is already running or starting!", client, 0, 225, 0 )
				else
					outputChatBox( theResource.." failed to start, reason: "..getResourceLoadFailureReason ( getResourceFromName( theResource ) ), client, 225, 0, 0 )
				end
			elseif ( theType == "restart" ) then
				if ( restartResource ( getResourceFromName( theResource ) ) ) then
					outputChatBox( "You restarted "..theResource, client, 0, 225, 0 )
				elseif ( getResourceState ( getResourceFromName( theResource ) ) == "starting" ) then
					outputChatBox( theResource.." is already starting!", client, 0, 225, 0 )
				else
					outputChatBox( theResource.. " failed to restart, reason: "..getResourceLoadFailureReason ( getResourceFromName( theResource ) ), client, 225, 0, 0 )
				end
			elseif ( theType == "stop" ) then
				if ( stopResource ( getResourceFromName( theResource ) ) ) then
					outputChatBox( "You stopped "..theResource, client, 0, 225, 0 )
					triggerClientEvent( client, "setResourceColor", client, theRow, 225, 0, 0 )
				elseif ( getResourceState ( getResourceFromName( theResource ) ) == "stopping" ) or ( getResourceState ( getResourceFromName( theResource ) ) == "loaded" ) then
					outputChatBox( theResource.." is already stopping or stopped!", client, 0, 225, 0 )
				else
					outputChatBox( theResource.. " failed to stop, reason: "..getResourceLoadFailureReason ( getResourceFromName( theResource ) ), client, 225, 0, 0 )
				end
			end
		end
	end
)