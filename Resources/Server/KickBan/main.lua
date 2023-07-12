-- This script provides a very basic kick and ban command from the server command line.

function handleConsoleInput(cmd)
    local delim = cmd:find(' ')
    if delim then
        local message = cmd:sub(delim+1)
        if cmd:sub(1, delim-1) == "kick" then
            return message
        end
        if cmd:sub(1, delim-1) == "ban" then
            return message
        end
    end
end

MP.RegisterEvent("onConsoleInput", "handleConsoleInput")
