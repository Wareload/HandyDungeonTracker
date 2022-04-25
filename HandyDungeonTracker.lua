SLASH_RL1 = "/RL"
SlashCmdList["RL"] = function(msg)
    ReloadUI();
end

-- Define Frame
local f = CreateFrame("Frame")
-- Register Event when in Chat Money was looted
f:RegisterEvent("CHAT_MSG_Money")

local function logMoney()
    -- Simply for Test purpose, prints out if you looted any amount of money
    print("|cffff0050[HDT]|r" .. " - |cff40ea1aSomeone looted Money.|r")
end

-- Event trigger, executes function when the Event occurs
f:SetScript("OnEvent", logMoney)
