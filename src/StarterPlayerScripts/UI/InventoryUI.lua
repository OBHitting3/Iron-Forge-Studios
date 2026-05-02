--[[
    InventoryUI.lua (Client)
    Icon inventory + Collection Book + Vault management.
    Tabs: Icons | Collection | Vault
    Actions: Display, Vault, Unvault, Evolve
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Shared.Constants)
local Util = require(ReplicatedStorage.Modules.Shared.Util)
local IconDatabase = require(ReplicatedStorage.Modules.Data.IconDatabase)
local Remotes = require(ReplicatedStorage.Modules.Shared.Remotes)
local UIHelpers = require(script.Parent.UIHelpers)

local InventoryUI = {}

local panel = nil
local currentTab = "Icons"
local contentFrame = nil
local tabButtons = {}

-- ═══════════════════════════════════════════════════════════════
-- BUILD
-- ═══════════════════════════════════════════════════════════════

local function buildIconCard(parent, iconInstance, iconDef)
    local card = UIHelpers.Frame("Icon_" .. iconInstance.UID, UDim2.new(0, 100, 0, 130), nil, parent,
        UIHelpers.Theme.BgLight)
    UIHelpers.Corner(card, 8)
    local rarityColor = UIHelpers.RarityColor(iconDef.Rarity)
    UIHelpers.Stroke(card, rarityColor, 2)

    -- Icon visual
    local gfx = Instance.new("Frame")
    gfx.Name = "Gfx"
    gfx.Size = UDim2.new(0, 60, 0, 60)
    gfx.Position = UDim2.new(0.5, -30, 0, 8)
    gfx.BackgroundColor3 = rarityColor
    gfx.BorderSizePixel = 0
    gfx.Parent = card
    local gfxCorner = Instance.new("UICorner")
    gfxCorner.CornerRadius = UDim.new(0.5, 0)
    gfxCorner.Parent = gfx

    -- Name
    local name = UIHelpers.Label("Name", iconDef.Name, UDim2.new(1, -8, 0, 20),
        UDim2.new(0, 4, 0, 72), card, { Color = UIHelpers.Theme.TextPrimary, Scaled = false })
    name.TextSize = 11
    name.TextWrapped = true

    -- Evolution badge
    if iconInstance.Evolution and iconInstance.Evolution ~= "Base" then
        local evoBadge = UIHelpers.Label("Evo", iconInstance.Evolution,
            UDim2.new(1, -8, 0, 14), UDim2.new(0, 4, 0, 92), card, {
            Color = Color3.fromRGB(255, 215, 0), Scaled = false, Font = Enum.Font.GothamBold,
        })
        evoBadge.TextSize = 10
    end

    -- Status indicators
    local statusText = ""
    if iconInstance.Displayed then statusText = statusText .. "🏛 " end
    if iconInstance.VaultSlot then statusText = statusText .. "🔒 " end
    if statusText ~= "" then
        local statusLabel = UIHelpers.Label("Status", statusText, UDim2.new(1, -8, 0, 14),
            UDim2.new(0, 4, 0, 108), card, { Scaled = false })
        statusLabel.TextSize = 10
    end

    -- Click to open detail
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = card
    clickBtn.MouseButton1Click:Connect(function()
        InventoryUI._showDetail(iconInstance, iconDef)
    end)

    return card
end

local function refreshIconsTab()
    if not contentFrame then return end

    -- Clear
    for _, child in contentFrame:GetChildren() do
        if child:IsA("Frame") then child:Destroy() end
    end

    local DataController = require(script.Parent.Parent.Controllers.DataController)
    local data = DataController.GetData()
    if not data then return end

    UIHelpers.GridLayout(contentFrame, UDim2.new(0, 100, 0, 130), 8)
    UIHelpers.Padding(contentFrame, 8)

    for _, iconInstance in data.Icons do
        local iconDef = IconDatabase.GetById(iconInstance.IconId)
        if iconDef then
            buildIconCard(contentFrame, iconInstance, iconDef)
        end
    end

    if #data.Icons == 0 then
        local empty = UIHelpers.Label("Empty",
            "No icons yet! Hatch an egg at Agua Caliente Hot Springs to get started.",
            UDim2.new(1, -32, 0, 60), UDim2.new(0, 16, 0, 20), contentFrame, {
            Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
        })
        empty.TextSize = 14
        empty.TextWrapped = true
    end
end

local function refreshCollectionTab()
    if not contentFrame then return end

    for _, child in contentFrame:GetChildren() do
        if child:IsA("Frame") then child:Destroy() end
    end

    local DataController = require(script.Parent.Parent.Controllers.DataController)
    local data = DataController.GetData()
    if not data then return end

    UIHelpers.GridLayout(contentFrame, UDim2.new(0, 100, 0, 130), 8)
    UIHelpers.Padding(contentFrame, 8)

    -- Show all icons in DB, mark discovered ones
    local total = IconDatabase.GetCount()
    local discovered = 0
    for _ in data.CollectionBook do discovered += 1 end

    -- Title
    local title = UIHelpers.Label("Title",
        string.format("Collection: %d / %d", discovered, total),
        UDim2.new(1, -16, 0, 30), UDim2.new(0, 8, 0, 0), contentFrame, {
        Color = UIHelpers.Theme.Accent,
    })
    title.LayoutOrder = -1

    for _, iconDef in IconDatabase.GetAll() do
        local isDiscovered = data.CollectionBook[iconDef.Id] == true
        local card = UIHelpers.Frame("Coll_" .. iconDef.Id, UDim2.new(0, 100, 0, 130), nil, contentFrame,
            UIHelpers.Theme.BgLight)
        UIHelpers.Corner(card, 8)

        local rarityColor = UIHelpers.RarityColor(iconDef.Rarity)
        UIHelpers.Stroke(card, isDiscovered and rarityColor or Color3.fromRGB(50, 50, 50), 2)

        local gfx = Instance.new("Frame")
        gfx.Size = UDim2.new(0, 60, 0, 60)
        gfx.Position = UDim2.new(0.5, -30, 0, 8)
        gfx.BackgroundColor3 = isDiscovered and rarityColor or Color3.fromRGB(40, 40, 40)
        gfx.BorderSizePixel = 0
        gfx.Parent = card
        local gfxCorner = Instance.new("UICorner")
        gfxCorner.CornerRadius = UDim.new(0.5, 0)
        gfxCorner.Parent = gfx

        local name = UIHelpers.Label("Name",
            isDiscovered and iconDef.Name or "???",
            UDim2.new(1, -8, 0, 20), UDim2.new(0, 4, 0, 72), card, {
            Color = isDiscovered and UIHelpers.Theme.TextPrimary or Color3.fromRGB(100, 100, 100),
            Scaled = false,
        })
        name.TextSize = 11
        name.TextWrapped = true

        local rarityText = UIHelpers.Label("Rarity", iconDef.Rarity,
            UDim2.new(1, -8, 0, 14), UDim2.new(0, 4, 0, 100), card, {
            Color = isDiscovered and rarityColor or Color3.fromRGB(80, 80, 80),
            Scaled = false, Font = Enum.Font.GothamBold,
        })
        rarityText.TextSize = 10
    end
end

local function refreshVaultTab()
    if not contentFrame then return end

    for _, child in contentFrame:GetChildren() do
        if child:IsA("Frame") then child:Destroy() end
    end

    local DataController = require(script.Parent.Parent.Controllers.DataController)
    local data = DataController.GetData()
    if not data then return end

    -- Header
    local headerFrame = UIHelpers.Frame("VaultHeader", UDim2.new(1, -16, 0, 50),
        UDim2.new(0, 8, 0, 8), contentFrame, UIHelpers.Theme.BgLight)
    UIHelpers.Corner(headerFrame, 6)
    headerFrame.LayoutOrder = -1

    local vaultUsed = 0
    for _, ic in data.Icons do
        if ic.VaultSlot then vaultUsed += 1 end
    end

    UIHelpers.Label("Title", string.format("🔒 Vault: %d / %d", vaultUsed, data.VaultSlots),
        UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 8, 0, 0), headerFrame, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.Button("BuySlots", "Buy +5 Slots", UDim2.new(0, 130, 0, 36),
        UDim2.new(1, -138, 0.5, -18), headerFrame, function()
            local MarketplaceService = game:GetService("MarketplaceService")
            local productId = Constants.DevProducts.VaultExpand.ProductId
            if productId > 0 then
                MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId)
            end
        end)

    -- Icons grid
    local gridFrame = UIHelpers.Frame("Grid", UDim2.new(1, -16, 1, -70),
        UDim2.new(0, 8, 0, 64), contentFrame, UIHelpers.Theme.BgMedium)
    UIHelpers.Corner(gridFrame, 6)
    UIHelpers.Padding(gridFrame, 6)
    UIHelpers.GridLayout(gridFrame, UDim2.new(0, 100, 0, 130), 6)

    for _, iconInstance in data.Icons do
        if iconInstance.VaultSlot then
            local iconDef = IconDatabase.GetById(iconInstance.IconId)
            if iconDef then
                buildIconCard(gridFrame, iconInstance, iconDef)
            end
        end
    end
