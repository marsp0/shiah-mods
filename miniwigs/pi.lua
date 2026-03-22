local pi_id = 10060 -- Power Infusion
local bop_id = 10278  -- Blessing of Protection
sm_config = sm_config or {}

-- local pi_id = 28609 -- debug mage
-- local bop_id = 28609 -- debug mage
-- local pi_id = 20906 -- debug hunter

function pi1_on_event(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then 
        self.unit = sm_config["pi1_unit"] or "Shiah"
        self.server = sm_config["pi1_server"] or "Golemagg"
        return;
    end

    local unit, _, spell_id = ...
    if spell_id ~= pi_id then return end

    local name = UnitName(unit)
    if name ~= self.unit then return end

    self:SetCooldown(GetTime(), 180)
end

function pi2_on_event(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then 
        self.unit = sm_config["pi2_unit"] or "Shiah"
        self.server = sm_config["pi2_server"] or "Golemagg"
        return;
    end

    local unit, _, spell_id = ...
    if spell_id ~= pi_id then return end

    local name = UnitName(unit)
    if name ~= self.unit then return end

    self:SetCooldown(GetTime(), 180)
end

function bop_on_event(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then 
        self.unit = sm_config["bop_unit"] or "Shiah"
        self.server = sm_config["bop_server"] or "Golemagg"
        return;
    end

    local unit, _, spell_id = ...
    if spell_id ~= bop_id then return end

    local name = UnitName(unit)
    if name ~= self.unit then return end

    self:SetCooldown(GetTime(), 180)
end

pi1 = CreateFrame("Cooldown", " ", MultiBarBottomLeftButton5, "CooldownFrameTemplate")
pi1:SetDrawEdge(false)
pi1:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
pi1:RegisterEvent("PLAYER_ENTERING_WORLD")
pi1:SetScript("OnEvent", pi1_on_event)
pi1.unit = "Shiah"
pi1.server = "Golemagg"

pi2 = CreateFrame("Cooldown", "MultiBarBottomLeftButton4CD", MultiBarBottomLeftButton4, "CooldownFrameTemplate")
pi2:SetDrawEdge(false)
pi2:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
pi2:RegisterEvent("PLAYER_ENTERING_WORLD")
pi2:SetScript("OnEvent", pi2_on_event)
pi2.unit = "Shiah"
pi2.server = "Golemagg"

bop = CreateFrame("Cooldown", "MultiBarBottomLeftButton3CD", MultiBarBottomLeftButton3, "CooldownFrameTemplate")
bop:SetDrawEdge(false)
bop:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
bop:RegisterEvent("PLAYER_ENTERING_WORLD")
bop:SetScript("OnEvent", bop_on_event)
bop.unit = "Shiah"
bop.server = "Golemagg"

-- register names of units priest/pally
SlashCmdList['PI_ONE_SLASHCMD'] = function(msg)
    pi1.unit, pi1.server = UnitName("target")
    if not pi1.server then pi1.server = GetRealmName() end
    sm_config["pi1_unit"] = pi1.unit
    sm_config["pi1_server"] = pi1.server
    SM_print("PI 1: " .. pi1.unit .. "-" .. pi1.server)
end
SLASH_PI_ONE_SLASHCMD1 = '/pi1'

SlashCmdList['PI_TWO_SLASHCMD'] = function(msg)
    pi2.unit, pi2.server = UnitName("target")
    if not pi2.server then pi2.server = GetRealmName() end
    sm_config["pi2_unit"] = pi2.unit
    sm_config["pi2_server"] = pi2.server
    SM_print("PI 2: " .. pi2.unit .. "-" .. pi2.server)
end
SLASH_PI_TWO_SLASHCMD1 = '/pi2'

SlashCmdList['BOP_SLASHCMD'] = function(msg)
    bop.unit, bop.server = UnitName("target")
    if not bop.server then bop.server = GetRealmName() end
    sm_config["bop_unit"] = bop.unit
    sm_config["bop_server"] = bop.server
    SM_print("BOP: " .. bop.unit .. "-" .. bop.server)
end
SLASH_BOP_SLASHCMD1 = '/bop'
