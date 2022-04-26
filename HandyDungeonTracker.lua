-- Define Slash Command
SLASH_RL1 = "/RL"
SlashCmdList["RL"] = function(_)
    ReloadUI();
end

-- Define Frame
local lootClearedFrame = CreateFrame("Frame")
local lootOpenedFrame = CreateFrame("Frame")
local lootClosedFrame = CreateFrame("Frame")

--variables
local money = nil
local loot = {}

-- Register Event
lootClearedFrame:RegisterEvent("LOOT_SLOT_CLEARED")
lootOpenedFrame:RegisterEvent("LOOT_OPENED")
lootClosedFrame:RegisterEvent("LOOT_CLOSED")

--called when open loot
local function logOpenLoot()
    for index = 1, GetNumLootItems() do
        if LootSlotHasItem(index) then
            local itemType = GetLootSlotType(index)
            if itemType == 1 then
                local _, _, lootQuantity = GetLootSlotInfo(index)
                local itemLink = GetLootSlotLink(index)
                local itemID = GetItemInfoFromHyperlink(itemLink);
                local _, _, _, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemID)
                loot[index] = (sellPrice * lootQuantity)
            elseif itemType == 2 then
                money = GetMoney()
            end
        end
    end
end

--called when taken an item from loot
local function logClearedLoot(_, _, slot)
    local value = loot[slot]
    if value ~= nil then
        print(value)--todo track in sessions
        loot[slot] = nil
    end

end

--called when closed loot
local function logClosedLoot()
    if money ~= nil then
        print(GetMoney() - money)--todo track in sessions
        money = nil
    end
    loot = {}
end


-- Event trigger, executes function when the Event occurs
lootClearedFrame:SetScript("OnEvent", logClearedLoot)
lootOpenedFrame:SetScript("OnEvent", logOpenLoot)
lootClosedFrame:SetScript("OnEvent", logClosedLoot)
