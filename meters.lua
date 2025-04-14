local empty_db = { ["Overall"] = {}, ["Current"] = {}}
SM_dmg_db = SM_dmg_db or empty_db

local view_map = { ["Overall"] = "Current", ["Current"] = "Overall" }
local current_view = "Overall"
local last_draw = 0
local combat_end = 0
local recent_cleared = false
local player_name = UnitName("player")
  
local backdrop_window = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                          tile = true, tileSize = 16, edgeSize = 16,
                          insets = { left = 3, right = 3, top = 3, bottom = 3 } }
  
local backdrop_border = { edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                          tile = true, tileSize = 16, edgeSize = 16,
                          insets = { left = 3, right = 3, top = 3, bottom = 3 } }

local dmg_events = { ["SWING_DAMAGE"] = true, ["RANGE_DAMAGE"] = true,
                     ["SPELL_DAMAGE"] = true, ["DAMAGE_SHIELD"] = true,
                     ["DAMAGE_SPLIT"] = true, ["SPELL_PERIODIC_DAMAGE"] = true }

local config = { width = 160, bar_height = 16, title_height = 22 }

local function dps_tooltip_show(self)
    GameTooltip:SetOwner(self)
    local unit      = self.unit
    local max_dmg   = SM_dmg_db[current_view][unit]["Total"]

    GameTooltip:AddDoubleLine("Total", max_dmg)
    GameTooltip:AddLine(" ")

    if max_dmg == 0 then return end

    -- sort names by damage
    local names = {}
    for k, v in pairs(SM_dmg_db[current_view][unit]) do 
        if k ~= "Total" then table.insert(names, k) end
    end
    table.sort(names, function(a, b) return SM_dmg_db[current_view][unit][a] > SM_dmg_db[current_view][unit][b] end)

    for i, name in ipairs(names) do
        local dmg = SM_dmg_db[current_view][unit][name]
        local percent = tonumber(string.format("%.2f", (dmg / max_dmg * 100)))
        GameTooltip:AddDoubleLine("|cffffffff" .. i .. ". " .. name, "|cffffffff" .. dmg .. " (" .. percent .. "%)")
    end

    GameTooltip:Show()
end

local function dps_clear_bars(window)
    for i, bar in pairs(window.bars) do 
        bar.left:SetText("")
        bar.right:SetText("")
        bar:SetValue(0)
    end
end

local function dps_swap_view(self, new_view)
    dps_clear_bars(self)
    current_view = new_view
    self.title:SetText(current_view)
end

local function dps_assign_unit_to_bar(bar, index, name, color, value, max_value)
    bar.left:SetText(index .. ". " .. string.sub(name, 1, 8))
    bar.right:SetText(value)
    bar.unit = name
    bar:SetValue(value / max_value * 100)
    bar:SetStatusBarColor(color.r, color.g, color.b, 1)
end

local function dps_on_update(self)
    local now = GetTime()

    -- check if we should draw bars
    if now - last_draw < 0.25 then return end

    -- check if current segment should be cleared
    if now - combat_end > 5 and not recent_cleared then
        SM_dmg_db["Current"] = {}
        recent_cleared = true
        dps_swap_view(self, "Overall")
        print("cleared current segmetn")
    end

    -- sort names by damage
    local names = {}
    for k, v in pairs(SM_dmg_db[current_view]) do table.insert(names, k) end
    table.sort(names, function(a, b) return SM_dmg_db[current_view][a]["Total"] > SM_dmg_db[current_view][b]["Total"] end)

    for i, name in ipairs(names) do
        if i > 10 then break end
        local bar = self.bars[i]
        local dmg = SM_dmg_db[current_view][name]["Total"]
        local max_dmg = SM_dmg_db[current_view][names[1]]["Total"]
        local _, class = UnitClass(name);
        local color = RAID_CLASS_COLORS[class] or {r = 0.5, g = 0.5, b = 0.5}
        dps_assign_unit_to_bar(bar, i, name, color, dmg, max_dmg)
    end

    for i, name in ipairs(names) do
        if name == player_name and i > 10 then
            local bar = self.bars[10]
            local dmg = SM_dmg_db[current_view][name]["Total"]
            local max_dmg = SM_dmg_db[current_view][names[1]]["Total"]
            local _, class = UnitClass(name);
            dps_assign_unit_to_bar(bar, i, player_name, RAID_CLASS_COLORS[class], dmg, max_dmg)
        end
    end

    last_draw = now
end

local function dps_add_data(db, name, spell_name, amount)
    db[name] = db[name] or {}
    db[name][spell_name] = db[name][spell_name] or 0
    db[name][spell_name] = db[name][spell_name] + amount
    db[name]["Total"] = db[name]["Total"] or 0
    db[name]["Total"] = db[name]["Total"] + amount
end

