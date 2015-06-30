--function to check if inventory item is a drug item or not
function isDrugItem (itemName)
	for i, v in ipairs(drugItems) do
		if ( i == itemName ) then return true end
	end
	return false
end