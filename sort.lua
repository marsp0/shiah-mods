local MAX_ID = 1000000000
local current_bag = 0
local type_map = {
    ["Quiver"]          = 6,
    ["Projectile"]      = 6,
    ["Armor"]           = 6,
    ["Weapon"]          = 6,
    ["Recipe"]          = 5,
    ["Consumable"]      = 4,
    ["Reagent"]         = 3,
    ["Container"]       = 2,
    ["Gem"]             = 2,
    ["Key"]             = 2,
    ["Miscellaneous"]   = 2,
    ["Money"]           = 2,
    ["Trade Goods"]     = 2,
    ["Quest"]           = 1
}

local exclude_map = {
    [184938] = true,        -- supercharged chrono
    [184937] = true,        -- boon
    [6948] = true,          -- hearthstone
    [6218] = true,          -- copper rod
    [11130] = true,         -- golden rod
    [11145] = true,         -- silver rod
    [6339] = true,          -- silver
    [16207] = true,         -- arcanite rod
}

function SM_should_swap(a_id, b_id)
    if a_id == MAX_ID then return false end
    if b_id == MAX_ID then return true end

    local _, _, a_rarity, a_subtype, _, a_type = GetItemInfo(a_id)
    local a_bag = GetItemFamily(a_id)
    local _, _, b_rarity, b_subtype, _, b_type = GetItemInfo(b_id)
    local b_bag = GetItemFamily(b_id)

    if type_map[a_type] ~= type_map[b_type] then return type_map[a_type]< type_map[b_type] end
    if a_bag            ~= b_bag            then return a_bag           < b_bag end
    if a_subtype        ~= b_subtype        then return a_subtype       < b_subtype end
    if a_rarity         ~= b_rarity         then return a_rarity        < b_rarity end
    return a_id < b_id
end

function SM_get_next_bag_slot(bag, slot)
    slot = slot - 1
    if slot < 1 then
        bag = bag + 1
        slot = C_Container.GetContainerNumSlots(bag)
    end
    return bag, slot
end

function SM_get_sort_item_id(bag, slot) return C_Container.GetContainerItemID(bag, slot) or MAX_ID end

function SM_sort(bag, slot)
    if bag > 4 or SM_get_next_bag_slot(bag, slot) > 4 then SM_print("Done sorting"); return end
    if bag ~= current_bag then current_bag = bag; SM_print("Sorting bag " .. bag) end

    local min_id                = SM_get_sort_item_id(bag, slot)
    local min_bag, min_slot     = bag, slot
    local next_bag, next_slot   = SM_get_next_bag_slot(bag, slot)
    while true do
        local next_item_id = SM_get_sort_item_id(next_bag, next_slot)
        if SM_should_swap(next_item_id, min_id) and not exclude_map[next_item_id] then
            min_id      = next_item_id
            min_bag     = next_bag
            min_slot    = next_slot
        end
        next_bag, next_slot = SM_get_next_bag_slot(next_bag, next_slot)
        if next_bag > 4 then break end
    end

    ClearCursor()
    if SM_get_sort_item_id(min_bag, min_slot) then 
        C_Container.PickupContainerItem(min_bag, min_slot)
        C_Container.PickupContainerItem(bag, slot)
    else
        C_Container.PickupContainerItem(min_bag, min_slot)
        C_Container.PickupContainerItem(bag, slot)
    end

    bag, slot = SM_get_next_bag_slot(bag, slot)
    C_Timer.After(0.4, function() SM_sort(bag, slot) end)
end

SlashCmdList['SORT_SLASHCMD'] = function(msg)
    current_bag = -1
    SM_sort(0, 20) 
end
SLASH_SORT_SLASHCMD1 = '/sort'