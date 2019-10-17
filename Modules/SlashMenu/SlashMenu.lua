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

    local contentGroup = AceGUI:Create("SimpleGroup")
    contentGroup.frame.SetParent(contentFrame)
    contentGroup.frame.SetPoint("TOPLEFT", contentFrame)
    contentGroup.frame:Show()
    contentGroup:SetFullHeight(true)
    contentGroup:SetFullWidth(true)

    local instanceTrackerFrameBackground = contentGroup.frame:CreateTexture()
    instanceTrackerFrameBackground:SetAllPoints(contentGroup.frame)
    instanceTrackerFrameBackground:SetColorTexture(1, 0, 0)
    contentGroup.frame.texture = instanceTrackerFrameBackground

    InterfaceOptions_AddCategory(frame)

    return contentGroup, contentFrame, frame
end

local frameMain = nil
local function makeMainFrame()
    _, _, frameMain = makeFrame("General", true)
end

local function makeLootListImporterFrame()
    local contentGroup = makeFrame("Loot List Importer")
    local editBox = AceGUI:Create("MultiLineEditBox")
    editBox.SetLabel("Import String")
    editBox:SetNumLines(20)
    editBox:SetFullWidth(true)
    contentGroup:AddChild(editBox)
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
