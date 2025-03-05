local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, ...)
    WorldMapFrame.MaximizeMinimizeFrame.Minimize(WorldMapFrame.MaximizeMinimizeFrame)
    WorldMapScreenAnchor:ClearAllPoints(); 
    WorldMapScreenAnchor:SetPoint("CENTER", -WorldMapFrame:GetWidth()/2, WorldMapFrame:GetHeight()/2)
end)
