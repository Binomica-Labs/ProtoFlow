local Users = {}
local userList = {}
local users = {}

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



function Users:newUser(activeUserList)
	os.execute("clear")
	io.write("Hello and welcome! What's your user handle? ")
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

		users[currentUserName] = {user = currentUserName, 
								 userHandle = currentUserHandle}
	end

		--BROKEN LOGIC
		if not users[handle] then
			io.write("Nice to meet you, " .. handle  .. "!" .."\n")
			io.write("What's your human name? ")
			local userName = io.read()
			io.write("Saving your user name and handle to file!\n")
			rawUserList:write(handle .. "/" .. userName .. "\n")
			rawUserList:close()
		else
			io.write("Welcome back, " .. users[userHandle].userName .."!")
		end
	else print("Please type in a User Name!\n")
	end
end



function Users:getUsers(userList)

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

		users[currentUserName] = {userName = currentUserName, 
								 userHandle = currentUserHandle}

		print("User name: " .. users[currentUserName].userName)
		print("User Handle: " .. users[currentUserName].userHandle)
		print("************************")
	end
		print("end of users list")
	return users
end

return Users
