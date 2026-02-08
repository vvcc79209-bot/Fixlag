--// Visual Optimizer - Grey World + Reduce Effects (Client Side)
--// Designed to minimize conflicts (non-destructive edits)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local TAG = "VISUAL_OPTIMIZED"

--// CONFIG
local EFFECT_REDUCTION = 0.95

--// Helper: check sky objects
local function isSkyObject(obj)
    if obj:IsDescendantOf(Lighting) then
        if obj:IsA("Sky") or obj.Name:lower():find("sky") then
            return true
        end
    end
    return false
end

--// Reduce visual effects safely
local function reduceEffects(obj)
    if CollectionService:HasTag(obj, TAG) then return end

    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj.Rate = obj.Rate * (1 - EFFECT_REDUCTION)
        obj.Lifetime = NumberRange.new(0)
        CollectionService:AddTag(obj, TAG)

    elseif obj:IsA("Beam") then
        obj.Enabled = false
        CollectionService:AddTag(obj, TAG)

    elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj.Brightness = obj.Brightness * 0.05
        CollectionService:AddTag(obj, TAG)

    elseif obj:IsA("Explosion") then
        obj.Visible = false
        CollectionService:AddTag(obj, TAG)
    end
end

--// Grey world filter (except sky)
local function greyify(obj)
    if CollectionService:HasTag(obj, TAG) then return end
    if isSkyObject(obj) then return end

    if obj:IsA("BasePart") then
        obj.Color = Color3.fromRGB(128,128,128)
        obj.Material = Enum.Material.SmoothPlastic
        CollectionService:AddTag(obj, TAG)

    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Color3 = Color3.fromRGB(150,150,150)
        CollectionService:AddTag(obj, TAG)
    end
end

--// Process existing objects
for _,obj in ipairs(workspace:GetDescendants()) do
    pcall(function()
        reduceEffects(obj)
        greyify(obj)
    end)
end

--// Process new objects (skills spawn liên tục)
workspace.DescendantAdded:Connect(function(obj)
    task.wait()
    pcall(function()
        reduceEffects(obj)
        greyify(obj)
    end)
end)

--// Lighting tweak (giữ sky nhưng giảm màu tổng thể)
Lighting.Brightness = 1
Lighting.GlobalShadows = false
Lighting.FogEnd = 100000

print("Visual Optimizer Loaded")
