local Users = {}
local userList = {}

function split(inputstr, sep) 
	sep = sep or '%s' 

	local t={}  

	for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do 
		table.insert(t,field)  
		if s == "" then 
			return t 
		end 
	end 
end

local function Set(list)
		local set = {}
		for _, l in ipairs(list) do set[1] = true end
		return set
end



function Users:newUser()
	local userName = ""
	os.execute("clear")
	io.write("Hello and welcome! What's would you like your user handle to be?\n")
	io.write("This is a 3 letter uppercase ID, typically your name initials. Please be respectful of letter choice.\n")
	io.write("Please type in a 3 letter handle and hit enter: ")
	local handle = string.upper(io.read())
	if handle ~= "" then

		local rawUserList = io.open("Admin/users.txt", "r+")
	
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

		
		if not userList[handle] then
			io.write("Nice to meet you, " .. handle  .. "!" .."\n")
			io.write("What's your human name?\n")
			io.write("You don't need a real name, just something to ID and cite you with. Be respectful.\n")
			io.write("Please type in a name and hit enter: ")
		    userName = io.read()
			io.write("Saving your user name and handle to file!\n")
			rawUserList:write(handle .. "/" .. userName .. "/" .. 0 .. "\n")
			io.write("New user " .. userName .." with the handle " .. handle .. " has been added to the list!\n")
			io.write("Please check to see if your name is on the list by using the listusers command.\n")
		
			rawUserList:close()
		else
			io.write("Welcome back, " .. userList[handle].user .."!")
		end
	else print("Please type in a valid user handle!\n")
	end
end



function Users:getUsers()
	local userTable = {}
	local rawUserList = io.open("Admin/users.txt", "r+")
	
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
		print("LINE LENGTH: " .. #currentUserInfo)
		local currentUserName = currentUserInfo[2]
		local currentUserHandle = currentUserInfo[1]
		local currentUserProtocolCount = currentUserInfo[3]
		print("CURRENT PROT COUNT: " .. currentUserInfo[3])

		userTable[currentUserHandle] = {userName = currentUserName, 
								 userHandle = currentUserHandle,
								 userProtocolCount = currentUserProtocolCount}

		print("User name: " .. userTable[currentUserHandle].userName)
		print("User Handle: " .. userTable[currentUserHandle].userHandle)
		print("User Protocol Count: " .. userTable[currentUserHandle].userProtocolCount)
		print("************************")
	end
	rawUserList:close()
	return userTable
end

return Users
