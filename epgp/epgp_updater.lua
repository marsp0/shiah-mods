function epgp_updater_sync_notes(self, event, ...)
    start_time = GetTime()
    if processing or (start_time - last_sync < 15) then return end

    processing = true
    for i = 1, GetNumGuildMembers() do
        name, _, rankIndex, _, _, _, note, officernote = GetGuildRosterInfo(i);
        
        if officernote ~= "" or officernote ~= note then
            GuildRosterSetPublicNote(i, officernote)
        end
    end

    last_sync = GetTime()
    SM_print("Synced officer and public notes")
    processing = false
end

processing = false
last_sync = GetTime()
epgp_updater_frame = CreateFrame("Frame")
epgp_updater_frame:SetScript("OnEvent", epgp_updater_sync_notes)
epgp_updater_frame:RegisterEvent("GUILD_ROSTER_UPDATE")