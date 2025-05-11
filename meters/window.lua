if GetRealmName() == "Spineshatter" then return end

local backdrop_window = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                          tile = true, tileSize = 16, edgeSize = 16,
                          insets = { left = 3, right = 3, top = 3, bottom = 3 } }
local backdrop_border = { edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                          tile = true, tileSize = 16, edgeSize = 16,
                          insets = { left = 3, right = 3, top = 3, bottom = 3 } }

local total_width = 322
local table_width = 160
local bar_width = 150
local bar_height = 16
local title_height = 22
local created = false

local window = CreateFrame("Frame", "SMMeterWindow", UIParent, "BackdropTemplate")
window:RegisterEvent("PLAYER_ENTERING_WORLD")
window:EnableMouse(true)
window:RegisterForDrag("LeftButton")
window:SetMovable(true)
window:SetScript("OnDragStart", function() window:StartMoving() end)
window:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
window:SetBackdrop(backdrop_window)
window:SetBackdropColor(.5,.5,.5,.5)
window:SetWidth(total_width)
window:SetHeight(bar_height * 10 + title_height + 4)
window:SetPoint("RIGHT", UIParent, "RIGHT", -130, -205)

window.border = CreateFrame("Frame", "$parentBorder", window, "BackdropTemplate")
window.border:ClearAllPoints()
window.border:SetPoint("TOPLEFT", window, "TOPLEFT", -1,1)
window.border:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 1,-1)
window.border:SetFrameLevel(100)
window.border:SetBackdrop(backdrop_border)
window.border:SetBackdropBorderColor(.7,.7,.7,1)
SM_print("DPSMeter UI created")
window:SetScript("OnEvent", function(self, event)
    if not IsInInstance() then window:Hide(); SM_print("DPSMeter disabled"); return end
    window:Show()
    SM_print("DPSMeter enabled"); 
end)

function meters_create_table(name, x_offset, y_offset, on_tooltip_show)
    local table = CreateFrame("Frame", name, window)
    table:EnableMouse(true)
    table:SetWidth(table_width)
    table:SetHeight(bar_height * 10 + title_height + 4)
    table:SetPoint("TOPLEFT", window, x_offset, y_offset)

    table.title = window:CreateFontString("$parentTitle", "OVERLAY", "GameFontWhite")
    table.title:SetFont(STANDARD_TEXT_FONT, 11)
    table.title:SetText(name)
    table.title:SetPoint("TOP", table, 0, -8)

    local create_text_bar = function(parent, name, justify)
        local f = parent:CreateFontString(name, "OVERLAY", "GameFontNormal")
        f:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
        f:SetJustifyH(justify)
        f:SetFontObject(GameFontWhite)
        f:SetParent(parent)
        f:ClearAllPoints()
        f:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, 1)
        f:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -5, 0)
        return f
    end

    table.bars = {}
    for i = 1, 10 do
        local name = "DPSMeterBar" .. i
        table.bars[i] = CreateFrame("StatusBar", "$parentBar" .. i, table)
        table.bars[i]:SetWidth(bar_width)
        table.bars[i]:SetHeight(bar_height)
        table.bars[i]:SetMinMaxValues(0, 100)
        table.bars[i]:SetPoint("TOPLEFT", table, "TOPLEFT", 5, -title_height - ((i-1) * bar_height))
        table.bars[i]:SetStatusBarTexture("Interface/TargetingFrame/UI-StatusBar")
        table.bars[i]:SetStatusBarColor(0, 0, 0, 0.0)
        table.bars[i]:SetMinMaxValues(0, 100)
        table.bars[i].left = create_text_bar(table.bars[i], name .. "TextLeft", "LEFT")
        table.bars[i].right = create_text_bar(table.bars[i], name .. "TextRight", "RIGHT")
        table.bars[i]:EnableMouse(true)
        table.bars[i]:SetScript("OnEnter", on_tooltip_show)
        table.bars[i]:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    table:Show()
    return table
end

function meters_clear_bars(window)
    for i, bar in pairs(window.bars) do 
        bar.left:SetText("")
        bar.right:SetText("")
        bar.unit = nil
        bar:SetValue(0)
    end
end
