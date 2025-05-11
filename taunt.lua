if GetRealmName() == "Spineshatter" then return end

local prev = 0
local window = CreateFrame("Frame", "Taunt", UIParent)
window:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
window:SetScript("OnEvent", function(self, event, ...)
    local now = GetTime()
    if now - prev < 1 then return end
    if select(3, ...) ~= 1161 then return end -- Taunt
    miniwigs_announcer_set_text("AOE Taunt")
    prev = now
end)