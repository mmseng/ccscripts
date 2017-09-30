local arg = { ... }

local urlPath = "http://minecraft.theroach.net/minecraft/ftb/turtle/"
local filename = arg[1]
local url = urlPath .. filename
local urlFile = http.get(url)
local text = urlFile.readAll()
urlFile:close()

local path = "/my/" .. filename
local file = io.open(path, "w")
file:write(text)
file:close()

