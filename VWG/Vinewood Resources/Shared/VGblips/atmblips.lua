-- ATM Table
local ATM = {
	{name="LS Rodeo ATM", x=561.65, y=-1253.71},
	{name="LS Santa Maria Beach ATM", x=515.69, y=-1737.80},
	{name="LS Commerce ATM", x=1674.73, y=-1720.96},
	{name="LS Jefferson ATM", x=2127.97, y=-1152.84},
	{name="LS Willowfield ATM", x=2404.96, y=-1954.82},
	{name="LS East Beach ATM", x=2737.83, y=-1836.09},
	{name="LS Airport ATM", x=1975.05, y=-2179.73},
	{name="LS Market ATM", x=1051.53, y=-1422.91},
	{name="LS Temple ATM", x=1053.11, y=-1027.94},
	{name="LS Blueberry ATM", x=224.16, y=-188.71},
	{name="LS Dillimore ATM", x=693.64, y=-538.27},
	{name="LS Montgomery ATM", x=1381.34, y=260.58},
	{name="SF Doherty ATM", x=-1979.64, y=240.52},
	{name="SF Juniper Hollow ATM", x=-2412.83, y=995.98},
	{name="SF Downtown ATM", x=-1650.2, y=1212.38},
	{name="SF Garcia ATM", x=-2211.50, y=116.95},
	{name="SF Ocean Flats ATM", x=-2695.34, y=260.93},
	{name="SF Avispa ATM", x=-2763.19, y=-357.95},
	{name="SF Juniper Hill ATM", x=-2512.64, y=745.73},
	{name="SF Bayside ATM", x=-2491.46, y=2358.65},
	{name="SF Downtown Zip ATM", x=-1885.16, y=889.44},
	{name="SF Airport ATM", x=-1655.78, y=-430.84},
	{name="SF Angel Pine ATM", x=-2125.27, y=-2443.33,},
	{name="LV Camel Toe's ATM", x=2207.84, y=1300.45},
	{name="LV Old Strip ATM", x=2576.65, y=2070.72},
	{name="LV Emerald Isle ATM", x=2183.77, y=2483.96},
	{name="LV Airport ATM", x=1710.54, y=1617.01},
	{name="LV Blackfield ATM", x=1117.27, y=1381.93},
	{name="LV Redsands West ATM", x=1668.72, y=2221.56},
	{name="LV Yellow Bell ATM", x=1450.23, y=2615.76},
	{name="LV Fort Carson ATM", x=-113.38, y=1116.07},
	{name="LV El Quebrados ATM", x=-1504.57, y=2587.97},
	{name="LV Abandoned Airstrip ATM", x=414.81, y=2533.15},
	{name="LV Tierra Robada ATM", x=-834.58, y=1506.72},
}


local table = table

local blipped = {}
function blipt()
	if ( #blipped > 0 ) then
		for k, v in pairs( blipped ) do
			exports.customblips:destroyCustomBlip( v )
		end
		blipped = {}
	else
		for k, v in pairs( ATM ) do
			blips = exports.customblips:createCustomBlip( v.x, v.y, 12, 12, "atmblip.png", 600 )
			table.insert( blipped, blips )
		end
	end
end
addCommandHandler( "batm", blipt )