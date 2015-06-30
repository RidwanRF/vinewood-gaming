

local table = table



-- Some tables 'n stuff to save data
local notificationsToDraw = {}
local notificationsTimers = {}

-- Unique number
local uniqueRands = {}

-- Screensize
local sx, sy = guiGetScreenSize()

-- Get a random number to identify the messages
local function uniqueRand ()
	local theRand = math.random( 0, 99999999 )
	for i=1,#uniqueRands do
		if ( uniqueRands[i] == theRand ) then
			uniqueRand ()
			return
		end
	end
	table.insert( uniqueRands, rand )
	return theRand
end

-- The exports to create a new DX message
addEvent( "onClientShowHudMessageDX", true )
function showHudMessageDX( theMessage, R, G, B, showTime )
	if not ( theMessage ) or not ( R ) or not ( G ) or not ( B ) then
		return false, "Wrong format"
	elseif ( showTime ) and ( showTime <= 1000 ) then
		return false, "Showtime is too short"
	else
		if not ( showTime ) then showTime = 10000 end
			
		for k, i in ipairs ( notificationsToDraw ) do
			if ( i[1] == theMessage ) then
				return false, "Message already exist"
			end
		end
			
		table.insert( notificationsToDraw, { theMessage, R, G, B, showTime, uniqueRand(), 0 } )
		return true, "Message created"
	end
end
addEventHandler( "onClientShowHudMessageDX", root, showHudMessageDX )

-- The function that handles the timers
local function isNotificationTimer ( index, theRand, showTime )
	if not ( notificationsTimers[ theRand ] ) and not ( isTimer( notificationsTimers[ theRand ] ) ) then
		notificationsTimers[ theRand ] = setTimer( destroyDxHudMessage, showTime, 0, theRand )
	else
		return true
	end
end

--Destroy the message
function destroyDxHudMessage ( theRand )
	for k, i in ipairs ( notificationsToDraw ) do
		if ( i[ 6 ] == theRand ) then
			table.remove( notificationsToDraw, k )
			return true, "Message removed"
		end
	end
end

-- The client render that keeps looping for new messages
addEventHandler( "onClientRender", root,
	function ()
		if ( notificationsToDraw ) and ( #notificationsToDraw > 0 ) then
			if ( notificationsToDraw[1] ) and ( isNotificationTimer ( 1, notificationsToDraw[1][6], notificationsToDraw[1][5] ) ) then
				dxDrawBorderedText( notificationsToDraw[1][1], sx*(328.0/1440),sy*(730.0/900),sx*(857.0/1440),sy*(748.0/900), tocolor ( notificationsToDraw[1][2], notificationsToDraw[1][3], notificationsToDraw[1][4], 225 ), sy*(1.6/1440), "default-bold", "left", "center", false, false, false, true )
			end
			
			if ( notificationsToDraw[2] ) and ( isNotificationTimer ( 2, notificationsToDraw[2][6], notificationsToDraw[2][5] ) ) then
				dxDrawBorderedText( notificationsToDraw[2][1], sx*(328.0/1440),sy*(754.0/900),sx*(857.0/1440),sy*(772.0/900), tocolor ( notificationsToDraw[2][2], notificationsToDraw[2][3], notificationsToDraw[2][4], 225 ), sy*(1.6/1440), "default-bold", "left", "center", false, false, false, true )
			end
			
			if ( notificationsToDraw[3] ) and ( isNotificationTimer ( 3, notificationsToDraw[3][6], notificationsToDraw[3][5] ) ) then
				dxDrawBorderedText( notificationsToDraw[3][1], sx*(328.0/1440),sy*(778.0/900),sx*(857.0/1440),sy*(796.0/900), tocolor ( notificationsToDraw[3][2], notificationsToDraw[3][3], notificationsToDraw[3][4], 225 ), sy*(1.6/1440), "default-bold", "left", "center", false, false, false, true )
			end
			
			if ( notificationsToDraw[4] ) and ( isNotificationTimer ( 4, notificationsToDraw[4][6], notificationsToDraw[4][5] ) ) then
				dxDrawBorderedText( notificationsToDraw[4][1], sx*(328.0/1440),sy*(802.0/900),sx*(857.0/1440),sy*(820.0/900), tocolor ( notificationsToDraw[4][2], notificationsToDraw[4][3], notificationsToDraw[4][4], 225 ), sy*(1.6/1440), "default-bold", "left", "center", false, false, false, true )
			end
		end
	end
)

-- Special magical function that draws text with a nice border
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( string.gsub( text,"#%x%x%x%x%x%x", "" ), x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, true )
end