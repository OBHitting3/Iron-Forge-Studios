--[[
    ClientInit.client.lua
    Main client bootstrap. Initializes controllers, components, and UI in order.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Wait for essential modules
ReplicatedStorage:WaitForChild("Modules")

print("[Client] Initializing Palm Springs Paradise...")

-- Initialize controllers and components in order.
-- UIController must be last because panels rely on other controllers being loaded.
local InitOrder = {
    { Name = "DataController",  Path = script.Parent.Controllers.DataController },
    { Name = "EggController",   Path = script.Parent.Controllers.EggController },
    { Name = "HeistController", Path = script.Parent.Controllers.HeistController },
    { Name = "PlotController",  Path = script.Parent.Controllers.PlotController },
    { Name = "TradeController", Path = script.Parent.Controllers.TradeController },
    { Name = "VFXController",   Path = script.Parent.Components.VFXController },
    { Name = "SoundController", Path = script.Parent.Components.SoundController },
    { Name = "UIController",    Path = script.Parent.Controllers.UIController },
}

for _, entry in InitOrder do
    local startTime = os.clock()
    local mod = entry.Path
    if not mod then
        warn(string.format("  [Client] %s missing!", entry.Name))
        continue
    end

    local ok, module = pcall(require, mod)
    if not ok then
        warn(string.format("  [Client] %s require failed: %s", entry.Name, tostring(module)))
        continue
    end

    if not module or not module.Init then
        warn(string.format("  [Client] %s has no Init()", entry.Name))
        continue
    end

    local initOk, err = pcall(module.Init, player)
    local elapsed = math.floor((os.clock() - startTime) * 1000)

    if initOk then
        print(string.format("  [Client] ✓ %s ready (%dms)", entry.Name, elapsed))
    else
        warn(string.format("  [Client] ✗ %s failed: %s", entry.Name, tostring(err)))
    end
end

print("[Client] All systems ready!")
