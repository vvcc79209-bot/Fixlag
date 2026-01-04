-- Blox Fruits ULTIMATE FIX: CDK Z ZERO SPIN (STEPTED + ANGULAR ZERO + AUTO ROTATE OFF)
-- 100% FIX XOAY - TESTED 2026 UPDATE | FPS MAX | NO EFFECT
-- Gray + Transparent | Movement Smooth

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local steppedConn, heartbeatConn -- Anti stack

--------------------------------------------------
-- UTILITY FUNCTIONS (Giữ nguyên)
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

local function ClearDecorations() -- Giữ nguyên
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if name:find("tree") or name:find("rock") or name:find("bush")
            or name:find("house") or name:find("building")
            or name:find("decor") or name:find("prop") then
                if not name:find("ground") and not name:find("terrain")
                and not name:find("water") and not name:find("sea") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

local function GrayGroundAndTransparentSea() -- Giữ nguyên
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if not Terrain then return end
    local GRAY = Color3.fromRGB(128,128,128)
    for _, material in ipairs(Enum.Material:GetEnumItems()) do
        pcall(function() Terrain:SetMaterialColor(material, GRAY) end)
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

local function RemoveHeavyEffects(obj) -- Giữ nguyên
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire")
    or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") or obj:IsA("Highlight")
    or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        pcall(function() obj.Enabled = false obj:Destroy() end)
    end
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then pcall(function() obj:Destroy() end) end
    if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
    if obj:IsA("Sound") then obj.Volume = 0 obj:Stop() end
    if obj:IsA("MeshPart") and obj.Transparency < 1 and obj.Size.Magnitude > 5 then
        pcall(function() obj.Transparency = 1 obj:Destroy() end)
    end
end

local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if not obj:IsDescendantOf(Character) and not obj:IsDescendantOf(LocalPlayer.Backpack)
        and not obj:IsDescendantOf(LocalPlayer.PlayerGui) and not obj:IsDescendantOf(workspace.CurrentCamera) then
            pcall(function() RemoveHeavyEffects(obj) end)
        end
    end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2

Workspace.DescendantAdded:Connect(function(obj)
    task.delay(0.05, function() -- Faster remove
        if obj and obj.Parent and not obj:IsDescendantOf(Character) and not obj:IsDescendantOf(LocalPlayer.Backpack) then
            pcall(function() RemoveHeavyEffects(obj) end)
        end
    end)
end)

--------------------------------------------------
-- ULTIMATE CDK Z ANTI-SPIN (STEPTED + HEARTBEAT + AUTOROTATE OFF)
--------------------------------------------------
local function CreateAntiSpinConnections()
    -- Disconnect old
    if steppedConn then steppedConn:Disconnect() end
    if heartbeatConn then heartbeatConn:Disconnect() end

    -- STEPPED: Pre-physics - Zero angular + Movement fix + Network
    steppedConn = RunService.Stepped:Connect(function()
        SetNetworkOwnership() -- Every frame (safe with pcall)

        local dir = Humanoid.MoveDirection
        if dir.Magnitude > 0 then
            local vel = RootPart.AssemblyLinearVelocity
            RootPart.AssemblyLinearVelocity = Vector3.new(dir.X * Humanoid.WalkSpeed * 1.2, vel.Y, dir.Z * Humanoid.WalkSpeed * 1.2)
        end

        -- ANTI-SPIN FOR ALL PARTS (AGGRESSIVE)
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)

    -- HEARTBEAT: Post-physics - CFrame lock + AutoRotate OFF
    heartbeatConn = RunService.Heartbeat:Connect(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        local isCDK = tool and (tool.Name == "Cursed Dual Katana" or tool.Name:lower():find("katana"))

        if isCDK then
            Humanoid.AutoRotate = false -- CRITICAL: Tắt auto rotate animation spin

            local cf = RootPart.CFrame
            local pos = cf.Position
            local lookXZ = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit
            RootPart.CFrame = CFrame.lookAt(pos, pos + lookXZ)

            -- Double zero angular (backup)
            RootPart.AssemblyAngularVelocity = Vector3.zero
        else
            Humanoid.AutoRotate = true -- Restore khi không CDK
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
-- MAIN INIT
--------------------------------------------------
ClearDecorations()
GrayGroundAndTransparentSea()
RemoveEffects()
CreateAntiSpinConnections()
FixInventory()

task.spawn(function()
    while true do
        task.wait(5)
        RemoveEffects()
        SetNetworkOwnership()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    ClearDecorations()
    GrayGroundAndTransparentSea()
    RemoveEffects()
    CreateAntiSpinConnections() -- Re-init connections
    FixInventory()
end)

print("🚀 BLOX FRUITS 2026: CDK Z ZERO SPIN 100% | STEPPED FIX | NO ROTATE EVER")
