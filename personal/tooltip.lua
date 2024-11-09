hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent) 
    self:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", 35, -20)
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self) 
    local _, unit = self:GetUnit()
    if not unit then return end

    local unit_name, unit_realm = UnitName(unit)
    local unit_is_player        = UnitIsPlayer(unit)
    local unit_level            = UnitLevel(unit)
    local unit_class            = UnitClassBase(unit)
    local unit_class_pretty     = UnitClass(unit)
    local unit_race             = UnitRace(unit)

    local line1 = _G["GameTooltipTextLeft1"]
    local line2 = _G["GameTooltipTextLeft2"]
    local line3 = _G["GameTooltipTextLeft3"]

    if unit_is_player then
        local unit_color = RAID_CLASS_COLORS[unit_class]:GenerateHexColorMarkup()

        line1:SetText(unit_color .. unit_name)
        line2:SetText(unit_level .. " " .. unit_race .. " " .. unit_class_pretty)

        -- guild - rank
        local guild, guild_rank = GetGuildInfo(unit)
        if not guild then return end
        local guild_line = "|c00aaaaff" .. guild .. " - " .. guild_rank
        if GameTooltip:NumLines() >= 3 and guild ~= GetGuildInfo("player") then
            line3:SetText(guild_line)
        else
            GameTooltip:AddLine(guild_line)
        end

        -- target of target
        local tt_unit   = "mouseovertarget"
        local tt_name   = GetUnitName(tt_unit)

        if not tt_name then return end

        local tt_class  = UnitClassBase(tt_unit)
        local tt_color  = RAID_CLASS_COLORS[tt_class]:GenerateHexColorMarkup()
        GameTooltip:AddLine("Target: " .. tt_color .. tt_name)
    else
        line1:SetText(unit_name)
        line2:SetText("Level " .. unit_level)

        if UnitPlayerControlled(unit) then line3:SetText("") end
    end
end)