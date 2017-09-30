wait = 1

p = peripheral.wrap("top")
p.setTextScale(1)

side = "right"
frontLeft = colors.yellow
frontRight = colors.white
backLeft = colors.brown
backRight = colors.black

frontLeftCount = 0
frontRightCount = 0
backLeftCount = 0
backRightCount = 0

count = 0
blocks = 0

countFile = "my/golemCount.txt"
countFileBackup = "my/golemCountBackup.txt"
file = io.open(countFile, "r")
count = tonumber(file:read())
file:close()

frontLeftStatus = rs.testBundledInput(side, frontLeft)
frontRightStatus = rs.testBundledInput(side, frontRight)
backLeftStatus = rs.testBundledInput(side, backLeft)
backRightStatus = rs.testBundledInput(side, backRight)

function newLine()
	local _,cY = p.getCursorPos()
	p.setCursorPos(1,cY+1)
end

function clear()
	p.clear()
	p.setCursorPos(1, 1)
end

function display()
	clear()
	p.write("Golems served:")
	newLine()
	p.write(tostring(count))
	newLine()
	newLine()
	
	blocks = math.floor((count * 4 / 9) + 0.5)
	p.write("Iron blocks:")
	newLine()
	p.write("~" .. blocks)
end

display()
while true do

	frontLeftCount = 0
	frontRightCount = 0
	backLeftCount = 0
	backRightCount = 0
	
	if(rs.testBundledInput(side, frontLeft) ~= frontLeftStatus) then
		frontLeftStatus = rs.testBundledInput(side, frontLeft)
		frontLeftCount = frontLeftCount + 1
	end
	
	if(rs.testBundledInput(side, frontRight) ~= frontRightStatus) then
		frontRightStatus = rs.testBundledInput(side, frontRight)
		frontRightCount = frontRightCount + 1
	end
	
	if(rs.testBundledInput(side, backLeft) ~= backLeftStatus) then
		backLeftStatus = rs.testBundledInput(side, backLeft)
		backLeftCount = backLeftCount + 1
	end
	
	if(rs.testBundledInput(side, backRight) ~= backRightStatus) then
		backRightStatus = rs.testBundledInput(side, backRight)
		backRightCount = backRightCount + 1
	end
	
	newCount = count + frontLeftCount + frontRightCount + backLeftCount + backRightCount
	
	if(newCount ~= count) then
		file = io.open(countFileBackup, "w")
		file:write(tostring(count))
		file:close()
		
		file = io.open(countFile, "w")
		file:write(tostring(count))
		file:close()
		
		clear()
		p.write("Golems served:")
		newLine()
		p.write(tostring(count))
		newLine()
		newLine()
		
		blocks = math.floor((count * 4 / 9) + 0.5)
		p.write("Iron blocks:")
		newLine()
		p.write("~" .. blocks)
	end
	
	display()
	
	sleep(1)
end