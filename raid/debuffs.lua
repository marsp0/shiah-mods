local shit_debuffs = {
    [11574] = true,     -- rend
    [11713] = true,     -- agony
    [25311] = true,     -- corruption
    [10894] = true,     -- shadow word pain
    [14325] = true,     -- hunters mark
    [14280] = true,     -- viper sting
    [25295] = true,     -- serpent sting
    [14277] = true,     -- scorpid

    -- [2855]  = true,     -- detect magic
}

function debuffs_player_enters_world(self)
    local zoneName, instanceType, _, _, _, _, _, areaID = GetInstanceInfo()

	if instanceType == "raid" and raid_zones_map[areaID] then 
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		SM_print("Debuff watch enabled")
	else
    	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		SM_print("Debuff watch disabled")
	end
end

function debuffs_handle_spellcast(...)
    local unit_id, _, spell_id = ...
    if not shit_debuffs[spell_id] then return end
    local spell_name = GetSpellInfo(spell_id)
    SM_print(GetUnitName(unit_id) .. " casted " .. spell_name)
    PlaySoundFile("Interface\\AddOns\\BigWigs\\Media\\Sounds\\alert.ogg")
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD"     then debuffs_player_enters_world(self) end
    if event == "UNIT_SPELLCAST_SUCCEEDED"  then debuffs_handle_spellcast(...) end
end)