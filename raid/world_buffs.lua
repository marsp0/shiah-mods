

SlashCmdList['WBUFFS_SLASHCMD'] = function(msg)

    local time_limit = 59
    local flower_limit = 50
    local msg_template = "%s ony(%d), hoh(%dm), song(%dm), fen(%dm), mol(%dm), slip(%dm)"

    print("--------------------- WBUFFS REPORT ---------------------")
    for i = 1, GetNumGroupMembers() do
        local player, _, _, _, class = GetRaidRosterInfo(i);
        local found_boon = false
        local missing_buffs = false

        for j=1, 32 do
            local id = "raid" .. i
            local spell_name,icon,_,_,_,_,_,_,_,spell_id = UnitAura(id, j, "HELPFUL")
            if spell_name == nil then break end
    
            if spell_id == 349981 then 
                found_boon = true

                local fengus = select(17, UnitAura(id, j, "HELPFUL")) / 60
                local moldar = select(18, UnitAura(id, j, "HELPFUL")) / 60
                local slipkik = select(19, UnitAura(id, j, "HELPFUL")) / 60

                local ony = select(20, UnitAura(id, j, "HELPFUL")) / 60
                local hoh = select(22, UnitAura(id, j, "HELPFUL")) / 60
                local flower = select(23, UnitAura(id, j, "HELPFUL")) / 60

                if ony < time_limit or hoh < time_limit or flower < flower_limit or moldar < time_limit then
                    missing_buffs = true
                end

                if fengus < time_limit and slipkik < time_limit then
                    missing_buffs = true
                end

                if missing_buffs then
                    print(string.format(msg_template, string.sub(player, 1, 5), ony, hoh, flower, fengus, moldar, slipkik))
                end
            end
        end

        if not found_boon then
            print(player, "has no world buffs")
        end
    end
end
SLASH_WBUFFS_SLASHCMD1 = '/wbuffs'