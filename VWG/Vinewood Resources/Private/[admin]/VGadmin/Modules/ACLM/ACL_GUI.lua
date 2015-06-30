--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	gui\admin_acl.lua
*
*	Original File by lil_Toady
*
**************************************]]


local table = table



local tonumber = tonumber
local loadstring = loadstring

aAclForm = nil
aAclData = {}

function aManageACL ()
	if ( aAclForm == nil ) then
		aAclData["group_objects"] = {}
		aAclData["group_acls"] = {}
		aAclData["acl_rights"] = {}
		local x, y = guiGetScreenSize()
		aAclForm		= guiCreateWindow ( x / 2 - 230, y / 2 - 250, 460, 500, "VG ACL Management", false )
		aACLList		= guiCreateGridList ( 0.03, 0.05, 0.50, 0.90, true, aAclForm )
					   guiGridListSetSortingEnabled ( aACLList, false )
					   guiGridListAddColumn( aACLList, "", 0.10 )
					   guiGridListAddColumn( aACLList, "", 0.85 )
		aACLCreateGroup	= guiCreateButton ( 0.55, 0.05, 0.40, 0.04, "Create group", true, aAclForm )
		aACLCreateACL		= guiCreateButton ( 0.55, 0.10, 0.40, 0.04, "Create ACL", true, aAclForm )
		aACLLabel		= guiCreateLabel ( 0.55, 0.19, 0.40, 0.04, "", true, aAclForm )
		aACLSeparator		= guiCreateStaticImage ( 0.55, 0.235, 0.40, 0.0025, "Functions/ACLM/images/dot.png", true, aAclForm )
		aACLDestroyGroup	= guiCreateButton ( 0.55, 0.25, 0.40, 0.04, "Destroy group", true, aAclForm )
		aACLDestroyACL	= guiCreateButton ( 0.55, 0.25, 0.40, 0.04, "Destroy ACL", true, aAclForm )
		aACLAddObject		= guiCreateButton ( 0.55, 0.30, 0.40, 0.04, "Add Object", true, aAclForm )
		aACLRemoveObject	= guiCreateButton ( 0.55, 0.35, 0.40, 0.04, "Remove Object", true, aAclForm )
		aACLAddACL		= guiCreateButton ( 0.55, 0.40, 0.40, 0.04, "Add ACL", true, aAclForm )
		aACLRemoveACL	= guiCreateButton ( 0.55, 0.45, 0.40, 0.04, "Remove ACL", true, aAclForm )

		aACLActionLabel	= guiCreateLabel ( 0.55, 0.31, 0.40, 0.04, "", true, aAclForm )
		aACLDropCurrent	= guiCreateEdit ( 0.55, 0.35, 0.40, 0.04, "", true, aAclForm )
					   guiSetEnabled ( aACLDropCurrent, false )
		aACLDropDown		= guiCreateStaticImage ( 0.91, 0.35, 0.04, 0.04, "Functions/ACLM/images/dropdown.png", true, aAclForm )
		aACLDropList		= guiCreateGridList ( 0.55, 0.35, 0.40, 0.30, true, aAclForm )
					   guiGridListAddColumn( aACLDropList, "", 0.85 )
					   guiSetVisible ( aACLDropList, false )
		aACLOk		= guiCreateButton ( 0.55, 0.40, 0.19, 0.04, "Ok", true, aAclForm )
		aACLCancel		= guiCreateButton ( 0.76, 0.40, 0.19, 0.04, "Cancel", true, aAclForm )

		aACLAddRight		= guiCreateButton ( 0.55, 0.30, 0.40, 0.04, "Add Right", true, aAclForm )
		aACLExit		= guiCreateButton ( 0.75, 0.90, 0.27, 0.04, "Close", true, aAclForm )
		aclDisplayOptions ( "", "" )

		addEvent ( "aAdminACL", true )
		addEventHandler ( "aAdminACL", getLocalPlayer(), aAdminACL )
		addEventHandler ( "onClientGUIClick", aAclForm, aClientACLClick )
		addEventHandler ( "onClientGUIDoubleClick", aAclForm, aClientACLDoubleClick )
		--Register With Admin Form
		--aRegister ( "ACLManage", aAclForm, aManageACL, aACLClose )
		triggerServerEvent ( "aAdmin", getLocalPlayer(), "sync", "aclgroups" )
	end
	guiSetVisible ( aAclForm, true )
	guiBringToFront ( aAclForm )
end

