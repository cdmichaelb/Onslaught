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
    frame.anchor:SetSize(width, 1)
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
    contentGroup:SetLayout("List")

    InterfaceOptions_AddCategory(frame)

    return contentGroup, contentFrame, frame
end

local frameMain = nil
local function makeMainFrame()
    _, _, frameMain = makeFrame("General", true)
end

local function makeLootListImporterFrame()
    local contentGroup = makeFrame("Loot List Importer")

    local howTo = AceGUI:Create("Heading")
    howTo:SetText("HOW TO")
    howTo:SetFullWidth(true)
    contentGroup:AddChild(howTo)

    local function instruct(txt)
        local step = AceGUI:Create("Label")
        step:SetText(txt)
        step:SetFullWidth(true)
        contentGroup:AddChild(step)
    end

    instruct("- Download the master loot list (e.g.: 'MC Loot' tab on spreadsheet)")
    instruct("-- Open the tab, then 'File -> Download -> Tab-separated Values (.tsv, current sheet)'")
    instruct("- Open the downloaded file in Notepad or some text editor (NOT EXCEL!)")
    instruct("- Copy the contents of that file and paste them in to the below box, then press 'Import'")

    local editBox = AceGUI:Create("MultiLineEditBox")
    editBox:SetLabel("")
    editBox:SetNumLines(20)
    editBox:SetFullWidth(true)
    editBox:DisableButton(true)
    contentGroup:AddChild(editBox)

    local statusGroup = AceGUI:Create("SimpleGroup")
    statusGroup:SetLayout("Flow")
    local statusText = AceGUI:Create("Label")
    statusText.frame:Hide()
    local importButton = AceGUI:Create("Button")
    importButton:SetText("Import")
    importButton:SetCallback("OnClick", function()
        importButton:SetDisabled(true)
        statusText:SetText("Importing... please wait")
        statusText.frame:Show()

        local lootText = editBox:GetText("")
        editBox:SetText("")
        local items = OSAddon.lib.parseLootTSV(lootText)
        local importOkay = OSAddon.LootManager.importItems(items)
        if importOkay then
            statusText.SetText("Success!")
        else
            statusText.SetText("An error occurred. Try again or contact an admin")
        end
        importButton:SetDisabled(false)
    end)
    statusGroup:AddChild(importButton)
    statusGroup:AddChild(statusText)
    contentGroup:AddChild(statusGroup)
end

local function setupSlashMenu()
    makeMainFrame()
    makeLootListImporterFrame()
end

function OnslaughtAce:OpenSlashMenuOptions(input)
    InterfaceOptionsFrame_OpenToCategory("Loot List Importer")
    InterfaceOptionsFrame_OpenToCategory("Loot List Importer")
    InterfaceOptionsFrame_OpenToCategory(frameMain)
end

OSAddon.SlashMenu.init = function()
    OnslaughtAce:RegisterChatCommand("onslaught", "OpenSlashMenuOptions")
    setupSlashMenu()
end
