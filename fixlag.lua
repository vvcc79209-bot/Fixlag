-- Blox Fruits Custom Script FINAL
-- Gray ground + Transparent Sea (SAFE)
-- Fix CDK Z spin, Fix movement, Remove 99.9% effects, Fix inventory

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
-- CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = string.lower(obj.Name)
            if n:find("tree") or n:find("rock") or n:find("bush")
            or n:find("house") or n:find("building")
            or n:find("decor") or n:find("prop") then
                if not n:find("ground")
                and not n:find("terrain")
                and not n:find("water")
                and not n:find("sea") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- GRAY GROUND + SEA
--------------------------------------------------
local function GrayGroundAndTransparentSea()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end

    local GRAY = Color3.fromRGB(128,128,128)

    for _, m in ipairs(Enum.Material:GetEnumItems()) do
        pcall(function()
            Terrain:SetMaterialColor(m, GRAY)
        end)
    end

    Terrain.WaterTransparency = 1
    Terrain.WaterColor = GRAY
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0

    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") and not p:IsDescendantOf(Character) then
            local n = string.lower(p.Name)
            if not n:find("water") and not n:find("sea") then
                p.Color = GRAY
                p.Material = Enum.Material.Concrete
            end
        end
    end
end

--------------------------------------------------
-- GRAY NPC
--------------------------------------------------
local function GrayNPC()
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc ~= Character then
            for _, b in pairs(npc:GetDescendants()) do
                if b:IsA("BasePart") then
                    b.Color = Color3.fromRGB(128,128,128)
                end
            end
        end
    end
end

--------------------------------------------------
-- REMOVE 99.9% EFFECTS (FINAL)
--------------------------------------------------
local EFFECT_CLASSES = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    PointLight = true,
    SurfaceLight = true,
    SpotLight = true,
    Decal = true,
    Texture = true
}

local function ClearEffect(obj)
    if EFFECT_CLASSES[obj.ClassName] then
        pcall(function() obj:Destroy() end)
    elseif obj:IsA("Sound") then
        obj.Volume = 0
    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    elseif obj:IsA("Attachment")
    and not obj:IsDescendantOf(Character)
    and not obj.Parent:IsA("Tool") then
        pcall(function() obj:Destroy() end)
    end
end

-- clear existing
for _, v in ipairs(Workspace:GetDescendants()) do
    ClearEffect(v)
end

-- clear new spawn effects
Workspace.DescendantAdded:Connect(function(obj)
    ClearEffect(obj)
end)

--------------------------------------------------
-- FIX CDK Z
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("katana") then
        Humanoid.AutoRotate = true
        Humanoid.PlatformStand = false
        for _, v in pairs(RootPart:GetChildren()) do
            if v:IsA("BodyGyro")
            or v:IsA("BodyAngularVelocity")
            or v:IsA("AlignOrientation") then
                v:Destroy()
            end
        end
        RootPart.AssemblyAngularVelocity = Vector3.zero
    end
end)

--------------------------------------------------
-- FIX MOVEMENT STUTTER
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local dir = Humanoid.MoveDirection
    if dir.Magnitude > 0 then
        local vel = RootPart.AssemblyLinearVelocity
        if Vector3.new(vel.X,0,vel.Z).Magnitude < Humanoid.WalkSpeed * 0.8 then
            RootPart.AssemblyLinearVelocity = Vector3.new(
                dir.X * Humanoid.WalkSpeed,
                vel.Y,
                dir.Z * Humanoid.WalkSpeed
            )
        end
    end
end)

--------------------------------------------------
-- FIX INVENTORY
--------------------------------------------------
pcall(function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
end)

--------------------------------------------------
-- INIT
--------------------------------------------------
SetNetworkOwnership()
ClearDecorations()
GrayGroundAndTransparentSea()
GrayNPC()

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    task.wait(1)
    SetNetworkOwnership()
    ClearDecorations()
    GrayGroundAndTransparentSea()
end)

print("BLOX FRUITS FINAL | REMOVE 99.9% EFFECTS | FIX CDK | FIX LAG")
