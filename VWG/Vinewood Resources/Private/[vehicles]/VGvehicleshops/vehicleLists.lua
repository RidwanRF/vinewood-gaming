importList = {445, 445, 602, 445, 445, 445, 496, 536,  568, 424, 581, 509 }

wangCarsList = {445, 602, 445, 445, 445, 496, 536,  568, 424, 581, 509}--SF south

ottosAutosList = {}--SF north

autoBahnList = {} --LV south

autoBahn2List = {} -- LV north

grottiList = {} -- LS west

couttAndSchutzList = {} --LS east



vehicles = {
[445] = { name= "Admiral", type = "Sedan", price = 30000, maxSpeed = "140", seats = "4", traction = "2X2", weight = "1650", engType = "Petrol", gears = "5"},
[602] = { name= "Alpha", type = "Compact", price = 35000, maxSpeed = "150", seats = "2", traction = "2X2", weight = "1500", engType = "Petrol", gears = "5"},
[424] = { name= "BF Injection", type = "Buggy", price = 40000, maxSpeed = "120", seats = "2", traction = "4X4", weight = "1200", engType = "Petrol", gears = "4"},
[581] = { name= "BF-400", type = "Motorbike", price = 30000, maxSpeed = "160", seats = "2", traction = "2X2", weight = "500", engType = "Petrol", gears = "5"},
[481] = { name= "BMX", type = "Bicycle", price = 300, maxSpeed = "60", seats = "1", traction = "2X2", weight = "20", engType = "N/A", gears = "N/A"},
[568] = { name= "Bandito", type = "Buggy", price = 30000, maxSpeed = "120", seats = "1", traction = "2X2", weight = "1000", engType = "Petrol", gears = "4"},
[429] = { name= "Banshee", type = "Sports car", price = 60000, maxSpeed = "180", seats = "2", traction = "2X2", weight = "1400", engType = "Petrol", gears = "5"},
[509] = { name= "Bike", type = "Bicycle", price = 120, maxSpeed = "70", seats = "1", traction = "2X2", weight = "15", engType = "N/A", gears = "N/A"},
[536] = { name= "Blade", type = "Lowrider", price = 27000, maxSpeed = "150", seats = "2", traction = "2X2", weight = "1500", engType = "Petrol", gears = "5"},
[496] = { name= "Blista Compact", type = "Compact", price = 25000, maxSpeed = "140", seats = "2", traction = "2X2", weight = "1000", engType = "Petrol", gears = "5"},
[422] = { name= "Bobcat", type = "Pick-up truck", price = 25000, maxSpeed = "110", seats = "2", traction = "4X4", weight = "1700", engType = "Diesel", gears = "5"},
[498] = { name= "Boxville", type = "Truck", price = 30000, maxSpeed = "100", seats = "2", traction = "2X2", weight = "5500", engType = "Diesel", gears = "5"},
[401] = { name= "Bravura", type = "Compact", price = 27000, maxSpeed = "120", seats = "2", traction = "4X4", weight = "1300", engType = "Petrol", gears = "5"},
[575] = { name= "Broadway", type = "Lowrider", price = 30000, maxSpeed = "140", seats = "2", traction = "2X2", weight = "1700", engType = "Petrol", gears = "4"},
[518] = { name= "Buccaneer", type = "Compact", price = 30000, maxSpeed = "140", seats = "2", traction = "2X2", weight = "1700", engType = "Petrol", gears = "4"},
[402] = { name= "Buffalo", type = "Sports car", price = 55000, maxSpeed = "160", seats = "2", traction = "2X2", weight = "1500", engType = "Petrol", gears = "5"},
[541] = { name= "Bullet", type = "Sports car", price = 75000, maxSpeed = "180", seats = "2", traction = "2X2", weight = "1200", engType = "Petrol", gears = "5"},
[482] = { name= "Burrito", type = "Van", price = 40000, maxSpeed = "130", seats = "4", traction = "2X2", weight = "1900", engType = "Petrol", gears = "5"},
[457] = { name= "Caddy", type = "Golf caddy", price = 2500, maxSpeed = "70", seats = "2", traction = "4X4", weight = "1000", engType = "Electric", gears = "3"},
[527] = { name= "Cadrona", type = "Compact", price = 29000, maxSpeed = "125", seats = "2", traction = "2X2", weight = "1200", engType = "Petrol", gears = "4"},
[483] = { name= "Camper", type= "Minivan", price= 30000, maxSpeed= "100", seats= "2", traction= "2X2", weight= "1900", engType= "Petrol", gears= "5"}, 
[415] = { name= "Cheetah", type= "Sports car", price= 80000, maxSpeed= "170", seats= "2", traction= "2X2", weight= "1200", engType= "petrol", gears= "5"}, 
[542] = { name= "Clover", type= "Sports car", price= 20000, maxSpeed= "140", seats= "2", traction= "2X2", weight= "1600", engType= "petrol", gears= "4"}, 
[589] = { name= "Club", type= "Compact", price= 27000, maxSpeed= "140", seats= "2", traction= "4X4", weight= "1400", engType= "petrol", gears= "5"}, 
[480] = { name= "Comet", type= "Sports car", price= 45000, maxSpeed= "160", seats= "2", traction= "4X4", weight= "1400", engType= "petrol", gears= "5"}, 
[507] = { name= "Elegant", type= "Sedan", price= 30000, maxSpeed= "140", seats= "4", traction= "2X2", weight= "2200", engType= "petrol", gears= "5"}, 
[562] = { name= "Elegy", type= "Sports car", price= 35000, maxSpeed= "150", seats= "2", traction= "2X2", weight= "1500", engType= "petrol", gears= "5"}, 
[585] = { name= "Emperor", type= "Sedan", price= 30000, maxSpeed= "130", seats= "4", traction= "2X2", weight= "1800", engType= "petrol", gears= "5"}, 

[565] = { name= "Flash", type= "Sports car", price= 30000, maxSpeed= "140", seats= "2", traction= "4X4", weight= "1400", engType= "petrol", gears= "5"}, 

}






