
local type = type

-- Some variables
local screenWidth, screenHeight = guiGetScreenSize()
local isDrawing = false
local missionPrice = false

-- Function that shows the mission passed text
function showPlayerMissionPassed( aPrice )
	if ( aPrice ) and ( type( aPrice ) == "string" ) and not ( isDrawing ) then
		missionPrice = aPrice
		isDrawing = true
		setTimer( hideMissionPassedText, 8000, 1 )
		playSound ( "mission_passed.mp3" )
		addEventHandler( "onClientRender", root, drawMissionPassedText )
	else
		return false
	end
end

-- Function that hides the mission passed text
function hideMissionPassedText ()
	removeEventHandler( "onClientRender", root, drawMissionPassedText )
	missionPrice = false
	isDrawing = false
end

-- The function to render the text
function drawMissionPassedText ()
	if ( missionPrice ) then 
		dxDrawMissionBorderedText( "Mission passed!", screenWidth/2 - 100 + 4, screenHeight/2 - 50 + 4, screenWidth/2 +  100, screenHeight/2, tocolor ( 238, 154, 0, 255 ), 2.6, "pricedown", "center", "center", tocolor ( 0, 0, 0, 255 ) )
		dxDrawMissionBorderedText( missionPrice, screenWidth/2 - 100 + 4, screenHeight/2 + 4, screenWidth/2 +  100, screenHeight/2 + 80, tocolor ( 225, 225, 225, 225 ), 2.4, "pricedown", "center", "center", tocolor ( 0, 0, 0, 255 ) ) 
	end
end

-- Function to draw the borders and the text
function dxDrawMissionBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale +0.05, font, alignX, alignY )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY )
end