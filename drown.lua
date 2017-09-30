p = peripheral.wrap("left")

water = 9
fullLevel = 9001
emptyLevel = 999
fullBucket = 1
wait = 1
pause = .1

length = 25

local function turn(side)
  if side == "left" then
    turtle.turnLeft()
  elseif side == "right" then
    turtle.turnRight()
  elseif side == "back" then
    turtle.turnRight()
    turtle.turnRight()
  else
    print("Turn direction not recognized!")
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.turnLeft()
  end
end

function level()
	local liquidType, liquidAmount = p.getLiquid()
	return liquidAmount
end

function fillTank()
	print("Filling tank...")
	while (level() < fullLevel) do
		sleep(pause)
		p.suckDown()
	end
	print("Tank filled.")
end

function fillBucket(s)
	print("Filling bucket in slot #" .. s .. "...")
	turtle.select(s)
	while not turtle.compareTo(fullBucket) do
		sleep(pause)
		if(level() > emptyLevel) then
			p.pack()
			print("Bucket filled.")
		else
			print("Not enough water in tank, refilling tank...")
			fillTank()
		end
	end
	print("Bucket filled.")
end

function fillBuckets()
	print("Filling all buckets...")
	for i = 2, 16, 1 do
		sleep(pause)
		print("Bucket in slot #" .. i .. "...")
		turtle.select(i)
		if turtle.compareTo(fullBucket) then
			print("Bucket is full.")
		else
			print("Bucket is empty, filling...")
			fillBucket(i)
		end
	end
	print("All buckets filled.")
end

function fillAll()
	print("Filling tank and buckets...")
	fillBuckets()
	fillTank()
	print("Everything filled.")
end

function refillTankFromBuckets(n)
	print("Refilling...")
	for i = 0, n, 1 do
		sleep(pause)
		print("Refill #" .. i .. ":")
		if(level() < fullLevel) then
			print("Tank not full, continuing...")
			for ii = 2, 16, 1 do
				sleep(pause)
				print("Attempting to fill from slot #" .. ii .. "...")
				turtle.select(fullBucket)
				if turtle.compareTo(ii) then
					print("Slot #" .. ii .. " has a full bucket.")
					turtle.select(ii)
					p.unpack()
					print("Filled from slot #" .. ii .. ", done with refill #" .. i .. ".")
					break
				else
					print("Slot #" .. ii .. " does not have a full bucket.")
				end
			end
		else
			print("Tank is full. Cannot continue filling.")
			break
		end
		print("Done with refill #" .. i .. ".")
	end
	print("Done refilling.")
end

function drainTankToBuckets(n)
	print("Draining...")
	for i = 0, n, 1 do
		sleep(pause)
		print("Drain #" .. i .. ":")
		if(level() > emptyLevel) then
			print("Tank not empty, continuing...")
			for ii = 2, 16, 1 do
				sleep(pause)
				print("Attempting to drain to slot #" .. ii .. "...")
				turtle.select(fullBucket)
				if not turtle.compareTo(ii) then
					print("Slot #" .. ii .. " has an empty bucket.")
					turtle.select(ii)
					p.pack()
					print("Drained to slot #" .. ii .. ", done with drain #" .. i .. ".")
					break
				else
					print("Slot #" .. ii .. " does not have an empty bucket.")
				end
			end
		else
			print("Tank is empty. Cannot continue draining.")
			break
		end
		print("Done with drain #" .. i .. ".")
	end
	print("Done draining.")
end

function dump()
	print("Dumping...")
	if(level() <= emptyLevel) then
		print("Not enough in tank, refilling...")
		refillTankFromBuckets(1)
	end
	local dumped = p.dropDown()
	
	-- Returns nil for some reason
	--print("Dumped " .. dumped .. "mB.")
end

function pick()
	print("Picking...")
	if(level() >= fullLevel) then
		print("Too much in tank, draining...")
		drainTankToBuckets(1)
	end
	picked = p.suckDown()
	print("Picked " .. picked .. "mB.")
end

function park()
	print("Parking...")
	turtle.forward()
	turtle.forward()
	turn("back")
end

function unpark()
	print("Unparking...")
	turtle.forward()
	turtle.forward()
end

function drown()
	print("Drowning...")
	fillAll()
	unpark()
	for i = 1, length, 1 do
		sleep(pause)
		print("Spot #" .. i .. "...")
		dump()
		if i < length then
			print("Continuing...")
			turtle.forward()
		end
	end
	
	print("Turning around...")
	turn("back")	
	
	print("Returning...")
	for i = length, 1, -1 do
		sleep(pause)
		if i > 1 then
			turtle.forward()
		end
	end
	park()
	fillAll()
end

function clear()
	print("Clearing...")
	unpark()
	turtle.down()
	for i = 1, length, 1 do
		sleep(pause)
		if i < length then
			turtle.forward()
		end
	end
	turtle.up()
	
	print("Turning around...")
	turn("back")	
	
	print("Returning...")
	for i = length, 1, -1 do
		sleep(pause)
		if i > 1 then
			turtle.forward()
		end
	end
	park()
end

while true do
	if redstone.getInput("back") then
		print("Signal detected, drowning...")
		drown()
		print("Drown complete.")
		
		while redstone.getInput("back") do
			sleep(pause)
			print("Signal detected.")
			sleep(wait)
		end
		
		print("Signal no longer detected, clearing...")
		clear()
	else
		print("Signal not detected.")
	end
	
	sleep(wait)
end