local OS, OSAddon = ...

local frame = CreateFrame("FRAME", "OSAddonMainFrame", UIParent)

local function handleAddonMessage(self, event, prefix, text)
    if not (prefix == OSAddon.lib.ADDON_MSG_PREFIX) then
        return
    end
    local command, body = OSAddon.lib.separate(text, 2)
    if command == OSAddon.LootAlerts.ADDON_MSG_PREFIX then
        OSAddon.LootAlerts.handleAddonMessage(command, body)
        return
    end
end

local function init()
    C_ChatInfo.RegisterAddonMessagePrefix(OSAddon.lib.ADDON_MSG_PREFIX)
    frame:RegisterEvent("CHAT_MSG_ADDON")
    frame:SetScript("OnEvent", handleAddonMessage)

	if not OnslaughtAddonGlobalDB then
		OnslaughtAddonGlobalDB = {}
    end
    if not OnslaughtAddonCharDB then
		OnslaughtAddonCharDB = {}
    end

    OSAddon.LootManager.init()
    OSAddon.LootAlerts.init()
    OSAddon.SlashMenu.init()
end

function OnslaughtAce:OnInitialize()
    init()
end

function OnslaughtAce:OnEnable()
    -- do nothing
end

function OnslaughtAce:OnDisable()
    -- do nothing
end
