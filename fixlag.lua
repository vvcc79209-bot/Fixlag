### Kịch bản Lua để Fix Lag trong Blox Fruits

```lua
-- Blox Fruits Lag Fix Script
-- Xoá hiệu ứng, cây cối, nhà, và biến màu mặt đất và biển

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--------------------------------------------------
-- 1. Xoá hiệu ứng 95% (trái, melee, súng, đánh thường)
--------------------------------------------------
local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")) and not obj:IsDescendantOf(Character) then
            obj:Destroy()
        end
    end
end

--------------------------------------------------
-- 2. Xoá cây cối và nhà không cần thiết
--------------------------------------------------
local function ClearUnnecessaryObjects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name, "tree") or string.find(name, "rock") or 
               string.find(name, "bush") or string.find(name, "house") or
               string.find(name, "accessory") then
                
                -- Đảm bảo không xóa mặt đất
                if not string.find(name, "baseplate") and not string.find(name, "terrain") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

--------------------------------------------------
-- 3. Biến mặt đất và mặt biển thành màu xám
--------------------------------------------------
local function GrayGroundAndWater()
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        local GRAY = Color3.fromRGB(128, 128, 128)

        -- Đặt màu cho mặt đất
        for _, material in ipairs(Enum.Material:GetEnumItems()) do
            pcall(function()
                Terrain:SetMaterialColor(material, GRAY)
            end)
        end

        -- Cấu hình biển
        pcall(function()
            Terrain.WaterTransparency = 1 
            Terrain.WaterColor = GRAY 
            Terrain.WaterWaveSize = 0 
            Terrain.WaterWaveSpeed = 0 
            Terrain.WaterReflectance = 0 
        end)
    end
end

--------------------------------------------------
-- 4. Fix Lag cho các items cụ thể
--------------------------------------------------
local function FixLagForSpecificItems()
    local specificItems = {
        "Skull Gita",   -- Súng
        "Dragon Stone", -- Súng
        "Control",      -- Trái
        "Dragon",       -- Trái
        "Thunder"       -- Trái
    }
    
    for _, itemName in pairs(specificItems) do
        local tool = Character:FindFirstChild(itemName)
        if tool then
            pcall(function()
                tool:Destroy() -- Nên dùng cách sửa đổi thay vì xóa nếu không muốn mất item
            end)
        end
    end
end

--------------------------------------------------
-- MAIN
--------------------------------------------------
RemoveEffects()
ClearUnnecessaryObjects()
GrayGroundAndWater()
FixLagForSpecificItems()

print("Lag Fix Script Loaded: Effects removed, unnecessary objects cleared, ground/water color changed.")
```
