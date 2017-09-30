local depth = 15
local length = 7
local height = 4

local collected = 0

local row = 0
local layer = 0

local function unload()
  for n=1,16 do
    turtle.select(n)
    turtle.drop()
   end
end  
  
local function collect()
	collected = collected + 1
	if math.fmod(collected, 25) == 0 then
		print( "Mined "..collected.." items." )
	end
end

local function tryDig()
	while turtle.detect() do
		if turtle.dig() then
			collect()
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
			collect()
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function refuel()
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" or fuelLevel > 0 then
		return
	end
	
	local function tryRefuel()
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					turtle.select(1)
					return true
				end
			end
		end
		turtle.select(1)
		return false
	end
	
	if not tryRefuel() then
		print( "Add more fuel to continue." )
		while not tryRefuel() do
			sleep(1)
		end
		print( "Resuming Tunnel." )
	end
end

local function tryUp()
	refuel()
	while not turtle.up() do
		if turtle.detectUp() then
			if not tryDigUp() then
				return false
			end
		elseif turtle.attackUp() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryDown()
	refuel()
	while not turtle.down() do
		if turtle.detectDown() then
			if not tryDigDown() then
				return false
			end
		elseif turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryForward()
	refuel()
	while not turtle.forward() do
		if turtle.detect() then
			if not tryDig() then
				return false
			end
		elseif turtle.attack() then
			collect()
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

local function digDepth()
  for d=1, (depth - 1) do
    tryDig()
    tryForward()
  end
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

local function nextLayer()
  tryDigUp()
  tryUp()
  turn("back")
end   

local function hollow()
  print( "Hollowing..." )
  
  row = 1
  layer = 1
  
  for h=1, height do
    for l=1, length do
      digDepth()
      if layer % 2 == 1 then
        if row < length then
          nextRow()
          row = row + 1
        end
      else
        if row > 1 then
          nextRow()
          row = row - 1
        end
      end
    end
    
    if layer < height then
      nextLayer()
      layer = layer + 1
    end
  end
end

local function reset()
  for h=1, (height - 1) do
    tryDown()
  end
  
  if layer % 2 == 1 then
    if row % 2 == 1 then
      turn("back")
      moveDepth()
    end 
  end
  
  turn("right")
  for r=1, (row - 1) do
    tryForward()
  end
  
  turn("left")
  unload()
end
  
hollow()
reset()
