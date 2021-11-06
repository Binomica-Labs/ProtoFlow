--[[
		Copyright 2021 - Sebastian S. Cocioba - Binomica Labs

		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--



--functions
function convertToPDF(input, output)
local protocol = {}
local steps = {}

for line in input:lines() do
	table.insert(protocol, line)
end

print("Number of lines in protocol: "..#protocol)
print("First line of protocol: "..protocol[1])

local IDnum = protocol[1]
local Author = protocol[2]
local Title = protocol[3]
local Description = protocol[4]

for i=4, #protocol do
 steps[i-4] = protocol[i]
end

--some colsole read outs to check variables loaded properly
print(IDnum)
print(Author)
print(Title)
print(Description)
if #steps <= 1 then print("Steps: 1") end
if #steps > 1 then print("Steps: " .. #steps - 1) end
print("First Step: " .. steps[1])
end



function formatProtocol(inputData)
	local protocol = {}
	local steps = {}
	
	for line in inputData:lines() do
		table.insert(protocol, line)
	end
	
	local idNum = protocol[1]
	local author = protocol[2]
	local title = protocol[3]
	local description = protocol[4]

	local authID = "SSC"
	local methodType = "BACT"
	local currentStepTime = 60
	local currentImagePath = "1.jpg"
	local currentStepNumber = 1
	
	for i=4, #protocol do
		steps[i-4] = protocol[i]
	end

	for i=0, #steps-1 do
		local currentStep = step[i]
		local formattedStep = authID .. "," .. 
							  methodType .. "," ..
							  currentStepNumber .. "," ..
							  currentStepTime .. "," ..
							  currentImagePath .. "," ..
							  currentStep 
	end
				
end



function newUser()
	io.write("Hello and welcome, new user! What's your name? ")
	local userName = io.read()
	io.write("Nice to meet you, " .. userName .. "!")
end



--handle passed arguments for later use 
if #arg < 1 then
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
	local inputFile = io.open(arg[2], "r")
	formatProtocol(inputFile)
	if not inputFile then
		print("")
		print("")
		print("Error: could not open file; check file name and path!")
		print("")
		print("")
		return
	end
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



if arg[1] == "newuser" then
	newUser()
end
