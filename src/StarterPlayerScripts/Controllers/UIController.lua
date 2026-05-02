--[[
    UIController.lua (Client)
    Master UI manager. Creates HUD, action bar, notifications, and
    wires action bar buttons to all panel modules.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Remotes = require(ReplicatedStorage.Modules.Shared.Remotes)
local Constants = require(ReplicatedStorage.Modules.Shared.Constants)
local Util = require(ReplicatedStorage.Modules.Shared.Util)
local Signal = require(ReplicatedStorage.Modules.Shared.Signal)

local UIController = {}

local player = nil
local screenGui = nil
local hudFrame = nil
local notificationContainer = nil
local panels = {}

-- ═══════════════════════════════════════════════════════════════
-- THEME (mirrored from UIHelpers for HUD consistency)
-- ═══════════════════════════════════════════════════════════════
local THEME = {
    BgDark        = Color3.fromRGB(28, 22, 18),
    BgMedium      = Color3.fromRGB(40, 32, 26),
    BgLight       = Color3.fromRGB(60, 50, 40),
    Accent        = Color3.fromRGB(255, 180, 80),
    AccentSoft    = Color3.fromRGB(255, 220, 150),
    TextPrimary   = Color3.fromRGB(255, 235, 200),
    TextSecondary = Color3.fromRGB(200, 180, 150),
    Border        = Color3.fromRGB(180, 140, 80),
}

-- ═══════════════════════════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════════════════════════

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.Border
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

-- ═══════════════════════════════════════════════════════════════
-- HUD
-- ═══════════════════════════════════════════════════════════════

local function createHUD()
    hudFrame = Instance.new("Frame")
    hudFrame.Name = "HUD"
    hudFrame.Size = UDim2.new(0, 320, 0, 100)
    hudFrame.Position = UDim2.new(0, 10, 0, 10)
    hudFrame.BackgroundColor3 = THEME.BgDark
    hudFrame.BackgroundTransparency = 0.15
    hudFrame.Parent = screenGui
    corner(hudFrame, 12)
    stroke(hudFrame, THEME.Accent, 2)

    local currencyLabel = Instance.new("TextLabel")
    currencyLabel.Name = "CurrencyLabel"
    currencyLabel.Size = UDim2.new(1, -20, 0, 35)
    currencyLabel.Position = UDim2.new(0, 10, 0, 5)
    currencyLabel.BackgroundTransparency = 1
    currencyLabel.Text = "DC: 0"
    currencyLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    currencyLabel.TextScaled = true
    currencyLabel.Font = Enum.Font.GothamBold
    currencyLabel.TextXAlignment = Enum.TextXAlignment.Left
    currencyLabel.Parent = hudFrame

    local incomeLabel = Instance.new("TextLabel")
    incomeLabel.Name = "IncomeLabel"
    incomeLabel.Size = UDim2.new(1, -20, 0, 25)
    incomeLabel.Position = UDim2.new(0, 10, 0, 40)
    incomeLabel.BackgroundTransparency = 1
    incomeLabel.Text = "+0 DC/min"
    incomeLabel.TextColor3 = Color3.fromRGB(150, 220, 100)
    incomeLabel.TextScaled = true
    incomeLabel.Font = Enum.Font.GothamMedium
    incomeLabel.TextXAlignment = Enum.TextXAlignment.Left
    incomeLabel.Parent = hudFrame

    local zoneLabel = Instance.new("TextLabel")
    zoneLabel.Name = "ZoneLabel"
    zoneLabel.Size = UDim2.new(1, -20, 0, 25)
    zoneLabel.Position = UDim2.new(0, 10, 0, 68)
    zoneLabel.BackgroundTransparency = 1
    zoneLabel.Text = "Downtown Palm Springs"
    zoneLabel.TextColor3 = THEME.TextSecondary
    zoneLabel.TextScaled = true
    zoneLabel.Font = Enum.Font.Gotham
    zoneLabel.TextXAlignment = Enum.TextXAlignment.Left
    zoneLabel.Parent = hudFrame
end

-- ═══════════════════════════════════════════════════════════════
-- ACTION BAR
-- ═══════════════════════════════════════════════════════════════

local function createActionBar()
    local bar = Instance.new("Frame")
    bar.Name = "ActionBar"
    bar.Size = UDim2.new(0, 660, 0, 64)
    bar.Position = UDim2.new(0.5, -330, 1, -74)
    bar.BackgroundColor3 = THEME.BgDark
    bar.BackgroundTransparency = 0.15
    bar.Parent = screenGui
    corner(bar, 12)
    stroke(bar, THEME.Accent, 2)

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    layout.Parent = bar

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = bar

    local function makeBtn(name, text, panelKey)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 95, 0, 48)
        btn.BackgroundColor3 = THEME.BgLight
        btn.Text = text
        btn.TextColor3 = THEME.AccentSoft
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = true
        btn.Parent = bar
        corner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            UIController.TogglePanel(panelKey)
        end)

        return btn
    end

    makeBtn("EggsBtn", "🥚 Eggs", "Eggs")
    makeBtn("InvBtn", "📦 Icons", "Inventory")
    makeBtn("BuildBtn", "🏗 Build", "Build")
    makeBtn("HeistBtn", "🎯 Heist", "Heist")
    makeBtn("TradeBtn", "🤝 Trade", "Trade")
    makeBtn("LBBtn", "🏆 Ranks", "Leaderboard")
    makeBtn("SetBtn", "⚙", "Settings")
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATIONS
-- ═══════════════════════════════════════════════════════════════

