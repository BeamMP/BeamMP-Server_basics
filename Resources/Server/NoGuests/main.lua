function onInit()
	print("NoGuests v1.0-basic Ready")
	MP.RegisterEvent("onPlayerAuth","onPlayerAuth")
end

function onPlayerAuth(name, role, isGuest)
	if isGuest then
		return "You must be signed in to join this server!"
	end
end
