function combat_log_event()
    local zoneName, instanceType, _, _, _, _, _, areaID = GetInstanceInfo()

	if instanceType == "raid" and raid_zones_map[areaID] then 
		print("Enabling combatlog")
		LoggingCombat(true)
	else
		print("Disabling combatlog")
    	LoggingCombat(false)
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", combat_log_event)
f:RegisterEvent("PLAYER_ENTERING_WORLD")