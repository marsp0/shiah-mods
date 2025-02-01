TargetFrameTextureFrame:CreateFontString("TargetFrameHealthBarText", "BORDER", "TextStatusBarText")
TargetFrameHealthBarText:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 3)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_HEALTH")
f:SetScript("OnEvent", function(self, event, unit)
    if (event == "UNIT_HEALTH" and unit ~= "target") then
        return
    end
    
    if UnitIsDead("target") then
        TargetFrameHealthBarText:SetText("")
        return
    end

    local val = AbbreviateLargeNumbers(UnitHealth("target"))
    local max_val = AbbreviateLargeNumbers(UnitHealthMax("target"))
    TargetFrameHealthBarText:SetText(math.ceil((val / max_val) * 100) .. "%")
end)