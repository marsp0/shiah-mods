local debuff_watch_spells = {
    [11597] = {0, 0},                -- sunder
    [1160]  = {0, 0},                -- demo
    [11574] = {0, 0},                -- rend
    [11198] = {0, 0},                -- exposed armor
    [17392] = {0, 0},                -- ff
    [9907]  = {0, 0},                -- ff
    [11717] = {0, 0},                -- cor
    [11722] = {0, 0},                -- coe
    [17937] = {0, 0},                -- cos
    [11713] = {0, 0},                -- agony
    [25311] = {0, 0},                -- corruption
    [10894] = {0, 0},                -- shadow word pain
    [14325] = {0, 0},                -- hunters mark
    [14280] = {0, 0},                -- viper sting
    [25295] = {0, 0},                -- serpent sting
    [14277] = {0, 0},                -- scorpid
}

local debuff_watch_last_render_time = GetTime()

function debuff_watch_init()
    _G["DebuffWatchFrame11".."Texture"]:SetTexture("Interface/icons/ability_warrior_sunder")
    _G["DebuffWatchFrame11".."Texture"].spells = {11597}
    _G["DebuffWatchFrame12".."Texture"]:SetTexture("Interface/icons/ability_warrior_warcry")
    _G["DebuffWatchFrame12".."Texture"].spells = {11556}
    _G["DebuffWatchFrame13".."Texture"]:SetTexture("Interface/icons/ability_gouge")
    _G["DebuffWatchFrame13".."Texture"].spells = {11574}
    _G["DebuffWatchFrame14".."Texture"]:SetTexture("Interface/icons/ability_warrior_riposte")
    _G["DebuffWatchFrame14".."Texture"].spells = {11198}

    _G["DebuffWatchFrame21".."Texture"]:SetTexture("Interface/icons/spell_nature_faeriefire")
    _G["DebuffWatchFrame21".."Texture"].spells = {17392, 9907}

    _G["DebuffWatchFrame31".."Texture"]:SetTexture("Interface/icons/spell_shadow_unholystrength")
    _G["DebuffWatchFrame31".."Texture"].spells = {11717}
    _G["DebuffWatchFrame32".."Texture"]:SetTexture("Interface/icons/spell_shadow_chilltouch")
    _G["DebuffWatchFrame32".."Texture"].spells = {11722}
    _G["DebuffWatchFrame33".."Texture"]:SetTexture("Interface/icons/spell_shadow_curseofachimonde")
    _G["DebuffWatchFrame33".."Texture"].spells = {17937}

    _G["DebuffWatchFrame41".."Texture"]:SetTexture("Interface/icons/spell_shadow_curseofsargeras")
    _G["DebuffWatchFrame41".."Texture"].spells = {11713}
    _G["DebuffWatchFrame42".."Texture"]:SetTexture("Interface/icons/spell_shadow_abominationexplosion")
    _G["DebuffWatchFrame42".."Texture"].spells = {25311}
    _G["DebuffWatchFrame43".."Texture"]:SetTexture("Interface/icons/spell_shadow_shadowwordpain")
    _G["DebuffWatchFrame43".."Texture"].spells = {10894}

    _G["DebuffWatchFrame51".."Texture"]:SetTexture("Interface/icons/ability_hunter_snipershot")
    _G["DebuffWatchFrame51".."Texture"].spells = {14325}
    _G["DebuffWatchFrame52".."Texture"]:SetTexture("Interface/icons/ability_hunter_aimedshot")
    _G["DebuffWatchFrame52".."Texture"].spells = {14280}
    _G["DebuffWatchFrame53".."Texture"]:SetTexture("Interface/icons/ability_hunter_quickshot")
    _G["DebuffWatchFrame53".."Texture"].spells = {25295}
    _G["DebuffWatchFrame54".."Texture"]:SetTexture("Interface/icons/ability_hunter_criticalshot")
    _G["DebuffWatchFrame54".."Texture"].spells = {14277}
end

function debuff_watch_update()
    local time_now = GetTime()

    -- reset state
    for i, v in pairs(debuff_watch_spells) do 
        debuff_watch_spells[i][1] = 0
        debuff_watch_spells[i][2] = 0 
    end

    for j=1, 32 do
        local name,_,count,_,duration,expirationTime,_,_,_,spell_id = UnitAura("target", j, "HARMFUL")
        if name == nil then break end

        if debuff_watch_spells[spell_id] then
            debuff_watch_spells[spell_id][1] = expirationTime - time_now
            debuff_watch_spells[spell_id][2] = count
        end
    end

    debuff_watch_draw()
end

function debuff_watch_draw()
    local time_now = GetTime()
    local active = false

    if time_now - debuff_watch_last_render_time < 0.5 then return end

    for row=1, 5 do
        for col=1, 4 do
            local frame_name = "DebuffWatchFrame" .. row .. col
            local texture_frame     = _G[frame_name.."Texture"]
            local cd_frame          = _G[frame_name.."Cooldown"]
            local stacks_frame      = _G[frame_name.."Stacks"]
            local remaining = 0
            local stacks = 0

            if texture_frame then
                for i, v in pairs(texture_frame.spells) do
                    if debuff_watch_spells[v] then
                        remaining = math.max(remaining, debuff_watch_spells[v][1])
                        stacks = math.max(stacks, debuff_watch_spells[v][2])
                        if remaining > 0 then active = true end
                    end
                end

                local r = 0.5
                local g = 0.5
                local b = 0.5

                if active then
                    r = 1
                    g = 1
                    b = 1
                end

                texture_frame:SetVertexColor(r, g, b)
                cd_frame:SetText(string.format("%d", remaining))
                stacks_frame:SetText(stacks)

                active = false
            end
        end
    end

    debuff_watch_last_render_time = time_now
end

SlashCmdList['DEBUFF_WATCH_SLASHCMD'] = function(msg)
    local f = _G["DebuffWatchFrame"]
    if f:IsVisible() then
        f:Hide()
    else
        f:Show()
    end
end
SLASH_DEBUFF_WATCH_SLASHCMD1 = '/debuffs'