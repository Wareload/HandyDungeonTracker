-- Classic, TBC, WOTLK, CATA, MOP, WOD, LEGION, BFA, SL Dungeons: DungeonIDs, Dungeon Listing, Tables/Arrays for simple accessability
    -- Track 1st, 2nd, 3rd etc. Bosses too? Any Functionality?
-- Timer Difference: Started 20:00 Ended 20:05 => 5 mins and X secs cleared
-- Hovering over the Instance-Portal on a Map, you can get all relevant Data



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

--- Endboss of a Dungeon ID / Dungeon ID
--- Source: https://wowpedia.fandom.com/wiki/JournalEncounterID
--- Source: https://wow.tools/dbc/?dbc=journalencounter&build=9.2.5.43412#page=1
local dungeonList = {
    -- Classic Dungeons
    [444] = 227, -- Aku'mai, Blackfathom Deeps
    [92] = 63, -- Admiral Ripsnarl, Deadmines
    [422] = 231, -- Mekgineer Thermaplugg, Gnomeregan
    [396] = 229, -- Overlord Wyrmthalak, Lower Blackrock Spire
    [431] = 232, -- Princess Theradras, Maraudon
    [697] = 226, -- Lava Guard Gordoth, Ragefire Chasm
    [1141] = 233, -- Amnennar the Coldbringer, Razorfen Downs
    [959] = 457, -- Charlga Razorflank, Razorfen Kraul
    [656] = 311, -- Flameweaver Koegler, Scarlet Halls
    [674] = 316, -- High Inquisitor Whitemane, Scarlet Monastery
    [684] = 246, -- Darkmaster Gandling, Scholomance
    [100] = 64, -- Lord Godfrey, Shadowfang Keep
    [456] = 236, -- Lord Aurius Rivendare, Stratholme
    [464] = 238, -- Hogger, The Stockade
    [463] = 237, -- Shade of Eranikus, The Temple of Atal'Hakkar
    [473] = 239, -- Archaedas, Uldaman
    [481] = 240, -- Mutanus the Devourer, Wailing Caverns
    [489] = 241, -- Chief Ukorz Sandscalp, Zul'Farrak
    -- TBC Dungeons
    [524] = 247, -- Exarch Maladaar, Auchenai Crypts
    [529] = 248, -- Vazruden the Herald, Hellfire Ramparts
    [533] = 249, -- Kael'thas Sunstrider, Magisters' Terrace
    [537] = 250, -- Nexus-Prince Shaffar, Mana-Tombs
    [540] = 251, -- Epoch Hunter, Old Hillsbrad Foothills
    [543] = 252, -- Talon King Ikiss, Sethekk Halls
    [547] = 253, -- Murmur, Shadow Labyrinth
    [551] = 254, -- Harbinger Skyriss, The Arcatraz
    [554] = 255, -- Aeonus, The Black Morass
    [557] = 256, -- Keli'dan the Breaker, The Blood Furnace
    [562] = 257, -- Warp Splinter, The Botanica
    [565] = 258, -- Pathaleon the Calculator, The Mechanar
    [569] = 259, -- Warchief Kargath Bladefist, The Shattered Halls
    [572] = 260, -- Quagmirran, The Slave Pens
    [575] = 261, -- Warlord Kalithresh, The Steamvault
    [579] = 262, -- The Black Stalker, The Underbog
    -- WOTLK Dungeons
    [584] = 271, -- Herald Volazj, Ahn'kahet: The Old Kingdom
    [587] = 272, -- Anub'arak, Azjol-Nerub
    [591] = 273, -- The Prophet Tharon'ja, Drak'Tharon Keep
    [596] = 274, -- Gal'darah, Gundrak
    [600] = 275, -- Loken, Halls of Lightning
    [603] = 276, -- Escape from Arthas, Halls of Reflection
    [607] = 277, -- Sjonnir the Ironshaper, Halls of Stone
    [610] = 278, -- Scourgelord Tyrannus, Pit of Saron
    [614] = 279, -- Mal'Ganis, The Culling of Stratholme
    [616] = 280, -- Devourer of Souls, The Forge of Souls
    [621] = 281, -- Keristrasza, The Nexus
    [625] = 282, -- Ley-Guardian Eregos, The Oculus
    [632] = 283, -- Cyanigosa, The Violet Hold
    [637] = 284, -- The Black Knight, Trial of the Champion
    [640] = 285, -- Ingvar the Plunderer, Utgarde Keep
    [644] = 286, -- King Ymiron, Utgarde Pinnacle
    -- CATA Dungeons
    [109] = 66, -- Ascendant Lord Obsidius, Blackrock Caverns
    [289] = 184, -- Murozond, End Time


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
        --print(isFirstBossDown)
        --print(isSecondBossDown)
        --print(isThirdBossDown)
        --print(isFourthBossDown)

    end
end



--- Simple Eventlogging Function
--- Tracks if the endboss of an instance/dungeon was recently killed
--- Source EncounterID: https://wowpedia.fandom.com/wiki/JournalEncounterID
--- @self idk
--- @event idk
local function OnEvent(self, event)
    if IsInInstance() then
        for key, value in pairs(dungeonList) do
            if C_EncounterJournal.IsEncounterComplete(key) and not isFourthBossDown then
                -- Get the Name/Link of the Dungeon
                name, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID, link, shouldDisplayDifficulty = EJ_GetInstanceInfo(dungeonList[key])
                -- Get the Difficulty of the Dungeon
                nameDifficulty, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(GetDungeonDifficultyID())
                -- Get the Finishing Time
                endTime = getCurrentTimeInInstance()

                --msg2 = "Instance cleared in: " .. startingTime-endTime .. "[" .. startingTime .. "]" .. " - " .. "[" .. endTime .. "]"
                msg2 = link .. "[" .. nameDifficulty .. "]" .. " cleared. " .. "[" .. startingTime .. "]" .. " - " .. "[" .. endTime .. "]"
                SendChatMessage(msg2 ,"PARTY" ,"COMMON" , nil);
                isFourthBossDown = true
            end
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
end

bossKillFrame:SetScript("OnEvent", OnEvent)

-- Event trigger, executes function when the Event occurs
moneyFrame:SetScript("OnEvent", logMoney)
lootFrame:SetScript("OnEvent", logLoot)
enteringInstanceFrame:SetScript("OnEvent", isPlayerEnteringInstance)
--bossKillFrame:SetScript("OnEvent", trackBossKill)



