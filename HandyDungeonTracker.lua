-- Classic, TBC, WOTLK, CATA, MOP, WOD, LEGION, BFA, SL Dungeons: DungeonIDs, Dungeon Listing, Tables/Arrays for simple accessability
    -- Track 1st, 2nd, 3rd etc. Bosses too? Any Functionality?
-- Timer Difference: Started 20:00 Ended 20:05 => 5 mins and X secs cleared


--- Reload Command
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

local isSecondBossDown = false
local isFirstBossDown = false
local isThirdBossDown = false
local isFourthBossDown = false
local startingTime

-- Endboss of a Dungeon ID / Dungeon ID
local dungeonList = {
    -- Classic Dungeons
    [697] = 226, -- Lava Guard Gordoth, Ragefire Chasm
    [444] = 227, -- Aku'mai, Blackfathom Deeps
    [92] = 63, -- Admiral Ripsnarl, Deadmines
    [422] = 231, -- Mekgineer Thermaplugg, Gnomeregan
    [396] = 229, -- Overlord Wyrmthalak, Lower Blackrock Spire

}

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
    return string.format("%02d:%02d", hours, mins)
end

local function isPlayerEnteringInstance()
    if IsInInstance() then
        name, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID, link, shouldDisplayDifficulty = EJ_GetInstanceInfo(dungeonList[697])
        nameD, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(GetDungeonDifficultyID())
        -- print(nameD)

        startingTime = getCurrentTimeInInstance()
        -- print(type(startingTime))
        --print("StartTime: " .. "["..getCurrentTimeInInstance().."]")
        --msg = "StartTime: " .. "["..getCurrentTimeInInstance().."]"
        --SendChatMessage(msg ,"SAY" ,"COMMON" , nil);
        print("|cffff0050[HDT]|r" .. " - |cff40ea1aI JOINED AN INSTANCE.|r")

        --print("EndTime: " .. "["..getCurrentTimeInInstance().."]")
        --isFirstBossDown, isSecondBossDown, isThirdBossDown, isFourthBossDown = false, false, false, false
    else
        print("|cffff0050[HDT]|r" .. " - |cff40ea1aI JOINED THE WORLD.|r")
        print(isFirstBossDown)
        print(isSecondBossDown)
        print(isThirdBossDown)
        print(isFourthBossDown)

    end
end



--- Simple Eventlogging Function
--- Tracks if the endboss of an instance/dungeon was recently killed
--- Source EncounterID: https://wowpedia.fandom.com/wiki/JournalEncounterID
--- @self idk
--- @event idk
local function OnEvent(self, event)
    if (IsInInstance() and C_EncounterJournal.IsEncounterComplete(697) and not isFourthBossDown) then
        name, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID, link, shouldDisplayDifficulty = EJ_GetInstanceInfo(dungeonList[697])
        nameDifficulty, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(GetDungeonDifficultyID())
        endTime = getCurrentTimeInInstance()

        msg = "Lava Guard Gordoth Down - C_EJ.IEC(696)"
        --msg2 = "Instance cleared in: " .. startingTime-endTime .. "[" .. startingTime .. "]" .. " - " .. "[" .. endTime .. "]"
        msg2 = link .. "[" .. nameDifficulty .. "]" .. " cleared. " .. "[" .. startingTime .. "]" .. " - " .. "[" .. endTime .. "]"
        --SendChatMessage(msg ,"SAY" ,"COMMON" , nil)
        SendChatMessage(msg ,"PARTY" ,"COMMON" , nil);
        SendChatMessage(msg2 ,"PARTY" ,"COMMON" , nil);
        isFourthBossDown = true
    end


    if C_EncounterJournal.IsEncounterComplete(694) and not isFirstBossDown then
        msg = "Adarogg Down - C_EJ.IEC(694)"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil)
        SendChatMessage(msg ,"PARTY" ,"COMMON" , nil);
        isFirstBossDown = true
    elseif C_EncounterJournal.IsEncounterComplete(695) and not isSecondBossDown then
        msg = "Dark Shaman Koranthal Down - C_EJ.IEC(695)"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil)
        SendChatMessage(msg ,"PARTY" ,"COMMON" , nil);
        isSecondBossDown = true
    elseif C_EncounterJournal.IsEncounterComplete(696) and not isThirdBossDown then
        msg = "Slagmaw Down - C_EJ.IEC(696)"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil)
        SendChatMessage(msg ,"PARTY" ,"COMMON" , nil);
        isThirdBossDown = true
    elseif C_EncounterJournal.IsEncounterComplete(697) and not isFourthBossDown then
        msg = "Lava Guard Gordoth Down - C_EJ.IEC(696)"
        SendChatMessage(msg ,"SAY" ,"COMMON" , nil)
        SendChatMessage(msg ,"PARTY" ,"COMMON" , nil);
        isFourthBossDown = true
    end

    --print(CombatLogGetCurrentEventInfo())
end

bossKillFrame:SetScript("OnEvent", OnEvent)

-- Event trigger, executes function when the Event occurs
moneyFrame:SetScript("OnEvent", logMoney)
lootFrame:SetScript("OnEvent", logLoot)
enteringInstanceFrame:SetScript("OnEvent", isPlayerEnteringInstance)
--bossKillFrame:SetScript("OnEvent", trackBossKill)



