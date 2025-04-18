local in_combat = false
local last_update = 0

local function threat_assign_unit_to_bar(bar, index, name, color, percent)
    percent = tonumber(string.format("%.1f", percent))
    bar.left:SetText(index .. ". " .. string.sub(name, 1, 8))
    bar.right:SetText(percent .. "%")
    bar.unit = name
    bar:SetValue(percent)
    bar:SetStatusBarColor(color.r, color.g, color.b, 1)
end

local function threat_on_update(self)
    local now = GetTime()

    if now - last_update < 0.3 then return end
    if not in_combat then return end
    if not UnitExists("target") then return end

    local data = {}

    if IsInGroup("player") or IsInRaid("player") then
        for i=1, GetNumGroupMembers() do
            local unit = "party"..i
            if IsInRaid("player") then unit = "raid"..i end
            
            local name = UnitName(unit)
            if name then
                local _, _, percent, _, value = UnitDetailedThreatSituation(unit, "target")
                data[name] = percent or 0;
            end
        end        
    end

    local name = UnitName("player")
    local _, _, percent, _, value = UnitDetailedThreatSituation("player", "target")
    data[name] = percent or 0;

    -- sort + draw
    local names = {}
    for k, v in pairs(data) do table.insert(names, k) end
    table.sort(names, function(a, b) return data[a] > data[b] end)

    for i, name in ipairs(names) do
        if i > 10 then break end
        local bar = self.bars[i]
        local _, class = UnitClass(name);
        local color = RAID_CLASS_COLORS[class] or {r = 0.5, g = 0.5, b = 0.5}
        threat_assign_unit_to_bar(bar, i, name, color, data[name])
    end

    last_update = now
end

local function threat_enter_world(self)
    if IsInInstance() then 
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        -- self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
        self:SetScript("OnUpdate", threat_on_update)
    else 
        self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
        self:UnregisterEvent("PLAYER_REGEN_ENABLED") 
        -- self:UnregisterEvent("UNIT_THREAT_LIST_UPDATE") 
        self:SetScript("OnUpdate", nil)
    end
end

local frame = meters_create_table("ThreatMeter", 0, 0, function() end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then threat_enter_world(self) end
    if event == "PLAYER_REGEN_DISABLED" then in_combat = true; meters_clear_bars(self) end
    if event == "PLAYER_REGEN_ENABLED" then in_combat = false end
end)