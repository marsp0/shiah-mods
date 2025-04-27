function miniwigs_raz_on_engage()
    miniwigs_bar_set_cooldown(29107, 25, 132333)
end

function miniwigs_raz_on_event()
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_CAST_SUCCESS" then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 29107 then return end

    miniwigs_announcer_set_text("Shout")
    miniwigs_bar_set_cooldown(spell_id, 25, 132333)
end

function miniwigs_noth_on_engage()
    miniwigs_bar_set_cooldown(29213, 9)
end

function miniwigs_noth_on_event()
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_CAST_SUCCESS" then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 29213 then return end

    miniwigs_announcer_set_text("Curse of the Plaguebringer")
    miniwigs_bar_set_cooldown(spell_id, 51.7)
end

function miniwigs_horsemen_on_engage()
    miniwigs_bar_set_cooldown(28832, 21)
end

do
    local prev = 0
    function miniwigs_horsemen_on_event()
        local timestamp, subevent = CombatLogGetCurrentEventInfo()
        if subevent ~= "SPELL_CAST_SUCCESS" then return end

        local spell_id = select(12, CombatLogGetCurrentEventInfo())
        if spell_id ~= 28832 and spell_id ~= 28833 and spell_id ~= 28834 and spell_id ~= 28835 then return end
        if timestamp - prev < 5 then return end

        prev = timestamp
        miniwigs_announcer_set_text("Mark")
        miniwigs_bar_set_cooldown(spell_id, 12.9)
    end
end

function miniwigs_saph_on_engage()
    miniwigs_bar_set_cooldown(28542, 12.5)
end

function miniwigs_saph_on_event()
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_CAST_SUCCESS" then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 28542 then return end

    miniwigs_announcer_set_text("Drain Life")
    miniwigs_bar_set_cooldown(spell_id, 23)
end

function miniwigs_loatheb_on_engage()
    miniwigs_bar_set_cooldown(29234, 11.2, 237556)
end

function miniwigs_loatheb_on_event()
    local timestamp, subevent = CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_CAST_SUCCESS" then return end

    local spell_id = select(12, CombatLogGetCurrentEventInfo())
    if spell_id ~= 29234 then return end

    miniwigs_announcer_set_text("Spore")
    miniwigs_bar_set_cooldown(spell_id, 12.5, 237556)
end
