local args = { ... }

p = peripheral.wrap("right")

emptyRef = 1
bookRef = 2
books = 3
eBook = 4
enchLevel = tonumber(args[1])
pause = 1
currLevel = 0
outOfBooks = false

function suckBooks()
	turtle.suckDown()
	if not turtle.compareTo(bookRef) then
		print("No books found in chest, disabling enchanting.")
		outOfBooks = true
	else
		print("Books grabbed from chest.")
		outOfBooks = false
	end
end

function getBook()
	print("Checking for book...")
	turtle.select(books)
	if turtle.compareTo(bookRef) then
		print("Book(s) found in slot #" .. books .. ".")
		outOfBooks = false
	elseif turtle.compareTo(emptyRef) then
		print("Slot #" .. books .. " is empty, sucking from chest...")
		suckBooks()
	else
		print("Slot #" .. books .. " not a book and not empty, dropping item...")
		turtle.dropDown()
		print("Sucking from chest...")
		suckBooks()
	end
	
	if not outOfBooks then
		turtle.transferTo(eBook, 1)
	end
end	

function enchBook()
	if not outOfBooks then
		turtle.select(eBook)
		if p.enchant(enchLevel) then
			print("Enchant successful, dropping enchanted book...")
			dropBook()
		else
			print("Enchant failed!?")
		end
	else
		print("Out of books, skipping enchant.")
	end
end

function dropBook()
	turtle.select(eBook)
	turtle.dropDown()
end

function ench()
	print("Getting a book...")
	getBook()
	print("Enchanting book...")
	enchBook()
end

turtle.select(books)
while true do
	sleep(pause)
	p.collect()
		
	local newLevel = p.getLevels()
	if(newLevel ~= currLevel) then
		currLevel = newLevel
		print("Level: " .. currLevel)
	end
	
	if p.getLevels() >= enchLevel then
		print("Level " .. enchLevel .. " reached, enchanting...")
		ench()
	end
end