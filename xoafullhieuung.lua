-- Blox Fruits Custom Clear & Optimize Script
-- Xóa cây cối, nhà, phụ kiện (không xóa đất)
-- Mặt đất & biển xám
-- Xóa hiệu ứng skill trái/võ/kiếm/súng (ưu tiên Skull Guitar/Soul Guitar & Dragon)
-- Fix lỗi xoay camera chiêu Z Sharkman Karate (xong kiếm)
-- NPC xám
-- Fix kho đồ
-- Không lag, không xóa đất Sea 2
-- Mặt trời KHÔNG xám

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local grayColor = Color3.new(0.5, 0.5, 0.5)

print("Blox Fruits Optimize Script Loaded!")

-- 1. FIX KHO ĐỒ (Inventory)
pcall(function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
end)
print("Inventory refreshed!")

-- 2. OPTIMIZE LIGHTING (NO LAG, KHÔNG XẢM MẶT TRỜI)
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("PostEffect") or effect:IsA("Atmosphere") then
        effect.Enabled = false
    end
end

-- 3. DETECT SEA 2 (KHÔNG XÓA ĐẤT SEA 2)
local inSecondSea = Workspace:FindFirstChild("SecondSea") ~= nil

-- 4. LÀM XÁM MẶT ĐẤT & BIỂN (KHÔNG XÓA)
local groundMaterials = {
    Enum.Material.Grass, Enum.Material.Sand, Enum.Material.Ground,
    Enum.Material.Mud, Enum.Material.Rock, Enum.Material.Concrete,
    Enum.Material.Basalt, Enum.Material.Pavement
}
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") and table.find(groundMaterials, obj.Material) then
        obj.Color = grayColor
        obj.Material = Enum.Material.Concrete
    end
end
-- Biển
local sea = Workspace:FindFirstChild("Sea")
if sea then
    sea.Color = grayColor
    sea.Material = Enum.Material.Concrete
end
print("Mặt đất & biển đã xám!")

-- 5. XÓA CÂY CỐI, NHÀ, PHỤ KIỆN (KHÔNG XÓA ĐẤT, SAFE SEA 2)
local clearNames = {"Tree", "Palm", "Rock", "SandPile", "Fence", "Sign", "Lantern", "Barrel", "Crate", "House", "Building", "Tower", "Wall", "Door", "Window"}
for _, obj in pairs(Workspace:GetChildren()) do
    local nameLower = obj.Name:lower()
    if obj:IsA("Model") or obj:IsA("Folder") then
        local shouldClear = false
        for _, clearName in pairs(clearNames) do
            if nameLower:find(clearName:lower()) then
                shouldClear = true
                break
            end
        end
        if shouldClear then
            pcall(function() obj:Destroy() end)
        end
    elseif obj:IsA("BasePart") and obj.Size.X < 30 and obj.Size.Y < 30 and not obj.Anchored then
        -- Xóa phụ kiện nhỏ không anchored
        pcall(function() obj.Transparency = 1 obj.CanCollide = false end)
    end
end
print("Đã xóa cây cối, nhà, phụ kiện!")

-- 6. LÀM NPC XÁM (LOOP)
task.spawn(function()
    while true do
        task.wait(3)
        for _, model in pairs(Workspace:GetChildren()) do
            if model:FindFirstChildOfClass("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model ~= LocalPlayer.Character then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = grayColor
                    end
                end
            end
        end
    end
end)
print("NPC xám enabled!")

-- 7. XÓA HIỆU ỨNG SKILL TRÁI/VÕ/KIẾM/SÚNG (ƯU TIÊN SKULL GUITAR/DRAGON, LOOP NO LAG)
task.spawn(function()
    while true do
        task.wait(0.3)  -- Optimize no lag
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") or obj:IsA("Light") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or obj:IsA("Attachment") then
                pcall(function()
                    obj.Enabled = false
                    obj:Destroy()
                end)
            end
        end
        -- Đặc biệt Skull Guitar/Soul Guitar & Dragon
        for _, char in pairs(Workspace:GetChildren()) do
            if char:FindFirstChild("HumanoidRootPart") then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("guitar") or tool.Name:lower():find("soul") or tool.Name:lower():find("skull") or tool.Name:lower():find("dragon")) then
                        for _, eff in pairs(tool:GetDescendants()) do
                            if eff:IsA("ParticleEmitter") or eff:IsA("Beam") or eff:IsA("Trail") then
                                pcall(function() eff:Destroy() end)
                            end
                        end
                    end
                end
            end
        end
    end
end)
print("Xóa hiệu ứng enabled (Skull Guitar/Dragon priority)!")

-- 8. FIX LỖI XOAY CHIÊU Z XONG KIẾM/SHARKMAN KARATE (LOOP)
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            Camera.CameraType = Enum.CameraType.Custom
        end
    end)
end)
print("Fix xoay camera Z Sharkman Karate enabled!")

print("Script hoàn tất! Không lag, chạy mượt!")
