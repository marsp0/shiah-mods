local handler_map = {}
for i = 1, 6 do
    local f = _G["QuestLogTitle"..i]
    handler_map[i] = f:GetScript("OnClick")
    f:SetScript("OnClick", function(self, ...)
        handler_map[i](self, ...)
        if select(1, ...) ~= "RightButton" or self.isHeader then return end
        local quest_id = select(8, GetQuestLogTitle(i))
        ChatEdit_ActivateChat(DEFAULT_CHAT_FRAME.editBox)
        DEFAULT_CHAT_FRAME.editBox:SetText("https://www.wowhead.com/classic/quest=" .. quest_id)
    end)
end