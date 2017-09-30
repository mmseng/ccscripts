local tArgs = { ... }
local side = "none"
local slot = "none"

if(#tArgs == 1) then
	side = tArgs[1]
	slot = 1
elseif(#tArgs == 2) then
	side = tArgs[1]
	slot = tonumber(tArgs[2])
else
	print("Usage: swap.lua <left | right> <optional slot#>")
	return
end

if(slot > 0) then
	if(slot < 17) then
		turtle.select(slot)
		
		if(side == "left") then
			turtle.equipLeft()
		elseif(side == "right") then
			turtle.equipRight()
		else
			print("Unrecognized side given!")
		end
	else
		print("Unrecognized slot given!")
	end
else
	print("Unrecognized slot given!")
end