-- Blox Fruits Custom Script FINAL
-- Gray everything EXCEPT SEA
-- Fix CDK Z spin (FINAL), Fix movement stutter, Remove 95% effects, Fix inventory

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
            if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "bush")
            or string.find(name, "house") or string.find(name, "building")
            or string.find(name, "decor") or string.find(name, "fence")
            or string.find(name, "lamp") or string.find(name, "sign")
            or string.find(name, "accessory") or string.find(name, "prop") then
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
-- 2. GRAY EVERYTHING EXCEPT SEA
--------------------------------------------------
local function GrayEverythingExceptSea()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end

    local GRAY = Color3.fromRGB(128,128,128)

    -- Gray terrain materials EXCEPT water
    for _, material in ipairs(Enum.Material:GetEnumItems()) do
        if material ~= Enum.Material.Water then
            pcall(function()
                Terrain:SetMaterialColor(material, GRAY)
            end)
        end
    end

    -- Gray all parts EXCEPT sea / water / ocean
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(Character) then
            local name = string.lower(part.Name)
            if not string.find(name, "water")
            and not string.find(name, "sea")
            and not string.find(name, "ocean") then
                pcall(function()
                    part.Color = GRAY
                    part.Material = Enum.Material.Concrete
                end)
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
-- 4. REMOVE 95% EFFECTS (SAFE)
--------------------------------------------------
local function IsEffect(obj)
    return obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam")
        or obj:IsA("Smoke")
        or obj:IsA("Fire")
        or obj:IsA("Sparkles")
        or obj:IsA("PointLight")
        or obj:IsA("SpotLight")
        or obj:IsA("SurfaceLight")
end

local function DisableEffect(obj)
    pcall(function()
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = false
            obj.Rate = 0
        elseif obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Light") then
            obj.Enabled = false
        end
    end)
end

local function RemoveEffects95()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if IsEffect(obj)
        and not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            DisableEffect(obj)
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
end

Workspace.DescendantAdded:Connect(function(obj)
    if IsEffect(obj) then
        DisableEffect(obj)
    end
end)

--------------------------------------------------
-- 5. FIX CDK Z SPIN
--------------------------------------------------
local CDKFixConnection
local function FixCDKIssues()
    if CDKFixConnection then CDKFixConnection:Disconnect() end

    CDKFixConnection = RunService.Heartbeat:Connect(function()
        if not Character or not RootPart or not Humanoid then return end

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
GrayEverythingExceptSea()
GrayNPC()
RemoveEffects95()
FixCDKIssues()
FixMovementStutter()
FixInventory()

task.spawn(function()
    while true do
        task.wait(8)
        RemoveEffects95()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    task.wait(1)
    SetNetworkOwnership()
    ClearDecorations()
    GrayEverythingExceptSea()
    FixCDKIssues()
    FixMovementStutter()
end)

print("Blox Fruits FINAL: GRAY ALL EXCEPT SEA ✔")
