--[[
    EggHatchUI.lua (Client)
    Egg shop and hatching animation panel.
    - Shows 4 egg tiers with cost
    - Server-validated purchases
    - Hatch result reveal with rarity glow
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Shared.Constants)
local Util = require(ReplicatedStorage.Modules.Shared.Util)
local IconDatabase = require(ReplicatedStorage.Modules.Data.IconDatabase)
local UIHelpers = require(script.Parent.UIHelpers)

local EggHatchUI = {}

local panel = nil
local resultOverlay = nil

-- ═══════════════════════════════════════════════════════════════
-- BUILD PANEL
-- ═══════════════════════════════════════════════════════════════

local function buildPanel(parent)
    panel = UIHelpers.Frame("EggHatchPanel", UDim2.new(0, 700, 0, 460), nil, parent, UIHelpers.Theme.BgDark)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Visible = false
    UIHelpers.Corner(panel, 14)
    UIHelpers.Stroke(panel, UIHelpers.Theme.Border, 2)

    -- Title
    UIHelpers.Label("Title", "Desert Egg Shop", UDim2.new(1, -100, 0, 50), UDim2.new(0, 16, 0, 8), panel, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.MakeCloseButton(panel, function() EggHatchUI.Close() end)

    -- Subtitle
    UIHelpers.Label("Subtitle", "Hatch eggs to collect Desert Icons. Rarer icons = more passive income.",
        UDim2.new(1, -32, 0, 24), UDim2.new(0, 16, 0, 56), panel, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
        XAlign = Enum.TextXAlignment.Left,
    }).TextSize = 14

    -- Egg tier grid
    local tiersFrame = UIHelpers.Frame("Tiers", UDim2.new(1, -32, 1, -120), UDim2.new(0, 16, 0, 100), panel,
        UIHelpers.Theme.BgMedium)
    UIHelpers.Corner(tiersFrame, 8)
    UIHelpers.Padding(tiersFrame, 12)

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tiersFrame

    for i, tier in Constants.EggTiers do
        local card = UIHelpers.Frame("Tier_" .. i, UDim2.new(0, 150, 1, -16), nil, tiersFrame,
            UIHelpers.Theme.BgLight)
        card.LayoutOrder = i
        UIHelpers.Corner(card, 10)
        UIHelpers.Stroke(card, tier.Color, 2)

        -- Egg visual
        local eggGfx = Instance.new("Frame")
        eggGfx.Name = "EggGfx"
        eggGfx.Size = UDim2.new(0, 80, 0, 100)
        eggGfx.Position = UDim2.new(0.5, -40, 0, 16)
        eggGfx.BackgroundColor3 = tier.Color
        eggGfx.BorderSizePixel = 0
        eggGfx.Parent = card
        local eggCorner = Instance.new("UICorner")
        eggCorner.CornerRadius = UDim.new(0.5, 0)
        eggCorner.Parent = eggGfx

        -- Tier name
        UIHelpers.Label("Name", tier.Name, UDim2.new(1, -8, 0, 22), UDim2.new(0, 4, 0, 130), card, {
            Color = UIHelpers.Theme.TextPrimary, Scaled = false, Font = Enum.Font.GothamBold,
        }).TextSize = 14

        -- Cost
        UIHelpers.Label("Cost", Util.FormatNumber(tier.Cost) .. " DC",
            UDim2.new(1, -8, 0, 20), UDim2.new(0, 4, 0, 156), card, {
            Color = Color3.fromRGB(255, 215, 0), Scaled = false, Font = Enum.Font.GothamMedium,
        }).TextSize = 13

        -- Hatch button
        local hatchBtn = UIHelpers.Button("Hatch", "Hatch", UDim2.new(1, -16, 0, 36),
            UDim2.new(0, 8, 1, -46), card, function()
                EggHatchUI._requestHatch(i)
            end)
        hatchBtn.BackgroundColor3 = tier.Color
    end
end

local function buildResultOverlay(parent)
    resultOverlay = UIHelpers.Frame("HatchResult", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), parent,
        Color3.fromRGB(0, 0, 0))
    resultOverlay.BackgroundTransparency = 0.4
    resultOverlay.Visible = false
    resultOverlay.ZIndex = 10

    local card = UIHelpers.Frame("Card", UDim2.new(0, 380, 0, 460), UDim2.new(0.5, 0, 0.5, 0), resultOverlay,
        UIHelpers.Theme.BgDark)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.ZIndex = 11
    UIHelpers.Corner(card, 16)

    local stroke = UIHelpers.Stroke(card, UIHelpers.Theme.Accent, 3)
    stroke.Name = "RarityStroke"

    UIHelpers.Label("Reveal", "✨ NEW ICON ✨", UDim2.new(1, -16, 0, 36), UDim2.new(0, 8, 0, 12), card, {
        Color = UIHelpers.Theme.Accent,
    }).ZIndex = 11

    local iconGfx = Instance.new("Frame")
    iconGfx.Name = "IconGfx"
    iconGfx.Size = UDim2.new(0, 200, 0, 200)
    iconGfx.Position = UDim2.new(0.5, -100, 0, 70)
    iconGfx.BackgroundColor3 = UIHelpers.Theme.BgLight
    iconGfx.BorderSizePixel = 0
    iconGfx.ZIndex = 11
    iconGfx.Parent = card
    UIHelpers.Corner(iconGfx, 100)
    local iconStroke = UIHelpers.Stroke(iconGfx, UIHelpers.Theme.Accent, 4)
    iconStroke.Name = "IconStroke"

    local nameLabel = UIHelpers.Label("IconName", "Loading...", UDim2.new(1, -16, 0, 32),
        UDim2.new(0, 8, 0, 286), card, { Color = UIHelpers.Theme.TextPrimary })
    nameLabel.ZIndex = 11

    local rarityLabel = UIHelpers.Label("Rarity", "", UDim2.new(1, -16, 0, 26),
        UDim2.new(0, 8, 0, 322), card, { Color = UIHelpers.Theme.AccentSoft, Scaled = false, Font = Enum.Font.GothamBold })
    rarityLabel.TextSize = 18
    rarityLabel.ZIndex = 11

    local descLabel = UIHelpers.Label("Desc", "", UDim2.new(1, -32, 0, 36),
        UDim2.new(0, 16, 0, 350), card, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
    })
    descLabel.TextSize = 13
    descLabel.TextWrapped = true
    descLabel.ZIndex = 11

    UIHelpers.Button("Continue", "Continue", UDim2.new(0, 200, 0, 40),
        UDim2.new(0.5, -100, 1, -52), card, function()
            EggHatchUI._dismissResult()
        end).ZIndex = 11
