-- By Roachy
waitCycle = 1
waitRestock = 10

slotMealComp = 1
slotMeal = 2
slotSeed = 3

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

function plant()
	turtle.select(slotSeed)
	turtle.placeDown()
end

function grow()
	turtle.select(slotMeal)
	turtle.placeDown()
end

function harvest()
	turtle.select(slotSeed)
	tryDigDown()
end

function getMeal()
	tryDown()
	turtle.select(slotMeal)
	turtle.dropDown()
	turtle.suck()
	tryUp()
end

function dump()
	for i = 4, 16 do
		turtle.select(i)
		turtle.drop()
	end
end

function full()
	if turtle.getItemCount(16) > 0 then
		return true
	end
	return false
end

function needMeal()
	turtle.select(slotMeal)
	if(turtle.compareTo(slotMealComp)) then
		return false
	end
	return true
end

while true do
	if(redstone.getInput('left')) then
		sleep(waitCycle)
		
		while(needMeal()) do
			getMeal()
			sleep(waitRestock)
		end
		
		if(full()) then
			dump()
		end
		
		plant()
		grow()
		harvest()
	else
		sleep(5)
	end
end