if GetRealmName() == "Spineshatter" then return end

local event_handlers = { 
    [709] = miniwigs_skeram_on_event,
    [710] = miniwigs_bug_trio_on_event,
    [715] = miniwigs_twins_on_event,

    [1113] = miniwigs_raz_on_event,
    [1117] = miniwigs_noth_on_event,
    [1121] = miniwigs_horsemen_on_event,
    [1119] = miniwigs_saph_on_event,
    [1115] = miniwigs_loatheb_on_event,
}

local engage_handlers = {
    [710] = miniwigs_bug_trio_on_engage,
    [715] = miniwigs_twins_on_engage,

    [1113] = miniwigs_raz_on_engage,
    [1117] = miniwigs_noth_on_engage,
    [1119] = miniwigs_saph_on_engage,
    [1115] = miniwigs_loatheb_on_engage,
}

local current = nil
local frame = CreateFrame("Frame", "MiniWigsBoss", UIParent)
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")

local function miniwigs_encounter_start(...)
    local encounter_id = select(1, ...)
    if not event_handlers[encounter_id] and not engage_handlers[encounter_id] then return end

    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    current = encounter_id
    local handler = engage_handlers[current]
    if not handler then return end
    miniwigs_bar_show()
    handler()
end

local function miniwigs_encounter_end(...)
    current = nil
    frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    miniwigs_bar_hide()
end

local function miniwigs_combat_event(...)
    if not current or not event_handlers[current] then return end
    local handler = event_handlers[current]
    handler()
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ENCOUNTER_START"               then miniwigs_encounter_start(...) end
    if event == "ENCOUNTER_END"                 then miniwigs_encounter_end(...) end
    if event == "COMBAT_LOG_EVENT_UNFILTERED"   then miniwigs_combat_event(...) end
end)
