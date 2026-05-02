--[[
    HeistUI.lua (Client)
    - Target picker (list of nearby players)
    - Countdown overlay (10s)
    - Lockpick minigame (15s, arrow key inputs)
    - Steal Cam (when YOU get heisted)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Shared.Constants)
local Util = require(ReplicatedStorage.Modules.Shared.Util)
local UIHelpers = require(script.Parent.UIHelpers)

local HeistUI = {}

local screenGuiRef = nil
local targetPanel = nil
local countdownOverlay = nil
local lockpickOverlay = nil
local stealCamOverlay = nil
local lockpickConn = nil
local lockpickPhase = nil

-- ═══════════════════════════════════════════════════════════════
-- TARGET PICKER
-- ═══════════════════════════════════════════════════════════════

local function buildTargetPanel(parent)
    targetPanel = UIHelpers.Frame("HeistTargetPanel", UDim2.new(0, 480, 0, 480),
        UDim2.new(0.5, 0, 0.5, 0), parent, UIHelpers.Theme.BgDark)
    targetPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    targetPanel.Visible = false
    UIHelpers.Corner(targetPanel, 14)
    UIHelpers.Stroke(targetPanel, UIHelpers.Theme.Border, 2)

    UIHelpers.Label("Title", "🎯 Pick a Target", UDim2.new(1, -100, 0, 50),
        UDim2.new(0, 16, 0, 8), targetPanel, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.MakeCloseButton(targetPanel, function() HeistUI.CloseTargetPanel() end)

    local subtitle = UIHelpers.Label("Subtitle",
        "Steal a displayed icon from another player. Only displayed icons (not vaulted) can be stolen.",
        UDim2.new(1, -32, 0, 36), UDim2.new(0, 16, 0, 56), targetPanel, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
        XAlign = Enum.TextXAlignment.Left,
    })
    subtitle.TextSize = 13
    subtitle.TextWrapped = true

    local listScroll = UIHelpers.ScrollFrame("List", UDim2.new(1, -32, 1, -120),
        UDim2.new(0, 16, 0, 100), targetPanel)
    UIHelpers.ListLayout(listScroll, 4)
    UIHelpers.Padding(listScroll, 6)
end

local function refreshTargetList()
    if not targetPanel then return end
    local list = targetPanel:FindFirstChild("List")
    if not list then return end

    for _, child in list:GetChildren() do
        if child:IsA("Frame") then child:Destroy() end
    end

    local localPlayer = Players.LocalPlayer
    for _, player in Players:GetPlayers() do
        if player ~= localPlayer then
            local row = UIHelpers.Frame("Player_" .. player.UserId,
                UDim2.new(1, -12, 0, 50), nil, list, UIHelpers.Theme.BgLight)
            UIHelpers.Corner(row, 6)

            UIHelpers.Label("Name", player.DisplayName or player.Name,
                UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 12, 0, 0), row, {
                Color = UIHelpers.Theme.TextPrimary, XAlign = Enum.TextXAlignment.Left,
            })

            UIHelpers.Button("Heist", "Start Heist", UDim2.new(0, 130, 0, 36),
                UDim2.new(1, -138, 0.5, -18), row, function()
                    local HeistController = require(script.Parent.Parent.Controllers.HeistController)
                    HeistController.StartHeist(player.UserId)
                    HeistUI.CloseTargetPanel()
                end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- COUNTDOWN OVERLAY
-- ═══════════════════════════════════════════════════════════════

local function buildCountdownOverlay(parent)
    countdownOverlay = UIHelpers.Frame("HeistCountdown", UDim2.new(1, 0, 1, 0),
        UDim2.new(0, 0, 0, 0), parent, Color3.fromRGB(0, 0, 0))
    countdownOverlay.BackgroundTransparency = 0.5
    countdownOverlay.Visible = false
    countdownOverlay.ZIndex = 50

    local card = UIHelpers.Frame("Card", UDim2.new(0, 380, 0, 220),
        UDim2.new(0.5, 0, 0.5, 0), countdownOverlay, UIHelpers.Theme.BgDark)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.ZIndex = 51
    UIHelpers.Corner(card, 12)
    UIHelpers.Stroke(card, UIHelpers.Theme.Danger, 3)

    UIHelpers.Label("Title", "🚨 HEIST INCOMING", UDim2.new(1, -16, 0, 36),
        UDim2.new(0, 8, 0, 12), card, { Color = UIHelpers.Theme.Danger }).ZIndex = 51

    local target = UIHelpers.Label("Target", "...", UDim2.new(1, -16, 0, 24),
        UDim2.new(0, 8, 0, 56), card, { Color = UIHelpers.Theme.AccentSoft, Scaled = false, Font = Enum.Font.GothamBold })
    target.TextSize = 16
    target.ZIndex = 51

    local countdown = UIHelpers.Label("Countdown", "10", UDim2.new(1, -16, 0, 80),
        UDim2.new(0, 8, 0, 90), card, { Color = UIHelpers.Theme.Accent })
    countdown.ZIndex = 51

    UIHelpers.Label("Hint", "Get ready to lockpick...", UDim2.new(1, -16, 0, 24),
        UDim2.new(0, 8, 0, 178), card, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
    }).ZIndex = 51
