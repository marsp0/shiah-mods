if GetRealmName() == "Spineshatter" then return end
if select(2, UnitClass("player")) ~= "MAGE" then return end

local total_width = 115
local total_height = 30
local event_map = { ["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_APPLIED_DOSE"] = true, 
                    ["SPELL_AURA_REFRESH"] = true, ["SPELL_AURA_REMOVED"] = true,
                    ["SPELL_PERIODIC_DAMAGE"] = true, }

local window = CreateFrame("Frame", "IgniteWindow", TargetFrame)
window:SetWidth(total_width)
window:SetHeight(total_height)
window:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 8, -19)

local frame = CreateFrame("Frame", "IgniteFrame", window)
frame:SetSize(total_height, total_height)
frame:SetPoint("TOPLEFT", window, 0, 0)

local texture = frame:CreateTexture("IgniteTexture", "ARTWORK")
texture:SetPoint("TOPLEFT", frame, 0, 0)
texture:SetTexture(135818)
texture:SetSize(total_height, total_height)

local stacks = frame:CreateFontString("IgniteStacks", "OVERLAY", "NumberFontNormalLarge")
stacks:SetPoint("CENTER", frame, 0, 0)

local cooldown = CreateFrame("Cooldown", "IgniteCooldown", frame, "CooldownFrameTemplate")
cooldown:SetDrawEdge(false)

local frame2 = CreateFrame("Frame", nil, window)
frame2:SetSize(total_width - total_height, total_height)
frame2:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, 0)

local tick = frame2:CreateFontString("IgniteTick", "OVERLAY", "GameFontNormal")
tick:SetPoint("CENTER", frame2, 0, 0)

local function ignite_enter_world(self)
    if IsInInstance() then
        SM_print("Ignite enabled")
        self:Show()
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        SM_print("Ignite disabled")
        self:Hide()
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end

local function ignite_target_changed()
    stacks:SetText("");
    cooldown:Clear()
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

    if event_type == "SPELL_AURA_APPLIED"       then stacks:SetText("1") end
    if event_type == "SPELL_AURA_APPLIED_DOSE"  then stacks:SetText(select(16, CombatLogGetCurrentEventInfo())) end
    if event_type == "SPELL_PERIODIC_DAMAGE"    then tick:SetText(select(15, CombatLogGetCurrentEventInfo())) end
    if event_type == "SPELL_AURA_REMOVED"       then stacks:SetText(""); tick:SetText("") end
    if event_type == "SPELL_AURA_APPLIED" or 
       event_type == "SPELL_AURA_APPLIED_DOSE" or 
       event_type == "SPELL_AURA_REFRESH"       then cooldown:SetCooldown(GetTime(), 4) end
end

window:RegisterEvent("PLAYER_ENTERING_WORLD")
window:RegisterEvent("PLAYER_TARGET_CHANGED")
window:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD"         then ignite_enter_world(self) end
    if event == "PLAYER_TARGET_CHANGED"         then ignite_target_changed() end
    if event == "COMBAT_LOG_EVENT_UNFILTERED"   then ignite_combat_log_event() end
end)