function aACLClose ( destroy )
	if ( ( destroy ) or ( aPerformanceACL and guiCheckBoxGetSelected ( aPerformanceACL ) ) ) then
		if ( aAclForm ) then
			removeEventHandler ( "onClientGUIClick", aAclForm, aClientACLClick )
			removeEventHandler ( "onClientGUIDoubleClick", aAclForm, aClientACLDoubleClick )
			destroyElement ( aAclForm )
			aAclForm = nil
		end
	else
		guiSetVisible ( aAclForm, false )
	end
end

function aAdminACL ( type, acltable )
	guiGridListClear ( aACLList )
	if ( type == "aclgroups" ) then
		aAclData["viewing"] = nil
		aAclData["group_row"] = guiGridListAddRow ( aACLList )
		guiGridListSetItemText ( aACLList, aAclData["group_row"], 2, "Groups:", true, false )
		aAclData["groups"] = acltable["groups"]
		for id, name in ipairs ( acltable["groups"] ) do
			local row = guiGridListAddRow ( aACLList )
			guiGridListSetItemText ( aACLList, row, 1, "+", false, false )
			guiGridListSetItemText ( aACLList, row, 2, name, false, false )
		end
		local row = guiGridListAddRow ( aACLList )
		aAclData["acl_row"] = guiGridListAddRow ( aACLList )
		guiGridListSetItemText ( aACLList, aAclData["acl_row"], 2, "ACL:", true, false )
		aAclData["acl"] = acltable["acl"]
		for id, name in ipairs ( acltable["acl"] ) do
			local row = guiGridListAddRow ( aACLList )
			guiGridListSetItemText ( aACLList, row, 1, "+", false, false )
			guiGridListSetItemText ( aACLList, row, 2, name, false, false )
		end
		aclDisplayOptions ( "", "" )
	elseif ( type == "aclobjects" ) then
		aAclData["group_row"] = guiGridListAddRow ( aACLList )
		guiGridListSetItemText ( aACLList, aAclData["group_row"], 2, "Groups:", true, false )
		for i, group in ipairs ( aAclData["groups"] ) do
			local group_row = guiGridListAddRow ( aACLList )
			guiGridListSetItemText ( aACLList, group_row, 2, group, false, false )
			if ( group == acltable["name"] ) then
				aclDisplayOptions ( "Group", acltable["name"] )
				aAclData["objects_row"] = guiGridListAddRow ( aACLList )
				aAclData["group_objects"][group] = acltable["objects"]
				guiGridListSetItemText ( aACLList, aAclData["objects_row"], 2, "  objects:", true, false )
				for j, object in ipairs ( acltable["objects"] ) do
					local row = guiGridListAddRow ( aACLList )
					guiGridListSetItemText ( aACLList, row, 2, "  "..object, false, false )
				end
				aAclData["acls_row"] = guiGridListAddRow ( aACLList )
				aAclData["group_acls"][group] = acltable["acl"]
				guiGridListSetItemText ( aACLList, aAclData["acls_row"], 2, "  acl:", true, false )
				for j, acl in ipairs ( acltable["acl"] ) do
					local row = guiGridListAddRow ( aACLList )
					guiGridListSetItemText ( aACLList, row, 2, "  "..acl, false, false )
				end
				guiGridListSetItemText ( aACLList, group_row, 1, "-", false, false )
			else
				guiGridListSetItemText ( aACLList, group_row, 1, "+", false, false )
			end
		end
		aAclData["acl_row"] = guiGridListAddRow ( aACLList )
		guiGridListSetItemText ( aACLList, aAclData["acl_row"], 2, "ACL:", true, false )
		for id, name in ipairs ( aAclData["acl"] ) do
			local row = guiGridListAddRow ( aACLList )
			guiGridListSetItemText ( aACLList, row, 1, "+", false, false )
			guiGridListSetItemText ( aACLList, row, 2, name, false, false )
		end
	elseif ( type == "aclrights" ) then
		aAclData["viewing"] = "rights"
		aAclData["group_row"] = guiGridListAddRow ( aACLList )
		guiGridListSetItemText ( aACLList, aAclData["group_row"], 2, "Groups:", true, false )
		for id, name in ipairs ( aAclData["groups"] ) do
			local row = guiGridListAddRow ( aACLList )
			guiGridListSetItemText ( aACLList, row, 1, "+", false, false )
			guiGridListSetItemText ( aACLList, row, 2, name, false, false )
		end
		aAclData["acl_row"] = guiGridListAddRow ( aACLList )
		guiGridListSetItemText ( aACLList, aAclData["acl_row"], 2, "ACL:", true, false )
		for i, acl in ipairs ( aAclData["acl"] ) do
			local acl_row = guiGridListAddRow ( aACLList )
			guiGridListSetItemText ( aACLList, acl_row, 2, acl, false, false )
			if ( acl == acltable["name"] ) then
				aAclData["acl_rights"][acl] = acltable["rights"]
				aclDisplayOptions ( "ACL", acltable["name"] )
				aAclData["rights_row"] = guiGridListAddRow ( aACLList )
				guiGridListSetItemText ( aACLList, aAclData["rights_row"], 2, "  rights:", true, false )
				for name, access in pairs ( acltable["rights"] ) do
					local row = guiGridListAddRow ( aACLList )
					guiGridListSetItemText ( aACLList, row, 2, "  "..name, false, false )
					if guiGridListSetItemColor then
						guiGridListSetItemColor ( aACLList, row, 2, access and 0 or 255, access and 255 or 0, 0, 255)
					end
				end
				guiGridListSetItemText ( aACLList, acl_row, 1, "-", false, false )
			else
				guiGridListSetItemText ( aACLList, acl_row, 1, "+", false, false )
			end
		end
	end
