
local SF_ADMINS <const> = "Resources/Server/Whitelist/data/admins.json"
local SF_WHITELIST <const> = "Resources/Server/Whitelist/data/whitelist.json"

local ADMINS = {}
local WHITELISTED = {}

local function messageSplit(message)
	local messageSplit = {}
	local nCount = 0
	for i in string.gmatch(message, "%S+") do
		messageSplit[nCount] = i
		nCount = nCount + 1
	end
	
	return messageSplit
end

local function tableSize(table)
	if type(table) ~= "table" then return 0 end
	local len = 0
	for k, v in pairs(table) do
		len = len + 1
	end
	return len
end


local function loadData()
	local handle = io.open(SF_ADMINS, "r")
	local data = Util.JsonDecode(handle:read("*all"))
	handle:close()
	
	for _, playerName in pairs(data.list) do
		ADMINS[playerName] = true
	end
	
	local handle = io.open(SF_WHITELIST, "r")
	local data = Util.JsonDecode(handle:read("*all"))
	handle:close()
	
	for _, playerName in pairs(data.list) do
		WHITELISTED[playerName] = true
	end
	
	if tableSize(ADMINS) == 0 then
		print("Whitelist - CRITICAL. NO ADMINS ARE SET")
		print("Set to: Resources/Server/Whitelist/data/admins.json")
		print('Set as: {"list":["YourPlayerNameHere","AnyOtherPlayerNameHere"]}')
	end 
end

local function saveData()
	if tableSize(ADMINS) > 0 then
		local data = {}
		data["list"] = {}
		for playerName, _ in pairs(ADMINS) do
			table.insert(data.list, playerName)
		end
	
		local handle = io.open(SF_ADMINS, "w")
		handle:write(Util.JsonEncode(data))
		handle:close()
	end
	
	if tableSize(WHITELISTED) > 0 then
		local data = {}
		data["list"] = {}
		for playerName, _ in pairs(WHITELISTED) do
			table.insert(data.list, playerName)
		end
	
		local handle = io.open(SF_WHITELIST, "w")
		handle:write(Util.JsonEncode(data))
		handle:close()
	end
end

function onChatMessage(senderId, senderName, message)
	if string.sub(message, 0, 3) ~= '/wl' then return 0 end
	if ADMINS[senderName] == nil then MP.SendChatMessage(senderId, "You are not an Admin"); return 1 end
	
	local message = messageSplit(message)
	if tableSize(message) < 2 then return 1 end
	if string.lower(message[1]) == "makeadmin" then
		if message[2] == nil then MP.SendChatMessage(senderId, "Missing Name"); return 1 end
		ADMINS[message[2]] = true
		saveData()
		MP.SendChatMessage(senderId, 'Made "' .. message[2] .. '" a admin')
		return 1
		
	elseif string.lower(message[1]) == "removeadmin" then
		if message[2] == nil then MP.SendChatMessage(senderId, "Missing Name"); return 1 end
		ADMINS[message[2]] = nil
		saveData()
		MP.SendChatMessage(senderId, 'Removed "' .. message[2] .. '" from admin')
		return 1
		
	elseif string.lower(message[1]) == "grant" then
		if message[2] == nil then MP.SendChatMessage(senderId, "Missing Name"); return 1 end
		WHITELISTED[message[2]] = true
		saveData()
		MP.SendChatMessage(senderId, 'Whitelisted "' .. message[2] .. '"')
		return 1
		
	elseif string.lower(message[1]) == "deny" then
		if message[2] == nil then MP.SendChatMessage(senderId, "Missing Name"); return 1 end
		WHITELISTED[message[2]] = nil
		saveData()
		MP.SendChatMessage(senderId, 'Removed "' .. message[2] .. '"')
		return 1
		
	else
		MP.SendChatMessage(senderId, "Unknown Command: " .. message[1])
		return 1
	end
	
end

function onPlayerAuth(senderName, senderRole, senderIsGuest, senderIdentifiers)
	if WHITELISTED[senderName] == nil and ADMINS[senderName] == nil then return "This Server is Whitelisted" end
end

loadData()
MP.RegisterEvent("onChatMessage", "onChatMessage")
MP.RegisterEvent("onPlayerAuth", "onPlayerAuth")

print("Whitelist v1.0-basic Ready")
print('"/wl makeadmin PlayerName" - makes this player a Admin')
print('"/wl removeadmin PlayerName" - removes this players admin status')
print('"/wl grant PlayerName" - Whitelists this player')
print('"/wl deny PlayerName" - Unwhitelists this player')
