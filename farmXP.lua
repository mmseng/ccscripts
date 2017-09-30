local arg = { ... }
height = 0
width = 0
delay = 0
rsCheck = false
waitNoticeInterval = 10 -- hopefully delay is a multiple of this

function toboolean(rsCheckString)
	return not not rsCheckString
end

print("Recieved " .. #arg .. " arguments.")
if(#arg ~= 4) then
	print("Usage: farmXP.lua <height> <width> <delay> <rsCheck>")
	exit()
else
	height = tonumber(arg[1])
	width = tonumber(arg[2])
	delay = tonumber(arg[3])
	rsCheck = toboolean(arg[4])
end

local col = 0

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


local function plant()
	turtle.place()
end

local function farmHeight()
	abort = false
	for d=1, (height - 1) do
		--tryDig()
		plant()
		if(rsCheck) then
			if(redstone.getInput("bottom")) then
				print("Aborting: redstone signal received.")
				abort = true
			end
		end		
		if((col % 2) == 1) then
			tryUp()
		else
			tryDown()
		end
	end
	return abort
end

local function nextRow()
	turn("right")
	tryForward()
	turn("left")
end

local function farm()
	print( "Farming..." )
	
	col = 1
	abort = false
	
	for l = 1, width do
		abort = farmHeight()
		if(abort) then
			print("Abort = true, ending farm().")
			break
		else
			if col < width then
				--tryDig()
				plant()
				
				nextRow()
				col = col + 1
			end
			if col == width then
				--tryDig()
				plant()
			end
		end
	end
end

local function raiseHeight()
  for d=1, (height - 1) do
    tryUp()
  end
end

local function lowerHeight()
  for d=1, (height - 1) do
    tryDown()
  end
end

local function unload()
	if((col % 2) == 1) then
		lowerHeight()
	end
	
	turn("right")
	for n = 2, 16 do
		turtle.select(n)
		turtle.drop()
	end
	turtle.select(1)
	turn("left")
end

local function moveWidth()
	for r=1, (col - 1) do
		tryForward()
	end
end

local function reset()
	turn("left")
	moveWidth()
	turn("right")
end

print("Waiting " .. delay .. " seconds...")
for w = 1, delay, waitNoticeInterval do
	sleep(waitNoticeInterval)
	timeLeft = delay - w
	print(timeLeft .. "s left.")
end
 
print("Farming " .. height .. "x" .. width .. "...")
turtle.select(1)
farm()
unload()
reset()
print("Done.")