end

function aClientACLDoubleClick ( button )
	if ( button == "left" ) then
		if ( source == aACLList ) then
			local row = guiGridListGetSelectedItem ( aACLList )
			if ( row ~= -1 ) then
				local clicked = guiGridListGetItemText ( aACLList, row, 2 )
				local state = guiGridListGetItemText ( aACLList, row, 1 )
				if ( row > aAclData["acl_row"] ) then
					for i, acl in ipairs ( aAclData["acl"] ) do
						if ( acl == clicked ) then
							if ( state == "-" ) then
								triggerServerEvent ( "aAdmin", getLocalPlayer(), "sync", "aclgroups" )
							else
								triggerServerEvent ( "aAdmin", getLocalPlayer(), "sync", "aclrights", clicked )
							end
							return
						end
					end
				else
					for i, group in ipairs ( aAclData["groups"] ) do
						if ( group == clicked ) then
							if ( state == "-" ) then
								triggerServerEvent ( "aAdmin", getLocalPlayer(), "sync", "aclgroups" )
							else
								triggerServerEvent ( "aAdmin", getLocalPlayer(), "sync", "aclobjects", clicked )
							end
							return
						end
					end
				end
			end
		elseif ( source == aACLDropList ) then
			local row = guiGridListGetSelectedItem ( aACLDropList )
			if ( row ~= -1 ) then
				local clicked = guiGridListGetItemText ( aACLDropList, row, 1 )
				guiSetText ( aACLDropCurrent, clicked )
				guiSetVisible ( aACLDropList, false )
			end
		end
	end
end

