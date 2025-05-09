SM_kill_map = SM_kill_map or {}
local broadcast_map = {}
local last_broadcast_time = 0

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", 
    function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"         then spy_enter_world() end
        if event == "COMBAT_LOG_EVENT_UNFILTERED"   then spy_combat_log() end
    end
)

function spy_enter_world()
    if IsInInstance() then
        f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        SM_print("Spy disabled")
    else
        f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        SM_print("Spy enabled")
    end
end

function spy_combat_log()
    local time, _, _, _, name = CombatLogGetCurrentEventInfo()
    if not SM_kill_map[name] then return end

    local last_shout = broadcast_map[name] or 0
    if time - last_shout < 120 or time - last_broadcast_time < 2 then return end

    broadcast_map[name] = time
    last_broadcast_time = time
    local sound = "Interface\\AddOns\\ShiahMods\\sounds\\detected-kos.wav"
    local msg   = "KOS: "

    PlaySoundFile(sound)
    SM_print(msg .. name)
end

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
