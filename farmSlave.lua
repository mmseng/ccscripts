local args = { ... }

if #args ~= 1 then
	print("slave.lua requires master id as 1st and only argument!")
else
	local master = tonumber(args[1])
	local ack = "Acknowledged."
	
	rednet.open("right")
	
	local rid, msg, dist, cmd
	while true do
		print("Waiting for commands...")
		rid, msg, dist = rednet.receive()
		if rid == master then
			print("Received message from " .. master .. ": " .. msg)
			print("Acknowledging...")
			rednet.send(master, ack)
			shell.run(msg)
		else
			print("Received msg from id '" .. rid .. "': " .. msg)
		end
	end
	
	rednet.close("right")
end