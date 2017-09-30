local tArgs = { ... }

if (#tArgs == 1) then
	label = tArgs[1]
else
	print( "Usage: setup.lua <label>" )
	return
end

shell.run("label", "set " .. label)
shell.run("copy", "disk/my ./")