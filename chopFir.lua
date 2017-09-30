width = 2
height = 45

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
	tryUp()
	turtle.select(1)
	while turtle.suck() ~= true do
		sleep(5)
	end
	turn('right')
	tryForward()
	turtle.placeDown()
	tryForward()
	turtle.placeDown()
	turn('right')
	tryForward()
	turtle.placeDown()
	turn('right')
	tryForward()
	turtle.placeDown()
	tryForward()
	turn('right')
	tryForward()
	turtle.drop()
	tryDown()
end

local function grow()
	turtle.select(1)
	while turtle.suck() ~= true do
		sleep(5)
	end
	turn('right')
	sleep(1)
	turtle.place()
	sleep(1)
end

local function chop()
	tryDig()
	tryForward()
	for i = 0, height do
		tryDig()
		tryDigUp()
		tryUp()
	end
	tryDig()
	
	turn('right')
	tryDig()
	tryForward()
	turn('left')
	for i = 0, height do
		tryDig()
		tryDigDown()
		tryDown()
	end
	tryDig()
	
	turn('left')
	turn('left')
	tryForward()
	turn('left')		
end

local function drop()
	for i = 1, 16 do
		turtle.select(i)
		turtle.drop()
	end
	
	turn('left')
	turn('left')
	tryForward()
end

while true do
	if(redstone.getInput('bottom')) then
		plant()
		grow()
		chop()
		drop()
	else
		sleep(5)
	end
end