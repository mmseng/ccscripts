local height = 7
local spacing = 3
local collected = 0
local rows = 3
local cols = 3
local loops = 100

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

local function tap()
  print( "Tapping this tree..." )
  
  for s=1,2 do
    for h=1,height do
    	 tryDig()
    	 tryUp()
      if h == height then
        tryDig()
      end
    end
   
    turtle.turnRight()
    tryForward()
    turtle.turnLeft()
    tryForward()
    turtle.turnLeft()
    
    for h=1,height do
      tryDig()
      tryDown()
      if h == height then
        tryDig()
      end
    end
    
    turtle.turnRight()
    tryForward()
    turtle.turnLeft()
    tryForward()
    turtle.turnLeft()
  end
  	
  print( "One tree complete." )
  print( "Mined "..collected.." items total." )
end

local function dropOff()
  turtle.turnLeft()
  tryForward()
  tryForward()
  turtle.turnRight()

  turtle.drop() 

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
  
  dropOff()
end

for l=1,loops do
  for r=1,rows do
    for c=1,cols do
      tap()
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

