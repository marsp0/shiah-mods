local last_check = 0
local map = {
    [13512] = 17628, -- flask
    [13454] = 17539, -- greater arcane elixir
    [21546] = 26276, -- greater fire power
    [20007] = 24363, -- mageblood
    [20749] = 25122, -- wizard oil
    [13931] = 18194, -- nightfin soup
    -- spells
    [23028] = 23028,
    [22783] = 22783
}

function consums_check(self, unit)
    local now = GetTime()
    if (now - last_check) < 15 then return end
    last_check = now

    SM_print("Checking consumables...")

    local auras = {}
    for i = 1, 32 do
        local name, _, count, _, dur, expiration_time, caster, _, _, spell_id = UnitBuff(unit, i)
        if not name then break end
        auras[spell_id] = true
    end

    local action_bars = {'MultiBarRight', 'MultiBarLeft'}
    for _, bar_name in pairs(action_bars) do
        for i = 1, 12 do
            local button = _G[bar_name .. 'Button' .. i]
            local slot = ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute('action') or 0
            if HasAction(slot) then
                local action_type, id = GetActionInfo(slot)

                if map[id] then
                    local appropriate_id = map[id]
                    local enchanted = id == 20749 and GetWeaponEnchantInfo()

                    if auras[appropriate_id] or enchanted then
                        ActionButton_HideOverlayGlow(button)
                    else
                        ActionButton_ShowOverlayGlow(button)
                    end 
                end
            end
        end
    end
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