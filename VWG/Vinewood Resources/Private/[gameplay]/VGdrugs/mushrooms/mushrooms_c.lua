

local txd = engineLoadTXD ( "mushrooms/mushroom.txd" )
engineImportTXD ( txd, 1942)

local dff = engineLoadDFF ( "mushrooms/mushroom.dff" )
engineReplaceModel ( dff, 1942 )

addEvent ( "toggleMushroomMessage", true )
function toggleMushroomMessage ( state )
	if ( source ~= localPlayer ) then return end
	if ( state == "on" ) then
		mushroomLabel = guiCreateLabel(0, 0.7, 1, 0.3, "Press F catch the mushroom", true)
		guiLabelSetHorizontalAlign(mushroomLabel, "center", true)
		bindKey ( "f", "down", pickMushroom )
	elseif ( state == "off" ) then
		unbindKey("f", "down", pickMushroom)
		if ( mushroomLabel ) and ( isElement( mushroomLabel ) ) then destroyElement( mushroomLabel ) end
	end
end
addEventHandler ( "toggleMushroomMessage", root, toggleMushroomMessage )

function pickMushroom ()
	if ( mushroomLabel ) and ( isElement( mushroomLabel ) ) then destroyElement( mushroomLabel ) end
	unbindKey("f", "down", pickMushroom)
	triggerServerEvent("onPlayerPickMushroom", localPlayer)
end

setDevelopmentMode(true)