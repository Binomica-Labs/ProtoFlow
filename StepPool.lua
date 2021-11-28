local StepPool = {}

local pool = {}
pool.userHandle = ""
pool.userName = ""
pool.userLab = ""
pool.protocolCategory = ""
pool.protocolTitle = ""
pool.protocolDescription = ""
pool.protocolNumber = ""
pool.stepNumber = ""
pool.stepTime = ""
pool.mediaBool = ""
pool.stepData = ""

--pool["SSC-001-001"].userHandle = "SSC"
--pool["SSC-001-023"].stepNumber = "23"

local function fileExists(fileName)
	local f = io.open(fileName, "r")
	if f ~= nil then io.close(f)
	return true
	else
	return false
	end
end



function string:split(delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from, true)
    while delim_from do
        if (delim_from ~= 1) then
            table.insert(result, string.sub(self, from, delim_from-1))
        end
   	    from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from, true)
    end
    if (from <= #self) then table.insert(result, string.sub(self, from)) end
    return result
end



local function splitBySep(inputstr, sep) 
	sep = sep or '%s' 

	local t={}  

	for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do 
		table.insert(t,field)  
		if s == "" then 
			return t 
		end 
	end 
end



local function splitByChunk(text, chunkSize)
	local s = {}
	for i=1, #text, chunkSize do
		s[#s+1] = text:sub(i,i+chunkSize - 1)
		end
	return s
end



--works as of 11-22-21
local function parseRawProtocol(rawProtFilePath)
	local polishedProtocol = {}
	local counter = 1
	local rawFile = io.open(rawProtFilePath, "r+")
	local rawFileLines = rawFile:lines()
	for line in rawFile:lines() do
		local rawLines = {}
		rawLines = line:split(": ")
		
		if counter <= 6 then
			polishedProtocol[counter] = rawLines[2]
				--print(polishedProtocol[counter])
		else
			polishedProtocol[counter] = rawLines[1]
				--print(polishedProtocol[counter])
		end
		
		counter = counter + 1
	end	

	rawFile:close()
	for i = 1, #polishedProtocol do
		print(polishedProtocol[i])
	end
	return polishedProtocol
end

parseRawProtocol("RawProtocols/tobaccoGMO.txt")

local function stepGen(protocol)

		local steps = {}
		local tempHandle = protocol[1]
		local tempName = protocol[2]
		local tempLab = protocol[3]
		local tempProtocolName = protocol[4]
		local tempProtocolDecription = protocol[5]
		for i = 6, #protocol do
			table.insert(protocol[i], steps)
		end
		print("last step: " .. step[1])



		--SSC	001 	001		600		"Spin down cells at 4500rpm for 10 minutes"
		local IDtab = splitByChunk(rawStepID, 3)
		local formattedStep = IDtab[1] .. "\t" .. --"SSC" user handle
							  IDtab[2] .. "\t" .. --"001" protocol number
							  IDtab[3] .. "\t" .. --"001" step number
							  timeNeeded  .. "\t" .. --"600" time os step in seconds
							  rawStep .. "\n" --"Spin down cells at 4500rpm for 10 minutes" step data			
	return formattedStep
end



local function checkHandle(userHandle, userList)
	if fileExists("Admin/users.txt") ~= true then
			print("Error: Cannot open User List file. Check Admin/users.txt!\n")
			return 
	end

	if userList[userHandle]~=nil then 
		return true
		else return false
	end
end



function StepPool:initializePool()
	if fileExists("Admin/pool.txt") ~= true then
		print("Error: Cannot open Step Pool file. Check Admin/pool.txt! \n")
		return 
	end
end



function StepPool:addStep(stepID, step, timeNeeded, v)
	if v~=nil then
		io.write("Let's add a step to an existing protocol! First, let's begin with your user handle. This is a 3 letter all-caps code you assigned when you made a user name. ex. SSC\n")

		local inputHandle = io.read()
		if checkHandle(inputHandle) ~= true then

			io.write("Welcome back, " .. inputHandle .. "!" .."\n")
			io.write("Tell me what protocol number this step will be adding to? ")
			local inputProtocol = io.read()
			if checkProtocol(inputProtocol) ~= nil then
				io.write("I found a protocol matching this number. Is this correct: \n")
				io.write(pool[inputHandle].stepData)  --still brokewn 
				io.write("Saving your user name and handle to file!\n")
				rawUserList:write(userName .. "/" .. userHandle .. "\n")
				rawUserList:close()

			else print("Please type in a User Name!\n")
			end
	end		
	if pool[stepID] ~= nil then
		local step = formatStep(stepID, step, timeNeeded)
		table.insert(pool, step)
	end	
end



function StepPool:removeStep()

end



function StepPool:addProtocol()

end



function StepPool:removeProtocol()

end



return StepPool
end
