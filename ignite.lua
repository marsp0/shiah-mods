local frequency = 4
local last_update = 0
local update_interval = 1 / frequency

function ignite_clear(name)
    _G[name .. "Texture"]:SetVertexColor(0.5, 0.5, 0.5)
    _G[name .. "Stacks"]:SetText("")
    _G[name .. "Cooldown"]:Clear()
end

function create_debuff(name, parent, texture_path, x_offset)
    local frame = CreateFrame("Frame", name .. "Frame", parent)
    frame:SetPoint("TOPLEFT", x_offset, 0)
    frame:SetSize(40, 40)

    local t = frame:CreateTexture(name .. "Texture", "ARTWORK")
    t:SetVertexColor(0.5, 0.5, 0.5)
    t:SetTexture(texture_path)
    t:SetPoint("TOPLEFT", frame, 0, 0)
    t:SetSize(40, 40)

    local s = frame:CreateFontString(name .. "Stacks", "OVERLAY", "NumberFontNormal")
    s:SetPoint("BOTTOMRIGHT", frame, -1, 2)

    local cd = CreateFrame("Cooldown", name .. "Cooldown", frame, "CooldownFrameTemplate")
    cd:SetDrawEdge(false)
    cd:SetPoint("TOPLEFT", 0, 0)
    cd:SetSize(40, 40)
    cd:SetScript("OnCooldownDone", function(self) ignite_clear(name) end)
end

local f = CreateFrame("Frame", "FireDebuffFrame", UIParent)
f:Hide()
f:SetPoint("CENTER", 0, -160)
f:SetSize(80, 40)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:SetScript("OnEvent", 
    function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then ignite_enter_world() end
        if event == "PLAYER_TARGET_CHANGED" then ignite_target_changed() end
    end
)

local fi = create_debuff("Ignite", f, "Interface\\Icons\\Spell_Fire_Incinerate", 0)
local fv = create_debuff("Fire Vulnerability", f, "Interface\\Icons\\Spell_Fire_SoulBurn", 40)

function ignite_enter_world()
    if not IsInInstance() then SM_print("Ignite disabled"); return end
    f:Show()
    f:SetScript("OnUpdate", ignite_on_update)
    SM_print("Ignite enabled")
end

function ignite_target_changed()
    if GetUnitName("target") then return end

    ignite_clear("Ignite")
    ignite_clear("Fire Vulnerability")
end

function ignite_on_update()
    local now = GetTime()
    if (now - last_update) < update_interval then return end
    if not GetUnitName("target") then return end

    for i = 1, 16 do
        local name, _, count, _, dur, expiration_time, caster, _, _, spell_id = UnitDebuff("target", i)
        if not name then break end

        if spell_id == 22959 or spell_id == 12654 then
            _G[name .. "Stacks"]:SetText(count)
            _G[name .. "Texture"]:SetVertexColor(1, 1, 1)
            _G[name .. "Cooldown"]:SetCooldown(expiration_time - dur, dur)
        end
    end

    last_update = now
end