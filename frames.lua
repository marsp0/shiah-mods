function move_frames_to_center(...)
    local isInitialLogin, isReloadingUi = ...
    if isInitialLogin or isReloadingUi then

        SetCVar("UnitNamePlayerGuild", 1)
        SetCVar("UnitNamePlayerPVPTitle", 0)

        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetPoint("CENTER", -221, -165)

        TargetFrame:ClearAllPoints()
        TargetFrame:SetPoint("CENTER", 221, -165)
        SM_print("Moved player and target frames")

        local player_color_frame = CreateFrame("FRAME", nil, PlayerFrame)
        player_color_frame:Hide()

        player_color_frame:SetWidth(TargetFrameNameBackground:GetWidth())
        player_color_frame:SetHeight(TargetFrameNameBackground:GetHeight())

        local _, _, _, x, y = TargetFrameNameBackground:GetPoint()
        player_color_frame:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", -x, y)

        player_color_frame.t = player_color_frame:CreateTexture(nil, "BORDER")
        player_color_frame.t:SetAllPoints()
        player_color_frame.t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")

        local _, class = UnitClass("player")
        local c = RAID_CLASS_COLORS[class]
        if c then player_color_frame.t:SetVertexColor(c.r, c.g, c.b) end
        player_color_frame:Show()
    end
end

function set_target_frame_color()
    if not UnitIsPlayer("target") then return end
    local _, class = UnitClass("target")
    local c = RAID_CLASS_COLORS[class]
    if c then TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b) end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then move_frames_to_center(...); return end
    
    set_target_frame_color()
end)