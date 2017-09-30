local spacing = 1
local collected = 0
local rows = 6
local cols = 6
local loops = 1

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
    

local function chop()
  print( "Chopping this tree..." )
  
  local height=0
  
	 while turtle.detect() do
    tryDig()
  	 tryForward()
  
    while turtle.detectUp() do
      tryDigUp()
      tryUp()
      height = height + 1
    end
    
    for h=0, (height - 1) do
      tryDown()
    end
    
    turn("back")
    tryForward()
    turn("back")
  end
    	
  print( "One tree complete." )
  print( "Mined "..collected.." items total." )
end

local function dropOff()
  turtle.turnLeft()
  tryForward()
  tryForward()
  turtle.turnRight()

  drop() 

  turtle.turnRight()
  tryForward()
  tryForward()
  turtle.turnLeft()
end

local function nextCol()
  local move = spacing + 1

  turtle.turnRight()
  for m=1,move do
   tryForward()
  end
  turtle.turnLeft()
end

local function nextRow(row)
  if row % 2 == 1 then
    -- odd row, just turn around
    turtle.turnLeft()
    turtle.turnLeft()
    for m=1,(spacing - 1) do
      tryForward()
    end
  else
    -- even row
    turtle.turnLeft()
    tryForward()
    turtle.turnRight()
    for m=1,(spacing + 3) do
      tryForward()
    end
    turtle.turnRight()
    tryForward()
    turtle.turnRight()
  end
end

local function reset()
  if rows % 2 == 1 then
    local move = (cols - 1) * (spacing + 1) + 1
   
    turtle.turnLeft()
    for m=1,move do
      tryForward()
    end
    turtle.turnRight()
    
    move = move - 1
    for m=1,move do
      tryForward()
    end
    
    turtle.turnRight()
    tryForward()
    turtle.turnLeft()
  else
    local move = (rows - 2) * (spacing + 1)
    turn("right")
    tryForward()
    turn("right")
    for m=1, move do
      tryForward()
    end
    turn("right")
    tryForward()
    turn("left")
  end
  
  dropOff()
end

for l=1,loops do
  for r=1,rows do
    for c=1,cols do
      chop()
      if c < cols then
        nextCol()
      else
        if r < rows then
          nextRow(r)
        end
      end
    end
  end
  reset()
end  

