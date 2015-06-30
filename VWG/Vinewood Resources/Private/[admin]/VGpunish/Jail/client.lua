-- Some variables
local sx, sy = guiGetScreenSize()
local theTime = false
local theTimer = false

-- Event when a player gets jailed
addEvent( "onSetPlayerJailed", true )
addEventHandler( "onSetPlayerJailed", root,
	function ( time )
		if ( time ) then
			theTime = time
			if not ( isTimer( theTimer ) ) then theTimer = setTimer( decreaseJailTime, 1000, 0 ) end
		else
			if ( isTimer( theTimer ) ) then killTimer( theTimer ) end
			theTime = false
		end
	end
)

-- Jail time render
addEventHandler( "onClientRender", root,
	function ()
		if ( theTime ) and ( theTime >= 0 ) then
			exports.VGdrawing:dxDrawBorderedText( theTime .. " seconds remaining!", sx*(969.0/1440),sy*(813.0/900),sx*(1394.0/1440),sy*(852.0/900), tocolor(8, 81, 180, 255), sx*(1.4/1440), "pricedown", "right", "top", false, false, true, false, false)
		end
	end
)

-- Function that decreases the jail time
function decreaseJailTime ()
	if ( theTime ) and ( theTime >= 0 ) then
		theTime = theTime - 1
	end
end

-- Function for when the resource start
addEventHandler( "onClientResourceStart", resourceRoot,
	function ()
		triggerServerEvent( "requestPlayerJailTime", localPlayer )
	end
)