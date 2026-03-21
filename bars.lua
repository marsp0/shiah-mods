local frames = {"ActionBarDownButton", "ActionBarUpButton", "CharacterBag0Slot",
                "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot",
                "CharacterMicroButton", "GuildMicroButton", "HelpMicroButton",
                "KeyRingButton", "MainMenuBarBackpackButton", "MainMenuMicroButton",
                "MultiBarBottomRight", "QuestLogMicroButton", "SocialsMicroButton",
                "SpellbookMicroButton", "TalentMicroButton", "WorldMapMicroButton",
                -- artframe regions
                "MainMenuBarLeftEndCap", "MainMenuBarRightEndCap", "MainMenuBarPageNumber",
                "MainMenuBarTexture0", "MainMenuBarTexture1", "MainMenuBarTexture2", "MainMenuBarTexture3", 
                "MainMenuBarTextureExtender",
                -- xp bars
                "ReputationWatchBar", "MainMenuMaxLevelBar0", "MainMenuMaxLevelBar1", 
                "MainMenuMaxLevelBar2", "MainMenuMaxLevelBar3",
                "MainMenuBarMaxLevelBar", "MainMenuExpBar", "MainMenuBarPerformanceBarFrame"
            }

for i, frame in ipairs(frames) do
    _G[frame]:Hide()
    _G[frame].Show = function (...) return end
end

-- move MainMenuBar to the center
local x_offset = MultiBarBottomLeft:GetWidth() / 2
MainMenuBar:SetPoint("CENTER", x_offset + 5, 0)

-- y offset between bars the same as x offset between buttons
local _, _, p, x, y = ActionButton2:GetPoint()
MultiBarBottomLeft:SetPoint("TOPLEFT", 8, -x)

RAID_CLASS_COLORS["SHAMAN"] = CreateColor(0.0, 0.44, 0.87);
RAID_CLASS_COLORS["SHAMAN"].colorStr = RAID_CLASS_COLORS["SHAMAN"]:GenerateHexColor();