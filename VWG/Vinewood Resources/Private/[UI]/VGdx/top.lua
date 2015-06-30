

local table = table

local unpack = unpack

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
addEvent( "onClientShowMessageDX", true )
function showMessageDX( theMessage, R, G, B, showTime )
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
			
		table.insert( notificationsToDraw, { theMessage, R, G, B, showTime, uniqueRand() } )
		return true, "Message created"
	end
end
addEventHandler( "onClientShowMessageDX", root, showMessageDX )

-- The function that handles the timers
local function isNotificationTimer ( index, theRand, showTime )
	if not ( notificationsTimers[ theRand ] ) and not ( isTimer( notificationsTimers[ theRand ] ) ) then
		notificationsTimers[ theRand ] = setTimer( destroyDxMessage, showTime, 0, theRand )
	else
		return true
	end
end

--Destroy the message
function destroyDxMessage ( theRand )
	for k, i in ipairs ( notificationsToDraw ) do
		if ( i[ 6 ] == theRand ) then
			table.remove( notificationsToDraw, k )
			return true, "Message removed"
		end
	end
end

-- Function to check if the message is the last one
local function getNotificationAlpha ( index )
	if not ( notificationsToDraw[ index +1 ] ) or ( index == 1 ) then
		return 255
	elseif ( index == 2 ) then
		return 255
	elseif ( index == 3 ) then
		return 163
	elseif ( index == 4 ) then
		return 129
	elseif ( index == 5 ) then
		return 79
	end
end

-- The client render that keeps looping for new messages
addEventHandler( "onClientRender", root,
	function ()
		if ( notificationsToDraw ) and ( #notificationsToDraw > 0 ) then			
			if ( notificationsToDraw[5] ) and ( isNotificationTimer ( 5, notificationsToDraw[5][6], notificationsToDraw[5][5] ) ) then
				dxDrawImage(sx*(420.0/1440),sy*(113.0/900),sx*(673.0/1440),sy*(23.0/900), "messagebox.png", 0, 0, 0, tocolor(0, 0, 0, getNotificationAlpha ( 5 )), false)
				exports.VGdrawing:dxDrawBorderedText(notificationsToDraw[5][1], sx*(419.0/1440),sy*(113.0/900),sx*(1092.0/1440),sy*(135.0/900), tocolor(notificationsToDraw[5][2], notificationsToDraw[5][3], notificationsToDraw[5][4], 255), 1.0, "default-bold", "center", "center", false, false, false, false, false)
			end
			
			if ( notificationsToDraw[4] ) and ( isNotificationTimer ( 4, notificationsToDraw[4][6], notificationsToDraw[4][5] ) ) then
				dxDrawImage(sx*(420.0/1440),sy*(85.0/900),sx*(673.0/1440),sy*(23.0/900), "messagebox.png", 0, 0, 0, tocolor(0, 0, 0, getNotificationAlpha ( 4 )), false)
				exports.VGdrawing:dxDrawBorderedText(notificationsToDraw[4][1], sx*(419.0/1440),sy*(85.0/900),sx*(1092.0/1440),sy*(107.0/900), tocolor(notificationsToDraw[4][2], notificationsToDraw[4][3], notificationsToDraw[4][4], 255), 1.0, "default-bold", "center", "center", false, false, false, false, false)
			end
			
			if ( notificationsToDraw[3] ) and ( isNotificationTimer ( 3, notificationsToDraw[3][6], notificationsToDraw[3][5] ) ) then
				dxDrawImage(sx*(420.0/1440),sy*(58.0/900),sx*(673.0/1440),sy*(23.0/900), "messagebox.png", 0, 0, 0, tocolor(0, 0, 0, getNotificationAlpha ( 3 )), false)
				exports.VGdrawing:dxDrawBorderedText(notificationsToDraw[3][1], sx*(419.0/1440),sy*(59.0/900),sx*(1092.0/1440),sy*(81.0/900), tocolor(notificationsToDraw[3][2], notificationsToDraw[3][3], notificationsToDraw[3][4], 255), 1.0, "default-bold", "center", "center", false, false, false, false, false)
			end
			
			if ( notificationsToDraw[2] ) and ( isNotificationTimer ( 2, notificationsToDraw[2][6], notificationsToDraw[2][5] ) ) then
				dxDrawImage(sx*(420.0/1440),sy*(30.0/900),sx*(673.0/1440),sy*(23.0/900), "messagebox.png", 0, 0, 0, tocolor(0, 0, 0, getNotificationAlpha ( 2 )), false)
				exports.VGdrawing:dxDrawBorderedText(notificationsToDraw[2][1], sx*(419.0/1440),sy*(31.0/900),sx*(1092.0/1440),sy*(53.0/900), tocolor(notificationsToDraw[2][2], notificationsToDraw[2][3], notificationsToDraw[2][4], 255), 1.0, "default-bold", "center", "center", false, false, false, false, false)
			end
			
			if ( notificationsToDraw[1] ) and ( isNotificationTimer ( 1, notificationsToDraw[1][6], notificationsToDraw[1][5] ) ) then
				dxDrawImage(sx*(420.0/1440),sy*(3.0/900),sx*(673.0/1440),sy*(23.0/900), "messagebox.png", 0, 0, 0, tocolor(0, 0, 0, getNotificationAlpha ( 1 )), false)
				dxDrawImage(sx*(420.0/1440),sy*(3.0/900),sx*(673.0/1440),sy*(23.0/900), "messagebox.png", 0, 0, 0, tocolor(0, 0, 0, getNotificationAlpha ( 1 )), false)
				exports.VGdrawing:dxDrawBorderedText(notificationsToDraw[1][1], sx*(419.0/1440),sy*(4.0/900),sx*(1092.0/1440),sy*(26.0/900), tocolor(notificationsToDraw[1][2], notificationsToDraw[1][3], notificationsToDraw[1][4], 255), 1.0, "default-bold", "center", "center", false, false, false, false, false)
			end
		end
	end
)

-- Some info messages that show every once in a while
local addsTable = {
	{ "The server is still being developed! Report bugs at vinewoodgaming.com", 255, 100, 0 },
	{ "Join the discussion! Visit our forum: vinewoodgaming.com", 0, 238, 238 },
	{ "Any bugs or problems found? Report it at our forum! vinewoodgaming.com", 0, 238, 238 },
}

-- Timer to show it
setTimer(
	function ()
		showMessageDX( unpack ( addsTable [ math.random ( #addsTable ) ] ) )
	end, 180000, 0
)