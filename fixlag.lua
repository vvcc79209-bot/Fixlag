-- Blox Fruits Custom Script FINAL
-- Gray ground (Concrete) + Sea transparent 100% (SAFE TERRAIN)
-- Fix CDK Z spin, Fix movement stutter, Remove effects, Fix inventory

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
    local sea = GetSea()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "bush")
            or string.find(name, "house") or string.find(name, "building") or string.find(name, "decor")
            or string.find(name, "fence") or string.find(name, "lamp") or string.find(name, "sign")
            or string.find(name, "accessory") or string.find(name, "prop") then
                if not string.find(name, "ground")
                and not string.find(name, "baseplate")
                and not string.find(name, "terrain")
                and not string.find(name, "water")
                and not string.find(name, "sea")
                and (sea ~= 2 or not string.find(obj.Parent.Name, "Sea2")) then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- 2. GRAY GROUND + TRANSPARENT SEA (CORE GHÉP)
--------------------------------------------------
local function GrayGroundAndTransparentSea()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end

    local GRAY = Color3.fromRGB(128,128,128)

    -- Terrain ground
    for _, material in ipairs(Enum.Material:GetEnumItems()) do
        pcall(function()
            Terrain:SetMaterialColor(material, GRAY)
        end)
    end

    -- Sea (visual remove, physics safe)
    pcall(function()
        Terrain.WaterTransparency = 1
        Terrain.WaterColor = GRAY
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
    end)

    -- Normal map parts
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Character) then
            local name = string.lower(part.Name)
            if not string.find(name, "sea")
            and not string.find(name, "water")
            and not string.find(name, "ocean") then
                part.Color = GRAY
                part.Material = Enum.Material.Concrete
            end
        end
    end
end

--------------------------------------------------
-- 3. GRAY NPC
--------------------------------------------------
local function GrayNPC()
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc ~= Character then
            for _, body in pairs(npc:GetDescendants()) do
                if body:IsA("BasePart") then
                    body.Color = Color3.fromRGB(128,128,128)
                end
            end
        end
    end
end

--------------------------------------------------
-- 4. REMOVE EFFECTS
--------------------------------------------------
local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
            if not obj:IsDescendantOf(Character)
            and not obj:IsDescendantOf(LocalPlayer.Backpack) then
                obj:Destroy()
            end
        elseif obj:IsA("Attachment") and not obj.Parent:IsA("Tool") then
            obj:Destroy()
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
end

--------------------------------------------------
-- 5. FIX CDK Z
--------------------------------------------------
local CDKFixConnection
local function FixCDKIssues()
    if CDKFixConnection then CDKFixConnection:Disconnect() end
    CDKFixConnection = RunService.Heartbeat:Connect(function()
        if not Character or not RootPart or not Humanoid then return end
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and string.find(string.lower(tool.Name), "katana") then
            local _, y, _ = RootPart.CFrame:ToEulerAnglesXYZ()
            RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, y, 0)
            Humanoid.PlatformStand = false
        end
    end)
end

--------------------------------------------------
-- 6. FIX MOVEMENT STUTTER
--------------------------------------------------
local MovementFixConnection
local function FixMovementStutter()
    if MovementFixConnection then MovementFixConnection:Disconnect() end
    MovementFixConnection = RunService.Heartbeat:Connect(function()
        if not Character or not RootPart or not Humanoid then return end
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

spawn(function()
    while true do
        task.wait(10)
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
    FixCDKIssues()
    FixMovementStutter()
end)

print("Blox Fruits FINAL: Gray Ground + Invisible Sea (SAFE) | Core merged OK")
