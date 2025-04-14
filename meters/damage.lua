local empty_db = { ["Overall"] = {}, ["Current"] = {}}
SM_dmg_db = SM_dmg_db or empty_db
local current_view = "Overall"
local player_name = UnitName("player")
local player_class = select(2, UnitClass("player"))
local combat_end = 0
local recent_cleared = false
local last_draw = 0

local dmg_events = { ["SWING_DAMAGE"] = true, ["RANGE_DAMAGE"] = true,
                     ["SPELL_DAMAGE"] = true, ["DAMAGE_SHIELD"] = true,
                     ["DAMAGE_SPLIT"] = true, ["SPELL_PERIODIC_DAMAGE"] = true }

local function damage_tooltip_show(self)
    GameTooltip:SetOwner(self)
    
    local unit      = self.unit
    if not unit then return end
    
    local max_dmg   = SM_dmg_db[current_view][unit]["Total"]
    if max_dmg == 0 then return end

    GameTooltip:AddDoubleLine("Total", max_dmg)
    GameTooltip:AddLine(" ")

    local names = {}
    for k, v in pairs(SM_dmg_db[current_view][unit]) do 
        if k ~= "Total" then table.insert(names, k) end
    end
    table.sort(names, function(a, b) return SM_dmg_db[current_view][unit][a] > SM_dmg_db[current_view][unit][b] end)

    for i, name in ipairs(names) do
        local dmg = SM_dmg_db[current_view][unit][name]
        local percent = tonumber(string.format("%.1f", (dmg / max_dmg * 100)))
        if percent >= 0.1 then
            GameTooltip:AddDoubleLine("|cffffffff" .. i .. ". " .. name, "|cffffffff" .. dmg .. " (" .. percent .. "%)")
        end
    end

    GameTooltip:Show()
end

local function dps_add_data(db, name, spell_name, amount)
    db[name] = db[name] or {}
    db[name][spell_name] = db[name][spell_name] or 0
    db[name][spell_name] = db[name][spell_name] + amount
    db[name]["Total"] = db[name]["Total"] or 0
    db[name]["Total"] = db[name]["Total"] + amount
end

local function damage_assign_unit_to_bar(bar, index, name, color, value, max_value)
    bar.left:SetText(index .. ". " .. string.sub(name, 1, 8))
    bar.right:SetText(value)
    bar.unit = name
    bar:SetValue(value / max_value * 100)
    bar:SetStatusBarColor(color.r, color.g, color.b, 1)
end

local function damage_swap_view(self, new_view)
    meters_clear_bars(self)
    current_view = new_view
    self.title:SetText(current_view)
end

local function damage_log_event(self)
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if not dmg_events[subevent] then return end
    
    combat_end = GetTime()
    recent_cleared = false
    if current_view == "Overall" then damage_swap_view(self, "Current") end
    
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

function damage_on_update(self)
    local now = GetTime()
    if now - last_draw < 0.25 then return end

    if now - combat_end > 5 and not recent_cleared then
        SM_dmg_db["Current"] = {}
        recent_cleared = true
        damage_swap_view(self, "Overall")
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
        damage_assign_unit_to_bar(bar, i, name, color, dmg, max_dmg)
    end

    for i, name in ipairs(names) do
        if name == player_name and i > 10 then
            local bar = self.bars[10]
            local dmg = SM_dmg_db[current_view][name]["Total"]
            local max_dmg = SM_dmg_db[current_view][names[1]]["Total"]
            local _, class = UnitClass(name);
            damage_assign_unit_to_bar(bar, i, player_name, RAID_CLASS_COLORS[class], dmg, max_dmg)
            break
        end
    end

    last_draw = now
end

local function damage_enter_world(self)
    if IsInInstance() then 
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        self:SetScript("OnUpdate", damage_on_update)
    else 
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
        self:SetScript("OnUpdate", nil)
    end
end

local frame = meters_create_table("DamageMeter", 162, 0, damage_tooltip_show)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then damage_enter_world(self) end
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then damage_log_event(self) end
end)

SlashCmdList['CLEAR_SLASHCMD'] = function(msg)
    SM_dmg_db = {}
    SM_dmg_db["Overall"] = {}
    SM_dmg_db["Current"] = {}
    meters_clear_bars(frame)
    SM_print("DPS database cleared")
end
SLASH_CLEAR_SLASHCMD1 = '/clear'