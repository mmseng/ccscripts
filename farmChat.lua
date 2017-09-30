local args = { ... }
local chatRoll = args[1]

p = peripheral.wrap("left")

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
          if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
          end
          last_end = e+1
          s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
          cap = pString:sub(last_end)
          table.insert(Table, cap)
   end
   return Table
end

local chats = split(chatRoll, ";")
local chatArray = {}
local chat = "No text set"
local delay = "No delay set"
local lastDelay = 0
local wait = 0

for num, chatPair in pairs(chats) do
	chatArray = split(chatPair, ":")
	chat = string.gsub(chatArray[1], "=", " ")
	delay = tonumber(chatArray[2])
	wait = delay - lastDelay
	
	print("Sleeping " .. wait .. " seconds...")
	sleep(wait)
	
	print(chat)
	p.say(chat)
	
	lastDelay = delay
end