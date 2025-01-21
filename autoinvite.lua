local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:SetScript("OnEvent", function(self, event, ...)
    local msg, author = ...
    if string.lower(msg) == "inv" then InviteUnit(author) end
end)
