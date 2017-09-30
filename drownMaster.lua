local args = { ... }
local cmd = ""
for i = 1, #args do
	cmd = cmd .. " " .. args[i]
end

local slaves =	
	{
		{72, "Tanky25"}
	}

local function say(msg)
	print(msg)
end

local function tell()
	rednet.open("top")
	
	local id = -1
	local rid = -2
	local msg = "No message set"
	local name = "No name set"
	local wait = 5
	local text = "No text set"
	
	for i = 1, 6 do
		id = slaves[i][1]
		name = slaves[i][2]		
		
		say("Telling " .. name .. " to '" .. cmd .. "'...")
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