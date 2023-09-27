-- Define the words you want to censor
local censoredWords = {
  "fuck",
  "shit",
  "censor",
  "cock",
}

function CensorMessage(message)
  local censoredMessage = message
  for _, word in ipairs(censoredWords) do
      -- Create a pattern to match the word while ignoring case
      local pattern = "(.-)(" .. word .. ")(.*)"
      local start, _, rest = censoredMessage:lower():match(pattern)

      if start and rest then
          -- Replace the censored word with asterisks of the same length
          local asterisks = string.rep("*", #word)
          censoredMessage = start .. asterisks .. rest
      end
  end
  return censoredMessage
end

function MyChatMessageHandler(sender_id, sender_name, message)
  -- Censor the message
  local censoredMessage = CensorMessage(message)

  -- Check if the censored message is different from the original message
  if censoredMessage ~= message then
      -- Log the original message
      print(sender_name .. " said: " .. message)

      -- Log the censored message
      print(sender_name .. " said (censored): " .. censoredMessage)

      -- Return the censored message
      MP.SendChatMessage(-1, sender_name..': '..censoredMessage)
      return 1
  end

  -- If the message is not censored, return it as is
  return 0
end

MP.RegisterEvent("onChatMessage", "MyChatMessageHandler")