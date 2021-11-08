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
	local currentUserName = currentUserInfo[1]
	local currentUserHandle = currentUserInfo[2]
	users[currentUserName] = {userName = currentUserName, 
							 userHandle = currentUserHandle}
	print("User name: " .. users[currentUserName].userName)
	print("User Handle: " .. users[currentUserName].userHandle)
	print("************************")
end
	print("end of users list")



function Users:newUser()
	io.write("Hello and welcome, new user! What's your name? ")
	local userName = io.read()
	if userName ~= "" then
	io.write("Nice to meet you, " .. userName .. "!" .."\n")
	io.write("What's your 3 letter author handle? ")
	local userHandle = string.upper(io.read())
	io.write("Saving your user name and handle to file!\n")
	rawUserList:write(userName .. "/" .. userHandle)
	rawUserList:close()
	else print("Please type in a User Name!\n")
	end
end

function Users:getUsers(userList)
	local rawlist = {}
end



function Users:setUsers()
	
end

return Users
