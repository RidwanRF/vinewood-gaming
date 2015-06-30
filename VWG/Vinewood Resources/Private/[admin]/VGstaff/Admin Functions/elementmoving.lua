-- Table needed for staff moving things
local mTable = {}

-- Command to start the element moving
addCommandHandler("elementmove", 
	function ()
		if ( getTeamName( getPlayerTeam( localPlayer  )) == "Staff" ) then
			if not ( mTable.isMoving ) then
				showCursor( true )
				addEventHandler( "onClientClick", root, startMoveElement )
				mTable.isMoving = true
			else
				if ( isTimer( mTable.timer ) ) then killTimer( mTable.timer ) end
				showCursor( false )
				removeEventHandler( "onClientClick", root, startMoveElement )
				mTable.isMoving = false
			end
		end
	end
)

-- Function that handles the moving
function startMoveElement( _, _, _, _, _, _, _, theElement )
	if ( theElement ) and ( isElement( theElement ) ) and not ( isElementFrozen( theElement ) ) and ( theElement ~= localPlayer ) then
		if ( getElementType( theElement ) == "vehicle" ) or ( getElementType( theElement ) == "player" ) then
			mTable.element = theElement
			addEventHandler( "onClientRender", root, attachElementToMouse )
			removeEventHandler( "onClientClick", root, startMoveElement )
			addEventHandler( "onClientClick", root, stopMoveElement )
			addEventHandler( "onClientElementDestroy", theElement, stopMoveElement )
			mTable.timer = setTimer( onElementMoving, 200, 0 )
			triggerServerEvent( "onMovementElementStopStart", localPlayer, mTable.element, true )
		end
	end
end

-- Attach the element to the mouse
function attachElementToMouse ()
	local _, _, worldx, worldy, worldz = getCursorPosition ()
	local px, py, pz = getCameraMatrix ()
	local hit, x, y, z, elementHit = processLineOfSight( px, py, pz, worldx, worldy, worldz )
	local x0, y0, z0, x1, y1, z1 = getElementBoundingBox( mTable.element )
	if ( hit ) then
		setElementPosition( mTable.element, x, y, z + ( z1 - z0 ) )
	else
		setElementPosition( mTable.element, worldx, worldy, worldz + ( z1 - z0 ) )
	end
end

-- When the element is moving, update it
function onElementMoving()
	if ( mTable.element ) and ( isElement( mTable.element ) ) then
		local x, y, z = getElementPosition( mTable.element )
		triggerServerEvent( "onMovementElementUpdate", localPlayer, mTable.element, x, y, z )
	end
end

-- Stop the element moving
function stopMoveElement()
	if ( isTimer( mTable.timer ) ) then killTimer( mTable.timer ) end
	if ( mTable.element ) and ( isElement( mTable.element ) ) then
		removeEventHandler( "onClientRender", root, attachElementToMouse )
		removeEventHandler( "onClientClick", root, stopMoveElement )
		removeEventHandler( "onClientElementDestroy", mTable.element, stopMoveElement )
		triggerServerEvent( "onMovementElementStopStart", localPlayer, mTable.element, false )
		onElementMoving( mTable.element )
		mTable.element = false
		showCursor( false )
		mTable.isMoving = false
	end
end