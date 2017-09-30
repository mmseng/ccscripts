local arg = { ... }
local r = tonumber(arg[1])

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

local function spin(r)
	for n = 1, r do
		turn("left")
		turn("left")
		turn("left")
		turn("left")
	end
end

local function jump(r)
	for n = 1, r do
		turtle.up()
		turtle.down()
	end
end

for n = 1, r do
	spin(1)
	jump(1)
end

print("Done.")