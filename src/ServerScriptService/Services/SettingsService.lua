--[[
    SettingsService.lua (Server)
    Handles client setting updates (volume sliders, notification toggles).
    Validates and persists to player data.
]]

local Players = game:GetService("Players")

local Remotes = require(game.ReplicatedStorage.Modules.Shared.Remotes)
local Util = require(game.ReplicatedStorage.Modules.Shared.Util)

local DataService -- deferred

local SettingsService = {}

local ALLOWED_KEYS = {
    MusicVolume = "number",
    SFXVolume = "number",
    ShowTradeRequests = "boolean",
    HeistNotifications = "boolean",
}

local function handleSettingUpdate(player, payload)
    if type(payload) ~= "table" then return end
    local key = payload.Key
    local value = payload.Value

    local expectedType = ALLOWED_KEYS[key]
    if not expectedType then return end
    if type(value) ~= expectedType then return end

    if expectedType == "number" then
        value = Util.Clamp(value, 0, 1)
    end

    local data = DataService.GetData(player)
    if not data then return end

    data.Settings = data.Settings or {}
    data.Settings[key] = value

    Remotes.GetEvent("PlayerDataUpdate"):FireClient(player, "Settings." .. key, value)
end

function SettingsService.Init()
    DataService = require(game.ServerScriptService.Services.DataService)
    Remotes.GetEvent("SettingsUpdate").OnServerEvent:Connect(handleSettingUpdate)
    print("[SettingsService] Initialized")
end

return SettingsService
