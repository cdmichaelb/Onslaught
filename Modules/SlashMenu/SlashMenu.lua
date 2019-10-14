local OS, OSAddon = ...

if not OSAddon.SlashMenu then
	OSAddon.SlashMenu = {}
end

local function makeBody()
    local history = OSAddon.LootAlerts.getHistory()
    local body = ""
    local s = function(v) return "\"" .. v .. "\"" end
    for i = 1, #history do
        local values = history[i]
        body = body .. strjoin(",", s(values.time), s(values.player), s(values.item)) .. "\n"
    end
    return body
end

local function showMenu()
    local menu = AceGUI:Create("Window")
    menu:SetLayout("List")
    menu:SetTitle("ONSLAUGHT")
    menu:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local editbox = AceGUI:Create("MultiLineEditBox")
    editbox:SetNumLines(25)
    editbox:SetText(makeBody())
    editbox:SetFullWidth(true)
    editbox:SetFullHeight(true)
    editbox:DisableButton(true)
    menu:AddChild(editbox)

    local buttonGroup = AceGUI:Create("SimpleGroup")
    buttonGroup:SetLayout("Flow")
    local selectAllButton = AceGUI:Create("Button")
    selectAllButton:SetText("Select All (Ctrl-C)")
    selectAllButton:SetCallback("OnClick", function()
        editbox:HighlightText()
        editbox:SetFocus()
    end)
    buttonGroup:AddChild(selectAllButton)
    local clearButton = AceGUI:Create("Button")
    clearButton:SetText("Clear Data")
    clearButton:SetCallback("OnClick", function()
        editbox:SetText("")
        OSAddon.LootAlerts.resetHistory()
    end)
    buttonGroup:AddChild(clearButton)
    menu:AddChild(buttonGroup)
end

OSAddon.SlashMenu.init = function()
    OnslaughtAce:RegisterChatCommand("onslaught", OSAddon.SlashMenu.showMenu)
end
