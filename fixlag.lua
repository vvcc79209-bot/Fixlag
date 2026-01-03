-- Blox Fruits Custom Script: Xóa cây nhà phụ kiện, Gray ground/sea/NPC, Fix CDK Spin Z, Remove Effects (Mạnh hơn), Fix Inventory
-- ĐÃ THÊM: Làm mặt đất + biển xám + Xóa effects trái/melee/kiếm/súng cực mạnh (ưu tiên Skull Guitar & Dragon)
-- KHÔNG xóa đất Sea 2, KHÔNG gray sun
-- Fix nhấn mạnh: CDK Z spin sau khi dùng xong

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Detect Sea
local function GetSea()
    local pos = RootPart.Position
    if pos.Y > 5000 then return 2 end -- Sea 2
    if pos.Y < 0 then return 3 end
    return 1
end

-- 1. XÓA CÂY CỐI, NHÀ, PHỤ KIỆN (KHÔNG XÓA MẶT ĐẤT/SEA 2)
local function ClearDecorations()
    local sea = GetSea()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = string.lower(obj.Name)
            if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "bush") or 
               string.find(name, "house") or string.find(name, "building") or string.find(name, "decor") or
               string.find(name, "fence") or string.find(name, "lamp") or string.find(name, "sign") or
               string.find(name, "accessory") or string.find(name, "prop") then
                if not string.find(name, "ground") and not string.find(name, "baseplate") and 
                   not string.find(name, "terrain") and not string.find(name, "water") and not string.find(name, "sea") and
                   (sea ~= 2 or not string.find(obj.Parent.Name, "Sea2")) then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    print("Đã xóa cây cối, nhà, phụ kiện (giữ đất Sea 2)")
end

-- 2. LÀM MẶT ĐẤT VÀ BIỂN XÁM (CẢI TIẾN + CHẠY LẠI KHI RESPAWN)
local function GrayGroundAndSea()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = string.lower(part.Name)
            if string.find(name, "ground") or string.find(name, "grass") or string.find(name, "dirt") or 
               string.find(name, "sand") or string.find(name, "baseplate") or string.find(name, "floor") or
               string.find(name, "sea") or string.find(name, "water") or string.find(name, "ocean") or string.find(name, "terrain") then
                part.Color = Color3.fromRGB(128, 128, 128) -- Xám
                part.Material = Enum.Material.Concrete
                part.Reflectance = 0
            end
        end
    end
    print("Đã làm mặt đất và biển xám")
end

-- 3. LÀM NPC XÁM
local function GrayNPC()
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:FindFirstChild("Humanoid") and not npc:FindFirstChild("PlayerName") then
            for _, body in pairs(npc:GetDescendants()) do
                if body:IsA("BasePart") then
                    body.Color = Color3.fromRGB(128, 128, 128)
                end
            end
        end
    end
    print("Đã làm NPC xám")
end

-- 4. XÓA HIỆU ỨNG TRÁI/MELEE/KIẾM/SÚNG (CỰC MẠNH + ƯU TIÊN SKULL GUITAR & DRAGON)
local EffectConnection
local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or 
           obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or 
           obj:IsA("Explosion") or obj:IsA("Attachment") then
            
            local name = string.lower(obj.Name .. (obj.Parent and " " .. obj.Parent.Name or "") .. (obj.Parent and obj.Parent.Parent and " " .. obj.Parent.Parent.Name or ""))
            
            -- Ưu tiên xóa Skull Guitar (Soul Guitar) và Dragon
            if string.find(name, "skull") or string.find(name, "soul") or string.find(name, "guita") or
               string.find(name, "dragon") or string.find(name, "talon") or string.find(name, "breath") or
               string.find(name, "fruit") or string.find(name, "effect") or string.find(name, "skill") or
               string.find(name, "melee") or string.find(name, "sword") or string.find(name, "gun") then
                pcall(function() obj:Destroy() end)
            else
                pcall(function() obj:Destroy() end) -- Xóa hết effects còn lại
            end
        end
    end
    
    -- Xóa effects trong tool đang cầm
    pcall(function()
        if Character then
            for _, tool in pairs(Character:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, eff in pairs(tool:GetDescendants()) do
                        if eff:IsA("ParticleEmitter") or eff:IsA("Trail") or eff:IsA("Beam") then
                            eff:Destroy()
                        end
                    end
                end
            end
        end
    end)
end

-- 5. FIX LỖI XOAY KIẾM CDK Z (CHẠY LIÊN TỤC SAU KHI DÙNG XONG)
local SpinConnection
local function FixSpin()
    if SpinConnection then SpinConnection:Disconnect() end
    SpinConnection = RunService.Heartbeat:Connect(function()
        if Character and RootPart then
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool and (string.find(string.lower(tool.Name), "cursed") or string.find(string.lower(tool.Name), "katana") or string.find(string.lower(tool.Name), "song")) then
                local pos = RootPart.Position
                RootPart.CFrame = CFrame.new(pos) * CFrame.Angles(0, RootPart.CFrame:ToOrientation(), 0)
                Humanoid.PlatformStand = false
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
    print("Đã fix lỗi xoay CDK Z (chạy liên tục)")
end

-- 6. FIX LỖI KHÔNG HIỆN VẬT PHẨM TRONG KHO ĐỒ
local function FixInventory()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
    end)
    print("Đã refresh inventory")
end

-- ================== CHẠY CHÍNH ==================
ClearDecorations()
GrayGroundAndSea()
GrayNPC()
RemoveEffects()
FixSpin()
FixInventory()

-- LOOP XÓA EFFECTS CỰC MẠNH (mỗi frame)
if EffectConnection then EffectConnection:Disconnect() end
EffectConnection = RunService.Heartbeat:Connect(RemoveEffects)

-- LOOP LÀM XÁM NPC (vì NPC spawn mới)
spawn(function()
    while true do
        wait(3)
        GrayNPC()
    end
end)

-- Khi respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    wait(2)
    ClearDecorations()
    GrayGroundAndSea()
    GrayNPC()
    FixSpin()
end)

print("Script hoàn tất + ĐÃ CẬP NHẬT!")
print("- Mặt đất & biển xám")
print("- Effects trái/melee/kiếm/súng bị xóa cực sạch (Skull Guitar & Dragon ưu tiên)")
print("- Fix xoay CDK Z tốt hơn")
print("F9 để xem console. Enjoy!")
