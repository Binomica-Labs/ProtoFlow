local StepPool = {}
print("StepPool LIBRARY LOADED")
local md5 = require("md5")

local pool = {}

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



local function loadPoolFromFile(poolFile)
	pool = {}
	stepTable = {}
	local poolStep = ""
	local tsvPool = io.open(poolFile, "r")
	for line in tsvPool:lines() do
		print("ADDING TO stepTable")
		stepTable = splitBySep(line, "\t")
		print("STEP TABLE 1: " .. stepTable[1])

			local tempHandle = stepTable[1]
			local tempName = stepTable[2]
			local tempLab = stepTable[3]
			local tempProtCategory = stepTable[4]
			local tempProtocolName = stepTable[5]
			local tempProtocolDescription = stepTable[6]
			local tempProtocolNumber = stepTable[7]
			local tempStepNumber = stepTable[8]
			local tempStepTime = stepTable[9]
			local tempMediaBool = stepTable[10]
			local tempStepData = stepTable[11]
			local tempStepID = tempHandle .. "-" .. tempProtocolNumber .. "-" .. tempStepNumber

			pool[tempStepID] = {userHandle = tempHandle,
				userName = tempName, 
				userLab = tempLab,
				protocolCategory = tempProtCategory,
				protocolTitle = tempProtocolName,
				protocolDescription = tempProtocolDescription,
				protocolNumber = tempProtocolNumber,
				stepNumber = tempStepNumber,
				stepTime = tempStepTime,
				mediaBool = tempMediaBool,
				stepData = tempStepData}
				print(pool[tempStepID].stepNumber)
	end
	tsvPool:close()
	return pool
end



local function parseRawProtocol(rawProtFilePath)
	local polishedProtocol = {}
	local counter = 1
	local rawFile = io.open(rawProtFilePath, "r+")
	local rawFileLines = rawFile:lines()
	for line in rawFile:lines() do
		local rawLines = {}
		rawLines = line:split(": ")
		
		if counter <= 5 then
			polishedProtocol[counter] = rawLines[2]
		else
			polishedProtocol[counter] = rawLines[1]
		end
		
		counter = counter + 1
	end	

	rawFile:close()
	return polishedProtocol
end



local function countProtocols(inputHandle)
	local userList = {}
	local protocolCount = 0;

	local rawUserList = io.open("Admin/users.txt", "a+")
		
		if not rawUserList then
			print("")
			print("")
			print("Error: could not open user list; check file name and path!")
			print("")
			print("")
			return
		end
			
	for line in rawUserList:lines() do
			local currentUserInfo = {}
			currentUserInfo = split(line, "/")
			local currentUserName = currentUserInfo[2]
			local currentUserHandle = currentUserInfo[1]
			local currentUserProtocolCount = currentUserInfo[3]
			
			userList[currentUserHandle] = {user = currentUserName, 
					  					 userHandle = currentUserHandle,
										 userProtocolCount = currentUserProtocolCount}
	end

	protocolCount = userList[inputHandle].userProtocolCount
	rawUserList:close()
	return protocolCount
end



local function count(base, pattern)
	return select(2, string.gsub(base, pattern, ""))
end



local function savePoolToFile()
	local TSVtable = {}
	local count = 0
	for _ in pairs(pool) do
		count = count + 1
		TSVtable[count] = pool[_].userHandle .. "\t" ..
						  pool[_].userName .. "\t" ..
						  pool[_].userLab .. "\t" ..
						  pool[_].protocolCategory .. "\t" ..
						  pool[_].protocolTitle .. "\t" ..
						  pool[_].protocolDescription .. "\t" ..
						  pool[_].protocolNumber .. "\t" ..
						  pool[_].stepNumber .. "\t" ..
						  pool[_].stepTime .. "\t" ..
						  pool[_].mediaBool .. "\t" ..
						  pool[_].stepData .. "\n"
	end

	for i = 1, count do
			  print("SAVING POOL TO FILE")
		local tsvPool = io.open("Admin/pool.tsv", "a+")
			  tsvPool:write(TSVtable[i])
			  tsvPool:close() 
	end
end



local function stepGen(protocol)
		local stepList = {}
		local tempLines = {}
		local tempStepNumber = 0
		local tempStepID = ""
		local tempSteps = {}
		local TSVsteps = {}
		local tempHandle = protocol[1]
		local tempName = protocol[2]
		local tempLab = protocol[3]
		local tempProtocolName = protocol[4]
		local tempProtocolDescription = protocol[5]

		--add protocol number generator code here or call function here
		local tempProtocolNumber = countProtocols(tempHandle) + 1 --append protocol count
		
		for i = 6, #protocol do
			
			tempSteps[(i-5)] = protocol[i]
		end
		
		for i = 1, #tempSteps do
			tempStepNumber = i
			tempStepID = tempHandle .. "-" .. tempProtocolNumber .. "-" .. tempStepNumber
			print(tempStepID)
			TSVsteps[i] = tempStepID .. "\t" .. 
						  tempHandle .. "\t" .. -- user handle
						  tempName .. "\t" .. --user name
						  tempLab .. "\t" .. --lab name
						  tempProtocolNumber .. "\t" .. --protocol number
						  tempProtocolName .. "\t" .. --protocol name
						  tempProtocolDescription .. "\t" ..	--protocol description
					  	  tempStepNumber .. "\t" ..
					 	  tempSteps[i] .. "\n" --actual step instructions	

				pool[tempStepID] = {userHandle = tempHandle,
				userName = tempName, 
				userLab = tempLab,
				protocolCategory = "@@@@",
				protocolTitle = tempProtocolName,
				protocolDescription = tempProtocolDescription,
				protocolNumber = tempProtocolNumber,
				stepNumber = tempStepNumber,
				stepTime = "@@@@",
				mediaBool = "@@@@",
				stepData = tempSteps[i]}

		end
			
		local tsvPool = io.open("TestFiles/testPool.tsv")
		local poolString = tsvPool:read("*all")	
		tsvPool:close()
		table.sort(pool)
		for k in pairs(pool) do
			print("K: " .. k)
			print("POOL STRING LENGTH: " .. #poolString) 
			local dupCount = 0
			_, dupCount = string.gsub(poolString, "([^"..k.."]*)("..k.."?)", "")
			if dupCount > 0 then
				print("DUPS FOUND!!!")
				print(dupCount)
			else
				print("NO DUPS")
			end
		end
		
	return TSVsteps
end





local function testStuff()
stepGen(parseRawProtocol("RawProtocols/tobaccoGMO.txt"))
--pool = loadPoolFromFile("Admin/pool.tsv")
--savePoolToFile()
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
end

function StepPool:removeStep()
	
end

function StepPool:addProtocol()
	
end

function StepPool:removeProtocol()

end

function StepPool:initPool()
		testStuff()
	print("POOL LOADED")
	local snapBack = "POOL LOADED"	
	--loadPoolFromFile("TestFiles/testPool.tsv")	
	return snapBack
end

return StepPool
