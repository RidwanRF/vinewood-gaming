--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--




-- / note command by Hellstunter
addCommandHandler("note",
function (player,cmd,...)
	local text = table.concat({...}, " ") 
	if ( exports.VGadmin:isPlayerAdmin( player ) )  then
		outputChatBox("#FF0000(NOTE) "..getPlayerName(player)..": #FFFFFF "..text, root, 255, 255, 255, true)
	end
end
)

-- TODO