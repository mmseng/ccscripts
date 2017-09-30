growTime = 30

function pass() 
	turtle.turnRight()
	turtle.drop()
	turtle.turnLeft()
end

while true do
	for i = 2, 16 do
		turtle.select(1)
		sleep(growTime)
		turtle.digDown()
		turtle.placeDown()
		turtle.select(i)
		pass()
	end
end