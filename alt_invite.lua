hooksecurefunc("SetItemRef", function(link)
    if IsAltKeyDown() then
        -- Normal chat: player:<name>:<lineId>:WHISPER:<name>
        -- BNet chat: BNplayer:<bNetName>:<bNetGameAccountID>:<lineId>:BN_WHISPER:<bNetName>
        local player = link:match("^player:([^:]+)")
        if player then
            InviteUnit(player)
            -- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
            ChatEdit_OnEscapePressed(ChatFrame1EditBox)
        end
    end
end)