TargetFrameTextureFrame:CreateFontString("TargetFrameHealthBarText", "BORDER", "TextStatusBarText")
TargetFrameHealthBarText:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 3)

UnitFrameHealthBar_Initialize("target", TargetFrameHealthBar, TargetFrameHealthBarText, true)

function health_update(statusFrame, textString, value, valueMin, valueMax)
    if (statusFrame.pauseUpdates) then textString:Hide() end
    
    local val = AbbreviateLargeNumbers(value)
    local max_val = AbbreviateLargeNumbers(valueMax)
    textString:SetText(math.ceil((val / max_val) * 100) .. "%")
end

hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", health_update)
