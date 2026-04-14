if select(2, UnitClass("player")) ~= "MAGE" then return end

local event_map = { ["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_APPLIED_DOSE"] = true, 
                    ["SPELL_AURA_REFRESH"] = true, ["SPELL_AURA_REMOVED"] = true,
                    ["SPELL_PERIODIC_DAMAGE"] = true, }

local frame = CreateFrame("Frame", "ShiahModsIgniteFrame", TargetFrame)
frame:SetFrameLevel(TargetFrame:GetFrameLevel() + 1)
frame:SetWidth(TargetFramePortrait:GetWidth())
frame:SetHeight(TargetFramePortrait:GetHeight())
frame:SetPoint("TOPLEFT", TargetFramePortrait, "TOPLEFT", 0, 0)

local cooldown = CreateFrame("Cooldown", "$parentCooldown", frame, "CooldownFrameTemplate")
cooldown:SetDrawEdge(false)
cooldown:SetDrawBling(false)
cooldown:SetHideCountdownNumbers(true)
cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")

local stacks = cooldown:CreateFontString("$parentStacks", "OVERLAY", "NumberFontNormalLarge")
stacks:SetDrawLayer("OVERLAY")
stacks:SetPoint("CENTER", cooldown, "CENTER", 0, 10)
stacks:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE")

local tick = cooldown:CreateFontString("$parentTick", "OVERLAY", "NumberFontNormalLarge")
tick:SetDrawLayer("OVERLAY")
tick:SetPoint("CENTER", cooldown, "CENTER", 0, -10)
tick:SetFont(STANDARD_TEXT_FONT, 19, "OUTLINE")

local function ignite_enter_world(self)
    if IsInInstance() then
        SM_print("Ignite enabled")
        self:Show()
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "target")
    else
        SM_print("Ignite disabled")
        self:Hide()
        self:UnregisterEvent("PLAYER_TARGET_CHANGED")
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end

local function ignite_target_changed()
    stacks:SetText("");
    cooldown:Clear();
    tick:SetText("")
    for i = 1, 16 do
        local name, _, count, _, dur, expiration_time, caster, _, _, spell_id = UnitDebuff("target", i)
        if not name then break end
        if spell_id == 12654 then
            stacks:SetText(count);
            cooldown:SetCooldown(expiration_time - dur, dur)
            tick:SetText("")
            return
        end
    end
end

local function ignite_combat_log_event()
    local timestamp, event_type, _, s_guid, s_name, _, d_name, d_guid = CombatLogGetCurrentEventInfo()
    if UnitGUID("target") ~= d_guid then return end
    if not event_map[event_type] then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 12654 then return end -- only track Ignite

    if event_type == "SPELL_AURA_APPLIED" then stacks:SetText("1") end
    if event_type == "SPELL_AURA_APPLIED_DOSE" then stacks:SetText(select(16, CombatLogGetCurrentEventInfo())) end
    if event_type == "SPELL_PERIODIC_DAMAGE" then
        dmg = select(15, CombatLogGetCurrentEventInfo())
        if dmg > 999 then
            dmg = math.floor(dmg / 100) / 10
            tick:SetText(string.format("%.1fk", dmg))
        else
            tick:SetText(string.format("%d", dmg))
        end
    end
    if  event_type == "SPELL_AURA_REMOVED" then stacks:SetText(""); tick:SetText("") end
    if  event_type == "SPELL_AURA_APPLIED" or 
        event_type == "SPELL_AURA_APPLIED_DOSE" or 
        event_type == "SPELL_AURA_REFRESH" then cooldown:SetCooldown(GetTime(), 4) end
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD"         then ignite_enter_world(self) end
    if event == "PLAYER_TARGET_CHANGED"         then ignite_target_changed() end
    if event == "COMBAT_LOG_EVENT_UNFILTERED"   then ignite_combat_log_event() end
end)
