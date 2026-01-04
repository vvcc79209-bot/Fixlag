-- Blox Fruits Custom Script FINAL
-- Gray ground + Invisible Sea (SAFE)
-- Remove ALL skill effects (Fruit / Melee / Gun / Sword)
-- Gray NPC auto
-- Fix CDK Z, Fix movement stutter, Fix inventory

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

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
-- Network ownership
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
-- CLEAR DECOR
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = string.lower(obj.Name)
            if n:find("tree") or n:find("rock") or n:find("bush")
            or n:find("house") or n:find("decor") or n:find("prop") then
                if not n:find("ground") and not n:find("terrain") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- GRAY GROUND + INVISIBLE SEA (CORE)
--------------------------------------------------
local function GrayGroundAndTransparentSea()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end
    local GRAY = Color3.fromRGB(128,128,128)

    for _, mat in ipairs(Enum.Material:GetEnumItems()) do
        pcall(function()
            Terrain:SetMaterialColor(mat, GRAY)
        end)
    end

    Terrain.WaterTransparency = 1
    Terrain.WaterColor = GRAY
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0

    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Character) then
            local n = string.lower(part.Name)
            if not n:find("water") and not n:find("sea") then
                part.Color = GRAY
                part.Material = Enum.Material.Concrete
            end
        end
    end
end

--------------------------------------------------
-- GRAY NPC (AUTO)
--------------------------------------------------
local function GrayNPCModel(model)
    for _, p in pairs(model:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Color = Color3.fromRGB(128,128,128)
            p.Material = Enum.Material.Concrete
        end
    end
end

local function GrayAllNPC()
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc ~= Character then
            GrayNPCModel(npc)
        end
    end
end

Workspace.ChildAdded:Connect(function(obj)
    task.wait(0.3)
    if obj:FindFirstChild("Humanoid") and obj ~= Character then
        GrayNPCModel(obj)
    end
end)

--------------------------------------------------
-- REMOVE ALL SKILL / KILL EFFECTS (CORE GHÉP)
--------------------------------------------------
local EffectClasses = {
    ParticleEmitter = true,
    Beam = true,
    Trail = true,
    Explosion = true,
    Fire = true,
    Smoke = true,
    Sparkles = true
}

local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if EffectClasses[obj.ClassName] then
            if not obj:IsDescendantOf(Character)
            and not obj:IsDescendantOf(LocalPlayer.Backpack) then
                pcall(function() obj:Destroy() end)
            end
        elseif obj:IsA("Attachment") then
            local n = string.lower(obj.Name)
            if n:find("fx") or n:find("slash") or n:find("wave")
            or n:find("ring") or n:find("aura") then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
end

--------------------------------------------------
-- FIX CDK Z
--------------------------------------------------
local function FixCDKIssues()
    RunService.Heartbeat:Connect(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name:lower():find("katana") then
            local _, y, _ = RootPart.CFrame:ToEulerAnglesXYZ()
            RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, y, 0)
            Humanoid.PlatformStand = false
        end
    end)
end

--------------------------------------------------
-- FIX MOVEMENT
--------------------------------------------------
local function FixMovementStutter()
    RunService.Heartbeat:Connect(function()
        local dir = Humanoid.MoveDirection
        if dir.Magnitude > 0 then
            RootPart.AssemblyLinearVelocity =
                Vector3.new(dir.X, 0, dir.Z) * Humanoid.WalkSpeed
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
GrayAllNPC()
RemoveEffects()
FixCDKIssues()
FixMovementStutter()
FixInventory()

task.spawn(function()
    while true do
        task.wait(8)
        RemoveEffects()
        GrayAllNPC()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    task.wait(1)
    SetNetworkOwnership()
    GrayGroundAndTransparentSea()
end)

print("✅ BLOX FRUITS FINAL | GRAY MAP + NO SKILL EFFECT + NPC GRAY | CORE MERGED")