function aClientACLClick ( button )
	if ( source ~= aACLDropList ) then guiSetVisible ( aACLDropList, false ) end
	if ( button == "left" ) then
		if ( source == aACLExit ) then
			aACLClose ( false )
		elseif ( source == aACLCreateGroup ) then
			aInputBox ( "Create ACL Group", "Enter group name:", "", "triggerServerEvent ( \"aAdmin\", getLocalPlayer(), \"aclcreate\", \"group\", $value )" )
		elseif ( source == aACLCreateACL ) then
			aInputBox ( "Create ACL", "Enter acl name:", "", "triggerServerEvent ( \"aAdmin\", getLocalPlayer(), \"aclcreate\", \"acl\", $value )" )
		elseif ( source == aACLAddObject ) then
			aInputBox ( "Create ACL Group", "Enter object name:", "", "triggerServerEvent ( \"aAdmin\", getLocalPlayer(), \"acladd\", \"object\", \""..aAclData["current"].."\", $value )" )
		elseif ( source == aACLAddRight ) then
			aInputBox ( "Create ACL", "Enter right name:", "", "triggerServerEvent ( \"aAdmin\", getLocalPlayer(), \"acladd\", \"right\", \""..aAclData["current"].."\", $value )" )
		elseif ( source == aACLDestroyGroup ) then
			aMessageBox ( "warning", "Are you sure to destroy "..aAclData["current"].." group?", "triggerServerEvent ( \"aAdmin\", getLocalPlayer(), \"acldestroy\", \"group\", \""..aAclData["current"].."\" )" )
		elseif ( source == aACLDestroyACL ) then
			aMessageBox ( "warning", "Are you sure to destroy "..aAclData["current"].." ACL?", "triggerServerEvent ( \"aAdmin\", getLocalPlayer(), \"acldestroy\", \"acl\", \""..aAclData["current"].."\" )" )
		elseif ( ( source == aACLRemoveObject ) or ( source == aACLAddACL ) or ( source == aACLRemoveACL ) ) then
			guiSetVisible ( aACLAddObject, false )
			guiSetVisible ( aACLRemoveObject, false )
			guiSetVisible ( aACLAddACL, false )
			guiSetVisible ( aACLRemoveACL, false )
			guiSetVisible ( aACLDropCurrent, true )
			guiSetVisible ( aACLDropDown, true )
			guiSetVisible ( aACLOk, true )
			guiSetVisible ( aACLCancel, true )
			guiSetVisible ( aACLActionLabel, true )
			guiGridListClear ( aACLDropList )
			local table = {}
			guiSetText ( aACLActionLabel, guiGetText ( source )..":" )
			if ( source == aACLRemoveObject ) then table = aAclData["group_objects"][aAclData["current"]]
			elseif ( source == aACLAddACL ) then table = aAclData["acl"]
			elseif ( source == aACLRemoveACL ) then table = aAclData["group_acls"][aAclData["current"]] end
			if ( #table >= 1 ) then guiSetText ( aACLDropCurrent, table[1] ) end
			for id, object in ipairs ( table ) do
				guiGridListSetItemText ( aACLDropList, guiGridListAddRow ( aACLDropList ), 1, object, false, false )
			end
		elseif ( source == aACLDropDown ) then
			guiSetVisible ( aACLDropList, true )
			guiBringToFront ( aACLDropList )
		elseif ( source == aACLCancel ) then
			aclDisplayOptions ( aAclData["viewing"], aAclData["current"] )
		elseif ( source == aACLOk ) then
			local action = guiGetText ( aACLActionLabel )
			if ( action == "Remove Object:" ) then
				triggerServerEvent ( "aAdmin", getLocalPlayer(), "aclremove", "object", aAclData["current"], guiGetText ( aACLDropCurrent ) )
			elseif ( action == "Add ACL:" ) then
				triggerServerEvent ( "aAdmin", getLocalPlayer(), "acladd", "acl", aAclData["current"], guiGetText ( aACLDropCurrent ) )
			elseif ( action == "Remove ACL:" ) then
				triggerServerEvent ( "aAdmin", getLocalPlayer(), "aclremove", "acl", aAclData["current"], guiGetText ( aACLDropCurrent ) )
			end
		end
	end
end

function aclDisplayOptions ( state, name )
	guiSetVisible ( aACLSeparator, false )
	aAclData["viewing"] = state
	if ( state ~= "" ) then
		aAclData["current"] = name
		guiSetVisible ( aACLSeparator, true )
		guiSetText ( aACLLabel, state..": "..name )
	else
		aAclData["current"] = ""
		guiSetText ( aACLLabel, "" )
	end
	guiSetVisible ( aACLDestroyGroup, false )
	guiSetVisible ( aACLDestroyACL, false )
	guiSetVisible ( aACLAddObject, false )
	guiSetVisible ( aACLRemoveObject, false )
	guiSetVisible ( aACLAddACL, false )
	guiSetVisible ( aACLRemoveACL, false )
	guiSetVisible ( aACLAddRight, false )
	guiSetVisible ( aACLDropCurrent, false )
	guiSetVisible ( aACLDropList, false )
	guiSetVisible ( aACLDropDown, false )
	guiSetVisible ( aACLCancel, false )
	guiSetVisible ( aACLOk, false )
	guiSetVisible ( aACLActionLabel, false )
	if ( state == "ACL" ) then
		guiSetVisible ( aACLDestroyACL, true )
		guiSetVisible ( aACLAddRight, true )
	elseif ( state == "Group" ) then
		guiSetVisible ( aACLDestroyGroup, true )
		guiSetVisible ( aACLAddObject, true )
		guiSetVisible ( aACLAddACL, true )
		guiSetVisible ( aACLRemoveObject, true )
		guiSetVisible ( aACLRemoveACL, true )
	end
end

aInputForm = nil

function aInputBox ( title, message, default, action )
	if ( aInputForm == nil ) then
		local x, y = guiGetScreenSize()
		aInputForm		= guiCreateWindow ( x / 2 - 150, y / 2 - 64, 300, 110, "", false )
				  	   guiWindowSetSizable ( aInputForm, false )
		aInputLabel		= guiCreateLabel ( 20, 24, 270, 15, "", false, aInputForm )
					   guiLabelSetHorizontalAlign ( aInputLabel, "center" )
		aInputValue		= guiCreateEdit ( 35, 47, 230, 24, "", false, aInputForm )
		aInputOk		= guiCreateButton ( 90, 80, 55, 17, "Ok", false, aInputForm )
		aInputCancel		= guiCreateButton ( 150, 80, 55, 17, "Cancel", false, aInputForm )
		guiSetProperty ( aInputForm, "AlwaysOnTop", "true" )
		aInputAction = nil

		addEventHandler ( "onClientGUIClick", aInputForm, aInputBoxClick )
		addEventHandler ( "onClientGUIAccepted", aInputValue, aInputBoxAccepted )
		--Register With Admin Form
		--aRegister ( "InputBox", aInputForm, aInputBox, aInputBoxClose )
	end
	guiSetInputEnabled ( true )
	guiSetText ( aInputForm, title )
	guiSetText ( aInputLabel, message )
	guiSetText ( aInputValue, default )
	aHideFloaters()
	guiSetVisible ( aInputForm, true )
	guiBringToFront ( aInputForm )
	aInputAction = action
end

function aInputBoxClose ( destroy )
	guiSetInputEnabled ( false )
	if ( destroy ) then
		if ( aInputForm ) then
			removeEventHandler ( "onClientGUIClick", aInputForm, aInputBoxClick )
			removeEventHandler ( "onClientGUIAccepted", aInputValue, aInputBoxAccepted )
			aInputAction = nil
			destroyElement ( aInputForm )
			aInputForm = nil
		end
	else
		guiSetVisible ( aInputForm, false )
	end
end

function aHideFloaters()
	if aMessagesForm then guiSetVisible ( aMessagesForm, false ) end	-- admin messages
	if aMessageForm then guiSetVisible ( aMessageForm, false ) end	-- message box
	if aInputForm then guiSetVisible ( aInputForm, false ) end
	if aMuteInputForm then guiSetVisible ( aMuteInputForm, false ) end
end

-- Escape character '%' will be lost when using gsub, so turn % into %%
function keepEscapeCharacter ( text )
	return string.gsub( text, "%%", "%%%%" )
end

function aInputBoxAccepted ()
	loadstring ( string.gsub ( aInputAction, "$value", "\""..keepEscapeCharacter( guiGetText ( aInputValue ) ).."\"" ) )()
end

function aInputBoxClick ( button )
	if ( button == "left" ) then
		if ( source == aInputOk ) then
			loadstring ( string.gsub ( aInputAction, "$value", "\""..keepEscapeCharacter( guiGetText ( aInputValue ) ).."\"" ) )()
			aInputAction = nil
			aInputBoxClose ( false )
		elseif ( source == aInputCancel ) then
			aInputAction = nil
			aInputBoxClose ( false )
		end
	end
end


--
-- Mute input box
--

aMuteInputForm = nil
local aMuteDurations = {}

function aMuteInputBox ( player )
	-- parse 'mutedurations' setting
	local durations = {}
	for i,dur in ipairs( split( g_Prefs.mutedurations, string.byte(',') ) ) do
		if tonumber( dur ) then
			table.insert( durations, tonumber( dur ) )
		end
	end
	-- destroy form if number of durations has changed
	if #aMuteDurations ~= #durations then
		if aMuteInputForm then
			_widgets["MuteInputBox"] = nil
			destroyElement( aMuteInputForm )
			aMuteInputForm = nil
		end
	end
	aMuteDurations = durations
	if ( aMuteInputForm == nil ) then
		local x, y = guiGetScreenSize()
		aMuteInputForm			= guiCreateWindow ( x / 2 - 150, y / 2 - 64, 300, 150 + #aMuteDurations * 15, "", false )
							  guiWindowSetSizable ( aMuteInputForm, false )
		guiSetAlpha(aMuteInputForm, 1)		
		y = 24

		aMuteInputLabel			= guiCreateLabel ( 20, y, 270, 15, "", false, aMuteInputForm )
		guiLabelSetHorizontalAlign ( aMuteInputLabel, "center" )
		y = y + 23

		aMuteInputValue			= guiCreateEdit ( 35, y, 230, 24, "", false, aMuteInputForm )
		y = y + 33

		local height2 = math.floor( #aMuteDurations * 1.02 * 15 ) + 20 
		aMuteInputRadioSet2bg			= guiCreateTabPanel( 55, y, 300-55*2, height2, false, aMuteInputForm)
		aMuteInputRadioSet2				= guiCreateStaticImage(0,0,1,1, 'Functions/ACLM/images/empty.png', true, aMuteInputRadioSet2bg)
		guiSetAlpha ( aMuteInputRadioSet2bg, 0.3 )
		guiSetProperty ( aMuteInputRadioSet2, 'InheritsAlpha', 'false' )

		local yy = 5
		aMuteInputRadio2Label	= guiCreateLabel ( 10, yy, 270, 15, "Duration:", false, aMuteInputRadioSet2 )
		aMuteInputRadio2s = {}
		for i,dur in ipairs(aMuteDurations) do
			aMuteInputRadio2s[i] = guiCreateRadioButton ( 70, yy, 120, 15, "-", false, aMuteInputRadioSet2 )
			yy = yy + 15
		end
		y = y + height2 + 10

		aMuteInputOk			= guiCreateButton ( 90, y, 55, 17, "Ok", false, aMuteInputForm )
		aMuteInputCancel		= guiCreateButton ( 150, y, 55, 17, "Cancel", false, aMuteInputForm )
		y = y + 30

		guiSetSize ( aMuteInputForm, guiGetSize ( aMuteInputForm, false ), y, false )

		guiSetProperty ( aMuteInputForm, "AlwaysOnTop", "true" )
		aMuteInputPlayer = nil

		addEventHandler ( "onClientGUIClick", aMuteInputForm, aMuteInputBoxClick )
		addEventHandler ( "onClientGUIAccepted", aMuteInputValue, aMuteInputBoxAccepted )
		--Register With Admin Form
		--aRegister ( "MuteInputBox", aMuteInputForm, aMuteInputBox, aMuteInputBoxClose )
	end

	-- update duration values in the form
	for i,dur in ipairs(aMuteDurations) do
		guiSetText ( aMuteInputRadio2s[i], dur>0 and secondsToTimeDesc(dur) or "Until reconnect" )
	end

	guiSetInputEnabled ( true )
	guiSetText ( aMuteInputForm, "Mute player " .. getPlayerName(player) )
	guiSetText ( aMuteInputLabel, "Enter the mute reason" )
	aHideFloaters()
	guiSetVisible ( aMuteInputForm, true )
	guiBringToFront ( aMuteInputForm )
	aMuteInputPlayer = player
end

function aMuteInputBoxClose ( destroy )
	guiSetInputEnabled ( false )
	if ( ( destroy ) or ( guiCheckBoxGetSelected ( aPerformanceInput ) ) ) then
		if ( aMuteInputForm ) then
			removeEventHandler ( "onClientGUIClick", aMuteInputForm, aMuteInputBoxClick )
			removeEventHandler ( "onClientGUIAccepted", aMuteInputValue, aMuteInputBoxAccepted )
			aMuteInputPlayer = nil
			destroyElement ( aMuteInputForm )
			aMuteInputForm = nil
		end
	else
		guiSetVisible ( aMuteInputForm, false )
	end
end

function aMuteInputBoxAccepted ()
	aMuteInputBoxFinish()
end

function aMuteInputBoxClick ( button )
	if ( button == "left" ) then
		if ( source == aMuteInputOk ) then
			aMuteInputBoxFinish()
			aMuteInputPlayer = nil
			aMuteInputBoxClose ( false )
		elseif ( source == aMuteInputCancel ) then
			aMuteInputPlayer = nil
			aMuteInputBoxClose ( false )
		end
	end
end


function aMuteInputBoxFinish ()
	-- Get duration
	local seconds = false
	for i,dur in ipairs(aMuteDurations) do
		if guiRadioButtonGetSelected( aMuteInputRadio2s[i] ) then
			seconds = dur
		end
	end

	-- Get reason
	local reason = guiGetText ( aMuteInputValue )

	-- Validate settings
	if seconds == false then
		aMessageBox ( "error", "No duration selected!" )
		return
	end

	-- Send mute info to the server
	triggerServerEvent ( "aPlayer", getLocalPlayer(), aMuteInputPlayer, "mute", reason, seconds )

	-- Clear input
	guiSetText ( aMuteInputValue, "" )
	for i,dur in ipairs(aMuteDurations) do
		guiRadioButtonSetSelected( aMuteInputRadio2s[i], false ) 
	end
end

function aMessageBox ( sMessage )
	outputChatBox( sMessage, 225, 0, 0 )
end