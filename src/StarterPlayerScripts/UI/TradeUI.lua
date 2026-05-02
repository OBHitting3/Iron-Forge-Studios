--[[
    TradeUI.lua (Client)
    - Incoming trade request popup
    - Trade window (offers, confirm, cancel)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Util = require(ReplicatedStorage.Modules.Shared.Util)
local IconDatabase = require(ReplicatedStorage.Modules.Data.IconDatabase)
local UIHelpers = require(script.Parent.UIHelpers)

local TradeUI = {}

local screenGuiRef = nil
local requestPopup = nil
local tradeWindow = nil

-- ═══════════════════════════════════════════════════════════════
-- INCOMING REQUEST POPUP
-- ═══════════════════════════════════════════════════════════════

local function buildRequestPopup(parent)
    requestPopup = UIHelpers.Frame("TradeRequest", UDim2.new(0, 360, 0, 180),
        UDim2.new(0.5, 0, 0, 100), parent, UIHelpers.Theme.BgDark)
    requestPopup.AnchorPoint = Vector2.new(0.5, 0)
    requestPopup.Visible = false
    requestPopup.ZIndex = 30
    UIHelpers.Corner(requestPopup, 12)
    UIHelpers.Stroke(requestPopup, UIHelpers.Theme.Accent, 2)

    UIHelpers.Label("Title", "Trade Request", UDim2.new(1, -16, 0, 30),
        UDim2.new(0, 8, 0, 8), requestPopup, { Color = UIHelpers.Theme.Accent }).ZIndex = 31

    local body = UIHelpers.Label("Body", "", UDim2.new(1, -32, 0, 50),
        UDim2.new(0, 16, 0, 44), requestPopup, {
        Color = UIHelpers.Theme.TextPrimary, Scaled = false, Font = Enum.Font.GothamMedium,
    })
    body.TextSize = 15
    body.TextWrapped = true
    body.ZIndex = 31

    local accept = UIHelpers.Button("Accept", "Accept", UDim2.new(0, 130, 0, 38),
        UDim2.new(0, 16, 1, -50), requestPopup, function()
            if requestPopup:GetAttribute("TradeId") then
                local TradeController = require(script.Parent.Parent.Controllers.TradeController)
                TradeController.RespondToTrade(requestPopup:GetAttribute("TradeId"), true)
                requestPopup.Visible = false
            end
        end)
    accept.BackgroundColor3 = UIHelpers.Theme.Success
    accept.ZIndex = 31

    local decline = UIHelpers.Button("Decline", "Decline", UDim2.new(0, 130, 0, 38),
        UDim2.new(1, -146, 1, -50), requestPopup, function()
            if requestPopup:GetAttribute("TradeId") then
                local TradeController = require(script.Parent.Parent.Controllers.TradeController)
                TradeController.RespondToTrade(requestPopup:GetAttribute("TradeId"), false)
                requestPopup.Visible = false
            end
        end)
    decline.BackgroundColor3 = UIHelpers.Theme.Danger
    decline.ZIndex = 31
end

local function showTradeRequest(data)
    if not requestPopup then return end
    requestPopup:SetAttribute("TradeId", data.TradeId)
    local body = requestPopup:FindFirstChild("Body")
    if body then
        body.Text = string.format("%s wants to trade with you", data.SenderName or "Someone")
    end
    requestPopup.Visible = true

    task.delay(30, function()
        if requestPopup and requestPopup.Visible
            and requestPopup:GetAttribute("TradeId") == data.TradeId then
            requestPopup.Visible = false
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- TRADE WINDOW
-- ═══════════════════════════════════════════════════════════════

local function buildTradeWindow(parent)
    tradeWindow = UIHelpers.Frame("TradeWindow", UDim2.new(0, 720, 0, 480),
        UDim2.new(0.5, 0, 0.5, 0), parent, UIHelpers.Theme.BgDark)
    tradeWindow.AnchorPoint = Vector2.new(0.5, 0.5)
    tradeWindow.Visible = false
    tradeWindow.ZIndex = 25
    UIHelpers.Corner(tradeWindow, 12)
    UIHelpers.Stroke(tradeWindow, UIHelpers.Theme.Border, 2)

    UIHelpers.Label("Title", "🤝 Trade", UDim2.new(1, -100, 0, 40),
        UDim2.new(0, 16, 0, 8), tradeWindow, {
        Color = UIHelpers.Theme.Accent, XAlign = Enum.TextXAlignment.Left,
    }).ZIndex = 26

    UIHelpers.MakeCloseButton(tradeWindow, function()
        local TradeController = require(script.Parent.Parent.Controllers.TradeController)
        local trade = TradeController.GetActiveTrade()
        if trade then TradeController.CancelTrade(trade.TradeId) end
        tradeWindow.Visible = false
    end).ZIndex = 26

    -- Two side-by-side panels
    local function makeOfferPanel(name, x, isMine)
        local panel = UIHelpers.Frame(name, UDim2.new(0, 320, 1, -120),
            UDim2.new(0, x, 0, 60), tradeWindow, UIHelpers.Theme.BgMedium)
        panel.ZIndex = 26
        UIHelpers.Corner(panel, 8)

        local title = UIHelpers.Label("Title", isMine and "Your Offer" or "Their Offer",
            UDim2.new(1, -16, 0, 24), UDim2.new(0, 8, 0, 4), panel, {
            Color = UIHelpers.Theme.AccentSoft, Scaled = false, Font = Enum.Font.GothamBold,
        })
        title.TextSize = 14
        title.ZIndex = 27

        local listScroll = UIHelpers.ScrollFrame("Items", UDim2.new(1, -16, 1, -90),
            UDim2.new(0, 8, 0, 32), panel)
        listScroll.ZIndex = 27
        UIHelpers.GridLayout(listScroll, UDim2.new(0, 70, 0, 70), 4)

        local dcLabel = UIHelpers.Label("DC", "DC: 0", UDim2.new(1, -16, 0, 24),
            UDim2.new(0, 8, 1, -54), panel, {
            Color = Color3.fromRGB(255, 215, 0), Scaled = false, Font = Enum.Font.GothamBold,
        })
        dcLabel.TextSize = 13
        dcLabel.ZIndex = 27

        local confirmLabel = UIHelpers.Label("Confirmed", "❌ Not Confirmed",
            UDim2.new(1, -16, 0, 22), UDim2.new(0, 8, 1, -28), panel, {
            Color = UIHelpers.Theme.Danger, Scaled = false, Font = Enum.Font.GothamMedium,
        })
        confirmLabel.TextSize = 12
        confirmLabel.ZIndex = 27

        return panel
    end

    makeOfferPanel("MyOffer", 16, true)
    makeOfferPanel("TheirOffer", 360, false)

    -- Bottom action buttons
    UIHelpers.Button("ConfirmBtn", "✓ Confirm Trade", UDim2.new(0, 200, 0, 40),
        UDim2.new(0.5, -210, 1, -50), tradeWindow, function()
            local TradeController = require(script.Parent.Parent.Controllers.TradeController)
            local trade = TradeController.GetActiveTrade()
            if trade then TradeController.ConfirmTrade(trade.TradeId) end
        end).ZIndex = 26

    local cancelBtn = UIHelpers.Button("CancelBtn", "✗ Cancel", UDim2.new(0, 200, 0, 40),
        UDim2.new(0.5, 10, 1, -50), tradeWindow, function()
            local TradeController = require(script.Parent.Parent.Controllers.TradeController)
            local trade = TradeController.GetActiveTrade()
            if trade then TradeController.CancelTrade(trade.TradeId) end
        end)
    cancelBtn.BackgroundColor3 = UIHelpers.Theme.Danger
    cancelBtn.ZIndex = 26
end

local function refreshOffer(side, offer)
    if not tradeWindow or not tradeWindow.Visible then return end
    local panel = tradeWindow:FindFirstChild(side)
    if not panel then return end

    local items = panel:FindFirstChild("Items")
    if items then
        for _, child in items:GetChildren() do
            if child:IsA("Frame") then child:Destroy() end
        end

        for _, uid in (offer.Icons or {}) do
            local DataController = require(script.Parent.Parent.Controllers.DataController)
            local data = DataController.GetData()
            local iconInstance = nil
            if data then
                for _, ic in data.Icons do
                    if ic.UID == uid then iconInstance = ic break end
                end
            end

            local card = UIHelpers.Frame("Item_" .. uid, UDim2.new(0, 70, 0, 70),
                nil, items, UIHelpers.Theme.BgLight)
            UIHelpers.Corner(card, 6)

            if iconInstance then
                local def = IconDatabase.GetById(iconInstance.IconId)
                if def then
                    UIHelpers.Stroke(card, UIHelpers.RarityColor(def.Rarity), 2)
                    local lbl = UIHelpers.Label("Name", def.Name,
                        UDim2.new(1, -4, 1, -4), UDim2.new(0, 2, 0, 2), card, {
                        Color = UIHelpers.Theme.TextPrimary, Scaled = false, Font = Enum.Font.Gotham,
                    })
                    lbl.TextSize = 9
                    lbl.TextWrapped = true
                end
            end
        end
    end

    local dcLabel = panel:FindFirstChild("DC")
    if dcLabel then
        dcLabel.Text = "DC: " .. Util.FormatNumber(offer.DC or 0)
    end
end

local function refreshConfirm(mineConfirmed, theirsConfirmed)
    if not tradeWindow or not tradeWindow.Visible then return end
    local function updatePanel(side, isConfirmed)
        local panel = tradeWindow:FindFirstChild(side)
        if not panel then return end
        local lbl = panel:FindFirstChild("Confirmed")
        if lbl then
            lbl.Text = isConfirmed and "✓ Confirmed" or "❌ Not Confirmed"
            lbl.TextColor3 = isConfirmed and UIHelpers.Theme.Success or UIHelpers.Theme.Danger
        end
    end
    updatePanel("MyOffer", mineConfirmed)
    updatePanel("TheirOffer", theirsConfirmed)
end

-- ═══════════════════════════════════════════════════════════════
-- PUBLIC
-- ═══════════════════════════════════════════════════════════════

function TradeUI.Init(screenGui)
    screenGuiRef = screenGui
    buildRequestPopup(screenGui)
    buildTradeWindow(screenGui)

    local TradeController = require(script.Parent.Parent.Controllers.TradeController)

    TradeController.TradeRequested:Connect(showTradeRequest)

    TradeController.TradeAccepted:Connect(function(data)
        tradeWindow.Visible = true
        UIHelpers.OpenPanel(tradeWindow)
    end)

    TradeController.OfferUpdated:Connect(function(data)
        local localPlayer = Players.LocalPlayer
        local trade = TradeController.GetActiveTrade()
        -- Determine which side is "mine" (no Player1/Player2 marker on client; both shown)
        refreshOffer("MyOffer", data.Player1Offer or {})
        refreshOffer("TheirOffer", data.Player2Offer or {})
    end)

    TradeController.ConfirmUpdated:Connect(function(data)
        refreshConfirm(data.Player1Confirmed, data.Player2Confirmed)
    end)

    TradeController.TradeCompleted:Connect(function()
        tradeWindow.Visible = false
        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController.ShowNotification then
            UIController.ShowNotification("Trade Complete", "Items exchanged successfully!", 4)
        end
    end)

    TradeController.TradeCancelled:Connect(function(data)
        tradeWindow.Visible = false
        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController.ShowNotification then
            UIController.ShowNotification("Trade Cancelled",
                (data.CancelledBy or "Someone") .. " cancelled the trade", 4)
        end
    end)

    TradeController.TradeError:Connect(function(data)
        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController.ShowNotification then
            UIController.ShowNotification("Trade Error", data.Reason or "Unknown error", 4)
        end
    end)

    TradeController.TradeDeclined:Connect(function()
        local UIController = require(script.Parent.Parent.Controllers.UIController)
        if UIController.ShowNotification then
            UIController.ShowNotification("Trade Declined", "Player declined your trade request", 3)
        end
    end)
end

return TradeUI
