SLASH_RL1 = "/RL"
SlashCmdList["RL"] = function(msg)
    ReloadUI();
end

-- Define Frame
local moneyFrame = CreateFrame("Frame")
local lootFrame = CreateFrame("Frame")
local enteringInstanceFrame = CreateFrame("Frame")
local bossKillFrame = CreateFrame("Frame")



-- Register Event when in Chat Money was looted
moneyFrame:RegisterEvent("CHAT_MSG_Money")
lootFrame:RegisterEvent("CHAT_MSG_Loot")
--enteringInstanceFrame:RegisterEvent("WORLD_MAP_UPDATE")
enteringInstanceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bossKillFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function OnEvent(self, event)
    if C_EncounterJournal.IsEncounterComplete(1443) then -- Adarogg
        msg = "Adarogg Down - C_EJ.IEC(1443)"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil);
    elseif C_EncounterJournal.IsEncounterComplete(694) then -- Adarogg
        msg = "Adarogg Down - C_EJ.IEC(694)"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil);
    elseif C_EncounterJournal.IsEncounterComplete(1444) then -- Dark Shaman Koranthal
        print("DARK SHAMAN DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(1445) then -- Slagmaw
        print("SLAGMAW DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(1446) then -- Lava Guard Gordoth
        print("GORDOTH DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(61528) then -- Lava Guard Gordoth
        print("GORDOTH DOWN")
    end
    --print(CombatLogGetCurrentEventInfo())
end

bossKillFrame:SetScript("OnEvent", OnEvent)

local function logMoney()
    -- Simply for Test purpose, prints out if you looted any amount of money
    print("|cffff0050[HDT]|r" .. " - |cff40ea1aSomeone looted Money.|r")
end

local function logLoot()
    -- Simply for Test purpose, prints out if you looted any item
    print("|cffff0050[HDT]|r" .. " - |cff40ea1aSomeone looted an Item.|r")
end

--- Defines a solid tracking method for ingame time
--- - Tracks the current Time in Game
local function getCurrentTimeInInstance()
    local hours, mins = GetGameTime()
    return hours .. ":" .. mins
end

local function trackEnteringInstance()
    if IsInInstance() then
        print("StartTime: " .. "["..getCurrentTimeInInstance().."]")
        msg = "StartTime: " .. "["..getCurrentTimeInInstance().."]"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil);
        print("|cffff0050[HDT]|r" .. " - |cff40ea1aI JOINED AN INSTANCE.|r")

        for _ = 1, 2^27 do
            -- Busy loop to make some time pass.
        end
        print("EndTime: " .. "["..getCurrentTimeInInstance().."]")
    else
    print("|cffff0050[HDT]|r" .. " - |cff40ea1aI JOINED THE WORLD.|r")
    end
end


local function trackBossKill()
    if C_EncounterJournal.IsEncounterComplete(1443) then -- Adarogg
        print("ADAROGG DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(1444) then -- Dark Shaman Koranthal
        print("DARK SHAMAN DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(1445) then -- Slagmaw
        print("SLAGMAW DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(1446) then -- Lava Guard Gordoth
        print("GORDOTH DOWN")
    elseif C_EncounterJournal.IsEncounterComplete(61528) then -- Lava Guard Gordoth
        print("GORDOTH DOWN")
    end

    if INSTANCE_ENCOUNTER_ENGAGE_UNIT(1443) then
        print("ADAROGG DOWN")
    elseif INSTANCE_ENCOUNTER_ENGAGE_UNIT(61408) then
        print("ADAROGG DOWN NPC ID")
    end

end


-- Event trigger, executes function when the Event occurs
moneyFrame:SetScript("OnEvent", logMoney)
lootFrame:SetScript("OnEvent", logLoot)
enteringInstanceFrame:SetScript("OnEvent", trackEnteringInstance)
--bossKillFrame:SetScript("OnEvent", trackBossKill)



