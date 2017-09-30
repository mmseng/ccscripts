m = peripheral.wrap("left")
os.loadAPI("button")
button.setMon("left")

wrSide = "bottom"
wr = peripheral.wrap(wrSide)
wtSide = "back"
wt = peripheral.wrap(wtSide)

bWidth = 14
bHeight = 2
bXMargin = 3
bYMargin = 2
bPerLine = 4

farms =	{ -- 
	{id = "b1", name = "Skele Grinder", freqIn = 4100, freqOut = 4600, onState = false},
	{id = "b2", name = "Zombie Grinder", freqIn = 4101, freqOut = 4601, onState = false},
	{id = "b3", name = "Creeper Grinder", freqIn = 4105, freqOut = 4605, onState = false},
	{id = "b4", name = "Wither Grinder", freqIn = 4104, freqOut = 4604, onState = false},
	{id = "b5", name = "Ender Grinder", freqIn = 4102, freqOut = 4602, onState = false},
	{id = "b6", name = "Blaze Grinder", freqIn = 4103, freqOut = 4603, onState = false},
	{id = "b7", name = "Slime Grinder", freqIn = 4109, freqOut = 4609, onState = false},
	{id = "b8", name = "Spider Grinder", freqIn = 4110, freqOut = 4610, onState = false},
	{id = "b9", name = "Fir Wood Farm", freqIn = 4200, freqOut = 4700, onState = true},
	{id = "b10", name = "Wheat Farms", freqIn = 4202, freqOut = 4702, onState = false},
	{id = "b11", name = "Cocoa Farm", freqIn = 4203, freqOut = 4703, onState = true}
	--{id = "b10", name = "Test", freqIn = 1, freqOut = 2, onState = true},
	--{id = "b11", name = "Test", freqIn = 1, freqOut = 2, onState = true},
	--{id = "b12", name = "Test", freqIn = 1, freqOut = 2, onState = true},
	--{id = "b13", name = "Test", freqIn = 1, freqOut = 2, onState = true},
	--{id = "b14", name = "Test", freqIn = 1, freqOut = 2, onState = true},
	--{id = "b15", name = "Test", freqIn = 1, freqOut = 2, onState = true},
	--{id = "b16", name = "Test", freqIn = 1, freqOut = 2, onState = true}
}

function pulse(freqIn)
	wt.setFreq(freqIn)
	redstone.setOutput(wtSide, true)
	sleep(.2)
	redstone.setOutput(wtSide, false)
	updateAll()
end

function getBPos(num)
	line = math.ceil(num / bPerLine)
	col = ((num - 1) % bPerLine) + 1
	--print(line .. " " .. col)
	
	x1 = (bXMargin * col) + (bWidth * (col - 1))
	x2 = x1 + bWidth
	
	y1 = (bYMargin * line) + (bHeight * (line - 1))
	y2 = y1 + bHeight
	
	return x1, x2, y1, y2
end

function addButton(id, text, freqIn, num)
	x1, x2, y1, y2 = getBPos(num)
	button.add(id, text, "toggle", x1, y1, x2, y2, colors.lime, colors.red, colors.white, function() pulse(freqIn) end)
end

function update(v)
	wr.setFreq(v.freqOut)
	state = redstone.getInput(wrSide)
	bState = state
	if(state == v.onState) then
		bState = true
	else
		bState = false
	end
	button.setState(v.id, bState)
end

function updateAll()
	for i, v in pairs(farms) do
		update(v)
	end
	button.draw()
end

function refresh()
	print("Refreshing...")
	updateAll()
end

function addRefresh()
	mWidth, mHeight = m.getSize()
	x1 = 0
	x2 = mWidth
	y1 = mHeight
	y2 = mHeight
	button.add("refresh", "Refresh", "flash", x1, y1, x2, y2, colors.blue, colors.orange, colors.white, refresh)
end

function makeButtons()
	for i, v in pairs(farms) do
		addButton(v.id, v.name, v.freqIn, i)
	end
	addRefresh()
end

makeButtons()
updateAll()
while true do
	button.check()
	updateAll()
end