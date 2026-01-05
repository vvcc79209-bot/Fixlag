-- Blox Fruits Custom Script FINAL
-- Gray ground + Transparent Sea (SAFE)
-- Fix CDK Z spin, Fix movement stutter
-- REMOVE 100% SKILL EFFECTS (FINAL)
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
-- NETWORK OWNERSHIP (ANTI LAG MOVE)
--------------------------------------------------
pcall(function()
    RootPart:SetNetworkOwner(LocalPlayer)
end)

--------------------------------------------------
-- 1. CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("tree") or n:find("rock") or n:find("house")
            or n:find("building") or n:find("bush") or n:find("decor")
            or n:find("prop") then
                if not n:find("ground") and not n:find("terrain")
                and not n:find("water") and not n:find("sea") then
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

    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") and not p:IsDescendantOf(Character) then
            p.Color = GRAY
            p.Material = Enum.Material.Concrete
        end
    end
end

--------------------------------------------------
-- 3. REMOVE 100% SKILL EFFECTS (FINAL)
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
    Decal = true,
    Texture = true,
    PointLight = true,
    SurfaceLight = true,
    SpotLight = true
}

local function RemoveAllEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if EffectClasses[obj.ClassName] then
            pcall(function() obj:Destroy() end)
        end
    end

    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if EffectClasses[obj.ClassName] then
            pcall(function() obj:Destroy() end)
        end
    end

    for _, obj in pairs(Character:GetDescendants()) do
        if EffectClasses[obj.ClassName] then
            pcall(function() obj:Destroy() end)
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
end

--------------------------------------------------
-- 4. FIX CDK Z SPIN (FINAL)
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
-- 5. FIX MOVEMENT STUTTER
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local dir = Humanoid.MoveDirection
    if dir.Magnitude > 0 then
        RootPart.AssemblyLinearVelocity =
            Vector3.new(dir.X * Humanoid.WalkSpeed,
                        RootPart.AssemblyLinearVelocity.Y,
                        dir.Z * Humanoid.WalkSpeed)
    end
end)

--------------------------------------------------
-- 6. FIX INVENTORY
--------------------------------------------------
pcall(function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
end)

--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------
ClearDecorations()
GrayGroundAndSea()

RunService.Heartbeat:Connect(function()
    RemoveAllEffects()
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    task.wait(1)
    ClearDecorations()
    GrayGroundAndSea()
end)

print("BLOX FRUITS FINAL | REMOVE 100% EFFECTS | FIX LAG | OK")
