lavaFuelAmount = 1000

turtle.select(1)
turtle.refuel()

print("Lava-ing myself...")
i = 1
while(turtle.getFuelLevel() < (turtle.getFuelLimit() - lavaFuelAmount)) do
	print("Fuel level: " .. turtle.getFuelLevel())
	turtle.place()
	print("Refueling...")
	turtle.refuel()
	i = i + 1
end
print("Done refueling.")