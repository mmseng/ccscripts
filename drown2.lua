active=1
empty=2

function activeBucketIsFull()
	turtle.select(active)
	if turtle.compareTo(empty) then
		return false
	end
	return true
end

while true do
	if redstone.getInput("top") then
		print("Signal detected.")
		if activeBucketIsFull() then
			print("Bucket is full, dumping water...")
			turtle.select(active)
			turtle.placeDown()
		end
	else
		print("Signal not detected.")
		if not activeBucketIsFull() then
			print("Bucket is empty,  picking up water...")
			turtle.select(active)
			turtle.placeDown()
		end
	end
	shell.run("label", "get")
	print("Resting...")
	sleep(5)
end
	