-- By Roachy
sleepWait = .5
delayWait = 2
open = false
closed = true
inputSide = "left"
outputSide = "back"

local function getState()
	return redstone.getOutput(outputSide)
end

local function getInput()
	return redstone.getInput(inputSide)
end

local function doOpen()
	print("Toggling gate to OPEN...")
	redstone.setOutput(outputSide, open)
end

local function doClose()
	print("Toggling gate to CLOSED...")
	redstone.setOutput(outputSide, closed)
end

local function toggle()
	state = getState()
	if(state == closed) then
		doOpen()
	elseif(state == open) then
		doClose()
	else
		print("Invalid state detected. Opening gate...")
		doOpen()
	end
end

print("Starting up...")
doClose()

while true do
	sleep(sleepWait)
	if(getInput()) then
		print("Input received.")
		toggle()
		sleep(delayWait)
	end
end