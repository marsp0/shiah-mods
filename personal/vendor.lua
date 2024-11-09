
local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function(self, event, ...)
    if not CanMerchantRepair() then return end
    local cost = GetRepairAllCost()
    if GetMoney() < cost or cost == 0 then return end
    RepairAllItems()
    SM_print("Repaired for " .. GetCoinText(cost))
end)