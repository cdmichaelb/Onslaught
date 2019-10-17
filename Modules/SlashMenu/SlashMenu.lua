local OS, OSAddon = ...

local addonName = "ONSLAUGHT"

if not OSAddon.SlashMenu then
	OSAddon.SlashMenu = {}
end

local function makeFrame(name, excludeParent)
    local height = InterfaceOptionsFramePanelContainer:GetHeight()-64
    local width = InterfaceOptionsFramePanelContainer:GetWidth()-32

    local frame = CreateFrame("Frame", nil, UIParent)
    frame.anchor = CreateFrame("Frame", nil, frame)
    frame.anchor:SetPoint("TOPLEFT", 32, -16)
    frame.anchor:SetSize(, 1)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetPoint("TOPLEFT", 16, -16)
    frame.title:SetText(format("%s |cff33eeff%s|r", addonName, name))
    if not excludeParent then
        frame.parent = addonName
        frame.name = name
    else
        frame.name = addonName
    end

    local contentFrame = CreateFrame("Frame", nil, frame)
    contentFrame:SetSize(width, height)
    contentFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -48)

    local contentGroup = AceGUI:Create("SimpleGroup")
    contentGroup.frame:SetParent(contentFrame)
    contentGroup.frame:SetPoint("TOPLEFT", contentFrame)
    contentGroup.frame:Show()
    contentGroup:SetHeight(height)
    contentGroup:SetWidth(width)

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
    editBox:SetLabel("Import String")
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
