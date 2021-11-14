local Format = {}

function Format:formatProtocol(inputFile)
	local rawProtocol = io.open(inputFile, "r")
	local protocol = {}
	local steps = {}
		
	for line in rawProtocol do
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
return Format
