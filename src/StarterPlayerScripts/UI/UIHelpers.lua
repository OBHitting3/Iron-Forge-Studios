--[[
    UIHelpers.lua
    Shared UI builder functions used across all panel modules.
    Keeps panel code concise and styling consistent.
]]

local TweenService = game:GetService("TweenService")

local UIHelpers = {}

UIHelpers.Theme = {
    BgDark        = Color3.fromRGB(28, 22, 18),
    BgMedium      = Color3.fromRGB(40, 32, 26),
    BgLight       = Color3.fromRGB(60, 50, 40),
    Accent        = Color3.fromRGB(255, 180, 80),
    AccentSoft    = Color3.fromRGB(255, 220, 150),
    TextPrimary   = Color3.fromRGB(255, 235, 200),
    TextSecondary = Color3.fromRGB(200, 180, 150),
    Success       = Color3.fromRGB(120, 220, 120),
    Danger        = Color3.fromRGB(230, 90, 90),
    Border        = Color3.fromRGB(180, 140, 80),
}

function UIHelpers.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

function UIHelpers.Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or UIHelpers.Theme.Border
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

function UIHelpers.Padding(parent, padding)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, padding)
    p.PaddingRight = UDim.new(0, padding)
    p.PaddingTop = UDim.new(0, padding)
    p.PaddingBottom = UDim.new(0, padding)
    p.Parent = parent
    return p
end

function UIHelpers.ListLayout(parent, padding, dir)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, padding or 4)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

function UIHelpers.GridLayout(parent, cellSize, padding)
    local g = Instance.new("UIGridLayout")
    g.CellSize = cellSize or UDim2.new(0, 80, 0, 80)
    g.CellPadding = UDim2.new(0, padding or 6, 0, padding or 6)
    g.SortOrder = Enum.SortOrder.LayoutOrder
    g.Parent = parent
    return g
end

function UIHelpers.Frame(name, size, position, parent, bgColor)
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size
    f.Position = position or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3 = bgColor or UIHelpers.Theme.BgMedium
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

function UIHelpers.Label(name, text, size, position, parent, opts)
    opts = opts or {}
    local l = Instance.new("TextLabel")
    l.Name = name
    l.Size = size
    l.Position = position or UDim2.new(0, 0, 0, 0)
    l.BackgroundTransparency = opts.BgTransparency or 1
    l.BackgroundColor3 = opts.BgColor or UIHelpers.Theme.BgMedium
    l.Text = text
    l.TextColor3 = opts.Color or UIHelpers.Theme.TextPrimary
    l.TextScaled = opts.Scaled ~= false
    l.Font = opts.Font or Enum.Font.GothamBold
    l.TextXAlignment = opts.XAlign or Enum.TextXAlignment.Center
    l.TextYAlignment = opts.YAlign or Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

function UIHelpers.Button(name, text, size, position, parent, callback)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = size
    b.Position = position or UDim2.new(0, 0, 0, 0)
    b.BackgroundColor3 = UIHelpers.Theme.BgLight
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = UIHelpers.Theme.AccentSoft
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = parent

    UIHelpers.Corner(b, 6)
    UIHelpers.Stroke(b, UIHelpers.Theme.Border)

    if callback then
        b.MouseButton1Click:Connect(callback)
    end

    return b
end

function UIHelpers.ScrollFrame(name, size, position, parent)
    local s = Instance.new("ScrollingFrame")
    s.Name = name
    s.Size = size
    s.Position = position or UDim2.new(0, 0, 0, 0)
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 6
    s.ScrollBarImageColor3 = UIHelpers.Theme.Accent
    s.CanvasSize = UDim2.new(0, 0, 0, 0)
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    s.Parent = parent
    return s
end

function UIHelpers.OpenPanel(panel)
    panel.Visible = true
    panel.Position = UDim2.new(0.5, 0, 1.2, 0)
    local goal = UDim2.new(0.5, 0, 0.5, 0)
    local tween = TweenService:Create(panel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
        Position = goal,
    })
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    tween:Play()
end

function UIHelpers.ClosePanel(panel)
    local tween = TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 1.2, 0),
    })
    tween:Play()
    tween.Completed:Connect(function()
        panel.Visible = false
    end)
end

function UIHelpers.MakeCloseButton(parent, callback)
    local btn = Instance.new("TextButton")
    btn.Name = "CloseBtn"
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.Position = UDim2.new(1, -42, 0, 6)
    btn.BackgroundColor3 = UIHelpers.Theme.Danger
    btn.Text = "X"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = parent
    UIHelpers.Corner(btn, 6)
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return btn
end

function UIHelpers.RarityColor(rarity)
    local Constants = require(game.ReplicatedStorage.Modules.Shared.Constants)
    local r = Constants.Rarities[rarity]
    return r and r.Color or Color3.fromRGB(180, 180, 180)
end

return UIHelpers
