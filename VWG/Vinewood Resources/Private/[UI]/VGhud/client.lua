
local tostring = tostring

-- Hud images
local hudTextureNames = {
	"ak47icon",
	"baticon",
	"bombicon",
	"BRASSKNUCKLEicon",
	"cameraCrosshair",
	"cameraicon",
	"cellphoneicon",
	"chnsawicon",
	"chromegunicon",
	"colt45icon",
	"cuntgunicon",
	"desert_eagleicon",
	"fire_exicon",
	"fist",
	"flameicon",
	"floweraicon",
	"flowerbicon",
	"font1",
	"font2",
	"golfclubicon",
	"grenadeicon",
	"gun_caneicon",
	"gun_dildo1icon",
	"gun_dildo2icon",
	"gun_paraicon",
	"gun_vibe1icon",
	"gun_vibe2icon",
	"heatseekicon",
	"irgogglesicon",
	"jetpackicon",
	"katanaicon",
	"knifecuricon",
	"M4icon",
	"micro_uziicon",
	"minigunicon",
	"molotovicon",
	"mp5lngicon",
	"nitestickicon",
	"nvgogglesicon",
	"poolcueicon",
	"rocketlaicon",
	"satchelicon",
	"sawnofficon",
	"shotgspaicon",
	"shovelicon",
	"silencedicon",
	"siteM16",
	"siterocket",
	"skateboardIcon",
	"SNIPERcrosshair",
	"SNIPERicon",
	"SPRAYCANicon",
	"teargasicon",
	"tec9icon",
}

-- Blip images
local blipTextureNames = {
    "arrow",
    "radardisc",
    "radarRingPlane",
    "radar_airYard",
    "radar_ammugun",
    "radar_barbers",
    "radar_BIGSMOKE",
    "radar_boatyard",
    "radar_bulldozer",
    "radar_burgerShot",
    "radar_cash",
    "radar_CATALINAPINK",
    "radar_centre",
    "radar_CESARVIAPANDO",
    "radar_chicken",
    "radar_CJ",
    "radar_CRASH1",
    "radar_dateDisco",
    "radar_dateDrink",
    "radar_dateFood",
    "radar_diner",
    "radar_emmetGun",
    "radar_enemyAttack",
    "radar_fire",
    "radar_Flag",
    "radar_gangB",
    "radar_gangG",
    "radar_gangN",
    "radar_gangP",
    "radar_gangY",
    "radar_girlfriend",
    "radar_gym",
    "radar_hostpital",
    "radar_impound",
    "radar_light",
    "radar_LocoSyndicate",
    "radar_MADDOG",
    "radar_mafiaCasino",
    "radar_MCSTRAP",
    "radar_modGarage",
    "radar_north",
    "radar_OGLOC",
    "radar_pizza",
    "radar_police",
    "radar_propertyG",
    "radar_propertyR",
    "radar_qmark",
    "radar_race",
    "radar_runway",
    "radar_RYDER",
    "radar_saveGame",
    "radar_school",
    "radar_spray",
    "radar_SWEET",
    "radar_tattoo",
    "radar_THETRUTH",
    "radar_TORENO",
    "radar_TorenoRanch",
    "radar_triads",
    "radar_triadsCasino",
    "radar_truck",
    "radar_tshirt",
    "radar_waypoint",
    "radar_WOOZIE",
    "radar_ZERO",
}

-- Radar images
local radarTextureNames = {
	"radar00",
	"radar01",
	"radar02",
	"radar03",
	"radar04",
	"radar05",
	"radar06",
	"radar07",
	"radar08",
	"radar09",
	"radar10",
	"radar11",
	"radar12",
	"radar13",
	"radar14",
	"radar15",
	"radar16",
	"radar17",
	"radar18",
	"radar19",
	"radar20",
	"radar21",
	"radar22",
	"radar23",
	"radar24",
	"radar25",
	"radar26",
	"radar27",
	"radar28",
	"radar29",
	"radar30",
	"radar31",
	"radar32",
	"radar33",
	"radar34",
	"radar35",
	"radar36",
	"radar37",
	"radar38",
	"radar39",
	"radar40",
	"radar41",
	"radar42",
	"radar43",
	"radar44",
	"radar45",
	"radar46",
	"radar47",
	"radar48",
	"radar49",
	"radar50",
	"radar51",
	"radar52",
	"radar53",
	"radar54",
	"radar55",
	"radar56",
	"radar57",
	"radar58",
	"radar59",
	"radar60",
	"radar61",
	"radar62",
	"radar63",
	"radar64",
	"radar65",
	"radar66",
	"radar67",
	"radar68",
	"radar69",
	"radar70",
	"radar71",
	"radar72",
	"radar73",
	"radar74",
	"radar75",
	"radar76",
	"radar77",
	"radar78",
	"radar79",
	"radar80",
	"radar81",
	"radar82",
	"radar83",
	"radar84",
	"radar85",
	"radar86",
	"radar87",
	"radar88",
	"radar89",
	"radar90",
	"radar91",
	"radar92",
	"radar93",
	"radar94",
	"radar95",
	"radar96",
	"radar97",
	"radar98",
	"radar99",
	"radar100",
	"radar101",
	"radar102",
	"radar103",
	"radar104",
	"radar105",
	"radar106",
	"radar107",
	"radar108",
	"radar109",
	"radar110",
	"radar111",
	"radar112",
	"radar113",
	"radar114",
	"radar115",
	"radar116",
	"radar117",
	"radar118",
	"radar119",
	"radar120",
	"radar121",
	"radar122",
	"radar123",
	"radar124",
	"radar125",
	"radar126",
	"radar127",
	"radar128",
	"radar129",
	"radar130",
	"radar131",
	"radar132",
	"radar133",
	"radar134",
	"radar135",
	"radar136",
	"radar137",
	"radar138",
	"radar139",
	"radar140",
	"radar141",
	"radar142",
	"radar143",
}

