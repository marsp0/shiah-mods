
local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function(self, event, ...)
    -- auto sell trash
    for bag = 0, 4 do 
        for slot = 1, C_Container.GetContainerNumSlots(bag) do 
            local item_link = C_Container.GetContainerItemLink(bag, slot) 
            if item_link then
                local _, _, rarity = GetItemInfo(item_link)
                if rarity == 0 then 
                    DEFAULT_CHAT_FRAME:AddMessage("Selling " .. item_link) 
                    C_Container.UseContainerItem(bag,slot) 
                end
            end
        end 
    end

    -- repair
    if not CanMerchantRepair() then return end
    local cost = GetRepairAllCost()
    if GetMoney() < cost or cost == 0 then return end
    RepairAllItems()
    SM_print("Repaired for " .. GetCoinText(cost))
end)