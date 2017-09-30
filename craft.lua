local arg = { ... }
print("Recieved " .. #arg .. " arguments.")
if(#arg ~= 1) then
	print("Usage: craft.lua <single | 4square | 8ring | 9full>")
	exit()
else
	recipeID = arg[1]
end

recipes = {
	["single"] = {
		true, false, false,
		false, false, false,
		false, false, false
	},
	["4square"] = {
		true, true, false,
		true, true, false,
		false, false, false
	},
	["8ring"] = {
		true, true, true,
		true, false, true,
		true, true, true
	},
	["9full"] = {
		true, true, true,
		true, true, true,
		true, true, true
	}
}

recipe = recipes[recipeID]

print("Recipe: ")
storage = 16
firstUsedSlot = 0
needCount = 0

for i = 1, 9 do
	if(recipe[i]) then
		needCount = needCount + 1
		io.write("[X] ")
		if(firstUsedSlot < 1) then
			firstUsedSlot = i
		end
	else
		io.write("[ ] ")
	end
	
	if((i % 3) == 0) then
		print(" ")
	end
end
print("Needed: " .. needCount)

function dropAll(direction)
	for i = 1, 16 do
		turtle.select(i)
		if(direction == "up") then
			turtle.dropUp()
		elseif(direction == "down") then
			turtle.dropDown()
		else
			turtle.drop()
		end
	end
end

function dropExtra()
	extra = turtle.getItemCount(storage) % needCount
	print("Dropping " .. extra .. " extra items...")
	turtle.dropUp(extra)
end

function arrange()
	itemsPerSlot = turtle.getItemCount(storage) / needCount
	print(itemsPerSlot .. " items per slot.")
	
	c = 1
	for i = 1, 11 do
		if((i % 4) ~= 0) then
			if(recipe[c]) then
				turtle.transferTo(i, itemsPerSlot)
			end
			c = c + 1
		end
		sleep(0.1)
	end
end

function craft()
	while(turtle.getItemCount(firstUsedSlot) > 0) do
		turtle.craft()
		turtle.dropDown()
	end
end

dropAll("up")
turtle.select(storage)
while true do
	if(turtle.suckUp()) then
		suckCount = turtle.getItemCount(storage)
		print(suckCount .. " items were sucked. At least " .. needCount .. " are needed.")

		if(suckCount >= needCount) then
			print("Enough items were sucked.")	
			dropExtra()
			arrange()
			craft()
		else
			print("Not enough items were sucked. Dropping items...")
			turtle.dropDown()
		end
	end
	sleep(0.5)
end