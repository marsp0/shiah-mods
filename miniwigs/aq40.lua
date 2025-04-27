function miniwigs_skeram_on_event()
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_AURA_APPLIED" then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 785 then return end

    miniwigs_announcer_set_text("Mind Control")
end

function miniwigs_bug_trio_on_engage()
    miniwigs_bar_set_cooldown(26580, 11.3)
end

function miniwigs_bug_trio_on_event()
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_CAST_SUCCESS" then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 26580 then return end

    miniwigs_announcer_set_text("Fear")
    miniwigs_bar_set_cooldown(spell_id, 21)
end

function miniwigs_twins_on_engage()
    miniwigs_bar_set_cooldown(800, 30)
end

do
    local prev = 0
    function miniwigs_twins_on_event()
        local timestamp, subevent = CombatLogGetCurrentEventInfo()
        if subevent ~= "SPELL_AURA_APPLIED" then return end

        local spell_id = select(12, CombatLogGetCurrentEventInfo())
        if spell_id ~= 800 then return end
        if timestamp - prev < 2 then return end

        miniwigs_announcer_set_text("Teleport")
        miniwigs_bar_set_cooldown(spell_id, 30)
        prev = timestamp
    end
end
