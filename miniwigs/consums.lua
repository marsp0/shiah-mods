if select(2, UnitClass("player")) ~= "MAGE" then return end

local last_check = 0
local map = {
    17628, -- flask
    17539, -- greater arcane elixir
    26276, -- greater fire power
    24363, -- mageblood
    18194, -- nightfin soup
    -- spells
    23028,
    22783
}

function consums_check(self, unit)
    local now = GetTime()
    if (now - last_check) < 15 then return end
    last_check = now

    local auras = {}
    for i = 1, 32 do
        local name, _, count, _, dur, expiration_time, caster, _, _, spell_id = UnitBuff(unit, i)
        if not name then break end
        auras[spell_id] = true
    end

    local missing = false
    local missing_name = ""

    for i, spell_id in ipairs(map) do
        if not auras[spell_id] then
            missing = true
            missing_name = GetSpellInfo(spell_id)
        end
        if missing then break end
    end

    if not GetWeaponEnchantInfo() then 
        missing = true
        missing_name = GetSpellInfo(25122) -- wizard oil
    end

    if missing then SM_print(missing_name .. " is missing!") end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" then
        if IsInInstance() then
            f:RegisterUnitEvent("UNIT_AURA", "player")
        else 
            f:UnregisterEvent("UNIT_AURA")
        end
    else
        consums_check(self, unit)
    end
end)