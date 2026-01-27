-- Blox Fruits - Remove 95% Effects + Gray 5%
-- Client-side | Anti-lag focused

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

-- CONFIG
local REMOVE_RATE = 0.95 -- 95% remove
local GRAY_COLOR = Color3.fromRGB(120,120,120)

-- Random helper
math.randomseed(tick())
local function shouldRemove()
    return math.random() < REMOVE_RATE
end

-- Grayify function
local function grayify(obj)
    if obj:IsA("ParticleEmitter") then
        obj.Color = ColorSequence.new(GRAY_COLOR)
        obj.LightEmission = 0
        obj.LightInfluence = 0
    elseif obj:IsA("Beam") then
        obj.Color = ColorSequence.new(GRAY_COLOR)
        obj.LightEmission = 0
    elseif obj:IsA("Trail") then
        obj.Color = ColorSequence.new(GRAY_COLOR)
        obj.LightEmission = 0
    elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj.Color = GRAY_COLOR
        obj.Brightness = 0.2
    end
end

-- Process effects
local function handle(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Beam")
    or obj:IsA("Trail")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles")
    or obj:IsA("PointLight")
    or obj:IsA("SpotLight")
    or obj:IsA("SurfaceLight") then

        if shouldRemove() then
            obj:Destroy()
        else
            grayify(obj)
        end
    end
end

-- Scan existing
for _,v in ipairs(Workspace:GetDescendants()) do
    handle(v)
end

-- Scan new effects (skills spam)
Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.05)
    handle(v)
end)

-- Character effects
local function onChar(char)
    for _,v in ipairs(char:GetDescendants()) do
        handle(v)
    end
end

if lp.Character then
    onChar(lp.Character)
end

lp.CharacterAdded:Connect(onChar)

print("✅ Blox Fruits: Removed 95% effects, remaining turned GRAY")
