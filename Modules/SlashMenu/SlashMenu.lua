local OS, OSAddon = ...

local addonName = "ONSLAUGHT"

if not OSAddon.SlashMenu then
	OSAddon.SlashMenu = {}
end

local frameMain = CreateFrame("Frame", nil, UIParent)
frameMain.anchor = CreateFrame("Frame", nil, frameMain)
frameMain.anchor:SetPoint("TOPLEFT", 32, -16)
frameMain.anchor:SetSize(InterfaceOptionsFramePanelContainer:GetWidth()-64, 1)
frameMain.title = frameMain:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frameMain.title:SetPoint("TOPLEFT", 18, -16)
frameMain.title:SetText(format("%s |cff33eeff%s|r", addonName, "General"))
frameMain.name = addonName

local frameLoot = CreateFrame("Frame", nil, UIParent)
frameLoot.anchor = CreateFrame("Frame", nil, frameLoot)
frameLoot.anchor:SetPoint("TOPLEFT", 32, -13)
frameLoot.anchor:SetSize(InterfaceOptionsFramePanelContainer:GetWidth()-64, 1)
frameLoot.title = frameLoot:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frameLoot.title:SetPoint("TOPLEFT", 18, -16)
frameLoot.title:SetText(format("%s |cff33eeff%s|r", addonName, "Loot"))
frameLoot.parent = addonName
frameLoot.name = "Loot"

local function setupSlashMenu()
    InterfaceOptions_AddCategory(frame)
    InterfaceOptions_AddCategory(frameLoot)
end

OnslaughtAce:OpenSlashMenuOptions = function()
    InterfaceOptionsFrame_OpenToCategory(frame)
end

OSAddon.SlashMenu.init = function()
    OnslaughtAce:RegisterChatCommand("onslaught", "OpenSlashMenuOptions")
    setupSlashMenu()
end
