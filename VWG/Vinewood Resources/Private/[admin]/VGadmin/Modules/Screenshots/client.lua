--[[**********************************
*
* VG ADMIN PANEL
* Made by Dennis/UniOn
*
**************************************]]--

-- Main GUI
local Window = guiCreateWindow( 190, 448, 489, 195, "Screenshots from ...", false )
guiWindowSetSizable( Window, false )
guiWindowSetMovable ( Window, true  )
guiWindowSetSizable ( Window, false  )
guiSetVisible ( Window, false  )
local Grid = guiCreateGridList( 10, 25, 320, 158, false, Window )
guiGridListAddColumn( Grid, "Date:", 0.45 )
guiGridListAddColumn( Grid, "Admin:", 0.45 )
local TakeButton = guiCreateButton( 334, 25, 145, 27, "Take New", false, Window )
local RemoveButton = guiCreateButton( 334, 58, 145, 27, "Remove", false, Window )
local ViewButton = guiCreateButton( 334, 91, 145, 27, "View", false, Window )
local RefreshButton = guiCreateButton( 334, 123, 145, 27, "Refresh", false, Window )
local CloseButton = guiCreateButton( 334, 156, 145, 27, "Close", false, Window )
exports.VGutils:centerWindow ( Window )

-- Screen GUI
local ScreenWindow = guiCreateWindow( 190, 448, 800, 600, "Screenshot", false )
guiWindowSetSizable( ScreenWindow, false )
guiWindowSetMovable ( ScreenWindow, true  )
guiWindowSetSizable ( ScreenWindow, false  )
guiSetVisible ( ScreenWindow, false  )
local ScreenLabel = guiCreateLabel( 0, 0, 1, 1, "Loading...", true, ScreenWindow )
local ScreenButton = guiCreateButton( 0.93, 0.95, 0.6, 0.4, "Close", true, ScreenWindow )
local ScreenImage = nil
guiLabelSetHorizontalAlign( ScreenLabel, "center" )
guiLabelSetVerticalAlign( ScreenLabel, "center" )
exports.VGutils:centerWindow ( ScreenWindow )

local selected = {}

-- Function to get the selected screenshot id
function getSelectedScreenShotID ()
    local row = guiGridListGetSelectedItem ( Grid )
    local unique_id = guiGridListGetItemData ( Grid, row, 1 )
    if ( unique_id ) and ( tostring( row ) ~= "-1" ) then
        return unique_id
    else
        return false
    end
end

-- Open the screenshots window
addEvent( "onClientShowScreenShotWindow", true )
addEventHandler( "onClientShowScreenShotWindow", root,
    function ( tbl, player, name, account )
        if ( tbl ) then
            selected = {}
            guiGridListClear( Grid )

            selected.account = account
            selected.player = player

            for i=1,#tbl do
                local Row = guiGridListAddRow( Grid )
                guiGridListSetItemText( Grid, Row, 1, exports.VGutils:timestampToDate( tbl[i].timestamp ), false, false )
                guiGridListSetItemText( Grid, Row, 2, tbl[i].admin, false, false )
                guiGridListSetItemData( Grid, Row, 1, tbl[i].unique_id )
            end  

            guiSetText( Window, "Screenshots from " .. name )
            guiSetVisible ( Window, true )
            guiBringToFront( Window )
            guiSetProperty( Window, "AlwaysOnTop", "True" )
            showCursor( true )
        end
    end
)

-- Close button evnet
addEventHandler( "onClientGUIClick", resourceRoot,
    function ()
        if ( source == CloseButton ) then
            guiSetVisible ( Window, false )
            selected = {}
        elseif ( source == TakeButton ) then
            if not ( isElement( selected.player ) ) then showMessageDX( "Couldn't take a screenshot because the player has left the server", 255, 0, 0 ) return end
            triggerServerEvent( "onServerTakePlayerScreenShot", localPlayer, selected.player )
            guiSetText( ScreenLabel, "Loading..." )
            guiSetProperty( Window, "AlwaysOnTop", "False" )
            guiSetVisible ( ScreenWindow, true )
            guiBringToFront( ScreenWindow )
            guiSetProperty( ScreenWindow, "AlwaysOnTop", "True" )
            showCursor( true )
        elseif ( source == ScreenButton ) then
            guiSetVisible ( ScreenWindow, false )
            if ( isElement( ScreenImage ) ) then destroyElement( ScreenImage ) end
            guiSetProperty( Window, "AlwaysOnTop", "True" )
        elseif ( source == RefreshButton ) then
            if not ( isElement( selected.player ) ) then showMessageDX( "Couldn't refresh the screenshots list because the player has left the server", 255, 0, 0 ) return end
            triggerServerEvent( "onServerOpenScreenShotWindow", localPlayer, selected.player)
        elseif ( source == RemoveButton ) then 
            local screenshotID = getSelectedScreenShotID ()
            if not ( screenshotID ) then showMessageDX( "You didn't select a screenshot to delete", 255, 0, 0 ) return end
            triggerServerEvent( "onServerRemovePlayerScreenShot", localPlayer, selected.account, getSelectedScreenShotID() )
            guiGridListRemoveRow ( Grid, guiGridListGetSelectedItem ( Grid ) )
        elseif ( source == ViewButton ) then 
            local screenshotID = getSelectedScreenShotID ()
            if not ( screenshotID ) then showMessageDX( "You didn't select a screenshot to view", 255, 0, 0 ) return end
            triggerServerEvent( "onServerViewPlayerScreenShot", localPlayer, selected.account, getSelectedScreenShotID() )
        end
    end, true
)

-- View the screenshot
addEvent( "onClientLoadPlayerScreenShot", true )
addEventHandler( "onClientLoadPlayerScreenShot", root,
    function ( result, data, hash, show )
        if ( result == "ok" ) then
            if ( show ) then 
                guiSetText( ScreenLabel, "Loading..." )
                guiSetProperty( Window, "AlwaysOnTop", "False" )
                guiSetVisible ( ScreenWindow, true )
                guiBringToFront( ScreenWindow )
                guiSetProperty( ScreenWindow, "AlwaysOnTop", "True" )
                showCursor( true )
            end

            if not ( guiGetVisible ( ScreenWindow ) ) then return end

            local file = fileCreate( "screenshots/" .. hash .. ".jpg" )
            fileWrite( file, data )
            fileClose( file )

            ScreenImage = guiCreateStaticImage( 0, 0, 1, 1, "screenshots/" .. hash .. ".jpg", true, ScreenWindow )
            guiBringToFront( ScreenButton )
            guiSetProperty( ScreenButton, "AlwaysOnTop", "True" )
        else
            guiSetText( ScreenLabel, "Couldn't take screenshot, either the screen is minimized or the player left..." )
        end
    end
)