-- Blox Fruits Custom Script FINAL (CDK Z SPIN FIXED 100%)
-- Gray ground + Transparent Sea (SAFE)
-- Fix CDK Z rotation + Angular Velocity ZERO
-- Remove 90%+ skill effects (NO WHITE FLASH)
-- Fix inventory + No connection stack

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local heartbeatConn -- Để tránh stack connection

--------------------------------------------------
-- Network ownership LOOP (anti lag)
--------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            RootPart:SetNetworkOwner(LocalPlayer)
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part:SetNetworkOwner(LocalPlayer)
                end
            end
        end)
    end
end)

--------------------------------------------------
-- CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if name:find("tree") or name:find("rock") or name:find("bush")
            or name:find("house") or name:find("building")
            or name:find("decor") or name:find("prop") then
                if not name:find("ground")
                and not name:find("terrain")
                and not name:find("water")
                and not name:find("sea") then
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
            if not name:find("sea") and not name:find("water") then
                part.Color = GRAY
                part.Material = Enum.Material.Concrete
            end
        end
    end
end

--------------------------------------------------
-- REMOVE HEAVY EFFECTS
--------------------------------------------------
local function RemoveHeavyEffects(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire")
    or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") or obj:IsA("Highlight")
    or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        pcall(function()
            obj.Enabled = false
            obj:Destroy()
        end)
    end

    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        pcall(function() obj:Destroy() end)
    end

    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    end

    if obj:IsA("Sound") then
        obj.Volume = 0
        obj:Stop()
    end

    if obj:IsA("MeshPart") and obj.Transparency < 1 and obj.Size.Magnitude > 5 then
        pcall(function()
            obj.Transparency = 1
            obj:Destroy()
        end)
    end
end

local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack)
        and not obj:IsDescendantOf(LocalPlayer.PlayerGui)
        and not obj:IsDescendantOf(workspace.CurrentCamera) then
            pcall(function() RemoveHeavyEffects(obj) end)
        end
    end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2

Workspace.DescendantAdded:Connect(function(obj)
    task.delay(0.1, function()
        if obj and obj.Parent
        and not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            pcall(function() RemoveHeavyEffects(obj) end)
        end
    end)
end)

--------------------------------------------------
-- COMBINED FIX: MOVEMENT + CDK Z SPIN (AngularVelocity ZERO + Better CFrame)
--------------------------------------------------
local function CreateFixConnections()
    if heartbeatConn then
        heartbeatConn:Disconnect()
    end

    heartbeatConn = RunService.Heartbeat:Connect(function()
        -- Fix Movement Stutter
        local dir = Humanoid.MoveDirection
        if dir.Magnitude > 0 then
            local vel = RootPart.AssemblyLinearVelocity
            RootPart.AssemblyLinearVelocity = Vector3.new(
                dir.X * Humanoid.WalkSpeed,
                vel.Y,
                dir.Z * Humanoid.WalkSpeed
            )
        end

        -- Fix CDK Z Spin (chỉ khi equip CDK hoặc katana)
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and (tool.Name == "Cursed Dual Katana" or string.lower(tool.Name):find("katana")) then
            local cf = RootPart.CFrame
            local pos = cf.Position
            local look = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
            if look.Magnitude > 0 then
                look = look.Unit
            else
                look = Vector3.new(0, 0, -1) -- default forward
            end
            RootPart.CFrame = CFrame.lookAt(pos, pos + look)
            RootPart.AssemblyAngularVelocity = Vector3.zero -- QUAN TRỌNG: Zero spin physics
            Humanoid.PlatformStand = false
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
ClearDecorations()
GrayGroundAndTransparentSea()
RemoveEffects()
CreateFixConnections()  -- Kết hợp CDK + Movement
FixInventory()

task.spawn(function()
    while true do
        task.wait(6)
        RemoveEffects()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    task.wait(1)
    ClearDecorations()
    GrayGroundAndTransparentSea()
    RemoveEffects()
    CreateFixConnections()  -- Re-create connection mới
    FixInventory()
end)

print("✅ BLOX FRUITS ULTIMATE: CDK Z KHÔNG XOAY NỮA | FPS MAX | NO EFFECT")
