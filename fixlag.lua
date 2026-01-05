-- Blox Fruits Custom Script FINAL (MERGED)
-- Gray ground + Transparent Sea (SAFE)
-- Fix CDK Z, Fix movement stutter, Remove 90% skill effects, Fix inventory

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--------------------------------------------------
-- Detect Sea
--------------------------------------------------
local function GetSea()
    local pos = RootPart.Position
    if pos.Y > 5000 then return 2 end
    if pos.Y < 0 then return 3 end
    return 1
end

--------------------------------------------------
-- Network ownership (anti lag movement)
--------------------------------------------------
local function SetNetworkOwnership()
    pcall(function()
        RootPart:SetNetworkOwner(LocalPlayer)
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part:SetNetworkOwner(LocalPlayer)
            end
        end
    end)
end

--------------------------------------------------
-- CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    local sea = GetSea()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "bush")
            or string.find(name, "house") or string.find(name, "building")
            or string.find(name, "decor") or string.find(name, "prop") then
                if not string.find(name, "ground")
                and not string.find(name, "terrain")
                and not string.find(name, "water")
                and not string.find(name, "sea") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- GRAY GROUND + TRANSPARENT SEA
--------------------------------------------------
local function GrayGroundAndTransparentSea()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end

    local GRAY = Color3.fromRGB(128,128,128)

    for _, material in ipairs(Enum.Material:GetEnumItems()) do
        pcall(function()
            Terrain:SetMaterialColor(material, GRAY)
        end)
    end

    Terrain.WaterTransparency = 1
    Terrain.WaterColor = GRAY
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0

    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Character) then
            local name = string.lower(part.Name)
            if not string.find(name, "sea")
            and not string.find(name, "water") then
                part.Color = GRAY
                part.Material = Enum.Material.Concrete
            end
        end
    end
end

--------------------------------------------------
-- REMOVE 90% EFFECTS (MERGED CORE)
--------------------------------------------------
local function RemoveHeavyEffects(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles")
    or obj:IsA("Explosion") then
        obj.Enabled = false
        obj:Destroy()
    end

    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    end

    if obj:IsA("Sound") then
        obj.Volume = 0
    end
end

local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            pcall(function()
                RemoveHeavyEffects(obj)
            end)
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
end

Workspace.DescendantAdded:Connect(function(obj)
    if not obj:IsDescendantOf(Character)
    and not obj:IsDescendantOf(LocalPlayer.Backpack) then
        pcall(function()
            RemoveHeavyEffects(obj)
        end)
    end
end)

--------------------------------------------------
-- FIX CDK Z
--------------------------------------------------
local function FixCDKIssues()
    RunService.Heartbeat:Connect(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and string.find(tool.Name:lower(), "katana") then
            local _, y, _ = RootPart.CFrame:ToEulerAnglesXYZ()
            RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, y, 0)
            Humanoid.PlatformStand = false
        end
    end)
end

--------------------------------------------------
-- FIX MOVEMENT STUTTER
--------------------------------------------------
local function FixMovementStutter()
    RunService.Heartbeat:Connect(function()
        local dir = Humanoid.MoveDirection
        if dir.Magnitude > 0 then
            local vel = RootPart.AssemblyLinearVelocity
            RootPart.AssemblyLinearVelocity = Vector3.new(
                dir.X * Humanoid.WalkSpeed,
                vel.Y,
                dir.Z * Humanoid.WalkSpeed
            )
        end
    end)
end

--------------------------------------------------
-- FIX INVENTORY
--------------------------------------------------
local function FixInventory()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
    end)
end

--------------------------------------------------
-- MAIN
--------------------------------------------------
SetNetworkOwnership()
ClearDecorations()
GrayGroundAndTransparentSea()
RemoveEffects()
FixCDKIssues()
FixMovementStutter()
FixInventory()

task.spawn(function()
    while true do
        task.wait(8)
        RemoveEffects()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    task.wait(1)
    SetNetworkOwnership()
    ClearDecorations()
    GrayGroundAndTransparentSea()
    RemoveEffects()
end)

print("✅ BLOX FRUITS FINAL MERGED: REMOVE ~90% EFFECTS | FPS BOOSTED")
