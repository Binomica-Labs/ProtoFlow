--[[
Copyright 2021 - Sebastian S. Cocioba - Binomica Labs
Inspired by a Tweet from @JacobPhD (Dr. Jacob A Tennessen)
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

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

--set file logic and catch loading errors
local inputFile = io.open(arg[1], "r")
local outputFile = io.open(arg[2], "w")
if not inputFile or not outputFile then
	print("")
	print("")
	print("Error: could not open files; check file names and paths!")
	print("")
	print("")
	return
end

protocol = {}
steps = {}

for line in inputFile:lines() do
	table.insert(protocol, line)
end

print("Number of lines in protocol: "..#protocol)
print("First line of protocol: "..protocol[1])

IDnum = protocol[1]
Author = protocol[2]
Title = protocol[3]
Description = protocol[4]

for i=4, #protocol do
 steps[i-4] = protocol[i]
end

print("First Step: " .. steps[1])

print("protocol parsing ready")
print(IDnum)
print(Author)
print(Title)
print(Description)
print("Steps: "..#steps)
print(steps[1])
