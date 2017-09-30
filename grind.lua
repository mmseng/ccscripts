local function check()
	if turtle.getItemCount(16) > 0 then
		for i=1, 16 do
			turtle.select(i)
			turtle.dropDown()
		end
		turtle.select(1)
	end
end

local function attack()
	turtle.attack()
	check()
	sleep(.1)
end

while true do
	attack()
end