end

local function refreshContent()
    if currentTab == "Icons" then
        refreshIconsTab()
    elseif currentTab == "Collection" then
        refreshCollectionTab()
    elseif currentTab == "Vault" then
        refreshVaultTab()
    end
end

local function switchTab(tabName)
    currentTab = tabName
    for name, btn in tabButtons do
        if name == tabName then
            btn.BackgroundColor3 = UIHelpers.Theme.Accent
            btn.TextColor3 = UIHelpers.Theme.BgDark
        else
            btn.BackgroundColor3 = UIHelpers.Theme.BgLight
            btn.TextColor3 = UIHelpers.Theme.AccentSoft
        end
    end
    refreshContent()
end

local function buildPanel(parent)
    panel = UIHelpers.Frame("InventoryPanel", UDim2.new(0, 760, 0, 540), nil, parent, UIHelpers.Theme.BgDark)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Visible = false
    UIHelpers.Corner(panel, 14)
    UIHelpers.Stroke(panel, UIHelpers.Theme.Border, 2)

    UIHelpers.Label("Title", "My Collection", UDim2.new(1, -100, 0, 50),
        UDim2.new(0, 16, 0, 8), panel, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.MakeCloseButton(panel, function() InventoryUI.Close() end)

    -- Tabs
    local tabsFrame = UIHelpers.Frame("Tabs", UDim2.new(1, -32, 0, 38),
        UDim2.new(0, 16, 0, 60), panel, UIHelpers.Theme.BgMedium)
    UIHelpers.Corner(tabsFrame, 6)
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabsFrame
    UIHelpers.Padding(tabsFrame, 4)

    local tabs = { "Icons", "Collection", "Vault" }
    for i, tabName in tabs do
        local btn = UIHelpers.Button(tabName, tabName, UDim2.new(0, 140, 1, -8),
            nil, tabsFrame, function() switchTab(tabName) end)
        btn.LayoutOrder = i
        tabButtons[tabName] = btn
    end

    -- Content scroll
    contentFrame = UIHelpers.ScrollFrame("Content", UDim2.new(1, -32, 1, -120),
        UDim2.new(0, 16, 0, 110), panel)

    switchTab("Icons")
end

-- ═══════════════════════════════════════════════════════════════
-- DETAIL OVERLAY
-- ═══════════════════════════════════════════════════════════════

local detailOverlay = nil

function InventoryUI._showDetail(iconInstance, iconDef)
    if detailOverlay then detailOverlay:Destroy() end

    detailOverlay = UIHelpers.Frame("Detail", UDim2.new(0, 360, 0, 420),
        UDim2.new(0.5, 0, 0.5, 0), panel.Parent, UIHelpers.Theme.BgDark)
    detailOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
    detailOverlay.ZIndex = 20
    UIHelpers.Corner(detailOverlay, 12)
    local rarityColor = UIHelpers.RarityColor(iconDef.Rarity)
    UIHelpers.Stroke(detailOverlay, rarityColor, 3)

    UIHelpers.MakeCloseButton(detailOverlay, function()
        if detailOverlay then detailOverlay:Destroy() detailOverlay = nil end
    end).ZIndex = 21

    local gfx = Instance.new("Frame")
    gfx.Size = UDim2.new(0, 140, 0, 140)
    gfx.Position = UDim2.new(0.5, -70, 0, 30)
    gfx.BackgroundColor3 = rarityColor
    gfx.Parent = detailOverlay
    gfx.ZIndex = 21
    local gfxCorner = Instance.new("UICorner")
    gfxCorner.CornerRadius = UDim.new(0.5, 0)
    gfxCorner.Parent = gfx

    UIHelpers.Label("Name", iconDef.Name, UDim2.new(1, -16, 0, 30),
        UDim2.new(0, 8, 0, 180), detailOverlay, { Color = UIHelpers.Theme.TextPrimary }).ZIndex = 21

    UIHelpers.Label("Rarity", iconDef.Rarity:upper(), UDim2.new(1, -16, 0, 22),
        UDim2.new(0, 8, 0, 212), detailOverlay, {
        Color = rarityColor, Scaled = false, Font = Enum.Font.GothamBold,
    }).ZIndex = 21

    local desc = UIHelpers.Label("Desc", iconDef.Description or "",
        UDim2.new(1, -32, 0, 50), UDim2.new(0, 16, 0, 240), detailOverlay, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
    })
    desc.TextSize = 13
    desc.TextWrapped = true
    desc.ZIndex = 21

    -- Action buttons
    local btnY = 304
    local function addBtn(text, callback)
        local b = UIHelpers.Button(text, text, UDim2.new(1, -32, 0, 32),
            UDim2.new(0, 16, 0, btnY), detailOverlay, callback)
        b.ZIndex = 21
        btnY = btnY + 36
    end

    if iconInstance.VaultSlot then
        addBtn("Unvault", function()
            -- Server doesn't expose unvault remote in current scaffold; could add later
            local UI = require(script.Parent.Parent.Controllers.UIController)
            if UI.ShowNotification then UI.ShowNotification("Vault", "Unvaulting requires server expansion", 3) end
        end)
    elseif iconInstance.Displayed then
        addBtn("Remove from Display", function()
            local PlotController = require(script.Parent.Parent.Controllers.PlotController)
            PlotController.RemoveDisplay(iconInstance.UID)
            if detailOverlay then detailOverlay:Destroy() detailOverlay = nil end
        end)
    else
        addBtn("Display on Plot", function()
            -- Place at plot center
            local DataController = require(script.Parent.Parent.Controllers.DataController)
            local data = DataController.GetData()
            local PlotController = require(script.Parent.Parent.Controllers.PlotController)
            local plot = PlotController.GetPlotData()
            if plot and plot.Position then
                PlotController.DisplayIcon(iconInstance.UID, plot.Position.X, plot.Position.Z)
                if detailOverlay then detailOverlay:Destroy() detailOverlay = nil end
            end
        end)

        addBtn("Try Evolve", function()
            local EggController = require(script.Parent.Parent.Controllers.EggController)
            EggController.RequestEvolve(iconInstance.UID)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- PUBLIC
-- ═══════════════════════════════════════════════════════════════

function InventoryUI.Open()
    refreshContent()
    if panel then UIHelpers.OpenPanel(panel) end
end

function InventoryUI.Close()
    if panel then UIHelpers.ClosePanel(panel) end
end

function InventoryUI.Init(screenGui)
    buildPanel(screenGui)

    local DataController = require(script.Parent.Parent.Controllers.DataController)
    DataController.DataChanged:Connect(function(field)
        if field == "Icons" or field == "CollectionBook" then
            if panel and panel.Visible then refreshContent() end
        end
    end)
end

return InventoryUI
