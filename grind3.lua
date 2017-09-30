local function check()
	if turtle.getItemCount(2) > 0 then
		for i=1, 16 do
			turtle.select(i)
			turtle.drop()
		end
		turtle.select(1)
	end
end

local function attack()
	turtle.attack()
	check()
	sleep(.1)
end

turtle.select(1)
while true do
	attack()
end