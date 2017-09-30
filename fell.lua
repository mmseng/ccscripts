local tArgs = { ... }
local sizeZ = tonumber(tArgs[1]) -- Quarry is this long in direction turtle is initially facing, including block turtle is on
local sizeX = tonumber(tArgs[2]) -- Quarry is this wide to the right of where turtle is facing, including block turtle is on
local sizeY = tonumber(tArgs[3]) -- Quarry removes this many layers of blocks including layer where turtle starts
movesPerCycle = (sizeZ * sizeX * (sizeY + 3)) + 1000

local sapling = 1
local bonemeal = 2
local wood1 = 3
local wood2 = 4
local openStart = 5
local saplingOpenStart = 5
local saplingOpenEnd = 10
local bonemealOpenStart = 11
local bonemealOpenEnd = 16
local openEnd = 16
local empty = true

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

local function fell()
	dimensions = sizeZ .. " " .. sizeX .. " " .. sizeY
	shell.run("my/fellQuarry.lua", dimensions)
end

local function lower()
	for i = 1, (sizeY - 1) do
		tryDown()
	end
end

local function use(item)
	found = false
	turtle.select(item)
	for i = openStart, openEnd do
		if turtle.compareTo(i) then
			turtle.select(i)
			found = true
		end
	end
	
	if not found then
		print("Empty!")
		empty = true
	end
end

local function refuel()
	if turtle.getFuelLevel() < movesPerCycle then
		turtle.turnRight()
		tryForward()
		turtle.select(1)
		turtle.suckUp()
		turtle.refuel(64)
		turtle.turnLeft()
		turtle.turnLeft()
		tryForward()
		turtle.turnLeft()
	end
end
	

local function fillComparison()
	turtle.select(sapling)
	turtle.suckUp()
	
	turtle.turnLeft()
	tryForward()
	turtle.select(bonemeal)
	turtle.suckUp()
	
	tryForward()
	turtle.select(wood1)
	turtle.suckUp()
	turtle.select(wood2)
	turtle.suckUp()
	
	turtle.select(wood1)
	turtle.drop(63)
	turtle.select(wood2)
	turtle.drop(63)
	turtle.turnLeft()
	turtle.turnLeft()
	tryForward()
end

local function fill()
	refuel()
	
	turtle.turnLeft()
	turtle.turnLeft()
	tryForward()
	
	fillComparison()
	
	-- fill bonemeal
	for i = bonemealOpenStart, bonemealOpenEnd do
		turtle.suckUp()
	end
	
	-- fill saplings
	tryForward()
	for i = saplingOpenStart, saplingOpenEnd do
		turtle.suckUp()
	end
	
	turtle.turnRight()
	tryForward()
	empty = false
end

local function dump()
	turtle.turnLeft()
	turtle.turnLeft()
	for i = 1, 16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.turnLeft()
	turtle.turnLeft()
end

local function plantCol(col)
	if((col % 2) == 0) then
		use(sapling)
		turtle.placeDown()
		planted = true
	else
		planted = false
	end
	
	return planted
end

local function weed()
	sleep( 0.5 )
	tryDig()
end

local function grow()
	tryDown()
	turtle.turnLeft()
	turtle.turnLeft()
	
	use(bonemeal)
	turtle.place()
	weed()
	
	turtle.turnLeft()
	turtle.turnLeft()
	tryUp()
end

local function plantRow(row, skip)
	planted = false
	
	if((row % 2) == 1) then
		turtle.turnRight()
	elseif((row % 2) == 0) then
		turtle.turnLeft()
	else
		print("Failure 1!")
		exit()
	end
	
	for col = 1, sizeX do
		if not empty then
			if not skip then
				planted = plantCol(col)
			end
		end
		
		if(col < sizeX) then
			tryForward()
			
			if not empty then
				if(planted) then
					grow()
				end
			end
		end
	end

	if((row % 2) == 1) then
		turtle.turnLeft()
	elseif((row % 2) == 0) then
		turtle.turnRight()
	else
		print("Failure 2!")
		exit()
	end
end

local function returnHome()
	turtle.turnLeft()
	if((sizeZ % 2) == 1) then
		for col = 1, (sizeX - 1) do
			tryForward()
		end
	end
	turtle.turnLeft()
	
	for row = 1, (sizeZ - 1) do
		tryForward()
	end
	turtle.turnLeft()
	turtle.turnLeft()
end

local function advanceRow()
	tryForward()
end

local function plant()
	tryUp()
	for row = 1, sizeZ do
		if((row % 2) == 1) then
			plantRow(row, true)
		else
			plantRow(row, false)
		end
		
		if(row == sizeZ) then
			returnHome()
		else
			advanceRow()
		end
	end
	tryDown()
end

local function raise()
	for i = 1, (sizeY - 1) do
		tryUp()
	end
end

while true do
	raise()
	dump()
	fell()
	lower()
	fill()
	plant()
end



