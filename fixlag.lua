-- Blox Fruits Custom Script FINAL (FULL FIX)
-- Gray ground + SAFE Transparent Sea
-- Remove ~95% skill effects (ALL PLAYERS)
-- Fix CDK Z, Fix movement, Fix inventory
-- FORCE SWIM (NO WALK UNDER SEA)

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
-- GRAY GROUND + SAFE TRANSPARENT SEA
--------------------------------------------------
local function GrayGroundAndTransparentSea()
    if not Terrain then return end
    local GRAY = Color3.fromRGB(128,128,128)

    -- ❗ KHÔNG ĐỤNG MATERIAL WATER
    for _, material in ipairs(Enum.Material:GetEnumItems()) do
        if material ~= Enum.Material.Water then
            pcall(function()
                Terrain:SetMaterialColor(material, GRAY)
            end)
        end
    end

    -- Chỉ đổi hiển thị nước
    Terrain.WaterTransparency = 1
    Terrain.WaterColor = Color3.fromRGB(90,90,90)
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0.05
end

--------------------------------------------------
-- REMOVE ~95% EFFECTS (ALL PLAYERS)
--------------------------------------------------
local EffectKeywords = {
    "effect","vfx","fx","skill","ability",
    "explosion","blast","hit","impact",
    "slash","cut","fire","ice","light","dark",
    "magma","smoke","electric","lightning"
}

local function IsEffect(obj)
    local n = obj.Name:lower()
    for _,k in pairs(EffectKeywords) do
        if string.find(n,k) then return true end
    end
    return false
end

local function KillEffect(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles")
    or obj:IsA("Explosion") then
        obj:Destroy()
    end

    if (obj:IsA("Model") or obj:IsA("BasePart")) and IsEffect(obj) then
        obj:Destroy()
    end

    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    end

    if obj:IsA("Sound") then
        obj.Volume = 0
        obj:Destroy()
    end
end

local function RemoveAllEffects()
    for _,obj in pairs(Workspace:GetDescendants()) do
        if not obj:IsDescendantOf(Character)
        and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            pcall(function()
                KillEffect(obj)
            end)
        end
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if not obj:IsDescendantOf(Character)
    and not obj:IsDescendantOf(LocalPlayer.Backpack) then
        task.wait()
        pcall(function()
            KillEffect(obj)
        end)
    end
end)

--------------------------------------------------
-- FIX CDK Z SPIN
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and string.find(tool.Name:lower(),"katana") then
        local _,y,_ = RootPart.CFrame:ToEulerAnglesXYZ()
        RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0,y,0)
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
-- FORCE SWIM (FIX ĐI BỘ DƯỚI BIỂN)
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
-- FIX INVENTORY
--------------------------------------------------
pcall(function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
end)

--------------------------------------------------
-- MAIN
--------------------------------------------------
ClearDecorations()
GrayGroundAndTransparentSea()
RemoveAllEffects()

task.spawn(function()
    while true do
        task.wait(6)
        RemoveAllEffects()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    RootPart = c:WaitForChild("HumanoidRootPart")
    task.wait(1)
    ClearDecorations()
    GrayGroundAndTransparentSea()
    RemoveAllEffects()
end)

print("✅ BLOX FRUITS FINAL: NO EFFECTS | SWIM FIXED | FPS BOOST")
