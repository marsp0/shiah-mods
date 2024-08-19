function combat_log_event()
    local zoneName, instanceType, _, _, _, _, _, areaID = GetInstanceInfo()

	if instanceType == "raid" then 
		if raid_zones_map[areaID] and not LoggingCombat() then
            print("Enabling combatlog")
			LoggingCombat(true)
			return
		end
	end

    print("Disabling combatlog")
    LoggingCombat(false)
end

combatlog_frame = CreateFrame("Frame")
combatlog_frame:SetScript("OnEvent", combat_log_event)
combatlog_frame:RegisterEvent("PLAYER_ENTERING_WORLD")