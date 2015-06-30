-- Blyat


local table = table

local chanceOfRain = 10 --%
local chanceOfStorm = 6 --%
local chanceOfFog = 10 --%

rainyIDs = {  9, 12, 13, 14, 15, 16, 33, 35 }
sunnyIDs = {  1,2,3,4,5,6,7,10,11,27,28,29,39,51,52,53 }


function weatherCycler ()
	rain = false
	storm = false
	fog = false
	setRainLevel(0)
	setFogDistance(0)
	setWaveHeight(0.2)
	if ( math.random(0,100) <= chanceOfRain ) then rain = true end
	if ( math.random(0,100) <= chanceOfStorm ) then storm = true end
	if ( math.random(0,100) <= chanceOfFog ) then fog = true end
	
	if ( storm ) then 
		setWeatherBlended(8)
		setWaveHeight(math.random(0.5,2.0) )
		if ( fog ) then
			setFogDistance(math.random(200,400))
		end
		
	elseif ( rain ) then
		setWaveHeight(math.random(0.1,1.5) )
		setWeatherBlended(rainyIDs[math.random(1,table.getn(rainyIDs))])
		
	else
		setWeatherBlended(sunnyIDs[math.random(1,table.getn(sunnyIDs))])
	end
end
setTimer( weatherCycler, 900000, 0 )

weatherCycler()