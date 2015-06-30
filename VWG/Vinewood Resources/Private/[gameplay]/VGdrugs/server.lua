addEvent("onPlayerCollectDrugsFromMachine", true)
function givePlayerDrug (itemName, amount)
	if ( itemName ) and ( amount ) then
		exports.VGinventory:givePlayerItem ( client, itemName, amount ) 
	end
end
addEventHandler("onPlayerCollectDrugsFromMachine", root, givePlayerDrug)