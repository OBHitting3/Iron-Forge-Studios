--[[
    LeaderboardUI.lua (Client)
    Tabbed leaderboard viewer for the 4 boards.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Modules.Shared.Remotes)
local Util = require(ReplicatedStorage.Modules.Shared.Util)
local UIHelpers = require(script.Parent.UIHelpers)

local LeaderboardUI = {}

local panel = nil
local content = nil
local currentBoard = "TopCollectors"
local tabButtons = {}

local BOARDS = {
    { Key = "TopCollectors", Display = "Top Collectors",   Suffix = " icons" },
    { Key = "Richest",       Display = "Richest",          Suffix = " DC"   },
    { Key = "BestHeists",    Display = "Best Heists",      Suffix = " wins" },
    { Key = "TopOasis",      Display = "Top Oasis",        Suffix = " ★"    },
}

local function fetchAndDisplay(boardKey)
    if not content then return end
    for _, child in content:GetChildren() do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end

    local loadingLbl = UIHelpers.Label("Loading", "Loading...", UDim2.new(1, -16, 0, 30),
        UDim2.new(0, 8, 0, 8), content, { Color = UIHelpers.Theme.TextSecondary })

    task.spawn(function()
        local success, entries = pcall(function()
            return Remotes.GetFunction("LeaderboardData"):InvokeServer(boardKey)
        end)

        if loadingLbl then loadingLbl:Destroy() end
        if not content then return end

        if not success or not entries or #entries == 0 then
            UIHelpers.Label("Empty", "No data available yet", UDim2.new(1, -16, 0, 30),
                UDim2.new(0, 8, 0, 8), content, { Color = UIHelpers.Theme.TextSecondary })
            return
        end

        local boardInfo
        for _, b in BOARDS do
            if b.Key == boardKey then boardInfo = b break end
        end

        for rank, entry in entries do
            local row = UIHelpers.Frame("Row_" .. rank, UDim2.new(1, -16, 0, 44),
                nil, content, UIHelpers.Theme.BgLight)
            row.LayoutOrder = rank
            UIHelpers.Corner(row, 6)

            local rankColor = UIHelpers.Theme.TextSecondary
            if rank == 1 then rankColor = Color3.fromRGB(255, 215, 0)
            elseif rank == 2 then rankColor = Color3.fromRGB(192, 192, 192)
            elseif rank == 3 then rankColor = Color3.fromRGB(205, 127, 50) end

            local rankLbl = UIHelpers.Label("Rank", "#" .. rank,
                UDim2.new(0, 50, 1, 0), UDim2.new(0, 8, 0, 0), row, {
                Color = rankColor, Font = Enum.Font.GothamBold,
            })

            UIHelpers.Label("Name", entry.Name or "Unknown",
                UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 64, 0, 0), row, {
                Color = UIHelpers.Theme.TextPrimary, XAlign = Enum.TextXAlignment.Left,
                Scaled = false, Font = Enum.Font.GothamMedium,
            }).TextSize = 14

            local valueText = entry.Value or 0
            if boardKey == "TopOasis" then
                valueText = string.format("%.1f", valueText / 100)
            else
                valueText = Util.FormatNumber(valueText)
            end

            UIHelpers.Label("Value", valueText .. (boardInfo and boardInfo.Suffix or ""),
                UDim2.new(0.4, 0, 1, 0), UDim2.new(0.6, 0, 0, 0), row, {
                Color = UIHelpers.Theme.AccentSoft, XAlign = Enum.TextXAlignment.Right,
                Scaled = false, Font = Enum.Font.GothamBold,
            }).TextSize = 14
        end
    end)
end

local function switchBoard(key)
    currentBoard = key
    for boardKey, btn in tabButtons do
        if boardKey == key then
            btn.BackgroundColor3 = UIHelpers.Theme.Accent
            btn.TextColor3 = UIHelpers.Theme.BgDark
        else
            btn.BackgroundColor3 = UIHelpers.Theme.BgLight
            btn.TextColor3 = UIHelpers.Theme.AccentSoft
        end
    end
    fetchAndDisplay(key)
end

local function buildPanel(parent)
    panel = UIHelpers.Frame("LeaderboardPanel", UDim2.new(0, 580, 0, 540),
        UDim2.new(0.5, 0, 0.5, 0), parent, UIHelpers.Theme.BgDark)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Visible = false
    UIHelpers.Corner(panel, 14)
    UIHelpers.Stroke(panel, UIHelpers.Theme.Border, 2)

    UIHelpers.Label("Title", "🏆 Leaderboards", UDim2.new(1, -100, 0, 50),
        UDim2.new(0, 16, 0, 8), panel, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    })

    UIHelpers.MakeCloseButton(panel, function() LeaderboardUI.Close() end)

    -- Tab buttons
    local tabsFrame = UIHelpers.Frame("Tabs", UDim2.new(1, -32, 0, 38),
        UDim2.new(0, 16, 0, 64), panel, UIHelpers.Theme.BgMedium)
    UIHelpers.Corner(tabsFrame, 6)
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabsFrame
    UIHelpers.Padding(tabsFrame, 4)

    for i, board in BOARDS do
        local btn = UIHelpers.Button("Tab_" .. board.Key, board.Display, UDim2.new(0, 130, 1, -8),
            nil, tabsFrame, function() switchBoard(board.Key) end)
        btn.LayoutOrder = i
        tabButtons[board.Key] = btn
    end

    content = UIHelpers.ScrollFrame("Content", UDim2.new(1, -32, 1, -120),
        UDim2.new(0, 16, 0, 110), panel)
    UIHelpers.ListLayout(content, 4)
    UIHelpers.Padding(content, 4)
end

function LeaderboardUI.Open()
    if panel then
        UIHelpers.OpenPanel(panel)
        switchBoard(currentBoard)
    end
end

function LeaderboardUI.Close()
    if panel then UIHelpers.ClosePanel(panel) end
end

function LeaderboardUI.Init(screenGui)
    buildPanel(screenGui)
end

return LeaderboardUI