end

local function startCountdownAnimation(seconds, targetName)
    if not countdownOverlay then return end
    countdownOverlay.Visible = true
    local card = countdownOverlay:FindFirstChild("Card")
    if not card then return end
    local targetLbl = card:FindFirstChild("Target")
    local cdLbl = card:FindFirstChild("Countdown")
    if targetLbl then targetLbl.Text = "Target: " .. targetName end

    task.spawn(function()
        for i = seconds, 1, -1 do
            if cdLbl then cdLbl.Text = tostring(i) end
            task.wait(1)
        end
        if countdownOverlay then countdownOverlay.Visible = false end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- LOCKPICK OVERLAY
-- ═══════════════════════════════════════════════════════════════

local function buildLockpickOverlay(parent)
    lockpickOverlay = UIHelpers.Frame("HeistLockpick", UDim2.new(1, 0, 1, 0),
        UDim2.new(0, 0, 0, 0), parent, Color3.fromRGB(0, 0, 0))
    lockpickOverlay.BackgroundTransparency = 0.6
    lockpickOverlay.Visible = false
    lockpickOverlay.ZIndex = 60

    local card = UIHelpers.Frame("Card", UDim2.new(0, 460, 0, 320),
        UDim2.new(0.5, 0, 0.5, 0), lockpickOverlay, UIHelpers.Theme.BgDark)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.ZIndex = 61
    UIHelpers.Corner(card, 12)
    UIHelpers.Stroke(card, UIHelpers.Theme.Accent, 3)

    UIHelpers.Label("Title", "🔓 LOCKPICK", UDim2.new(1, -16, 0, 36),
        UDim2.new(0, 8, 0, 12), card, { Color = UIHelpers.Theme.Accent }).ZIndex = 61

    UIHelpers.Label("Hint", "Press ARROW KEYS or WASD in order to lockpick. One mistake = fail!",
        UDim2.new(1, -32, 0, 36), UDim2.new(0, 16, 0, 50), card, {
        Color = UIHelpers.Theme.TextSecondary, Scaled = false, Font = Enum.Font.Gotham,
    }).TextWrapped = true

    -- Progress dots
    local dotsFrame = UIHelpers.Frame("Dots", UDim2.new(1, -32, 0, 60),
        UDim2.new(0, 16, 0, 100), card, UIHelpers.Theme.BgMedium)
    dotsFrame.ZIndex = 61
    UIHelpers.Corner(dotsFrame, 6)
    local dotLayout = Instance.new("UIListLayout")
    dotLayout.FillDirection = Enum.FillDirection.Horizontal
    dotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    dotLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    dotLayout.Padding = UDim.new(0, 8)
    dotLayout.Parent = dotsFrame

    -- Time remaining
    local timer = UIHelpers.Label("Timer", "15.0s", UDim2.new(1, -16, 0, 30),
        UDim2.new(0, 8, 0, 174), card, { Color = UIHelpers.Theme.AccentSoft })
    timer.ZIndex = 61

    -- Last input feedback
    local feedback = UIHelpers.Label("Feedback", "", UDim2.new(1, -16, 0, 80),
        UDim2.new(0, 8, 0, 210), card, { Color = UIHelpers.Theme.Success })
    feedback.ZIndex = 61
end

local function showLockpickDots(total, completed)
    if not lockpickOverlay then return end
    local dots = lockpickOverlay.Card.Dots
    for _, child in dots:GetChildren() do
        if child:IsA("Frame") then child:Destroy() end
    end

    for i = 1, total do
        local dot = Instance.new("Frame")
        dot.Name = "Dot_" .. i
        dot.Size = UDim2.new(0, 32, 0, 32)
        dot.BackgroundColor3 = i <= completed and UIHelpers.Theme.Success or UIHelpers.Theme.BgLight
        dot.BorderSizePixel = 0
        dot.LayoutOrder = i
        dot.ZIndex = 62
        dot.Parent = dots
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0.5, 0)
        c.Parent = dot
    end
