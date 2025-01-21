SM_kill_map = SM_kill_map or {}
local broadcast_map = {}

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event, ...)

    local time, _, _, _, name = CombatLogGetCurrentEventInfo()
    if not SM_kill_map[name] then return end

    local last_shout = broadcast_map[name] or 0
    if time - last_shout < 20 then return end

    broadcast_map[name] = time
    PlaySoundFile("Interface\\AddOns\\ShiahMods\\sounds\\detected-kos.wav")
    SM_print("Kill target: " .. name)
end)

SlashCmdList['KILL_SLASHCMD'] = function(msg) 
    if msg == "" then msg = UnitName("target") end
    SM_kill_map[msg] = true 
    SM_print("Kill target added: " .. msg)
end
SLASH_KILL_SLASHCMD1 = '/kill'

SlashCmdList['DKILL_SLASHCMD'] = function(msg)
    if msg == "" then msg = UnitName("target") end
    SM_kill_map[msg] = nil 
    SM_print("Kill target removed: " .. msg)
end
SLASH_DKILL_SLASHCMD1 = '/dkill'