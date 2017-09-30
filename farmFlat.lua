local arg = { ... }
depth = 0
length = 0
delay = 0
rsCheck = false
waitNoticeInterval = 10 -- hopefully delay is a multiple of this

function toboolean(rsCheckString)
	return not not rsCheckString
end

print("Recieved " .. #arg .. " arguments.")
if(#arg ~= 4) then
	print("Usage: farmFlat.lua <depth/height> <length/width> <delay> <rsCheck>")
	exit()
else
	depth = tonumber(arg[1])
	length = tonumber(arg[2])
	delay = tonumber(arg[3])
	rsCheck = toboolean(arg[4])
end

local row = 0

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

local function unload()
	turn("left")
	for n = 2, 16 do
		turtle.select(n)
		turtle.drop()
	end
	turn("right")
end  

local function pickup()
	turn("left")
	for n = 2, 16 do
		turtle.select(n)
		turtle.suck()
	end
	turn("right")
end

local function tryDig()
	while turtle.detect() do
		if turtle.dig() then
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function tryDigUp()
	while turtle.detectUp() do
		if turtle.digUp() then
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function tryDigDown()
	while turtle.detectDown() do
		if turtle.digDown() then
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function tryUp()
	while not turtle.up() do
		if turtle.detectUp() then
			if not tryDigUp() then
				return false
			end
		elseif turtle.attackUp() then
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryDown()
	while not turtle.down() do
		if turtle.detectDown() then
			if not tryDigDown() then
				return false
			end
		elseif turtle.attackDown() then
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryForward()
	while not turtle.forward() do
		if turtle.detect() then
			if not tryDig() then
				return false
			end
		elseif turtle.attack() then
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function digDepth()
	abort = false
	for d=1, (depth - 1) do
		tryDig()
		tryDigDown()
		if(rsCheck) then
			if(redstone.getInput("top")) then
				print("Aborting: redstone signal received.")
				abort = true
			end
		end
		tryForward()
	end
	return abort
end

local function plant()
	for n = 2, 16 do
		turtle.select(n)
		if(turtle.compareTo(1)) then
			turtle.placeDown()
			break
		end
	end
end

local function plantDepth()
	abort = false
	for d=1, (depth - 1) do
		plant()
		if(rsCheck) then
			if(redstone.getInput("top")) then
				print("Aborting: redstone signal received.")
				abort = true
			end
		end
		tryForward()
	end
	return abort
end

local function moveDepth()
  for d=1, (depth - 1) do
    tryForward()
  end
end

local function nextRow()
  if row % 2 == 1 then
    turn("right")
    tryDig()
    tryForward()
    turn("right")
  else
    turn("left")
    tryDig()
    tryForward()
    turn("left")
  end
end

local function farm()
	print( "Farming..." )
	
	row = 1
	abort = false
	
	for l = 1, length do
		abort = digDepth()
		if(abort) then
			print("Abort = true, ending farm().")
			break
		else
			if row < length then
				tryDigDown()
				nextRow()
				row = row + 1
			end
			if row == length then
				tryDigDown()
			end
		end
	end
end

local function plantAll()
	print( "Planting..." )
	
	row = 1
	abort = false
	
	for l = 1, length do
		abort = plantDepth()
		if(abort) then
			print("Abort = true, ending plantAll().")
			break
		else
			if row < length then
				plant()
				nextRow()
				row = row + 1
			end
			if row == length then
				plant()
			end
		end
	end
end

local function reset()
	if row % 2 == 1 then
		turn("back")
		moveDepth()
	end 
	
	turn("right")
	for r=1, (row - 1) do
		tryForward()
	end
	
	turn("right")
end

print("Waiting " .. delay .. " seconds...")
for w = 1, delay, waitNoticeInterval do
	sleep(waitNoticeInterval)
	timeLeft = delay - w
	print(timeLeft .. "s left.")
end
 
print("Farming " .. depth .. "x" .. length .. "...")
farm()
reset()
unload()
pickup()
plantAll()
reset()
unload()
print("Done.")