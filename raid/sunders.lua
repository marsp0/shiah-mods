local sunders_watch_spells = {
    [11597] = {0, 0},                -- sunder
    [1160]  = {0, 0},                -- demo
    [11198] = {0, 0},                -- exposed armor
    [17392] = {0, 0},                -- ff
    [9907]  = {0, 0},                -- ff
    [11717] = {0, 0},                -- cor
}
local sunders_last_update_time = GetTime()

function sunders_handle_event(self, event, ...)
    local zoneName, instanceType, _, _, _, _, _, areaID = GetInstanceInfo()

	if instanceType == "raid" and raid_zones_map[areaID] then 
		self:Show()
		SM_print("[Enabled] Watching sunders")

        _G["DebuffWatchFrame1".."Texture"]:SetTexture("Interface/icons/ability_warrior_sunder")
        _G["DebuffWatchFrame1".."Texture"].spells = {11597}
        
        _G["DebuffWatchFrame2".."Texture"]:SetTexture("Interface/icons/ability_warrior_warcry")
        _G["DebuffWatchFrame2".."Texture"].spells = {11556}

        _G["DebuffWatchFrame3".."Texture"]:SetTexture("Interface/icons/ability_warrior_riposte")
        _G["DebuffWatchFrame3".."Texture"].spells = {11198}

        _G["DebuffWatchFrame4".."Texture"]:SetTexture("Interface/icons/spell_nature_faeriefire")
        _G["DebuffWatchFrame4".."Texture"].spells = {17392, 9907}

        _G["DebuffWatchFrame5".."Texture"]:SetTexture("Interface/icons/spell_shadow_unholystrength")
        _G["DebuffWatchFrame5".."Texture"].spells = {11717}
	else
    	self:Hide()
		SM_print("[Disabled] Watching sunders")
	end
end

function sunders_on_update()
    local time_now = GetTime()
    if time_now - sunders_last_update_time < 1 then return end

    -- reset state
    for i, v in pairs(sunders_watch_spells) do 
        sunders_watch_spells[i][1] = 0
        sunders_watch_spells[i][2] = 0 
    end

    for j=1, 32 do
        local name,_,count,_,duration,expirationTime,_,_,_,spell_id = UnitAura("target", j, "HARMFUL")
        if name == nil then break end

        if sunders_watch_spells[spell_id] then
            sunders_watch_spells[spell_id][1] = expirationTime - time_now
            sunders_watch_spells[spell_id][2] = count
        end
    end

    sunders_draw()

    sunders_last_update_time = time_now
end

function sunders_draw()
    local active = false

    for row=1, 5 do
        local frame_name        = "DebuffWatchFrame" .. row
        local texture_frame     = _G[frame_name.."Texture"]
        local cd_frame          = _G[frame_name.."Cooldown"]
        local stacks_frame      = _G[frame_name.."Stacks"]
        local remaining         = 0
        local stacks            = 0
        local r                 = 0.5
        local g                 = 0.5
        local b                 = 0.5

        for i, v in pairs(texture_frame.spells) do
            if sunders_watch_spells[v] then
                remaining = math.max(remaining, sunders_watch_spells[v][1])
                stacks = math.max(stacks, sunders_watch_spells[v][2])
                if remaining > 0 then active = true end
            end
        end

        if active then r = 1; g = 1; b = 1 end

        texture_frame:SetVertexColor(r, g, b)
        cd_frame:SetText(string.format("%d", remaining))
        stacks_frame:SetText(stacks)

        active = false
    end
end