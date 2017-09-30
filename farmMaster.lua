local args = { ... }
local cmd = args[1]
for i = 2, #args do
	cmd = cmd .. " " .. args[i]
end

local slaves =
	{
	--	{id, label, seeds, harvest, depth/height, length/width, delay, script, redstone check}
	-- delay should be a multiple of 10
		{103, "Holo", "Seeds", "Wheat", 17, 17, 0, "farmFlat", true},
		{116, "Wheatley", "Seeds", "Wheat", 17, 17, 500, "farmFlat", true},
		{110, "Barley", "Seeds", "Wheat", 17, 17, 1000, "farmFlat", true},
		{94, "Buckwheat", "Seeds", "Wheat", 17, 17, 1500, "farmFlat", true},
		{113, "Koko", "Cocoa Beans", "Cocoa Beans", 7, 13, 2000, "farmCocoa", true},		
		-- If adding/removing turtles to this array add them above this line
		-- and remember to change the slaveCount variable below
		
		{83, "farmChat", "Chat", "Chat", 0, 0, 0, "farmChat", false}
	}
local slaveCount = 6 -- includes farmChat
	

local function say(msg)
	print(msg)
end

local function tell()
	
	rednet.open("top")
	local rid = -2
	local msg = "No message set"
	local dist = -1
	local wait = 1 -- seconds to wait until communication timeout
	
	
	local id = -1
	local name = "No name set"
	local seed = "No seed set"
	local harvest = "No harvest set"
	local farmDepth = "No depth/height set"
	local farmLength = "No length/width set"
	local delay = -1
	local script = "spinmove"
	
	local baseCmd = "No baseCmd set"
	
	local chatRoll = "No chatRoll set:0;"
	
	-- Change this number if adding/removing turtles
	for i = 1, slaveCount do
		id = slaves[i][1]
		name = slaves[i][2]
		seed = slaves[i][3]
		harvest = slaves[i][4]
		farmDepth = slaves[i][5]
		farmLength = slaves[i][6]
		delay = slaves[i][7]
		script = slaves[i][8]
		rsCheck = slaves[i][9]
		
		if(args[1] == "farm") then					
			baseCmd = "my/" .. script .. ".lua"
			
			if(i < slaveCount) then
				cmd = baseCmd .. " " .. farmDepth .. " " .. farmLength .. " " .. delay .. " " .. tostring(rsCheck)
				say("Telling " .. name .. " to '" .. cmd .. "'...")
				
				if(i == 1) then
					chatRoll = "Farming " .. harvest .. "...:" .. delay .. ";"
				else
					chatRoll = chatRoll .. "Farming " .. harvest .. "...:" .. delay .. ";"
				end
			else
				chatRoll = string.sub(chatRoll, 1, -2)
				chatRoll = string.gsub(chatRoll, " ", "=")
				cmd = baseCmd .. " " .. chatRoll			
			end
		else
			-- just use the given cmd
		end
				
		rednet.send(id, cmd)
		rid, msg, dist = rednet.receive(wait)
		
		if rid == nil then
			say(name .. " did not reply within " .. wait .. " seconds.")
		elseif rid == id then
			if msg ~= nil then
				say(name .. " replied from " .. dist .. "m: " .. msg)
			else
				say(name .. " replied with a blank message.")
			end
		else
			if msg ~= nil then
				say("Received msg from id " .. rid .. ": " .. msg)
			else
				say("Received blank msg from id :" .. rid)
			end			
		end
	end
	
	rednet.close("top")
end

tell()