end

local function startLockpickInput(timeLimit, sequenceLength)
    if not lockpickOverlay then return end
    lockpickOverlay.Visible = true
    lockpickPhase = { Total = sequenceLength, Done = 0, EndTime = os.clock() + timeLimit }

    showLockpickDots(sequenceLength, 0)

    -- Disable input on screen close
    if lockpickConn then lockpickConn:Disconnect() end

    local keyMap = {
        [Enum.KeyCode.Up] = "Up", [Enum.KeyCode.W] = "Up",
        [Enum.KeyCode.Down] = "Down", [Enum.KeyCode.S] = "Down",
        [Enum.KeyCode.Left] = "Left", [Enum.KeyCode.A] = "Left",
        [Enum.KeyCode.Right] = "Right", [Enum.KeyCode.D] = "Right",
    }

    lockpickConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local dir = keyMap[input.KeyCode]
        if not dir then return end

        local HeistController = require(script.Parent.Parent.Controllers.HeistController)
        HeistController.SendLockpickInput(dir)

        -- Local feedback (optimistic)
        local feedback = lockpickOverlay.Card.Feedback
        if feedback then
            feedback.Text = "→ " .. dir
            feedback.TextColor3 = UIHelpers.Theme.AccentSoft
        end
    end)

    -- Timer update loop
    task.spawn(function()
        while lockpickPhase and lockpickOverlay.Visible do
            local timeLeft = math.max(0, lockpickPhase.EndTime - os.clock())
            local timer = lockpickOverlay.Card.Timer
            if timer then
                timer.Text = string.format("%.1fs", timeLeft)
                timer.TextColor3 = timeLeft < 5 and UIHelpers.Theme.Danger or UIHelpers.Theme.AccentSoft
            end
            if timeLeft <= 0 then break end
            task.wait(0.1)
        end
    end)
end

local function endLockpick()
    if lockpickConn then
        lockpickConn:Disconnect()
        lockpickConn = nil
    end
    if lockpickOverlay then lockpickOverlay.Visible = false end
    lockpickPhase = nil
end

-- ═══════════════════════════════════════════════════════════════
-- STEAL CAM (victim view)
-- ═══════════════════════════════════════════════════════════════

