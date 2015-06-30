createObject ( 3409, -1010, -1058.8, 128.2 )
createObject ( 3409, -1014.1, -1058.8, 128.2 )
createObject ( 3409, -1018, -1058.8, 128.2 )
createObject ( 3409, -1022.1, -1058.8, 128.2 )


local plants = {}


--addCommandHandler("plant", root, function() end )


function analyse (dn, ov)
	
	--outputChatBox(getElementType(source).."|"..dn)
end 
addEventHandler("onClientElementDataChange", root, analyse)