addCommandHandler("insert", function (command, t, maxSpeed, traction, price)
	local name = getVehicleName(getPedOccupiedVehicle(localPlayer))
	local id = getVehicleModelFromName(name)
	local seats = getVehicleMaxPassengers(id)
	local details = getVehicleHandling(getPedOccupiedVehicle(localPlayer))
	local weight = details["mass"]
	local engType = details["engineType"]
	local gears = details["numberOfGears"]
	
	row = "["..id.."] = { name= \""..name.."\", type= \""..tostring(types[tonumber(t)]).."\", price= "..price..", maxSpeed= \""..maxSpeed.."\", seats= \""..( tonumber(seats)+1 ).."\", traction= \""..traction.."\", weight= \""..weight.."\", engType= \""..engType.."\", gears= \""..gears.."\"}, \n"
	
	triggerServerEvent("submitVehicleDetails", root, row)

	
end )



types = {
[1]="Sports car",
[2]="Compact",
[3]="Lowrider",
[4]="Van",
[5]="Minivan",
[6]="Truck",
[7]="Pick-up truck",
[8]="Bycicle",
[9]="Buggy",
[10]="Sedan",
[11]="Scooter",
[12]="Motor bike",
[13]="SUV",
[14]="Camper",
}

GUIEditor = {
    combobox = {},
    button = {},
    edit = {},
    window = {},
}
addCommandHandler("startInsertingVehicles", function()
        GUIEditor.window[1] = guiCreateWindow(1001, 232, 225, 341, "", false)
        guiWindowSetSizable(GUIEditor.window[1], false)

        GUIEditor.button[1] = guiCreateButton(10, 314, 105, 17, "Insert", false, GUIEditor.window[1])
        GUIEditor.button[3] = guiCreateButton(139, 314, 76, 17, "Close", false, GUIEditor.window[1])
        id = guiCreateEdit(9, 25, 48, 28, "ID", false, GUIEditor.window[1])
        name = guiCreateEdit(61, 26, 155, 28, "Name", false, GUIEditor.window[1])
        type = guiCreateComboBox(10, 63, 143, 269, "", false, GUIEditor.window[1])
        guiComboBoxAddItem(GUIEditor.combobox[1], "Sports car")
        guiComboBoxAddItem(GUIEditor.combobox[1], "Compact")
        guiComboBoxAddItem(GUIEditor.combobox[1], "Lowrider")
        maxspeed = guiCreateEdit(161, 64, 54, 27, "", false, GUIEditor.window[1])
        seats = guiCreateEdit(19, 94, 29, 32, "", false, GUIEditor.window[1])
        traction = guiCreateComboBox(61, 102, 83, 64, "", false, GUIEditor.window[1])
        guiComboBoxAddItem(GUIEditor.combobox[2], "2X2")
        guiComboBoxAddItem(GUIEditor.combobox[2], "4X4")
        weight = guiCreateEdit(155, 110, 61, 25, "", false, GUIEditor.window[1])
        engType = guiCreateEdit(17, 143, 125, 29, "", false, GUIEditor.window[1])
        gears = guiCreateEdit(151, 150, 65, 25, "", false, GUIEditor.window[1])    
    end
)