local function createNotificationContainer()
    notificationContainer = Instance.new("Frame")
    notificationContainer.Name = "Notifications"
    notificationContainer.Size = UDim2.new(0, 360, 0, 500)
    notificationContainer.Position = UDim2.new(1, -370, 0, 120)
    notificationContainer.BackgroundTransparency = 1
    notificationContainer.Parent = screenGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = notificationContainer
end

function UIController.ShowNotification(title, text, duration)
    if not notificationContainer then return end
    duration = duration or 3

    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(1, 0, 0, 64)
    toast.BackgroundColor3 = THEME.BgDark
    toast.BackgroundTransparency = 0.1
    toast.Parent = notificationContainer
    corner(toast, 8)
    stroke(toast, THEME.Accent)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -12, 0, 22)
    titleLabel.Position = UDim2.new(0, 8, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = THEME.Accent
    titleLabel.TextScaled = false
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = toast

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -12, 0, 32)
    textLabel.Position = UDim2.new(0, 8, 0, 28)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = THEME.TextSecondary
    textLabel.TextScaled = false
    textLabel.TextSize = 13
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Parent = toast

    -- Animate in
    toast.Position = UDim2.new(1, 20, 0, 0)
    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
    }):Play()

    task.delay(duration, function()
        if not toast.Parent then return end
        local out = TweenService:Create(toast, TweenInfo.new(0.25), {
            Position = UDim2.new(1, 20, 0, 0),
            BackgroundTransparency = 1,
        })
        out:Play()
        out.Completed:Wait()
        if toast then toast:Destroy() end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- HUD UPDATES
-- ═══════════════════════════════════════════════════════════════

local function updateHUD(data)
    if not hudFrame or not data then return end

    local cur = hudFrame:FindFirstChild("CurrencyLabel")
    if cur then cur.Text = "DC: " .. Util.FormatNumber(data.Currency or 0) end

    local inc = hudFrame:FindFirstChild("IncomeLabel")
    if inc then inc.Text = "+" .. Util.FormatNumber(data.TotalPassiveIncome or 0) .. " DC/min" end
end

-- ═══════════════════════════════════════════════════════════════
-- PANEL MANAGEMENT
-- ═══════════════════════════════════════════════════════════════

function UIController.TogglePanel(panelKey)
    if panelKey == "Heist" then
        local HeistUI = panels.Heist
        if HeistUI then HeistUI.OpenTargetPanel() end
        return
    end

    local panelMod = panels[panelKey]
    if not panelMod then return end
    if panelMod.Open then panelMod.Open() end
end

-- ═══════════════════════════════════════════════════════════════
-- KEYBINDS
-- ═══════════════════════════════════════════════════════════════

local function setupKeybinds()
    local keyMap = {
        [Enum.KeyCode.E] = "Eggs",
        [Enum.KeyCode.I] = "Inventory",
        [Enum.KeyCode.B] = "Build",
        [Enum.KeyCode.H] = "Heist",
        [Enum.KeyCode.T] = "Trade",
        [Enum.KeyCode.L] = "Leaderboard",
    }

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local panelKey = keyMap[input.KeyCode]
        if panelKey then
            UIController.TogglePanel(panelKey)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════════════════════

function UIController.Init(localPlayer)
    player = localPlayer

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PalmSpringsUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 10
    screenGui.Parent = player:WaitForChild("PlayerGui")

    createHUD()
    createActionBar()
    createNotificationContainer()

    -- Initialize all UI panels (load lazily to avoid circular requires)
    local UIFolder = script.Parent.Parent:FindFirstChild("UI")
    if UIFolder then
        local panelLoaders = {
            { Key = "Eggs",        Module = "EggHatchUI" },
            { Key = "Inventory",   Module = "InventoryUI" },
            { Key = "Heist",       Module = "HeistUI" },
            { Key = "Trade",       Module = "TradeUI" },
            { Key = "Build",       Module = "BuildUI" },
            { Key = "Leaderboard", Module = "LeaderboardUI" },
            { Key = "Settings",    Module = "SettingsUI" },
        }

        for _, info in panelLoaders do
            local mod = UIFolder:FindFirstChild(info.Module)
            if mod then
                local ok, panel = pcall(require, mod)
                if ok and panel and panel.Init then
                    pcall(panel.Init, screenGui)
                    panels[info.Key] = panel
                else
                    warn("[UIController] Failed to load panel:", info.Module, panel)
                end
            end
        end
    end

    -- HUD updates
    local DataController = require(script.Parent.DataController)
    DataController.DataLoaded:Connect(updateHUD)
    DataController.DataChanged:Connect(function()
        updateHUD(DataController.GetData())
    end)

    -- Zone updates
    Remotes.GetEvent("ZoneEntered").OnClientEvent:Connect(function(zoneName)
        local zoneLabel = hudFrame and hudFrame:FindFirstChild("ZoneLabel")
        if zoneLabel then
            local zoneData = Constants.ZoneData[zoneName]
            zoneLabel.Text = zoneData and zoneData.DisplayName or "Wilderness"
            zoneLabel.TextColor3 = THEME.AccentSoft
            TweenService:Create(zoneLabel, TweenInfo.new(1.2), {
                TextColor3 = THEME.TextSecondary,
            }):Play()
        end
    end)

    -- Server notifications
    Remotes.GetEvent("NotificationPush").OnClientEvent:Connect(function(data)
        UIController.ShowNotification(data.Title or "Notice", data.Text or "", data.Duration)
    end)

    setupKeybinds()
end

return UIController
