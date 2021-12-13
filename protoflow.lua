--[[
		Copyright 2021 - Sebastian S. Cocioba - Binomica Labs

		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--



--functions
local users = require("Users")
--local format = require("Format")
--local generator = require("Generator")
local pool = require("StepPool")


--handle passed arguments for later use 
if #arg < 1 then
	os.execute("clear")
	print("")
	print("ProtoFlow v1.0 - CLI Bioprotocol Designer")
	print("----------------------------------------------------------------------------")
	print("")
	print("usage: lua " .. arg[0] .. " [protocol file name] [output PDF name]  ")
	print("")
	print("example input: lua protoflow testProtocol.txt testOutput.pdf")
	print("")
	return
end




if arg[1] == "newprotocol" then
	local activeUsers = {}
	local currentChoice = ""
	os.execute("clear")
	io.write("What's your user handle? ")
	local handle = string.upper(io.read())
	print("Getting user list...\n")
	activeUsers = users:getUsers()

	if not activeUsers[handle] then
		print("User not found! User command listusers or read above to see if your user name is there.\n")
	else 
		print("Welcome back, ".. activeUsers[handle].userName .."!\n")
		print("Choose a category for your new protocol using the list below:\n")
		local catFile = io.open("Admin/categories.txt", "r")

		if not catFile then
			print("")
			print("")
			print("Error: could not open file; check file name and path!")
			print("")
			print("")
		return
		end
		local categories = catFile:read("*a")
		io.write(categories)
		catFile:close()
		print("Please type in the 4 letter category code that best fits your protocol: ")
		local currentCategory = string.upper(io.read())
		print("Alright, your new protocol's category is " .. currentCategory .. ". Now, please tell me the title of your protocol.")
		print("Type in a short but descriptive title here: ")
		local currentTitle = io.read()
		print("Got it. Your new protocol's title is " .. currentTitle .. ". Onto the description!")
		print("Please type in a more thorough description of the protocol, its purpose, etc: ")
		local currentDescription = io.read()
		os.execute("clear")
		print("Sounds good. Here's what I got so far:")
		print("Handle: " .. handle)
		print("Author: " .. activeUsers[handle].userName)
		print("Title: " .. currentTitle)
		print("Description: " .. currentDescription .. "\n")
		io.write("Is this correct? Type in yes or no: ")
		local reply = string.upper(io.read())
		::editDetails::
		if reply == "YES" then
			--continue
		elseif reply == "NO" then
			print("Which section would you like to change? Please choose a letter for (H)andle, (A)uthor, (T)itle, or (D)escription: ") 
			
			currentChoice = string.upper(io.read())
			if currentChoice == "H" then
				print("What shall your new handle be?")
				handle = io.read()
				print("Alright, your new protocol's corrected handle is " .. handle)
			elseif	currentChoice == "A" then
				print("What shall your protocol's new Author Name be?")
				local currentUsername = io.read()
				print("Alright, your new protocol's corrected Author Name is " .. currentUsername)
			elseif	currentChoice == "T" then
				print("What shall your protocol's new Title be?")
				local currentTitle = io.read()
				print("Alright, your new protocol's corrected title is " .. currentTitle)
			elseif	currentChoice == "D" then
				print("What shall your protocol's new Description be?")
				local currentDescription = io.read()
				print("Alright, your new protocol's corrected Author Name is " .. currentDescription)
			else
				print("Please type in a letter corresponding to either (H)andle, (A)uthor, (T)itle, or (D)escription: ")
				goto editDetails			
			end		
		else
			
		end
		end
	
end


--[[
if arg[1] == "format" then
--set file logic and catch loading errors
	if not arg[2] then 
		print("")
		print("")
		print("Error: Please define a file to be formatted!")
		print("")
		print("")
		return
	end
	
		fileToFormat = io.open(arg[2], "r")

	if not fileToFormat then
		print("")
		print("")
		print("Error: could not open file; check file name and path!")
		print("")
		print("")
		return
	end
		--print("format input file loaded")
		format.formatProtocol(fileToFormat)
end

]]--

if arg[1] == "compile" then
--set file logic and catch loading errors
	local inputFile = io.open(arg[2], "r")
	local outputFile = io.open(arg[3], "w")
	convertToPDF(inputFile, outputFile)
	if not inputFile or not outputFile then
		print("")
		print("")
		print("Error: could not open files; check file names and paths!")
		print("")
		print("")
		return
	end
end


--works as of 11-20-21
if arg[1] == "listusers" then
	users.getUsers()
end


--works as of 11-21-21
if arg[1] == "listcats" then

	catFile = io.open("Admin/categories.txt", "r")

	if not catFile then
		print("")
		print("")
		print("Error: could not open file; check file name and path!")
		print("")
		print("")
		return
	end
	io.write("I found some cats!\n")
	local categories = catFile:read("*a")
	io.write(categories)
	catFile:close()
end


--works as of 11-20-21
if arg[1] == "newuser" then
	activeUsers = users.newUser()	
end


