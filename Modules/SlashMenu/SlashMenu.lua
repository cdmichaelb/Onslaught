local OS, OSAddon = ...

local addonName = "ONSLAUGHT"

if not OSAddon.SlashMenu then
	OSAddon.SlashMenu = {}
end

local function makeFrame(name, excludeParent)
    local frame = CreateFrame("Frame", nil, UIParent)
    frame.anchor = CreateFrame("Frame", nil, frameLootListImport)
    frame.anchor:SetPoint("TOPLEFT", 32, -16)
    frame.anchor:SetSize(InterfaceOptionsFramePanelContainer:GetWidth()-64, 1)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    frame.title:SetText(format("%s |cff33eeff%s|r", addonName, name))
    if not excludeParent then
        frame.parent = addonName
    end
    frame.name = name

    local contentFrame = AceGUI:Create("SimpleGroup")
    contentFrame:SetFullHeight(true)
    contentFrame:SetFullWidth(true)
    contentFrame:SetPoint("TOPLEFT", frame, 0, -32)
    local instanceTrackerFrameBackground = contentFrame.frame:CreateTexture()
    instanceTrackerFrameBackground:SetAllPoints(contentFrame.frame)
    instanceTrackerFrameBackground:SetColorTexture(1, 0, 0)
    contentFrame.frame.texture = instanceTrackerFrameBackground
    return frame
end

local frameMain = makeFrame(addonName, true)

local frameLootListImporter = makeFrame("Loot List Importer")

local function setupSlashMenu()
    InterfaceOptions_AddCategory(frameMain)
    InterfaceOptions_AddCategory(frameLootListImporter)
end

function OnslaughtAce:OpenSlashMenuOptions(input)
    InterfaceOptionsFrame_OpenToCategory(frameLootListImporter)
    InterfaceOptionsFrame_OpenToCategory(frameLootListImporter)
    InterfaceOptionsFrame_OpenToCategory(frameMain)
end

OSAddon.SlashMenu.init = function()
    OnslaughtAce:RegisterChatCommand("onslaught", "OpenSlashMenuOptions")
    setupSlashMenu()
end
