if select(2, UnitClass("player")) ~= "MAGE" then return end

sm_config = sm_config or {}
local str_2_frame = {
    ["PI1"] = "MultiBarBottomLeftButton12CD",
    ["PI2"] = "MultiBarBottomLeftButton11CD",
    ["BOP"] = "MultiBarBottomLeftButton10CD"
}
local pi_id = 10060 -- Power Infusion
local bop_id = 10278  -- Blessing of Protection
-- local pi_id = 28609 -- debug mage frost ward
-- local bop_id = 10220 -- debug mage ice armor

function SM_request(name)
    if name == "PI1" then
        SendChatMessage("PI", "WHISPER", nil, sm_config["pi1_unit"]  .. "-" .. sm_config["pi1_server"])
    elseif name == "PI2" then
        SendChatMessage("PI", "WHISPER", nil, sm_config["pi2_unit"]  .. "-" .. sm_config["pi2_server"])
    else
        SendChatMessage(name, "WHISPER", nil, sm_config["bop_unit"]  .. "-" .. sm_config["bop_server"])
    end
end

pi1 = CreateFrame("Cooldown", "MultiBarBottomLeftButton12CD", MultiBarBottomRightButton12, "CooldownFrameTemplate")
pi1:SetDrawEdge(false)

pi2 = CreateFrame("Cooldown", "MultiBarBottomLeftButton11CD", MultiBarBottomRightButton11, "CooldownFrameTemplate")
pi2:SetDrawEdge(false)

bop = CreateFrame("Cooldown", "MultiBarBottomLeftButton10CD", MultiBarBottomRightButton10, "CooldownFrameTemplate")
bop:SetDrawEdge(false)

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", function(self, event, ...)
    local unit, _, spell_id = ...
    if spell_id ~= bop_id and spell_id ~= pi_id then return end

    local name = UnitName(unit)
    if name == sm_config["pi1_unit"] and spell_id == pi_id then
        _G[str_2_frame["PI1"]]:SetCooldown(GetTime(), 180)
    elseif name == sm_config["pi2_unit"] and spell_id == pi_id then
        _G[str_2_frame["PI2"]]:SetCooldown(GetTime(), 180)
    elseif name == sm_config["bop_unit"] and spell_id == bop_id then
        _G[str_2_frame["BOP"]]:SetCooldown(GetTime(), 180)
    end
end)

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
