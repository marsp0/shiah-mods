local last_update = 0
local update_interval = 1 / 5 -- 5 Hz
local _, cls, _ = UnitClass("unit");
if cls ~= "MAGE" then return end

local f = CreateFrame("Frame", "IgniteFrame", TargetFrame)
f:SetSize(30, 30)
f:SetPoint("BOTTOMLEFT", TargetFrame, "TOPLEFT", 5, -18)

local t = f:CreateTexture("IgniteTexture", "ARTWORK")
t:SetVertexColor(0.5, 0.5, 0.5)
t:SetPoint("TOPLEFT", f, 0, 0)
t:SetTexture(135818)
t:SetSize(30, 30)

local cd = CreateFrame("Cooldown", "IgniteCooldown", f, "CooldownFrameTemplate")
cd:SetDrawEdge(false)

local s = f:CreateFontString("IgniteStacks", "OVERLAY", "NumberFontNormalLarge")
s:SetPoint("CENTER", f, 0, 0)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" then ignite_enter_world() end
    if event == "UNIT_AURA" then ignite_unit_aura(unit) end
end)

cd:SetScript("OnCooldownDone", function() t:SetVertexColor(0.5, 0.5, 0.5); s:SetText("") end)

function ignite_enter_world()
    if IsInInstance() then  SM_print("Ignite enabled");     f:Show();   f:RegisterUnitEvent("UNIT_AURA", "target"); return; end
                            SM_print("Ignite disabled");    f:Hide();
end

function ignite_unit_aura(unit)
    local now = GetTime()
    if (now - last_update) < update_interval then return end
    t:SetVertexColor(0.5, 0.5, 0.5); s:SetText(""); cd:Clear()
    for i = 1, 16 do
        local name, _, count, _, dur, expiration_time, caster, _, _, spell_id = UnitDebuff("target", i)
        if not name then break end

        if spell_id == 12654 then
            s:SetText(count); t:SetVertexColor(1, 1, 1); cd:SetCooldown(expiration_time - dur, dur)
            break
        end
    end
    last_update = now
end