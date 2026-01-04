-- Blox Fruits Custom Script FINAL
-- Gray ground
-- Remove ~90% skill effects (SAFE – vẫn thấy chiêu)
-- Fix walk under water (force swim)
-- Fix CDK Z, movement stutter, inventory

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

--------------------------------------------------
-- NETWORK OWNERSHIP (ANTI LAG)
--------------------------------------------------
pcall(function()
    RootPart:SetNetworkOwner(LocalPlayer)
    for _, p in pairs(Character:GetChildren()) do
        if p:IsA("BasePart") then
            p:SetNetworkOwner(LocalPlayer)
        end
    end
end)

--------------------------------------------------
-- CLEAR DECORATIONS
--------------------------------------------------
local function ClearDecorations()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if string.find(n,"tree") or string.find(n,"rock")
            or string.find(n,"bush") or string.find(n,"house")
            or string.find(n,"building") or string.find(n,"decor")
            or string.find(n,"prop") then
                if not string.find(n,"ground")
                and not string.find(n,"terrain")
                and not string.find(n,"water")
                and not string.find(n,"sea") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- GRAY GROUND (KHÔNG ĐỤNG NƯỚC)
--------------------------------------------------
local function GrayGroundOnly()
    if not Terrain then return end
    local GRAY = Color3.fromRGB(128,128,128)

    for _, material in ipairs(Enum.Material:GetEnumItems()) do
        if material ~= Enum.Material.Water then
            pcall(function()
                Terrain:SetMaterialColor(material, GRAY)
            end)
        end
    end

    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart")
        and not part:IsDescendantOf(Character)
        and part.Material ~= Enum.Material.Water then
            part.Color = GRAY
            part.Material = Enum.Material.Concrete
        end
    end
end

--------------------------------------------------
-- REMOVE ~90% EFFECTS (CHỈ XOÁ PHẦN NẶNG)
--------------------------------------------------
local function ReduceEffects(obj)
    -- Particle / VFX nặng
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam") then
        obj.Enabled = false
        obj:Destroy()
    end

    -- Explosion (chỉ xoá hiệu ứng, không xoá damage)
    if obj:IsA("Explosion") then
        obj.Visible = false
        obj.BlastPressure = 0
    end

    -- Âm thanh skill
    if obj:IsA("Sound") then
        obj.Volume = 0
    end

    -- Decal / Texture (giữ model nhưng làm mờ)
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 0.9
    end
end

local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            pcall(function()
                ReduceEffects(obj)
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
        task.wait()
        pcall(function()
            ReduceEffects(obj)
        end)
    end
end)

--------------------------------------------------
-- FORCE SWIM (FIX ĐI BỘ DƯỚI NƯỚC)
--------------------------------------------------
local WATER_Y = Terrain and Terrain.WaterLevel or 0

RunService.Heartbeat:Connect(function()
    if RootPart.Position.Y < WATER_Y - 1 then
        if Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
            Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end
        Humanoid.Jump = false
    end
end)

--------------------------------------------------
-- FIX CDK Z
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and string.find(tool.Name:lower(), "katana") then
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
ClearDecorations()
GrayGroundOnly()
RemoveEffects()

task.spawn(function()
    while true do
        task.wait(8)
        RemoveEffects()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    task.wait(1)
    ClearDecorations()
    GrayGroundOnly()
    RemoveEffects()
end)

print("✅ BLOX FRUITS FINAL: REMOVE ~90% EFFECTS | SWIM OK | FPS BOOST")
