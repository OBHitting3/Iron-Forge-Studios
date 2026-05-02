--[[
    BuildUI.lua (Client)
    Building toolbar with furniture catalog by category, placement preview.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Shared.Constants)
local FurnitureDatabase = require(ReplicatedStorage.Modules.Data.FurnitureDatabase)
local UIHelpers = require(script.Parent.UIHelpers)

local BuildUI = {}

local panel = nil
local catalog = nil
local categoryButtons = {}
local currentCategory = nil
local previewPart = nil
local placeConn = nil
local rotateConn = nil
local currentRotation = 0
local selectedItem = nil

-- ═══════════════════════════════════════════════════════════════
-- BUILD
-- ═══════════════════════════════════════════════════════════════

local function buildPanel(parent)
    panel = UIHelpers.Frame("BuildPanel", UDim2.new(0, 720, 0, 460),
        UDim2.new(0.5, 0, 0.5, 0), parent, UIHelpers.Theme.BgDark)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Visible = false
    UIHelpers.Corner(panel, 14)
    UIHelpers.Stroke(panel, UIHelpers.Theme.Border, 2)

    UIHelpers.Label("Title", "🏗 Build Mode", UDim2.new(1, -100, 0, 50),
        UDim2.new(0, 16, 0, 8), panel, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.MakeCloseButton(panel, function() BuildUI.Close() end)

    UIHelpers.Label("Hint", "Click an item, then click on your plot to place. Press R to rotate.",
        UDim2.new(1, -32, 0, 22), UDim2.new(0, 16, 0, 56), panel, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
        XAlign = Enum.TextXAlignment.Left,
    }).TextSize = 13

    -- Category tabs
    local catFrame = UIHelpers.Frame("Cats", UDim2.new(0, 160, 1, -100),
        UDim2.new(0, 16, 0, 84), panel, UIHelpers.Theme.BgMedium)
    UIHelpers.Corner(catFrame, 8)
    local catScroll = UIHelpers.ScrollFrame("CatScroll", UDim2.new(1, -8, 1, -8),
        UDim2.new(0, 4, 0, 4), catFrame)
    UIHelpers.ListLayout(catScroll, 4)

    local cats = FurnitureDatabase.GetCategories()
    for i, cat in cats do
        local btn = UIHelpers.Button("Cat_" .. cat, cat, UDim2.new(1, -8, 0, 32),
            nil, catScroll, function() BuildUI._selectCategory(cat) end)
        btn.LayoutOrder = i
        categoryButtons[cat] = btn
    end

    -- Catalog grid
    local catalogFrame = UIHelpers.Frame("Catalog", UDim2.new(1, -204, 1, -100),
        UDim2.new(0, 188, 0, 84), panel, UIHelpers.Theme.BgMedium)
    UIHelpers.Corner(catalogFrame, 8)
    catalog = UIHelpers.ScrollFrame("Items", UDim2.new(1, -8, 1, -8),
        UDim2.new(0, 4, 0, 4), catalogFrame)
    UIHelpers.GridLayout(catalog, UDim2.new(0, 100, 0, 110), 6)

    if cats[1] then BuildUI._selectCategory(cats[1]) end
end

function BuildUI._selectCategory(cat)
    currentCategory = cat
    for name, btn in categoryButtons do
        btn.BackgroundColor3 = (name == cat) and UIHelpers.Theme.Accent or UIHelpers.Theme.BgLight
        btn.TextColor3 = (name == cat) and UIHelpers.Theme.BgDark or UIHelpers.Theme.AccentSoft
    end

    -- Clear old items
    for _, child in catalog:GetChildren() do
        if child:IsA("Frame") then child:Destroy() end
    end

    local items = FurnitureDatabase.GetByCategory(cat)
    for i, item in items do
        local card = UIHelpers.Frame("Item_" .. item.Id, UDim2.new(0, 100, 0, 110),
            nil, catalog, UIHelpers.Theme.BgLight)
        card.LayoutOrder = i
        UIHelpers.Corner(card, 6)
        UIHelpers.Stroke(card, item.Color or UIHelpers.Theme.Border, 1)

        -- Color swatch
        local swatch = Instance.new("Frame")
        swatch.Size = UDim2.new(1, -16, 0, 50)
        swatch.Position = UDim2.new(0, 8, 0, 8)
        swatch.BackgroundColor3 = item.Color or UIHelpers.Theme.BgMedium
        swatch.BorderSizePixel = 0
        swatch.Parent = card
        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(0, 4)
        sc.Parent = swatch

        local nameLbl = UIHelpers.Label("Name", item.Name, UDim2.new(1, -8, 0, 32),
            UDim2.new(0, 4, 0, 60), card, {
            Color = UIHelpers.Theme.TextPrimary, Scaled = false, Font = Enum.Font.GothamMedium,
        })
        nameLbl.TextSize = 10
        nameLbl.TextWrapped = true

        if item.Exclusive then
            local exclusive = UIHelpers.Label("Excl", "★ ARCHITECT",
                UDim2.new(1, -8, 0, 12), UDim2.new(0, 4, 1, -16), card, {
                Color = Color3.fromRGB(255, 215, 0), Scaled = false, Font = Enum.Font.GothamBold,
            })
            exclusive.TextSize = 9
        end

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = card
        clickBtn.MouseButton1Click:Connect(function()
            BuildUI._selectItem(item)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- PLACEMENT
-- ═══════════════════════════════════════════════════════════════

function BuildUI._selectItem(item)
    selectedItem = item

    -- Cleanup previous preview
    if previewPart then previewPart:Destroy() previewPart = nil end
    if placeConn then placeConn:Disconnect() placeConn = nil end
    if rotateConn then rotateConn:Disconnect() rotateConn = nil end
    currentRotation = 0

    previewPart = Instance.new("Part")
    previewPart.Name = "PlacementPreview"
    previewPart.Size = item.Size or Vector3.new(2, 2, 2)
    previewPart.Material = Enum.Material.ForceField
    previewPart.Color = item.Color or Color3.fromRGB(100, 255, 100)
    previewPart.Transparency = 0.5
    previewPart.Anchored = true
    previewPart.CanCollide = false
    previewPart.Parent = game.Workspace

    local localPlayer = Players.LocalPlayer
    local mouse = localPlayer:GetMouse()

    -- Update preview position via Heartbeat
    placeConn = RunService.Heartbeat:Connect(function()
        if not previewPart or not previewPart.Parent then return end

        local hit = mouse.Hit
        if hit then
            local x = math.floor(hit.X + 0.5)
            local z = math.floor(hit.Z + 0.5)
            previewPart.CFrame = CFrame.new(x, hit.Y + previewPart.Size.Y / 2, z)
                * CFrame.Angles(0, math.rad(currentRotation), 0)
        end
    end)

    -- Place on click
    mouse.Button1Down:Connect(function()
        if not selectedItem then return end
        local hit = mouse.Hit
        if not hit then return end

        local PlotController = require(script.Parent.Parent.Controllers.PlotController)
        local x = math.floor(hit.X + 0.5)
        local z = math.floor(hit.Z + 0.5)
        PlotController.PlaceFurniture(selectedItem.Id, x, hit.Y, z, currentRotation)
    end)

    -- Rotate on R
    rotateConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.R then
            currentRotation = (currentRotation + 90) % 360
        elseif input.KeyCode == Enum.KeyCode.Escape then
            BuildUI._cancelPlacement()
        end
    end)
end

function BuildUI._cancelPlacement()
    if previewPart then previewPart:Destroy() previewPart = nil end
    if placeConn then placeConn:Disconnect() placeConn = nil end
    if rotateConn then rotateConn:Disconnect() rotateConn = nil end
    selectedItem = nil
end

-- ═══════════════════════════════════════════════════════════════
-- PUBLIC
-- ═══════════════════════════════════════════════════════════════

function BuildUI.Open()
    if panel then UIHelpers.OpenPanel(panel) end
end

function BuildUI.Close()
    if panel then UIHelpers.ClosePanel(panel) end
    BuildUI._cancelPlacement()
end

function BuildUI.Init(screenGui)
    buildPanel(screenGui)
end

return BuildUI
