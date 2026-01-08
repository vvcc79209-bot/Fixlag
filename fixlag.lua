-- Blox Fruits FINAL SAFE (NO CONFLICT)
-- Fix lag + CDK Z + movement
-- Remove effects 95% (SAFE MODE)

if getgenv().BF_SAFE_LOADED then return end
getgenv().BF_SAFE_LOADED = true

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

--------------------------------------------------
-- CHARACTER HANDLER
--------------------------------------------------
local Character, Humanoid, RootPart
local function SetupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 5)
    RootPart = char:WaitForChild("HumanoidRootPart", 5)
end
SetupCharacter(LP.Character or LP.CharacterAdded:Wait())

LP.CharacterAdded:Connect(SetupCharacter)

--------------------------------------------------
-- NETWORK OWNERSHIP (SAFE)
--------------------------------------------------
local function SetNetOwner()
    if not RootPart then return end
    pcall(function()
        RootPart:SetNetworkOwner(LP)
    end)
end

--------------------------------------------------
-- SAFE DECOR CLEAN (NO DESTROY MAP CORE)
--------------------------------------------------
local DECOR_KEYWORDS = {
    "tree","rock","bush","prop","decor","fence",
    "lamp","sign","house","building"
}

local function ClearDecor()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Character) then
            local n = string.lower(obj.Name)
            for _, k in ipairs(DECOR_KEYWORDS) do
                if string.find(n, k) then
                    obj.Transparency = 1
                    obj.CanCollide = false
                    obj.CastShadow = false
                    break
                end
            end
        end
    end
end

--------------------------------------------------
-- GRAY MAP (SAFE)
--------------------------------------------------
local GRAY = Color3.fromRGB(128,128,128)

local function GrayMap()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterTransparency = 1
        terrain.WaterColor = GRAY
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
    end
end

--------------------------------------------------
-- EFFECT FILTER (ANTI CONFLICT)
--------------------------------------------------
local EFFECT_TYPES = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    PointLight = true,
    SpotLight = true,
    SurfaceLight = true
}

local function SafeDisableEffect(obj)
    if obj:IsDescendantOf(Character) then return end
    if obj:IsDescendantOf(LP.Backpack) then return end
    if obj:IsDescendantOf(Character:FindFirstChildOfClass("Tool") or Instance.new("Folder")) then
        return
    end

    if obj:IsA("ParticleEmitter") then
        obj.Enabled = false
        obj.Rate = 0
    elseif obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
    elseif obj:IsA("Light") then
        obj.Enabled = false
    end
end

local function RemoveEffectsSafe()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if EFFECT_TYPES[obj.ClassName] then
            SafeDisableEffect(obj)
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e9
end

--------------------------------------------------
-- CDK Z FIX (ONLY WHEN USING)
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not Character or not RootPart or not Humanoid then return end

    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("katana") then
        Humanoid.AutoRotate = true
        Humanoid.PlatformStand = false
        RootPart.AssemblyAngularVelocity = Vector3.zero
    end
end)

--------------------------------------------------
-- MOVEMENT FIX (LIGHT MODE)
--------------------------------------------------
RunService.Stepped:Connect(function()
    if not RootPart or not Humanoid then return end
    if Humanoid.MoveDirection.Magnitude > 0 then
        RootPart:SetNetworkOwner(LP)
    end
end)

--------------------------------------------------
-- INVENTORY FIX (SAFE CALL)
--------------------------------------------------
task.spawn(function()
    task.wait(3)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
    end)
end)

--------------------------------------------------
-- START
--------------------------------------------------
SetNetOwner()
ClearDecor()
GrayMap()
RemoveEffectsSafe()

task.spawn(function()
    while task.wait(10) do
        RemoveEffectsSafe()
    end
end)

print("Blox Fruits SAFE MODE ✔ No conflict ✔")
