local OS, OSAddon = ...

local addonName = "ONSLAUGHT"

if not OSAddon.SlashMenu then
	OSAddon.SlashMenu = {}
end

local function makeFrame(name, excludeParent)
    local frame = CreateFrame("Frame", nil, UIParent)
    frame.anchor = CreateFrame("Frame", nil, frame)
    frame.anchor:SetPoint("TOPLEFT", 32, -16)
    frame.anchor:SetSize(InterfaceOptionsFramePanelContainer:GetWidth()-32, 1)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    frame.title:SetText(format("%s |cff33eeff%s|r", addonName, name))
    if not excludeParent then
        frame.parent = addonName
    end
    frame.name = name

    local contentFrame = CreateFrame("Frame", nil, frame)
    contentFrame:SetSize(InterfaceOptionsFramePanelContainer:GetWidth()-32, InterfaceOptionsFramePanelContainer:GetWidth()-64)
    contentFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -48)
    local instanceTrackerFrameBackground = contentFrame:CreateTexture()
    instanceTrackerFrameBackground:SetAllPoints(contentFrame)
    instanceTrackerFrameBackground:SetColorTexture(1, 0, 0)
    contentFrame.texture = instanceTrackerFrameBackground

    InterfaceOptions_AddCategory(frame)

    return contentFrame, frame
end

local frameMain = nil
local function makeMainFrame()
    _, frameMain = makeFrame("General", true)
end

local function makeLootListImporterFrame()
    local contentFrame = makeFrame("Loot List Importer")
    local editBox = AceGUI:Create("MultiLineEditBox")
    editBox.frame.parent = contentFrame
    editBox:SetNumLines(20)
    editBox:Show()
end

local function setupSlashMenu()
    makeMainFrame()
    makeLootListImporterFrame()
end

function OnslaughtAce:OpenSlashMenuOptions(input)
    InterfaceOptionsFrame_OpenToCategory(frameMain)
    InterfaceOptionsFrame_OpenToCategory(frameMain)
    InterfaceOptionsFrame_OpenToCategory(frameMain)
end

OSAddon.SlashMenu.init = function()
    OnslaughtAce:RegisterChatCommand("onslaught", "OpenSlashMenuOptions")
    setupSlashMenu()
end
