SM_print("bars.lua code called")

-- remove gryphons
MainMenuBarLeftEndCap:Hide()
MainMenuBarRightEndCap:Hide()
MainMenuBarPerformanceBarFrame:Hide()
MainMenuBarBackpackButton:Hide()
MainMenuBarArtFrame:Hide()

-- move MainMenuBar to the center
local x_offset = MultiBarBottomLeft:GetWidth() / 2
MainMenuBar:SetPoint("CENTER", x_offset + 5, 0)

-- y offset between bars the same as x offset between buttons
local _, _, p, x, y = ActionButton2:GetPoint()
MultiBarBottomLeft:SetPoint("TOPLEFT", 8, -x)

-- move action buttons to MainMenuBar frame
ActionButton1:SetParent(MainMenuBar)
ActionButton2:SetParent(MainMenuBar)
ActionButton3:SetParent(MainMenuBar)
ActionButton4:SetParent(MainMenuBar)
ActionButton5:SetParent(MainMenuBar)
ActionButton6:SetParent(MainMenuBar)
ActionButton7:SetParent(MainMenuBar)
ActionButton8:SetParent(MainMenuBar)
ActionButton9:SetParent(MainMenuBar)
ActionButton10:SetParent(MainMenuBar)
ActionButton11:SetParent(MainMenuBar)
ActionButton12:SetParent(MainMenuBar)
MultiBarBottomLeft:SetParent(MainMenuBar)

-- hide xp bars
ReputationWatchBar:Hide()
MainMenuMaxLevelBar0:Hide()
MainMenuMaxLevelBar1:Hide()
MainMenuMaxLevelBar2:Hide()
MainMenuMaxLevelBar3:Hide()
MainMenuBarMaxLevelBar:Hide()
MainMenuExpBar:Hide()
MainMenuExpBar.Show = function (...) return end
StanceBarFrame:Hide()

-- shaman class color
if not whoaUFaddon and not whoaThFaddon then
	RAID_CLASS_COLORS["SHAMAN"] = CreateColor(0.0, 0.44, 0.87);
	RAID_CLASS_COLORS["SHAMAN"].colorStr = RAID_CLASS_COLORS["SHAMAN"]:GenerateHexColor();
end
