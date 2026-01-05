-- Blox Fruits Custom Script FINAL (ANTI LAG)
-- Gray ground + Transparent Sea (SAFE)
-- Fix CDK Z spin, Fix movement stutter
-- REMOVE 100% EFFECTS (DISABLE METHOD)
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
-- NETWORK OWNERSHIP
--------------------------------------------------
pcall(function()
    RootPart:SetNetworkOwner(LocalPlayer)
end)

--------------------------------------------------
-- 1. CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("tree") or n:find("rock") or n:find("house")
            or n:find("building") or n:find("bush")
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
-- 2. GRAY GROUND + SEA
--------------------------------------------------
local function GrayGroundAndSea()
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

    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") and not p:IsDescendantOf(Character) then
            p.Color = GRAY
            p.Material = Enum.Material.Concrete
        end
    end
end

--------------------------------------------------
-- 3. REMOVE 100% EFFECTS (ANTI LAG - FINAL)
--------------------------------------------------
local EffectClasses = {
    ParticleEmitter = true,
    Beam = true,
    Trail = true,
    Smoke = true,
    Fire = true,
    Sparkles = true,
    Explosion = true,
    Sound = true,
    PointLight = true,
    SurfaceLight = true,
    SpotLight = true
}

local function DisableEffect(obj)
    if not EffectClasses[obj.ClassName] then return end
    pcall(function()
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = false
        elseif obj:IsA("Beam") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("Sound") then
            obj.Volume = 0
            obj:Stop()
        elseif obj:IsA("Explosion") then
            obj.BlastPressure = 0
            obj.BlastRadius = 0
        elseif obj:IsA("Light") then
            obj.Enabled = false
        end
    end)
end

-- xử lý hiệu ứng đã tồn tại (CHỈ 1 LẦN)
for _, v in ipairs(Workspace:GetDescendants()) do
    DisableEffect(v)
end

-- xử lý hiệu ứng spawn sau này (KHÔNG LOOP)
Workspace.DescendantAdded:Connect(function(v)
    DisableEffect(v)
end)

--------------------------------------------------
-- 4. FIX CDK Z SPIN
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("katana") then
        Humanoid.AutoRotate = true
        Humanoid.PlatformStand = false

        for _, v in ipairs(RootPart:GetChildren()) do
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
-- 5. FIX MOVEMENT STUTTER
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
-- 6. FIX INVENTORY
--------------------------------------------------
pcall(function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
end)

--------------------------------------------------
-- INIT
--------------------------------------------------
ClearDecorations()
GrayGroundAndSea()

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    task.wait(1)
    ClearDecorations()
    GrayGroundAndSea()
end)

print("BLOX FRUITS FINAL | REMOVE 100% EFFECTS | NO LAG | OK")