local function dps_log_event(self)
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if not dmg_events[subevent] then return end
    
    combat_end = GetTime()
    recent_cleared = false
    if current_view == "Overall" then dps_swap_view(self, "Current") end
    
    local _, event, hideCaster, sourceGUID, sourceName, _, _, destGUID, destName = CombatLogGetCurrentEventInfo()
    if not (sourceName and UnitIsPlayer(sourceName)) then return end

    local amount = 10000
    local overkill = 0
    local spell_name = "DEBUG"
    local spell_id = 0
    if event == "SWING_DAMAGE" then
        spell_name  = "Attack"
        amount      = select(12, CombatLogGetCurrentEventInfo())
        overkill    = select(13, CombatLogGetCurrentEventInfo())
    else
        spell_id    = select(12, CombatLogGetCurrentEventInfo())
        spell_name  = select(13, CombatLogGetCurrentEventInfo())
        amount      = select(15, CombatLogGetCurrentEventInfo())
        overkill    = select(16, CombatLogGetCurrentEventInfo())
    end

    dps_add_data(SM_dmg_db["Current"], sourceName, spell_name, amount - overkill)

    if spell_id == 12654 then return end -- ignore ignite damage in overall data
    dps_add_data(SM_dmg_db["Overall"], sourceName, spell_name, amount - overkill)
end

local function dps_enter_world(window)
    if not IsInInstance() then
        window:Hide()
        window:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        SM_print("DPSMeter disabled"); 
        return 
    end

    window:Show()
    window:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    SM_print("DPSMeter enabled")

    if window.created then SM_print("DPSMeter ui exists"); return end

    SM_print("DPSMeter ui created")
    window.created = true
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetMovable(true)
    window:SetScript("OnDragStart", function() window:StartMoving() end)
    window:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
    window:SetBackdrop(backdrop_window)
    window:SetBackdropColor(.5,.5,.5,.5)
    window:SetWidth(config.width)
    window:SetHeight(config.bar_height * 10 + config.title_height + 4)
    window:SetPoint("RIGHT", UIParent, "RIGHT", -150, -150)
    window:SetScript("OnUpdate", dps_on_update)

    window.border = CreateFrame("Frame", "DPSMeterBorder", window, "BackdropTemplate")
    window.border:ClearAllPoints()
    window.border:SetPoint("TOPLEFT", window, "TOPLEFT", -1,1)
    window.border:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 1,-1)
    window.border:SetFrameLevel(100)
    window.border:SetBackdrop(backdrop_border)
    window.border:SetBackdropBorderColor(.7,.7,.7,1)

    window.title = window:CreateFontString("DPSMeterTitle", "OVERLAY", "GameFontWhite")
    window.title:SetFont(STANDARD_TEXT_FONT, 11)
    window.title:SetText(current_view)
    window.title:SetPoint("TOP", window, 0, -8)

    local create_text_bar = function(parent, name, justify)
        local f = parent:CreateFontString(name, "OVERLAY", "GameFontNormal")
        f:SetFont(STANDARD_TEXT_FONT, 10)
        f:SetJustifyH(justify)
        f:SetFontObject(GameFontWhite)
        f:SetParent(parent)
        f:ClearAllPoints()
        f:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, 1)
        f:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -5, 0)
        return f
    end

    window.bars = {}
    for i = 1, 10 do
        local name = "DPSMeterBar" .. i
        window.bars[i] = CreateFrame("StatusBar", "DPSMeterBar" .. i, window)
        window.bars[i]:SetWidth(config.width - 10)
        window.bars[i]:SetHeight(config.bar_height)
        window.bars[i]:SetMinMaxValues(0, 100)
        window.bars[i]:SetPoint("TOPLEFT", window, "TOPLEFT", 5, -config.title_height - ((i-1) * config.bar_height))
        window.bars[i]:SetStatusBarTexture("Interface/TargetingFrame/UI-StatusBar")
        window.bars[i]:SetStatusBarColor(0, 0, 0, 0.0)
        window.bars[i]:SetMinMaxValues(0, 100)
        window.bars[i].left = create_text_bar(window.bars[i], name .. "TextLeft", "LEFT")
        window.bars[i].right = create_text_bar(window.bars[i], name .. "TextRight", "RIGHT")
        window.bars[i]:EnableMouse(true)
        window.bars[i]:SetScript("OnEnter", dps_tooltip_show)
        window.bars[i]:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
end

local function dps_on_event(self, event)
    if event == "PLAYER_ENTERING_WORLD" then dps_enter_world(self) end
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then dps_log_event(self) end
end

local window = CreateFrame("Frame", "DPSMeter", UIParent, "BackdropTemplate")
window:RegisterEvent("PLAYER_ENTERING_WORLD")
window:SetScript("OnEvent", dps_on_event)

SlashCmdList['CLEAR_SLASHCMD'] = function(msg)
    SM_dmg_db = {}
    SM_dmg_db["Overall"] = {}
    SM_dmg_db["Current"] = {}
    if window then dps_clear_bars(window) end
    SM_print("DPS database cleared")
end
SLASH_CLEAR_SLASHCMD1 = '/clear'
