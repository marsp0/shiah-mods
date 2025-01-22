local MAX_ID = 1000000000
local current_bag = 0

function SM_should_swap(a_id, b_id)
    if a_id == MAX_ID then return false end
    if b_id == MAX_ID then return true end

    local _, _, a_rarity, a_subtype, _, a_type, _, a_stack_count = GetItemInfo(a_id)
    local _, _, b_rarity, b_subtype, _, b_type, _, b_stack_count = GetItemInfo(b_id)

    if a_type           ~= b_type           then return a_type          < b_type end
    if a_subtype        ~= b_subtype        then return a_subtype       < b_subtype end
    if a_rarity         ~= b_rarity         then return a_rarity        < b_rarity end
    if a_id             ~= b_id             then return a_id            < b_id end
    return                                              a_stack_count   < b_stack_count
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
    if bag > 4 or SM_get_next_bag_slot(bag, slot) > 4 then
        SM_print("Done sorting")
        return 
    end

    if bag ~= current_bag then
        current_bag = bag
        SM_print("Sorting bag " .. bag)
    end

    local min_id                = SM_get_sort_item_id(bag, slot)
    local min_bag, min_slot     = bag, slot
    local next_bag, next_slot   = SM_get_next_bag_slot(bag, slot)
    while true do
        local next_item_id = SM_get_sort_item_id(next_bag, next_slot)
        if SM_should_swap(next_item_id, min_id) then
            min_id      = next_item_id
            min_bag     = next_bag
            min_slot    = next_slot
        end
        next_bag, next_slot = SM_get_next_bag_slot(next_bag, next_slot)
        if next_bag > 4 then break end
    end

    ClearCursor()
    C_Container.PickupContainerItem(min_bag, min_slot)
    C_Container.PickupContainerItem(bag, slot)

    bag, slot = SM_get_next_bag_slot(bag, slot)
    C_Timer.After(0.4, function() SM_sort(bag, slot) end)
end

SlashCmdList['SORT_SLASHCMD'] = function(msg)
    current_bag = -1
    SM_sort(0, 20) 
end
SLASH_SORT_SLASHCMD1 = '/sort'