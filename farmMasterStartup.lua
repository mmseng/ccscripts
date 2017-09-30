wait = 2250
update = 60
while true do
	left = wait
	print("Sleeping for " .. wait .. " seconds...")
	
	for i = 0, wait, update do
		sleep(update)
		left = left - update
		leftMin = left / 60
		print(leftMin .. " minutes left.")
		
		if(left <= 0) then
			print("Starting harvest...")
			shell.run("my/farmMaster.lua", "farm")
			print("Harvest command sent.")
		end
		sleep(5)
	end
end