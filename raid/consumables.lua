local buff_checker_id_map = {
    ["arcane"]      = {17549},
    ["nature"]      = {17546},
    ["fire"]        = {17543},
    ["frost"]       = {17544},
    ["shadow"]      = {17548},
    ["zanza"]       = {24382},
    ["jujup"]       = {16323},
    ["jujum"]       = {16329},
    ["jujuc"]       = {16325},
    ["jujue"]       = {16326},
    ["titans"]      = {17626},
    ["wisdom"]      = {17627},
    ["supreme"]     = {17628},
    ["mongoose"]    = {17538},
    ["elixir"]      = {17539},
    ["firewater"]   = {17038},
    ["Firepower"]   = {26276},
    ["mageblood"]   = {24363},
    ["nightfin"]    = {18194},
    ["salvation"]   = {25895, 1038},
    ["dampen"]      = {10174},
    ["chrono"]      = {349981}
}

function buff_checker_crawl()

    local buff_checker_id = {}
    local buff_checker_roster = {}
    local target_id = _G["BuffCheckerId"]:GetText()
    local target_id_num = tonumber(target_id)
    if buff_checker_id_map[target_id] then
        buff_checker_id = buff_checker_id_map[target_id]
    elseif target_id_num ~= nil then
        buff_checker_id = {target_id_num}
    else
        SM_print("invalid id")
        return
    end

    -- crawl
    for i = 1, GetNumGroupMembers() do
        name, rank, subgroup, level, class = GetRaidRosterInfo(i);
        buff_checker_roster[name] = false

        for j=1, 32 do
            local spell_name,_,_,_,_,_,_,_,_,spell_id = UnitAura("raid"..i, j, "HELPFUL")
            if spell_name == nil then break end
    
            for _, id in pairs(buff_checker_id) do
                if spell_id == id then buff_checker_roster[name] = true end
            end
        end
    end

    -- draw
    local names_frame = _G["BuffCheckerNames"]
    local is_present = _G["BuffCheckerIsPresent"]:GetChecked()
    local display_string = ""
    

    for i, v in pairs(buff_checker_roster) do
        if v == is_present then display_string = display_string .. i .. "\n" end
    end

    names_frame:SetText(display_string)
end

SlashCmdList['BUFF_CHECKER_SLASHCMD'] = function(msg)
    local f = _G["BuffChecker"]
    if f:IsVisible() then
        f:Hide()
    else
        f:Show()
    end
end
SLASH_BUFF_CHECKER_SLASHCMD1 = '/buffs'