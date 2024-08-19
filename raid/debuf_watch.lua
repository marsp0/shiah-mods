function debuff_watch_init()

end

function debuff_watch_draw(self)

end

function debuff_watch_update(self)
    time_now = GetTime()

    if time_now - self.time_since_last_update < 0.5 then return end

    active = false
    for j=1, 32 do
        local name,_,count,_,duration,expirationTime,_,_,_,spell_id = UnitAura("target", j, "HARMFUL")
        -- local name,_,count,_,duration,expirationTime,_,_,_,spell_id = UnitAura("target", j, "HELPFUL")
        if name == nil then break end

        if self.spell_id == spell_id then
            active = true
            _G[self:GetName().."Texture"]:SetVertexColor(1,1,1)
            _G[self:GetName().."Cooldown"]:SetText(string.format("%d", expirationTime - time_now))

            if count > -1 then
                _G[self:GetName().."Stacks"]:SetText(count)
            end
        end
    end

    if not active then
        _G[self:GetName().."Texture"]:SetVertexColor(0.5, 0.5, 0.5)
        _G[self:GetName().."Cooldown"]:SetText(0)
        _G[self:GetName().."Stacks"]:SetText(0)
    end

    self.time_since_last_update = time_now
end

SlashCmdList['DEBUFF_WATCH_SLASHCMD'] = function(msg)
    local f = _G["DebuffWatchFrame"]
    if f:IsVisible() then
        f:Hide()
    else
        f:Show()
    end
end
SLASH_DEBUFF_WATCH_SLASHCMD1 = '/debuff_watch'