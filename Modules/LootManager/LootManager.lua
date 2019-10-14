local OS, OSAddon = ...

if not OSAddon.LootManager then
	OSAddon.LootManager = {}
end

local frame = CreateFrame("FRAME", "OSAddonLootManagerFrame", UIParent)

local lootWindow = AceGUI:Create("Window")
lootWindow:SetLayout("List")
lootWindow:SetTitle("ONSLAUGHT LOOT")
lootWindow:SetCallback("OnClose", function() lootWindow:Hide() end)
lootWindow:EnableResize(false)
lootWindow:SetWidth(620)
lootWindow:Hide()

local function drawLootGroup(item, quality, texture, quantity, namesInRoster)
    local lootGroup = AceGUI:Create("SimpleGroup")
    lootGroup:SetLayout("Flow")
    lootGroup:SetFullWidth(true)
    lootGroup:SetHeight(40)

    local itemLabel = AceGUI:Create("Label")
    itemLabel:SetText("[" .. item .. "]")
    itemLabel:SetImage(texture)
    itemLabel:SetImageSize(32, 32)
    itemLabel:SetRelativeWidth(0.4)
    if quality == 0 then
        itemLabel:SetColor(0.62, 0.62, 0.62)
    elseif quality == 1 then
        itemLabel:SetColor(1.00, 1.00, 1.00)
    elseif quality == 2 then
        itemLabel:SetColor(0.12, 1.00, 0.00)
    elseif quality == 3 then
        itemLabel:SetColor(0.00, 0.44, 0.87)
    elseif quality == 4 then
        itemLabel:SetColor(0.64, 0.21, 0.93)
    elseif quality == 5 then
        itemLabel:SetColor(1.00, 0.50, 0.00)
    end
    lootGroup:AddChild(itemLabel)

    if #namesInRoster == 0 then
        local noFound = AceGUI:Create("Label")
        noFound:SetText("No eligibile players found!")
        noFound:SetRelativeWidth(0.6)
        lootGroup:AddChild(noFound)
    end

    if #namesInRoster > 0 then
        for i = 1, 4 do
            local player = namesInRoster[i]
            if player then
                local nameLabel = AceGUI:Create("Label")
                nameLabel:SetText(player.name .. " (" .. player.score .. ")")
                nameLabel:SetRelativeWidth(0.15)
                lootGroup:AddChild(nameLabel)
            end
        end
    end

    lootWindow:AddChild(lootGroup)
end

local function handleLootOpened(lootData, distribution, roster)
    lootWindow:ReleaseChildren()
    local count = 0
    table.foreach(lootData, function(k,v)
        if distribution[v.item] then
            count = count + 1
            local namesInRoster = {}
            for i = 1, #distribution[v.item] do
                local player = #distribution[v.item]
                if roster[player.name] then
                    table.insert(namesInRoster, player)
                end
            end
            drawLootGroup(v.item, v.quality, v.texture, v.quantity, namesInRoster)
        end
    end)
    if count == 0 then
        return
    end
    lootWindow:SetHeight(40 + (54 * count))
    lootWindow:Show()
    lootWindow:DoLayout()
end

-- SETUP 
local function startLootManager()
    frame:RegisterEvent("LOOT_OPENED")
    frame:SetScript("OnEvent", function(self, event)
        if event == "LOOT_OPENED" then
            local roster = OSAddon.lib.getRosterInfo()
            if not roster[UnitName("player")].isMasterLooter then return end
            local lootData = GetLootInfo()
            if #lootData == 0 then return end
            handleLootOpened(lootData, OnslaughtAddonGlobalDB.LootManager.distribution, roster)
            return
        end
    end)
end

OSAddon.LootManager.init = function()
    if not OnslaughtAddonGlobalDB.LootManager then
        OnslaughtAddonGlobalDB.LootManager = {}
    end
    if not OnslaughtAddonGlobalDB.LootManager.distribution then
        OnslaughtAddonGlobalDB.LootManager.distribution = {}
    end
    startLootManager()
    -- testing
    local testLootData = {
        { item = "Test Item", quality = 4, texture = "", quantity = 1 }
    }
    local testDistribution = {
        "Test Item" = { name = "Dw", score = 40 }
    }
    local testRoster = {
        "Dw" = { name = "Dw", isMasterLooter = true }
    }
    handleLootOpened(testLootData, testDistribution, testRoster)
end
