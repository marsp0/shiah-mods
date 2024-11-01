local on = false
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) 
    local unit_id, spell_guid, spell_id = ...
    if (unit_id ~= "player") then return end

    local name = GetSpellInfo(spell_id)
    print(name)
end)

SlashCmdList['SPELLS_SLASHCMD'] = function(msg)
    if on then
        SM_print("Showing casted spells disabled")
        f:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    else
        SM_print("Showing casted spells enabled")
        f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end
    on = not on
end
SLASH_SPELLS_SLASHCMD1 = '/spells'