-- Get the screen size
local sx,sy = guiGetScreenSize()

-- Some variables
local isPhoneEnabled = false
local showAreaNames = false

-- Version label
local version = "0.1"
local label = guiCreateLabel( 0, 0, sx, 15, "VG "..tostring( version ), false )
guiSetSize( label, guiLabelGetTextExtent( label ) + 5, 14, false )
guiSetPosition( label, sx - guiLabelGetTextExtent( label ) - 5, sy - 27, false )
guiSetAlpha( label, 0.5 )

-- Draw a custom circle around the hud
addEventHandler( "onClientRender", root,
    function()
		dxSetAspectRatioAdjustmentEnabled( true )
		if ( isPhoneEnabled ) then
			dxDrawImage( sx*(1115.0/1440),sy*(40.0/900),sx*(110.0/1440),sy*(115.0/900),"images/cellphoneicon.png", 0.0, 0.0, 0.0, tocolor( 255, 255, 255, 255 ),false )
		end
		if not ( showAreaNames ) or ( isPlayerMapVisible () ) or ( getElementHealth( localPlayer ) == 0 ) or not ( isPlayerHudComponentVisible( "radar" ) ) then return end
		local x, y, z = getElementPosition( localPlayer )
		exports.VGdrawing:dxDrawBorderedText( getZoneName ( x, y, z, true ), sx*(18.0/1440),sy*(659.0/900),sx*(388.0/1440),sy*(675.0/900), tocolor(255, 255, 255, 255), sy*(0.9/1440), "bankgothic", "center", "center", false, false, false, false, false)
		exports.VGdrawing:dxDrawBorderedText( getZoneName ( x, y, z, false ), sx*(19.0/1440),sy*(861.0/900),sx*(389.0/1440),sy*(877.0/900), tocolor(255, 255, 255, 255), sy*(0.9/1440), "bankgothic", "center", "center", false, false, false, false, false)
	end
)

-- On setting change check if we should toggle or hide it
addEvent( "onClientPlayerSettingChange" )
addEventHandler( "onClientPlayerSettingChange", root,
	function ( setting, newValue, oldValue )
		if ( setting == "radar" ) then
			showAreaNames = newValue
		end
	end
)

-- Function to set phone enabled
function setPhoneEnabled( state )
	if ( state ) and ( isPlayerHudComponentVisible( "weapon" ) ) then
		setPlayerHudComponentVisible( "weapon", false )
		isPhoneEnabled = true
	elseif ( isPhoneEnabled ) then
		setPlayerHudComponentVisible( "weapon", true )
		isPhoneEnabled = false
	end
end

-- Replace function
function replaceTexture( textureName, imgPath )
	local textureReplaceShader = dxCreateShader( "shaders/texture_replace.fx", 0, 0, false, "world" )
    local texture = dxCreateTexture( imgPath .. textureName .. ".png" )
    dxSetShaderValue( textureReplaceShader, "gTexture", texture )
    engineApplyShaderToWorldTexture( textureReplaceShader, textureName )
end

-- Replace function
function replaceTextures()
    for i, textureName in ipairs(hudTextureNames) do
    	replaceTexture( textureName, "images/" )
    end

    for i, textureName in ipairs(blipTextureNames) do
    	replaceTexture(textureName, "images/radar/blips/")
    end

    for i, textureName in ipairs(radarTextureNames) do
    	replaceTexture(textureName, "images/radar/map/")
    end
end

-- Check on the start of the resource of we should hide or show it
addEventHandler( "onClientResourceStart", resourceRoot,
	function ( )
		if ( exports.VGsettings:getPlayerSetting( "radar" ) ) then
			showAreaNames = true
		end

		replaceTextures()
	end
)