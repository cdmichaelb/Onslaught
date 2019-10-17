local OS, OSAddon = ...

if not OSAddon.LootAlerts then
	OSAddon.LootAlerts = {}
end

local ADDON_MSG_PREFIX = "LOOT_ALERT"

local frame = CreateFrame("FRAME", "OSAddonLootAlertsFrame", UIParent)

local function inRaid()
    local inInstance, instanceType = IsInInstance()
    return instanceType == "raid"
end

local function handleLootReceivedEvent(playerName, text)
    if not (UnitName("player") == playerName) then return end
    if not inRaid() then return end

    local itemLink = string.match(text, "|%x+|Hitem:.-|h.-|h|r")
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local itemName = GetItemInfo(itemString)

    OSAddon.lib.sendAddonMessage(ADDON_MSG_PREFIX, playerName, itemName)
end

local function handleLootAlert(body)
    if not OnslaughtAddonGlobalDB.LootAlerts.config.logLoot then return end

    local player, item = OSAddon.lib.separate(body, 2)
    table.insert(OnslaughtAddonGlobalDB.LootAlerts.history, {
        player = player,
        item = item,
        time = GetServerTime()
    })
end

local function handleRaidZoneInEvent()
    if not inRaid() then return end
    if not OnslaughtAddonGlobalDB.LootAlerts.config.logLoot then return end

    local window = AceGUI:Create("Window")
    window:SetTitle("ONSLAUGHT LOOT")
    window:EnableResize(false)
    window:SetLaytout("List")

    local heading = AceGUI:Create("Heading")
    heading:SetText("Would you like to reset the loot history?")
    window:AddChild(heading)

    local buttonGroup = AceGUI:Create("SimpleGroup")
    buttonGroup:SetLayout("Flow")
    local dontResetButton = AceGUI:Create("Button")
    dontResetButton:SetText("No")
    dontResetButton:SetCallback("OnClick", function()
        AceGUI:Release(window)
    end)
    local resetButton = AceGUI:Create("Button")
    resetButton:SetText("Reset!")
    resetButton:SetCallback("OnClick", function()
        OnslaughtAddonGlobalDB.LootAlerts.history = {}
        AceGUI:Release(window)
    end)
    buttonGroup:AddChild(dontResetButton)
    buttonGroup:AddChild(resetButton)
    window:AddChild(buttonGroup)
end

-- SETUP 
local function startLootAlerts()
    frame:RegisterEvent("CHAT_MSG_LOOT")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "CHAT_MSG_LOOT" then
            local text, _, _, _, playerName = ...
            handleLootReceivedEvent(playerName, text)
            return
        end
        if event == "PLAYER_ENTERING_WORLD" then
            handleRaidZoneInEvent()
            return
        end
    end)
end

OSAddon.LootAlerts.init = function()
    if not OnslaughtAddonGlobalDB.LootAlerts then
        OnslaughtAddonGlobalDB.LootAlerts = {}
    end
    if not OnslaughtAddonGlobalDB.LootAlerts.config then
        OnslaughtAddonGlobalDB.LootAlerts.config = { logLoot = false }
    end
    if not OnslaughtAddonGlobalDB.LootAlerts.history then
        OnslaughtAddonGlobalDB.LootAlerts.history = {}
    end
    startLootAlerts()
end
OSAddon.LootAlerts.handleAddonMessage = function(command, body)
    handleLootAlert(body)
end
OSAddon.LootAlerts.ADDON_MSG_PREFIX = ADDON_MSG_PREFIX
OSAddon.LootAlerts.getHistory = function()
    return OnslaughtAddonGlobalDB.LootAlerts.history
end
OSAddon.LootAlerts.resetHistory = function()
    OnslaughtAddonGlobalDB.LootAlerts.history = {}
end
