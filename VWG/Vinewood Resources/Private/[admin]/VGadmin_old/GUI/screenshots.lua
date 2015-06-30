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
guiGridListAddColumn( Grid, "Date", 0.5 )
guiGridListAddColumn( Grid, "Admin", 0.4 )
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

-- Open the screenshots window
addEvent( "onClientShowScreenShotWindow", true )
addEventHandler( "onClientShowScreenShotWindow", root,
    function ( tbl, name )
        if ( tbl ) then
            guiGridListClear( Grid )

            for i=1,#tbl do
                local Row = guiGridListAddRow( Grid )
                guiGridListSetItemText( Grid, Row, 1, exports.VGutils:timestampToDate( tbl[i].timestamp ), false, false )
                guiGridListSetItemText( Grid, Row, 2, tbl[i].admin, false, false )
                
                guiSetText( Window, "Screenshots from " .. name )
            end  

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
        elseif ( source == TakeButton ) then
            triggerServerEvent( "onServerTakePlayerScreenShot", localPlayer, getAdminPanelSelectedPlayer() )
            guiSetProperty( Window, "AlwaysOnTop", "False" )
            guiSetVisible ( ScreenWindow, true )
            guiBringToFront( ScreenWindow )
            guiSetProperty( ScreenWindow, "AlwaysOnTop", "True" )
            showCursor( true )
        elseif ( source == ScreenButton ) then
            guiSetVisible ( ScreenWindow, false )
            destroyElement( ScreenImage )
            guiSetProperty( Window, "AlwaysOnTop", "True" )
        end
    end, true
)

-- View the screenshot
addEvent( "onClientLoadPlayerScreenShot", true )
addEventHandler( "onClientLoadPlayerScreenShot", root,
    function ( result, data, hash )
        if ( result == "ok" ) then
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