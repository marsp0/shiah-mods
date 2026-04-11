local max_rows = 3
local max_cols = 3
local width = 38
local queue = {
    [13] = nil, -- left trinket
    [14] = nil  -- right trinket
}

function scan_inventory()
    local data = {}
    for i = 0, 4 do
		for j = 1, C_Container.GetContainerNumSlots(i) do
            item_id = C_Container.GetContainerItemID(i, j)
            if item_id and select(9, GetItemInfo(item_id)) == "INVTYPE_TRINKET" then
                table.insert(data, item_id)
            end
		end
	end
    return data
end

local function equip_trinket(item_id, slot)
    PlaySound(1204)
    EquipItemByName(item_id, slot)
    queue[slot] = nil
end

local function queue_trinket(item_id, slot)
    if queue[slot] == item_id then
        queue[slot] = nil
    else
        queue[slot] = item_id
    end
end

local function equip_queue()
    for slot, item_id in pairs(queue) do
        if item_id then equip_trinket(item_id, slot) end
    end
end

local function handle_mouse_click(self, button)
    slot = 13
    if button == 'RightButton' then slot = 14 end

    if InCombatLockdown() then
        queue_trinket(self.item_id, slot)
    else
        equip_trinket(self.item_id, slot)
    end
end

local function populate_trinket_window(self)
    print("ShiahMods: Scanning inventory for trinkets...")
    local data = scan_inventory()

    for i, item_id in ipairs(data) do
        if i > max_rows * max_cols then break end
        local row = math.floor((i-1) / max_cols) + 1
        local col = ((i-1) % max_cols) + 1
        local frame = _G["ShiahTrinketWindowButton"..row..col]
        frame.item_id = item_id
        frame.texture:SetTexture(GetItemIcon(item_id))
        frame.cd:SetCooldown(C_Container.GetItemCooldown(item_id))
    end
end

local function create_trinket_window(self)
    for i = 1, max_rows do
        for j = 1, max_cols do
            local b = CreateFrame("Frame", "$parentButton"..i..j, self)
            b:SetWidth(width)
            b:SetHeight(width)
            b:SetPoint("TOPLEFT", (j-1)*width, (i-1)*width)

            b.texture = b:CreateTexture("$parentTexture", "ARTWORK")
            b.texture:SetPoint("TOPLEFT", b, 0, 0)
            b.texture:SetWidth(width)
            b.texture:SetHeight(width)

            b.cd = CreateFrame("Cooldown", "$parentCooldown", b, "CooldownFrameTemplate")
            b.cd:SetAllPoints(b)
            b.cd:SetDrawEdge(false)

            b:SetScript("OnMouseDown", function(self, button) handle_mouse_click(self, button) end)
        end
    end
end

local f = CreateFrame("Frame", "ShiahTrinketWindow", UIParent)
f:SetWidth(5)
f:SetHeight(5)
f:SetPoint("TOPLEFT", UIParent, "RIGHT", -240, 120)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        equip_queue();
    elseif event == "PLAYER_ENTERING_WORLD" then
        create_trinket_window(self)
        populate_trinket_window(self)
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        local slot = ...
        if slot == 13 or slot == 14 then populate_trinket_window(self) end
    end
end)