-- Blox Fruits Custom Script FINAL
-- Gray ground (Concrete) + Sea transparent 100% (SAFE TERRAIN)
-- Fix CDK Z spin (FINAL), Fix movement stutter
-- Remove 99.9% effects (Fruit / Melee / Gun / Sword / Normal)
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
-- 1. CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name,"tree") or string.find(name,"rock") or string.find(name,"bush")
            or string.find(name,"house") or string.find(name,"building")
            or string.find(name,"decor") or string.find(name,"prop")
            or string.find(name,"fence") or string.find(name,"lamp") then
                if not string.find(name,"ground")
                and not string.find(name,"terrain")
                and not string.find(name,"water")
                and not string.find(name,"sea") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- 2. GRAY GROUND + TRANSPARENT SEA
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

    pcall(function()
        Terrain.WaterTransparency = 1
        Terrain.WaterColor = GRAY
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
    end)
end

--------------------------------------------------
-- 3. GRAY NPC
--------------------------------------------------
local function GrayNPC()
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc ~= Character then
            for _, part in pairs(npc:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.fromRGB(128,128,128)
                end
            end
        end
    end
end

--------------------------------------------------
-- 4. REMOVE 99.9% EFFECTS (UPGRADED)
--------------------------------------------------
local REMOVE_CLASS = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Explosion = true,
    Highlight = true
}

local REMOVE_NAME_KEYWORDS = {
    "effect","fx","vfx","skill","attack",
    "explosion","blast","aura","trail"
}

local function ShouldRemove(obj)
    if REMOVE_CLASS[obj.ClassName] then
        return true
    end

    local name = string.lower(obj.Name)
    for _, k in ipairs(REMOVE_NAME_KEYWORDS) do
        if string.find(name, k) then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                return true
            end
        end
    end

    return false
end

local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if ShouldRemove(obj)
        and not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            pcall(function() obj:Destroy() end)
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
    Lighting.Brightness = 1

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("BlurEffect")
        or v:IsA("DepthOfFieldEffect")
        or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end
end

-- remove new effects instantly
Workspace.DescendantAdded:Connect(function(obj)
    if ShouldRemove(obj) then
        task.wait()
        pcall(function() obj:Destroy() end)
    end
end)

--------------------------------------------------
-- 5. FIX CDK Z SPIN (FINAL)
--------------------------------------------------
local function FixCDKIssues()
    RunService.Heartbeat:Connect(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and string.find(string.lower(tool.Name), "katana") then
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
end

--------------------------------------------------
-- 6. FIX MOVEMENT STUTTER
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
-- 7. FIX INVENTORY
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
GrayNPC()
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
    RemoveEffects()
end)

print("Blox Fruits FINAL: REMOVE 99.9% EFFECTS | CDK Z FIX | NO LAG")
