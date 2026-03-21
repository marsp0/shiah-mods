-- artframe children
ActionBarDownButton:Hide()
ActionBarUpButton:Hide()
CharacterBag0Slot:Hide()
CharacterBag1Slot:Hide()
CharacterBag2Slot:Hide()
CharacterBag3Slot:Hide()
CharacterMicroButton:Hide()
GuildMicroButton:Hide()
HelpMicroButton:Hide()
KeyRingButton:Hide()
KeyRingButton.Show = function (...) return end
MainMenuBarBackpackButton:Hide()
MainMenuMicroButton:Hide()
MultiBarBottomRight:Hide()
QuestLogMicroButton:Hide()
SocialsMicroButton:Hide()
SpellbookMicroButton:Hide()
TalentMicroButton:Hide()
TalentMicroButton.Show = function (...) return end
WorldMapMicroButton:Hide()

-- artframe regions
MainMenuBarLeftEndCap:Hide()
MainMenuBarRightEndCap:Hide()
MainMenuBarPageNumber:Hide()
MainMenuBarTexture0:Hide()
MainMenuBarTexture1:Hide()
MainMenuBarTexture2:Hide()
MainMenuBarTexture3:Hide()
MainMenuBarTextureExtender:Hide()

-- move MainMenuBar to the center
local x_offset = MultiBarBottomLeft:GetWidth() / 2
MainMenuBar:SetPoint("CENTER", x_offset + 5, 0)

-- y offset between bars the same as x offset between buttons
local _, _, p, x, y = ActionButton2:GetPoint()
MultiBarBottomLeft:SetPoint("TOPLEFT", 8, -x)

-- hide xp bars
ReputationWatchBar:Hide()
MainMenuMaxLevelBar0:Hide()
MainMenuMaxLevelBar1:Hide()
MainMenuMaxLevelBar2:Hide()
MainMenuMaxLevelBar3:Hide()
MainMenuBarMaxLevelBar:Hide()
MainMenuExpBar:Hide()
MainMenuExpBar.Show = function (...) return end
MainMenuBarPerformanceBarFrame:Hide()

RAID_CLASS_COLORS["SHAMAN"] = CreateColor(0.0, 0.44, 0.87);
RAID_CLASS_COLORS["SHAMAN"].colorStr = RAID_CLASS_COLORS["SHAMAN"]:GenerateHexColor();
