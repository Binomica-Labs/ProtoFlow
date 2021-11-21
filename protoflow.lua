--[[
		Copyright 2021 - Sebastian S. Cocioba - Binomica Labs

		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--



--functions
local users = require("Users")
local format = require("Format")
local generator = require("Generator")
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



if arg[1] == "newuser" then
	users.newUser()
end
