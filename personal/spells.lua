local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", function(self, event, ...) 
    local unit_id, spell_guid, spell_id = ...
    if (unit_id ~= "player") then return end

    local name = GetSpellInfo(spell_id)
    print(name)
end)