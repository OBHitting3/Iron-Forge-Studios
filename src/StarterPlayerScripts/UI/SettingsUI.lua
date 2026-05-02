--[[
    SettingsUI.lua (Client)
    Volume sliders, toggles for trade requests and heist notifications.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Modules.Shared.Remotes)
local UIHelpers = require(script.Parent.UIHelpers)

local SettingsUI = {}

local panel = nil

local function buildToggle(parent, key, label, layoutOrder)
    local row = UIHelpers.Frame("Row_" .. key, UDim2.new(1, -16, 0, 50),
        nil, parent, UIHelpers.Theme.BgLight)
    row.LayoutOrder = layoutOrder
    UIHelpers.Corner(row, 6)

    UIHelpers.Label("Label", label, UDim2.new(0.7, 0, 1, 0),
        UDim2.new(0, 16, 0, 0), row, {
        Color = UIHelpers.Theme.TextPrimary, XAlign = Enum.TextXAlignment.Left,
        Scaled = false, Font = Enum.Font.GothamMedium,
    }).TextSize = 14

    local toggle = UIHelpers.Button("Toggle", "ON", UDim2.new(0, 90, 0, 36),
        UDim2.new(1, -100, 0.5, -18), row, function() end)
    toggle.BackgroundColor3 = UIHelpers.Theme.Success
    toggle:SetAttribute("Value", true)

    toggle.MouseButton1Click:Connect(function()
        local current = toggle:GetAttribute("Value")
        local newValue = not current
        toggle:SetAttribute("Value", newValue)
        toggle.Text = newValue and "ON" or "OFF"
        toggle.BackgroundColor3 = newValue and UIHelpers.Theme.Success or UIHelpers.Theme.Danger

        Remotes.GetEvent("SettingsUpdate"):FireServer({ Key = key, Value = newValue })
    end)

    return row, toggle
end

local function buildSlider(parent, key, label, layoutOrder)
    local row = UIHelpers.Frame("Row_" .. key, UDim2.new(1, -16, 0, 60),
        nil, parent, UIHelpers.Theme.BgLight)
    row.LayoutOrder = layoutOrder
    UIHelpers.Corner(row, 6)

    UIHelpers.Label("Label", label, UDim2.new(1, -32, 0, 22),
        UDim2.new(0, 16, 0, 4), row, {
        Color = UIHelpers.Theme.TextPrimary, XAlign = Enum.TextXAlignment.Left,
        Scaled = false, Font = Enum.Font.GothamMedium,
    }).TextSize = 13

    -- Track
    local track = UIHelpers.Frame("Track", UDim2.new(1, -32, 0, 8),
        UDim2.new(0, 16, 0, 36), row, UIHelpers.Theme.BgDark)
    UIHelpers.Corner(track, 4)

    -- Fill (50% default)
    local fill = UIHelpers.Frame("Fill", UDim2.new(0.5, 0, 1, 0),
        UDim2.new(0, 0, 0, 0), track, UIHelpers.Theme.Accent)
    UIHelpers.Corner(fill, 4)

    -- Click handler (simple slider — click to set position)
    local trackBtn = Instance.new("TextButton")
    trackBtn.Size = UDim2.new(1, 0, 1, 0)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text = ""
    trackBtn.Parent = track

    trackBtn.MouseButton1Down:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local trackAbsPos = track.AbsolutePosition.X
        local trackAbsSize = track.AbsoluteSize.X
        local relX = math.clamp((mouse.X - trackAbsPos) / trackAbsSize, 0, 1)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        Remotes.GetEvent("SettingsUpdate"):FireServer({ Key = key, Value = relX })
    end)

    return row
end

local function buildPanel(parent)
    panel = UIHelpers.Frame("SettingsPanel", UDim2.new(0, 460, 0, 480),
        UDim2.new(0.5, 0, 0.5, 0), parent, UIHelpers.Theme.BgDark)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Visible = false
    UIHelpers.Corner(panel, 14)
    UIHelpers.Stroke(panel, UIHelpers.Theme.Border, 2)

    UIHelpers.Label("Title", "⚙ Settings", UDim2.new(1, -100, 0, 50),
        UDim2.new(0, 16, 0, 8), panel, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.MakeCloseButton(panel, function() SettingsUI.Close() end)

    local content = UIHelpers.ScrollFrame("Content", UDim2.new(1, -32, 1, -80),
        UDim2.new(0, 16, 0, 70), panel)
    UIHelpers.ListLayout(content, 8)
    UIHelpers.Padding(content, 4)

    buildSlider(content, "MusicVolume", "Music Volume", 1)
    buildSlider(content, "SFXVolume", "SFX Volume", 2)
    buildToggle(content, "ShowTradeRequests", "Allow trade requests", 3)
    buildToggle(content, "HeistNotifications", "Heist notifications", 4)
end

function SettingsUI.Open()
    if panel then UIHelpers.OpenPanel(panel) end
end

function SettingsUI.Close()
    if panel then UIHelpers.ClosePanel(panel) end
end

function SettingsUI.Init(screenGui)
    buildPanel(screenGui)
end

return SettingsUI
