local on = false
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
    local msg, author = ...
    msg = string.lower(msg)
    local is_wtb = string.find(msg, "wtb")
    local is_port = string.find(msg, "port")

    if is_wtb and is_port then
        InviteUnit(author)
    end
end)

SlashCmdList['PORTALS_SLASHCMD'] = function(msg)
    if on then
        SM_print("Scanning for portal messages disabled")
        f:UnregisterEvent("CHAT_MSG_YELL")
    else
        SM_print("Scanning for portal messages enabled")
        f:RegisterEvent("CHAT_MSG_YELL")
    end
    on = not on
end
SLASH_PORTALS_SLASHCMD1 = '/portals'