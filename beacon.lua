-- Remote controlled player beacon activation by Roachy

local side = 'front'
local slot = 1

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

local function getSignal()
	return redstone.getInput(side)
end

turtle.select(slot)
while true do
	signal = getSignal()
	--print('signal = ' .. tostring(signal))
	
	itemCount = turtle.getItemCount(slot)
	--print('itemCount = ' .. tostring(itemCount))
	
	time = os.time()
	fTime = '(' .. textutils.formatTime(time, true) .. ')'
	
	if(signal) then
		print(fTime .. ' Signal detected.')
		
		if(itemCount > 0) then
			print('- Item detected in slot.')
			
			if(not turtle.detectDown()) then
				print('- Block not detected below.')
				
				print('- Placing item...')
				turtle.placeDown()
			else
				print('- Block detected below!')
				print('- There must be an extra block/item!')
			end
		else
			print('- Item not detected in slot.')
			print('- Skipping placing item.')
		end
	else
		print(fTime .. ' Signal not detected.')
		
		if(itemCount < 1) then
			print('- Item not detected in slot.')
			
			if(turtle.detectDown()) then
				print('- Block detected below.')
				
				print('- Digging block...')
				turtle.digDown()
			else
				print('- No block detected below!')
				print('- Block/item must be missing!')
			end
		else
			print('- Item already detected in slot.')
			print('- Skipping digging block.')
		end
	end
	
	sleep(5)
end