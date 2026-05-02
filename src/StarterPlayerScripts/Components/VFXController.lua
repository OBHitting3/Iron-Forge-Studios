--[[
    VFXController.lua (Client)
    Particle effects, screen flashes, camera shakes, and rarity glows.
    All client-side - server fires signals, client renders the spectacle.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Shared.Constants)

local VFXController = {}

-- ═══════════════════════════════════════════════════════════════
-- HATCH BURST (sparkle particles when egg cracks)
-- ═══════════════════════════════════════════════════════════════

function VFXController.PlayHatchBurst(rarity, position)
    local rarityData = Constants.Rarities[rarity or "Common"]
    local color = rarityData and rarityData.Color or Color3.fromRGB(255, 255, 255)

    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position or Vector3.new(0, 5, 0)
    part.Parent = workspace

    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    emitter.Color = ColorSequence.new(color)
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 2.0),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Lifetime = NumberRange.new(0.8, 1.5)
    emitter.Rate = 0
    emitter.Speed = NumberRange.new(8, 16)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.LightEmission = 0.8
    emitter.Parent = part

    -- Burst effect
    local count = 30
    if rarity == "Epic" then count = 60
    elseif rarity == "Legendary" then count = 100
    elseif rarity == "Mythical" then count = 150
    elseif rarity == "SECRET" then count = 250 end

    emitter:Emit(count)

    -- Cleanup
    task.delay(2, function()
        if part then part:Destroy() end
    end)

    -- Screen flash for high rarity
    if rarity == "Mythical" or rarity == "SECRET" then
        VFXController.ScreenFlash(color, 0.6)
    elseif rarity == "Legendary" then
        VFXController.ScreenFlash(color, 0.3)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- SCREEN FLASH
-- ═══════════════════════════════════════════════════════════════

function VFXController.ScreenFlash(color, intensity)
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screen = Instance.new("ScreenGui")
    screen.Name = "VFX_Flash"
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 999
    screen.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 1 - (intensity or 0.5)
    frame.BorderSizePixel = 0
    frame.Parent = screen

    TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1,
    }):Play()

    task.delay(0.7, function()
        if screen then screen:Destroy() end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- EVOLUTION SPARKLES
-- ═══════════════════════════════════════════════════════════════

function VFXController.PlayEvolveBurst(evolutionName, position)
    local color = Color3.fromRGB(255, 215, 0) -- gold
    if evolutionName == "Diamond" then color = Color3.fromRGB(180, 240, 255)
    elseif evolutionName == "Celestial" then color = Color3.fromRGB(255, 100, 255) end

    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Position = position or Vector3.new(0, 5, 0)
    part.Parent = workspace

    -- Light
    local light = Instance.new("PointLight")
    light.Color = color
    light.Brightness = 5
    light.Range = 20
    light.Parent = part

    -- Particles
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    emitter.Color = ColorSequence.new(color)
    emitter.Size = NumberSequence.new(1.5)
    emitter.Lifetime = NumberRange.new(1, 2)
    emitter.Speed = NumberRange.new(5, 10)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.LightEmission = 1
    emitter.Parent = part
    emitter:Emit(80)

    TweenService:Create(light, TweenInfo.new(1.5), { Brightness = 0 }):Play()

    task.delay(2.5, function()
        if part then part:Destroy() end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- HEIST SLOW-MO (Steal Cam)
-- ═══════════════════════════════════════════════════════════════

function VFXController.PlayStealCamEffect(duration)
    duration = duration or 2

    -- Color tint
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "StealCamCC"
    cc.Saturation = -0.5
    cc.Brightness = -0.2
    cc.TintColor = Color3.fromRGB(255, 100, 100)
    cc.Parent = Lighting

    -- Vignette via blur
    local blur = Instance.new("BlurEffect")
    blur.Name = "StealCamBlur"
    blur.Size = 8
    blur.Parent = Lighting

    -- Fade out
    task.delay(duration, function()
        TweenService:Create(cc, TweenInfo.new(0.5), {
            Saturation = 0,
            Brightness = 0,
            TintColor = Color3.fromRGB(255, 255, 255),
        }):Play()
        TweenService:Create(blur, TweenInfo.new(0.5), { Size = 0 }):Play()
        task.wait(0.6)
        if cc then cc:Destroy() end
        if blur then blur:Destroy() end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- CAMERA SHAKE
-- ═══════════════════════════════════════════════════════════════

local activeShake = nil

function VFXController.CameraShake(intensity, duration)
    intensity = intensity or 0.5
    duration = duration or 0.4

    if activeShake then return end -- prevent overlap

    activeShake = true
    local camera = workspace.CurrentCamera
    local elapsed = 0

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
        elapsed += dt
        if elapsed >= duration then
            conn:Disconnect()
            activeShake = nil
            return
        end

        local t = 1 - (elapsed / duration)
        local shakeX = (math.random() - 0.5) * intensity * t
        local shakeY = (math.random() - 0.5) * intensity * t
        camera.CFrame = camera.CFrame * CFrame.new(shakeX, shakeY, 0)
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════════════════════

function VFXController.Init(player)
    -- Hook into egg hatch results
    local EggController = require(script.Parent.Parent.Controllers.EggController)
    EggController.HatchResult:Connect(function(result)
        if result.Success and result.Icon then
            local character = player.Character
            local pos = character and character.PrimaryPart and character.PrimaryPart.Position
                or Vector3.new(0, 5, 0)
            VFXController.PlayHatchBurst(result.Icon.Rarity, pos)
        end
    end)

    EggController.EvolveResult:Connect(function(result)
        if result.Success then
            local character = player.Character
            local pos = character and character.PrimaryPart and character.PrimaryPart.Position
                or Vector3.new(0, 5, 0)
            VFXController.PlayEvolveBurst(result.NewEvolution, pos)
        end
    end)

    -- Heist effects
    local HeistController = require(script.Parent.Parent.Controllers.HeistController)
    HeistController.StealCamTriggered:Connect(function()
        VFXController.PlayStealCamEffect(3)
        VFXController.CameraShake(1.0, 0.6)
    end)

    HeistController.HeistCompleted:Connect(function(result)
        if result.Success then
            VFXController.ScreenFlash(Color3.fromRGB(120, 220, 120), 0.4)
        else
            VFXController.ScreenFlash(Color3.fromRGB(230, 90, 90), 0.4)
            VFXController.CameraShake(0.5, 0.3)
        end
    end)
end

return VFXController
