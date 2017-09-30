while true do
	for i = 1, 16 do
		sleep(.1)
		turtle.attack()
		turtle.select(i)
		turtle.dropDown()
	end
end