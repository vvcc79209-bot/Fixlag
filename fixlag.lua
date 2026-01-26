-- Blox Fruits Effect Optimizer
-- Remove 90% effects + Gray remaining effects
-- Client-side | Lag reduction

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Settings
local REMOVE_PERCENT = 0.9 -- 90%
local GRAY_COLOR = Color3.fromRGB(130,130,130)

-- Random remover
local function shouldRemove()
    return math.random() < REMOVE_PERCENT
end

-- Make gray
local function makeGray(obj)
    if obj:IsA("BasePart") then
        obj.Color = GRAY_COLOR
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.Transparency = math.clamp(obj.Transparency, 0, 0.4)
    elseif obj:IsA("ParticleEmitter") then
        obj.Color = ColorSequence.new(GRAY_COLOR)
        obj.LightEmission = 0
        obj.Size = NumberSequence.new(0.3)
        obj.Rate = obj.Rate * 0.2
    elseif obj:IsA("Trail") then
        obj.Color = ColorSequence.new(GRAY_COLOR)
        obj.Lifetime = obj.Lifetime * 0.4
    elseif obj:IsA("Beam") then
        obj.Color = ColorSequence.new(GRAY_COLOR)
        obj.Width0 *= 0.3
        obj.Width1 *= 0.3
    end
end

-- Handle effect object
local function handleEffect(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Explosion")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles") then
        
        if shouldRemove() then
            obj.Enabled = false
            task.delay(0.1, function()
                if obj then obj:Destroy() end
            end)
        else
            makeGray(obj)
        end
    end
end

-- Scan existing effects
for _, v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        handleEffect(v)
    end)
end

-- Detect new effects
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.02)
    pcall(function()
        handleEffect(obj)
    end)
end)

-- Reduce debris spam
RunService.Heartbeat:Connect(function()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Explosion") then
            v.BlastPressure = 0
            v.BlastRadius = 0
        end
    end
end)

print("✅ Blox Fruits: 90% effects removed, remaining effects turned gray")
