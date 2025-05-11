if GetRealmName() == "Spineshatter" then return end

local window = CreateFrame("Frame", "MiniWigs", UIParent)
window:SetWidth(50)
window:SetHeight(50)
window:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

local announcer = CreateFrame("Frame", "MiniWigsAnnouncer", window)
announcer:SetWidth(200)
announcer:SetHeight(50)
announcer:SetPoint("CENTER", window, "CENTER", 0, 200)
announcer.text = announcer:CreateFontString("$parentText", "OVERLAY")
announcer.text:SetFont(STANDARD_TEXT_FONT, 30, "THINOUTLINE")
announcer.text:SetPoint("CENTER", announcer, 0, 0)

local bar = CreateFrame("Frame", "MiniWigsCooldown1", window)
bar:SetWidth(50)
bar:SetHeight(50)
bar:SetPoint("CENTER", window, "CENTER", 0, -100)
bar.cd = CreateFrame("Cooldown", "$parentCooldown", bar, "CooldownFrameTemplate")
bar.cd:SetAllPoints(bar)
bar.cd:SetDrawEdge(false)
bar.cd:SetDrawBling(false)
bar.texture = bar:CreateTexture("$parentTexture", "ARTWORK")
bar.texture:SetPoint("TOPLEFT", bar, 0, 0)
bar.texture:SetSize(50, 50)

function miniwigs_announcer_set_text(text)
    announcer.text:SetText(text)
    PlaySoundFile("Interface\\AddOns\\ShiahMods\\sounds\\info.ogg", "Master")
    C_Timer.After(3, function() announcer.text:SetText("") end)
end

function miniwigs_bar_set_cooldown(spell_id, duration, texture_id)
    if not texture_id then texture_id = select(3, GetSpellInfo(spell_id)) end
    bar.texture:SetTexture(texture_id)
    bar.cd:SetCooldown(GetTime(), duration)
end

function miniwigs_bar_show() bar:Show() end
function miniwigs_bar_hide() bar:Hide() end