end

-- ═══════════════════════════════════════════════════════════════
-- LOGIC
-- ═══════════════════════════════════════════════════════════════

function EggHatchUI._requestHatch(tierIndex)
    local EggController = require(script.Parent.Parent.Controllers.EggController)
    EggController.RequestHatch(tierIndex)
end

function EggHatchUI._showResult(result)
    if not resultOverlay then return end

    if not result.Success then
        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController and UIController.ShowNotification then
            UIController.ShowNotification("Hatch Failed", result.Reason or "Unknown error", 3)
        end
        return
    end

    local icon = result.Icon
    if not icon then return end

    local card = resultOverlay:FindFirstChild("Card")
    if not card then return end

    local rarityColor = UIHelpers.RarityColor(icon.Rarity)
    local nameLabel = card:FindFirstChild("IconName")
    local rarityLabel = card:FindFirstChild("Rarity")
    local descLabel = card:FindFirstChild("Desc")
    local iconGfx = card:FindFirstChild("IconGfx")
    local stroke = card:FindFirstChild("RarityStroke")

    if nameLabel then nameLabel.Text = icon.Name end
    if rarityLabel then
        rarityLabel.Text = icon.Rarity:upper()
        rarityLabel.TextColor3 = rarityColor
    end
    if descLabel then descLabel.Text = icon.Description or "" end
    if iconGfx then
        iconGfx.BackgroundColor3 = rarityColor
        local iconStroke = iconGfx:FindFirstChild("IconStroke")
        if iconStroke then iconStroke.Color = rarityColor end
    end
    if stroke then stroke.Color = rarityColor end

    resultOverlay.Visible = true

    -- Pulse glow for rare+
    if icon.Rarity ~= "Common" and icon.Rarity ~= "Uncommon" and stroke then
        local startThickness = stroke.Thickness
        task.spawn(function()
            for _ = 1, 6 do
                TweenService:Create(stroke, TweenInfo.new(0.3), { Thickness = 8 }):Play()
                task.wait(0.3)
                TweenService:Create(stroke, TweenInfo.new(0.3), { Thickness = startThickness }):Play()
                task.wait(0.3)
            end
        end)
    end
end

function EggHatchUI._dismissResult()
    if resultOverlay then
        resultOverlay.Visible = false
    end
end

-- ═══════════════════════════════════════════════════════════════
-- PUBLIC
-- ═══════════════════════════════════════════════════════════════

function EggHatchUI.Open()
    if panel then UIHelpers.OpenPanel(panel) end
end

function EggHatchUI.Close()
    if panel then UIHelpers.ClosePanel(panel) end
end

function EggHatchUI.Init(screenGui)
    buildPanel(screenGui)
    buildResultOverlay(screenGui)

    local EggController = require(script.Parent.Parent.Controllers.EggController)
    EggController.HatchResult:Connect(EggHatchUI._showResult)
end

return EggHatchUI
