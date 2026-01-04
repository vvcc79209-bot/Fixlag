-- Blox Fruits Custom Script FINAL (MERGED)
-- Gray ground + Transparent Sea (SAFE)
-- Fix CDK Z, Fix movement stutter
-- CLEAN SKILL EFFECT ONLY (NO MAP / NO NPC DELETE)
-- Fix inventory

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
-- CLEAR DECORATIONS (CÂY / NHÀ PHỤ)
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("tree") or n:find("rock") or n:find("bush")
            or n:find("decor") or n:find("prop") then
                pcall(function() obj:Destroy() end)
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
    for _, m in ipairs(Enum.Material:GetEnumItems()) do
        pcall(function()
            Terrain:SetMaterialColor(m, GRAY)
        end)
    end

    Terrain.WaterTransparency = 1
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
end

--------------------------------------------------
-- CHECK SKILL EFFECT (AN TOÀN)
--------------------------------------------------
local function IsSkillEffect(obj)
    if obj:IsDescendantOf(Character) then return false end
    if obj:FindFirstAncestorOfClass("Humanoid") then return false end

    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Explosion") then
        return true
    end

    if obj:IsA("BasePart") then
        return obj.Anchored
        and not obj.CanCollide
        and obj.Transparency < 0.95
        and (
            obj.Material == Enum.Material.Neon
            or obj.Material == Enum.Material.ForceField
            or obj.Material == Enum.Material.Plastic
        )
    end

    if obj:IsA("Model") then
        local c = 0
        for _, v in pairs(obj:GetDescendants()) do
            if v:IsA("BasePart") and v.Anchored and not v.CanCollide then
                c += 1
            end
        end
        return c >= 2
    end

    return false
end

--------------------------------------------------
-- REMOVE SKILL EFFECT ONLY
--------------------------------------------------
local function RemoveSkillEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if IsSkillEffect(obj) then
            pcall(function() obj:Destroy() end)
        end
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.2)
    if IsSkillEffect(obj) then
        pcall(function() obj:Destroy() end)
    end
end)

--------------------------------------------------
-- FIX CDK Z
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("katana") then
        local _, y, _ = RootPart.CFrame:ToEulerAnglesXYZ()
        RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, y, 0)
        Humanoid.PlatformStand = false
    end
end)

--------------------------------------------------
-- FIX MOVEMENT STUTTER
--------------------------------------------------
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

--------------------------------------------------
-- FIX INVENTORY
--------------------------------------------------
pcall(function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
end)

--------------------------------------------------
-- MAIN
--------------------------------------------------
SetNetworkOwnership()
ClearDecorations()
GrayGroundAndTransparentSea()
RemoveSkillEffects()

task.spawn(function()
    while true do
        task.wait(2)
        RemoveSkillEffects()
    end
end)

print("✅ BLOX FRUITS FINAL: CHỈ XOÁ HIỆU ỨNG SKILL | MAP & QUÁI GIỮ NGUYÊN")
