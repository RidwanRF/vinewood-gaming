-- Get the screen size
local sx, sy = guiGetScreenSize()

-- The editbox
editbox = createEditBox( sx*(711.0/1440),sy*(387.0/900),sx*(153.0/1440),sy*(23.0/900) )
setEditBoxVisable( editbox, false )
editbox_transfer = createEditBox( sx*(854.0/1920),sy*(523.0/1080),sx*(298.0/1920),sy*(28.0/1080) )
setEditBoxVisable( editbox_transfer, false )

-- Table with all the data needed to draw
bankingUI = {}

-- Function that draws everything
function drawBankingWindow()
	-- If we don't have a window selected stop drawing
	if not ( bankingUI.window ) then return end
	
	bankingUI.selected = false
	
	-- Check which window we want to draw
	if ( bankingUI.window == 1 ) then
		-- Main window
	    dxDrawRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*(197.0/900), tocolor(0, 0, 0, 134), false)
		dxDrawBorderedRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*(197.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("National Bank", sx*(469.0/1440),sy*(316.0/900),sx*(915.0/1440),sy*(352.0/900), tocolor(255, 255, 255, 255), sx*(1.15/1440), "bankgothic", "left", "top", false, false, false, false, false)
        if ( isDrawElementSelected( sx*(489.0/1440), sy*(360.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(360.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = "Withdraw" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(360.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(360.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawImage(sx*(494.0/1440),sy*(364.0/900),sx*(30.0/1440),sy*(27.0/900), "GUI/images/image2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        if ( isDrawElementSelected( sx*(489.0/1440), sy*(400.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(400.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = "Deposit" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(400.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(400.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        if ( isDrawElementSelected( sx*(489.0/1440), sy*(442.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(442.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = "Transactions" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(442.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(442.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawImage(sx*(493.0/1440),sy*(402.0/900),sx*(29.0/1440),sy*(30.0/900), "GUI/images/image3.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(sx*(492.0/1440),sy*(446.0/900),sx*(31.0/1440),sy*(27.0/900), "GUI/images/image4.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        if ( isDrawElementSelected( sx*(489.0/1440), sy*(482.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(482.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = "Transfer" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(482.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(482.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawImage(sx*(490.0/1440),sy*(484.0/900),sx*(31.0/1440),sy*(31.0/900), "GUI/images/image6.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawBorderedText("Withdraw money from your bank account", sx*(535.0/1440),sy*(369.0/900),sx*(853.0/1440),sy*(386.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawBorderedText("Deposit money into your bank account", sx*(535.0/1440),sy*(409.0/900),sx*(855.0/1440),sy*(427.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawBorderedText("Check the latest transactions", sx*(535.0/1440),sy*(451.0/900),sx*(853.0/1440),sy*(468.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawBorderedText("Transfer money to another player", sx*(535.0/1440),sy*(492.0/900),sx*(856.0/1440),sy*(509.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
		if ( isDrawElementSelected( sx*(782.0/1440), sy*(531.0/900), sx*(782.0/1440)+sx*(117.0/1440), sy*(531.0/900)+sy*(21.0/900) ) ) then bankingUI.selected = "Close" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(782.0/1440),sy*(531.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(782.0/1440),sy*(531.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("Close window", sx*(784.0/1440),sy*(532.0/900),sx*(896.0/1440),sy*(550.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
	elseif ( bankingUI.window == 2 ) then
		-- Transaction window
		if ( transactions ) then iter = #transactions else iter = 0 end
		dxDrawRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*((126.0+(iter*21.0))/900), tocolor(0, 0, 0, 134), false)
		dxDrawBorderedRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*((126.0+(iter*21.0))/900), tocolor(0, 0, 0, 255), false)
        dxDrawRectangle(sx*(484.0/1440),sy*(419.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 218), false)
		dxDrawBorderedRectangle(sx*(484.0/1440),sy*(419.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("Date:", sx*(490.0/1440),sy*(420.0/900),sx*(602.0/1440),sy*(438.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
        dxDrawBorderedText("National Bank of NEG", sx*(469.0/1440),sy*(316.0/900),sx*(915.0/1440),sy*(352.0/900), tocolor(255, 255, 255, 255), sx*(1.15/1440), "bankgothic", "left", "top", false, false, false, false, false)
		if ( isDrawElementSelected( sx*(782.0/1440), sy*((461.0+(iter*21.0))/900), sx*(782.0/1440)+sx*(117.0/1440), sy*((461.0+(iter*21.0))/900)+sy*(21.0/900) ) ) then bankingUI.selected = "Return" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(782.0/1440),sy*((460.0+(iter*21.0))/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(782.0/1440),sy*((460.0+(iter*21.0))/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("Return", sx*(785.0/1440),sy*((461.0+(iter*21.0))/900),sx*(897.0/1440),sy*((479.0+(iter*21.0))/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawImage(sx*(484.0/1440),sy*(384.0/900),sx*(30.0/1440),sy*(24.0/900), "GUI/images/image1.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawBorderedText(exports.VGutils:convertNumber( bankingUI.balance or 0 ), sx*(520.0/1440),sy*(380.0/900),sx*(666.0/1440),sy*(413.0/900), tocolor(251, 254, 252, 253), 1.20, "pricedown", "left", "top", false, false, false, false, false)
        dxDrawRectangle(sx*(605.0/1440),sy*(419.0/900),sx*(267.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 218), false)
		dxDrawBorderedRectangle(sx*(605.0/1440),sy*(419.0/900),sx*(267.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("Transaction details:", sx*(612.0/1440),sy*(420.0/900),sx*(724.0/1440),sy*(438.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
		if ( transactions) then
			i = 0
			for _, aTable in ipairs ( transactions ) do
				i = i + 1
				dxDrawRectangle(sx*(605.0/1440),sy*((419.0+(i*21.0))/900),sx*(267.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 133), false)
				dxDrawBorderedRectangle(sx*(605.0/1440),sy*((419.0+(i*21.0))/900),sx*(267.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
				dxDrawRectangle(sx*(484.0/1440),sy*((419.0+(i*21.0))/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 133), false)
				dxDrawBorderedRectangle(sx*(484.0/1440),sy*((419.0+(i*21.0))/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
				dxDrawBorderedText(aTable.date, sx*(649.0/1920),sy*((501.0+(i*26.0))/1080),sx*(798.0/1920),sy*((525.0+(i*26.0))/1080), tocolor(255, 255, 255, 255), 1.0, "default", "left", "center", false, true, false, false, false, false)
				dxDrawBorderedText(aTable.action, sx*(812.0/1920),sy*((501.0+(i*26.0))/1080),sx*(1156.0/1920),sy*((525.0+(i*26.0))/1080), tocolor(255, 255, 255, 255), 1.00, "default", "left", "center", false, true, false, false, false, false)
			end
		end
	elseif ( bankingUI.window == 3 ) then
		-- Withdraw and deposit window
		if ( bankingUI.type == 1 ) then img = "image2" btnTxt1 = "Withdraw given amount" btnTxt2 = "Withdraw all money in the bank" evntTxt = "Withdraw" else img = "image3" btnTxt1 = "Deposit given amount" btnTxt2 = "Deposit all money to the bank" evntTxt = "Deposit" end
		dxDrawRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*(197.0/900), tocolor(0, 0, 0, 134), false)
		dxDrawBorderedRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*(197.0/900), tocolor(0, 0, 0, 255), false)
		if ( isDrawElementSelected( sx*(489.0/1440), sy*(482.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(482.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = evntTxt .. "All" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(482.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(482.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("National Bank", sx*(469.0/1440),sy*(316.0/900),sx*(915.0/1440),sy*(352.0/900), tocolor(255, 255, 255, 255), sx*(1.15/1440), "bankgothic", "left", "top", false, false, false, false, false)
        dxDrawImage(sx*(494.0/1440),sy*(486.0/900),sx*(30.0/1440),sy*(27.0/900), "GUI/images/"..img..".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        if ( isDrawElementSelected( sx*(489.0/1440), sy*(442.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(442.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = evntTxt .. "Money" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(442.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(442.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText(btnTxt2, sx*(535.0/1440),sy*(492.0/900),sx*(856.0/1440),sy*(509.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        if ( isDrawElementSelected( sx*(782.0/1440), sy*(531.0/900), sx*(782.0/1440)+sx*(117.0/1440), sy*(531.0/900)+sy*(21.0/900) ) ) then bankingUI.selected = "Return" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(782.0/1440),sy*(531.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(782.0/1440),sy*(531.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("Return", sx*(784.0/1440),sy*(532.0/900),sx*(896.0/1440),sy*(550.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawImage(sx*(494.0/1440),sy*(445.0/900),sx*(30.0/1440),sy*(27.0/900), "GUI/images/"..img..".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawBorderedText(btnTxt1, sx*(535.0/1440),sy*(450.0/900),sx*(856.0/1440),sy*(467.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawImage(sx*(490.0/1440),sy*(384.0/900),sx*(30.0/1440),sy*(24.0/900), "GUI/images/image1.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawBorderedText(exports.VGutils:convertNumber( bankingUI.balance or 0 ), sx*(522.0/1440),sy*(380.0/900),sx*(668.0/1440),sy*(413.0/900), tocolor(251, 254, 252, 253), 1.20, "pricedown", "left", "top", false, false, false, false, false)
		dxDrawImage(sx*(711.0/1440),sy*(387.0/900),sx*(153.0/1440),sy*(23.0/900), ":VGcore/images/edit_field.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	elseif ( bankingUI.window == 4 ) then
		dxDrawRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*(197.0/900), tocolor(0, 0, 0, 134), false)
		dxDrawBorderedRectangle(sx*(457.0/1440),sy*(334.0/900),sx*(442.0/1440),sy*(197.0/900), tocolor(0, 0, 0, 255), false)
		if ( isDrawElementSelected( sx*(489.0/1440), sy*(482.0/900), sx*(489.0/1440)+sx*(376.0/1440), sy*(482.0/900)+sy*(34.0/900) ) ) then bankingUI.selected = "TransferMoney" alpha = 220 else alpha = 176 end
		dxDrawRectangle(sx*(489.0/1440),sy*(482.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, alpha), false)
		dxDrawBorderedRectangle(sx*(489.0/1440),sy*(482.0/900),sx*(376.0/1440),sy*(34.0/900), tocolor(0, 0, 0, 255), false)
        dxDrawBorderedText("National Bank", sx*(469.0/1440),sy*(316.0/900),sx*(915.0/1440),sy*(352.0/900), tocolor(255, 255, 255, 255), sx*(1.15/1440), "bankgothic", "left", "top", false, false, false, false, false)
        if ( isDrawElementSelected( sx*(782.0/1440), sy*(531.0/900), sx*(782.0/1440)+sx*(117.0/1440), sy*(531.0/900)+sy*(21.0/900) ) ) then bankingUI.selected = "Return" alpha = 220 else alpha = 176 end
		dxDrawImage(sx*(494.0/1440),sy*(486.0/900),sx*(30.0/1440),sy*(27.0/900), "GUI/images/image6.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawRectangle(sx*(782.0/1440),sy*(531.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, alpha), false)
        dxDrawBorderedRectangle(sx*(782.0/1440),sy*(531.0/900),sx*(117.0/1440),sy*(21.0/900), tocolor(0, 0, 0, 255), false)
		dxDrawBorderedText("Return", sx*(784.0/1440),sy*(532.0/900),sx*(896.0/1440),sy*(550.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawImage(sx*(490.0/1440),sy*(384.0/900),sx*(30.0/1440),sy*(24.0/900), "GUI/images/image1.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("Send money", sx*(535.0/1440),sy*(492.0/900),sx*(856.0/1440),sy*(509.0/900), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawBorderedText(exports.VGutils:convertNumber( bankingUI.balance or 0 ), sx*(522.0/1440),sy*(380.0/900),sx*(668.0/1440),sy*(413.0/900), tocolor(251, 254, 252, 253), 1.20, "pricedown", "left", "top", false, false, false, false, false)
		dxDrawImage(sx*(711.0/1440),sy*(387.0/900),sx*(153.0/1440),sy*(23.0/900), ":VGcore/images/edit_field.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(sx*(854.0/1920),sy*(523.0/1080),sx*(298.0/1920),sy*(28.0/1080), ":VGcore/images/edit_field.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawBorderedText("Name of recipient:", sx*(655.0/1920),sy*(528.0/1080),sx*(843.0/1920),sy*(546.0/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
	end
end

-- When the person clicks on a button
addEventHandler ( "onClientClick", root,
	function ( button, state )
		if ( bankingUI.window ) and ( button == "left" ) and ( state == "up" ) then
			if ( bankingUI.selected ) then
				if ( bankingUI.selected == "Close" ) then
					bankingUI.window = false
					removeEventHandler( "onClientRender", root, drawBankingWindow )
					showCursor( false )
				elseif ( bankingUI.selected == "Return" ) then
					setEditBoxVisable( editbox, false )
					setEditBoxVisable( editbox_transfer, false )
					bankingUI.window = 1
					bankingUI.balance = exports.VGaccounts:getPlayerAccountData( "bankmoney" )
				elseif ( bankingUI.selected == "Transactions" ) then
					bankingUI.window = 2
					bankingUI.balance = exports.VGaccounts:getPlayerAccountData( "bankmoney" )
				elseif ( bankingUI.selected == "Withdraw" ) then
					setEditBoxVisable( editbox, true )
					bankingUI.window = 3
					bankingUI.type	 = 1
					bankingUI.balance = exports.VGaccounts:getPlayerAccountData( "bankmoney" )
				elseif ( bankingUI.selected == "Deposit" ) then
					setEditBoxVisable( editbox, true )
					bankingUI.window = 3
					bankingUI.type	 = 2
					bankingUI.balance = exports.VGaccounts:getPlayerAccountData( "bankmoney" )
				elseif ( bankingUI.selected == "Transfer" ) then
					setEditBoxVisable( editbox, true )
					setEditBoxVisable( editbox_transfer, true )
					bankingUI.window = 4
					bankingUI.balance = exports.VGaccounts:getPlayerAccountData( "bankmoney" )
				elseif ( bankingUI.selected == "WithdrawMoney" ) then
					withDrawMoney()
				elseif ( bankingUI.selected == "DepositMoney" ) then
					depositMoney()
				elseif ( bankingUI.selected == "WithdrawAll" ) then
					withDrawMoney( true )
				elseif ( bankingUI.selected == "DepositAll" ) then
					depositMoney( true )
				elseif ( bankingUI.selected == "TransferMoney" ) then
					transferMoney()
				end
			end
		end
	end
)

-- Draw bordered text
function dxDrawBorderedText ( text, x, y, w, h, color, scale, font, alignX, alignY, borderColor, clip, wordBreak, postGUI )
	if not ( borderColor ) then borderColor = tocolor ( 0, 0, 0, 255 ) end
	dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x - 1, y, w - 1, h, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y - 1, w, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
	return true
end

-- Draw bordered rectangle
function dxDrawBorderedRectangle( x, y, width, height, color, postGUI )
	dxDrawLine ( x, y, x+width, y, color, 1, postGUI or false )
	dxDrawLine ( x, y, x, y+height, color, 1, postGUI or false )
	dxDrawLine ( x, y+height, x+width, y+height, color, 1, postGUI or false )
	dxDrawLine ( x+width, y, x+width, y+height, color, 1, postGUI or false )
	return true
end

-- Check the the draw element is selected
function isDrawElementSelected ( minX, minY, maxX, maxY )
	if not ( isCursorShowing() ) then return end
	local x, y = getCursorPosition()
	if ( sx*x >= minX ) and ( sx*x <= maxX ) then
		if ( sy*y >= minY ) and ( sy*y <= maxY ) then
			return true
		else
			return false
		end
	else
		return false
	end
end