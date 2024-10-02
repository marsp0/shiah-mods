local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    local isInitialLogin, isReloadingUi = ...
    if isInitialLogin or isReloadingUi then
        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetPoint("CENTER", -221, -165)

        TargetFrame:ClearAllPoints()
        TargetFrame:SetPoint("CENTER", 221, -165)
        SM_print("Moved player and target frames")
    end
end)