--[[
    SoundController.lua (Client)
    Centralized sound playback. Maps sound names to Roblox asset IDs.
    Replace placeholder asset IDs with real sounds before shipping.
]]

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SoundController = {}

-- ═══════════════════════════════════════════════════════════════
-- SOUND LIBRARY
-- Replace these IDs with real Roblox audio assets in production.
-- Format: rbxassetid://AUDIO_ID
-- ═══════════════════════════════════════════════════════════════
local SOUNDS = {
    -- UI
    UIClick      = { Id = "rbxassetid://6895079853", Volume = 0.5 },
    UIOpen       = { Id = "rbxassetid://6895079853", Volume = 0.4 },
    UIClose      = { Id = "rbxassetid://6895079853", Volume = 0.4 },
    Notification = { Id = "rbxassetid://9118821061", Volume = 0.5 },

    -- Egg / Hatching
    EggCrack    = { Id = "rbxassetid://9119737655", Volume = 0.6 },
    HatchCommon = { Id = "rbxassetid://9119737655", Volume = 0.5 },
    HatchRare   = { Id = "rbxassetid://9119737655", Volume = 0.7 },
    HatchEpic   = { Id = "rbxassetid://9119737655", Volume = 0.8 },
    HatchLegend = { Id = "rbxassetid://9119737655", Volume = 1.0 },
    HatchSecret = { Id = "rbxassetid://9119737655", Volume = 1.0 },

    -- Heist
    HeistAlarm  = { Id = "rbxassetid://9118821061", Volume = 0.7 },
    HeistTick   = { Id = "rbxassetid://6895079853", Volume = 0.4 },
    HeistFail   = { Id = "rbxassetid://9119737655", Volume = 0.7 },
    HeistWin    = { Id = "rbxassetid://9119737655", Volume = 0.8 },
    LockpickHit = { Id = "rbxassetid://6895079853", Volume = 0.5 },
    LockpickMiss = { Id = "rbxassetid://9119737655", Volume = 0.6 },

    -- Currency
    CoinGain    = { Id = "rbxassetid://6895079853", Volume = 0.4 },
    Purchase    = { Id = "rbxassetid://9118821061", Volume = 0.6 },

    -- Trade
    TradeOpen   = { Id = "rbxassetid://6895079853", Volume = 0.5 },
    TradeClose  = { Id = "rbxassetid://6895079853", Volume = 0.5 },
    TradeReady  = { Id = "rbxassetid://9119737655", Volume = 0.6 },

    -- Building
    PlaceItem   = { Id = "rbxassetid://6895079853", Volume = 0.4 },
    RemoveItem  = { Id = "rbxassetid://9119737655", Volume = 0.4 },

    -- Ambient
    AmbientDesert = { Id = "rbxassetid://1838107296", Volume = 0.15, Looped = true },
}

local musicVolume = 0.5
local sfxVolume = 0.8
local soundCache = {}

-- ═══════════════════════════════════════════════════════════════
-- PRELOAD
-- ═══════════════════════════════════════════════════════════════

local function getOrCreateSound(name)
    if soundCache[name] then return soundCache[name] end

    local def = SOUNDS[name]
    if not def then
        warn("[SoundController] Unknown sound:", name)
        return nil
    end

    local sound = Instance.new("Sound")
    sound.Name = "SFX_" .. name
    sound.SoundId = def.Id
    sound.Volume = (def.Volume or 0.5) * sfxVolume
    sound.Looped = def.Looped or false
    sound.Parent = SoundService

    soundCache[name] = sound
    return sound
end

-- ═══════════════════════════════════════════════════════════════
-- PUBLIC API
-- ═══════════════════════════════════════════════════════════════

function SoundController.Play(name)
    local sound = getOrCreateSound(name)
    if not sound then return end

    -- For non-looped sounds, clone so multiple can overlap
    if not sound.Looped then
        local clone = sound:Clone()
        clone.Parent = SoundService
        clone:Play()
        clone.Ended:Connect(function() clone:Destroy() end)
        -- Also cleanup if interrupted
        task.delay(10, function() if clone then clone:Destroy() end end)
    else
        sound:Play()
    end
end

function SoundController.Stop(name)
    local sound = soundCache[name]
    if sound then sound:Stop() end
end

function SoundController.SetSFXVolume(vol)
    sfxVolume = math.clamp(vol, 0, 1)
    for name, sound in soundCache do
        local def = SOUNDS[name]
        if def and not def.Looped then
            sound.Volume = (def.Volume or 0.5) * sfxVolume
        end
    end
end

function SoundController.SetMusicVolume(vol)
    musicVolume = math.clamp(vol, 0, 1)
    for name, sound in soundCache do
        local def = SOUNDS[name]
        if def and def.Looped then
            sound.Volume = (def.Volume or 0.5) * musicVolume
        end
    end
end

-- Convenience helpers
function SoundController.PlayHatchSound(rarity)
    if rarity == "SECRET" then SoundController.Play("HatchSecret")
    elseif rarity == "Mythical" or rarity == "Legendary" then SoundController.Play("HatchLegend")
    elseif rarity == "Epic" then SoundController.Play("HatchEpic")
    elseif rarity == "Rare" then SoundController.Play("HatchRare")
    else SoundController.Play("HatchCommon") end
end

-- ═══════════════════════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════════════════════

function SoundController.Init(player)
    -- Start ambient
    SoundController.Play("AmbientDesert")

    -- Hook into events
    local EggController = require(script.Parent.Parent.Controllers.EggController)
    EggController.HatchResult:Connect(function(result)
        if result.Success and result.Icon then
            SoundController.Play("EggCrack")
            task.delay(0.4, function()
                SoundController.PlayHatchSound(result.Icon.Rarity)
            end)
        else
            SoundController.Play("HatchFail")
        end
    end)

    EggController.EvolveResult:Connect(function(result)
        if result.Success then
            SoundController.Play("HatchLegend")
        end
    end)

    local HeistController = require(script.Parent.Parent.Controllers.HeistController)
    HeistController.CountdownStarted:Connect(function()
        SoundController.Play("HeistAlarm")
    end)
    HeistController.LockpickProgress:Connect(function(data)
        if data.Correct then
            SoundController.Play("LockpickHit")
        else
            SoundController.Play("LockpickMiss")
        end
    end)
    HeistController.HeistCompleted:Connect(function(result)
        if result.Success then
            SoundController.Play("HeistWin")
        else
            SoundController.Play("HeistFail")
        end
    end)
    HeistController.StealCamTriggered:Connect(function()
        SoundController.Play("HeistAlarm")
    end)

    local TradeController = require(script.Parent.Parent.Controllers.TradeController)
    TradeController.TradeAccepted:Connect(function() SoundController.Play("TradeOpen") end)
    TradeController.TradeCompleted:Connect(function() SoundController.Play("TradeReady") end)

    -- Currency change feedback
    local DataController = require(script.Parent.Parent.Controllers.DataController)
    DataController.DataChanged:Connect(function(field, newValue, oldValue)
        if field == "Currency" and oldValue and newValue and newValue > oldValue then
            -- Don't spam on passive ticks (small gains)
            if newValue - oldValue >= 50 then
                SoundController.Play("CoinGain")
            end
        end
    end)
end

return SoundController
