local Generator = {}

function Generator:convertToPDF(input, output)
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

return Generator
