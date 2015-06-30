
unpack = unpack

machineColShapes = {}

drugItems = {
	["Marijuana Seed"] = {"seed", "imgs/seed.png"},
	["Marijuana Leaf"] = {"raw material", "imgs/marijuanaLeaf.png"},
	["Marijuana"] = {"drug", "imgs/marijuanaBag.png"},
	
	["Coca Plant Seed"] = {"seed", "imgs/seed.png"},
	["Coca Plant Leaf"] = {"raw material", "imgs/cocaLeaf.png"},
	["Coca Oil"] = {"raw material", "imgs/oilBottle.png"},
	["Refined Coca Oil"] = {"raw material", "imgs/oilBottle.png"},
	["Cocaine"] = {"drug", "imgs/.png"},
	["Crack Cocaine"] = {"drug", "imgs/.png"},

	
	["Opium Poppy Seed"] = {"seed", "imgs/seed.png"},
	["Opium Poppy"] = {"raw material", "imgs/opiumPoppy.png"},
	["Poppy Oil"] = {"raw material", "imgs/oilBottle.png"},
	["Opium Oil"] = {"raw material", "imgs/oilBottle.png"},
	["Heroin"] = {"drug", "imgs/.png"},
	
	--["Mushroom Spore"] = {"seed", "imgs/spore.png"},
	["Mushroom"] = {"raw material", "imgs/mushroom.png"},
	["Mushroom Oil"] = {"raw material", "imgs/oilBottle.png"},
	["LSD"] = {"drug", "imgs/.png"},
}

seedsList = {
	["Marijuana Seed"] = "Marijuana Leaf",
	["Coca Plant Seed"] = "Coca Plant Leaf",
	["Opium Poppy Seed"] = "Opium Poppy",
	["Mushroom Spore"] = "Mushroom",
}

squeezerList = {
	["Coca Plant Leaf"] = {"Coca Oil", 6000},
	["Opium Poppy"] = {"Poppy Oil", 6000},
	["Mushroom"] = {"Mushroom Oil", 6000},
}

microwavesList = {
	["Marijuana Leaf"] = {"Marijuana", 5000},
	["Coca Oil"] = {"Cocaine", 8000},
	["Refined Coca Oil"] = {"Crack Cocaine", 10000},
	["Opium Oil"] = {"Heroin", 10000},
	["Mushroom Oil"] = {"LSD", 8000},
}

distillerList = {
	["Coca Oil"] = {"Refined Coca Oil", 10000},
	["Poppy Oil"] = {"Opium Oil", 10000},
}

local drugMachines = {
	{-2106.789, -256.105, 35, 353, 943, "squeezer"},
	{-2110.789, -256.105, 35, 353, 920, "distiller"},
	{-2100.789, -256.105, 35.5, 353, 2149, "microwaves"},
}
drugMachColShapeSize = {
	[943] = 2, -- squeezer
	[920] = 1.2, -- distiller
	[2149] = 1, -- microwaves
}

function createMachines ()
	for i=1, #drugMachines do
		local x, y, z, rot, id, name = unpack(drugMachines[i])
		local machine = createObject(id, x, y, z, 0, 0, rot)
		local colShape = createColSphere(0, 0, 0, drugMachColShapeSize[id])
		attachElements(colShape, machine)
		addEventHandler("onClientColShapeHit", colShape, showLabel)
		addEventHandler("onClientColShapeLeave", colShape, destroyLabel)
		setElementData(colShape, "machineName", name)
		machineColShapes[#machineColShapes+1] = colShape
	end
end
