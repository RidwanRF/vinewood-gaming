
ipairs = ipairs

hitDuration = { -- default duration for 1 dose of each drug
	["Marijuana"] = 60,
	["Cocaine"] = 45,
	["Heroin"] = 30,
	["LSD"] = 60,
	["Crack Cocaine"] = 30,
}

drugEffectsDuration = { --seconds left until the effect stops
	["Marijuana"] = 0,
	["Cocaine"] = 0,
	["Heroin"] = 0,
	["LSD"] = 0,
	["Crack Cocaine"] = 0,
}

setTimer(function ()
	for i,v in ipairs(drugEffectsDuration) do
		if ( v == -1 ) then 
			-- nothing 
		elseif ( v == 0 ) then
			if ( i == "Marijuana" ) then
				setMarijuanaEffects( false )
			elseif ( i == "Cocaine" ) then
				setCocaineEffects( false )
			elseif ( i == "Heroin" ) then
				setHeroinEffects( false )
			elseif ( i == "LSD" ) then
				setLSDEffects( false )
			elseif ( i == "Crack Cocaine" ) then
				setCrackCocaineEffects( false )
			end
			drugEffectsDuration[i] = v-1
		else
			drugEffectsDuration[i] = v-1
		end
	end
end,1000,0)


-- Marijuana effects
function setMarijuanaEffects ( state )
	if ( state == true ) then
	
	elseif ( state == false ) then
		
	end
end

-- Cocaine effects
function setCocaineEffects ( state )
	if ( state == true ) then
	
	elseif ( state == false ) then
		
	end
end

-- Heroin effects
function setHeroinEffects ( state )
	if ( state == true ) then
	
	elseif ( state == false ) then
		
	end
end

-- LSD effects
function setLSDEffects ( state )
	if ( state == true ) then
	
	elseif ( state == false ) then
		
	end
end

-- Crack Cocaine effects
function setCrackCocaineEffects ( state )
	if ( state == true ) then
	
	elseif ( state == false ) then
		
	end
end