local function buildStealCamOverlay(parent)
    stealCamOverlay = UIHelpers.Frame("StealCam", UDim2.new(1, 0, 1, 0),
        UDim2.new(0, 0, 0, 0), parent, Color3.fromRGB(0, 0, 0))
    stealCamOverlay.BackgroundTransparency = 0.3
    stealCamOverlay.Visible = false
    stealCamOverlay.ZIndex = 70

    local card = UIHelpers.Frame("Card", UDim2.new(0, 480, 0, 280),
        UDim2.new(0.5, 0, 0.5, 0), stealCamOverlay, UIHelpers.Theme.BgDark)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.ZIndex = 71
    UIHelpers.Corner(card, 12)
    UIHelpers.Stroke(card, UIHelpers.Theme.Danger, 3)

    UIHelpers.Label("Title", "💀 YOU GOT HEISTED!", UDim2.new(1, -16, 0, 40),
        UDim2.new(0, 8, 0, 12), card, { Color = UIHelpers.Theme.Danger }).ZIndex = 71

    local body = UIHelpers.Label("Body", "", UDim2.new(1, -32, 0, 120),
        UDim2.new(0, 16, 0, 60), card, {
        Color = UIHelpers.Theme.TextPrimary, Scaled = false, Font = Enum.Font.GothamMedium,
    })
    body.TextSize = 16
    body.TextWrapped = true
    body.ZIndex = 71

    UIHelpers.Button("Dismiss", "Dismiss", UDim2.new(0, 200, 0, 40),
        UDim2.new(0.5, -100, 1, -52), card, function()
            stealCamOverlay.Visible = false
        end).ZIndex = 71
end

local function showStealCam(data)
    if not stealCamOverlay then return end

    local card = stealCamOverlay.Card
    local body = card:FindFirstChild("Body")
    if body then
        body.Text = string.format(
            "%s heisted your icon!\n\nProtect your collection by vaulting valuable icons or buying a Heist Shield.",
            data.AttackerName or "Someone"
        )
    end

    stealCamOverlay.Visible = true

    -- Auto-dismiss after 8s
    task.delay(8, function()
        if stealCamOverlay and stealCamOverlay.Visible then
            stealCamOverlay.Visible = false
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- PUBLIC
-- ═══════════════════════════════════════════════════════════════

function HeistUI.OpenTargetPanel()
    refreshTargetList()
    if targetPanel then UIHelpers.OpenPanel(targetPanel) end
end

function HeistUI.CloseTargetPanel()
    if targetPanel then UIHelpers.ClosePanel(targetPanel) end
end

function HeistUI.Init(screenGui)
    screenGuiRef = screenGui

    buildTargetPanel(screenGui)
    buildCountdownOverlay(screenGui)
    buildLockpickOverlay(screenGui)
    buildStealCamOverlay(screenGui)

    local HeistController = require(script.Parent.Parent.Controllers.HeistController)

    HeistController.CountdownStarted:Connect(function(data)
        startCountdownAnimation(data.CountdownSeconds, data.TargetName)
    end)

    HeistController.LockpickStarted:Connect(function(data)
        startLockpickInput(data.TimeLimit, data.SequenceLength)
    end)

    HeistController.LockpickProgress:Connect(function(data)
        if lockpickPhase then
            lockpickPhase.Done = data.Progress
            showLockpickDots(data.Total, data.Progress)
        end
    end)

    HeistController.HeistCompleted:Connect(function(result)
        endLockpick()

        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController.ShowNotification then
            if result.Success then
                UIController.ShowNotification("HEIST SUCCESS!",
                    "You stole an icon from " .. (result.TargetName or "someone"), 5)
            else
                UIController.ShowNotification("Heist Failed",
                    result.Reason or "Try again later", 4)
            end
        end
    end)

    HeistController.StealCamTriggered:Connect(showStealCam)

    HeistController.HeistNotification:Connect(function(data)
        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController.ShowNotification then
            if data.Type == "HeistIncoming" then
                UIController.ShowNotification("⚠ HEIST IN PROGRESS",
                    (data.AttackerName or "Someone") .. " is trying to heist you!", 6)
            elseif data.Type == "HeistFailed" then
                UIController.ShowNotification("Heist Defended!",
                    (data.AttackerName or "Someone") .. " failed to heist you", 4)
            end
        end
    end)
end

return HeistUI
