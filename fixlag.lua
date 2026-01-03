-- Blox Fruits Custom Script: Xóa cây nhà phụ kiện, Gray ground/sea/NPC, Fix CDK Spin Z, Remove Effects, Fix Inventory
-- Load bằng executor như Synapse X, KRNL, etc.
-- KHÔNG xóa đất Sea 2, KHÔNG gray sun
-- Fix nhấn mạnh: CDK (Song Kiếm) Z spin sau khi dùng xong
-- Thêm: Làm biển trong suốt (Transparency = 1) nhưng giữ Material Water và CanCollide để vẫn bơi/đi lại được

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Detect Sea (1: First Sea ~0, 2: Second ~7000 Y, 3: Third ~-5000 Y)
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
                -- Không xóa nếu là ground/baseplate/sea hoặc Sea 2
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

-- 2. LÀM MẶT ĐẤT XÁM VÀ BIỂN TRONG SUỐT (GIỮ PHYSICS BIỂN)
local function GrayGroundAndTransparentSea()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = string.lower(part.Name)
            if string.find(name, "ground") or string.find(name, "grass") or string.find(name, "dirt") or string.find(name, "sand") or
               string.find(name, "baseplate") or string.find(name, "floor") then
                part.Color = Color3.fromRGB(128, 128, 128) -- Gray cho đất
                part.Material = Enum.Material.Concrete
            elseif string.find(name, "sea") or string.find(name, "water") then
                part.Transparency = 1 -- Trong suốt hoàn toàn
                part.Material = Enum.Material.Water -- Giữ material Water để bơi/đi lại
                part.CanCollide = true -- Đảm bảo collide (thường đã true)
                -- Không thay đổi color để tránh xung đột visual, nhưng có thể gray nếu muốn: part.Color = Color3.fromRGB(128, 128, 128)
            end
        elseif part:IsA("Terrain") then
            -- Gray terrain nếu có (nhưng terrain nước khó transparent, giả sử biển là BasePart)
            pcall(function()
                part.Color = Color3.fromRGB(128, 128, 128)
            end)
        end
    end
    -- KHÔNG gray sun: Lighting.Sun không touch
    print("Đã làm mặt đất xám và biển trong suốt (vẫn bơi/đi lại được)")
end

-- 3. LÀM NPC XÁM
local function GrayNPC()
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Name ~= "Enemies" then -- NPCs không phải enemies
            for _, body in pairs(npc:GetDescendants()) do
                if body:IsA("BasePart") then
                    body.Color = Color3.fromRGB(128, 128, 128)
                end
            end
        end
    end
    print("Đã làm NPC xám")
end

-- 4. XÓA HIỆU ỨNG SKILL TRÁI, VÕ, KIẾM, SÚNG (ĐẶC BIỆT SKULL GUITA, DRAGON)
local function RemoveEffects()
    -- Clear tất cả particles, beams, attachments trong workspace và tools
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("Attachment") then
            obj:Destroy()
        end
    end
    -- Clear effects trong character/tools
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _, eff in pairs(tool:GetDescendants()) do
                if eff:IsA("ParticleEmitter") or eff:IsA("Beam") or eff:IsA("Trail") then
                    eff:Destroy()
                end
            end
        end
    end
    -- Disable Lighting effects dư thừa
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
    -- Specific: Dragon, Skull Guitar (Soul Guitar?), fruits
    for _, part in pairs(Workspace:GetDescendants()) do
        local name = string.lower(part.Name)
        if string.find(name, "dragon") or string.find(name, "skull") or string.find(name, "guita") or string.find(name, "fruit") then
            if part:IsA("ParticleEmitter") or part:IsA("Beam") then part:Destroy() end
        end
    end
    print("Đã xóa hiệu ứng skill trái/võ/kiếm/súng/dragon/skull guitar")
end

-- 5. FIX LỖI XOAY KIẾM (CDK Z MOVE SPIN) - NHẤN MẠNH FIX SAU KHI DÙNG XONG
local SpinConnection
local function FixSpin()
    if SpinConnection then SpinConnection:Disconnect() end
    SpinConnection = RunService.Heartbeat:Connect(function()
        if Character and RootPart then
            -- Reset rotation mỗi frame nếu đang spin (detect by tool activated)
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool and string.find(string.lower(tool.Name), "cursed") or string.find(string.lower(tool.Name), "katana") or string.find(string.lower(tool.Name), "song") then
                -- Fix spin: set CFrame no rotation
                local pos = RootPart.Position
                RootPart.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(RootPart.Rotation.Y), 0) -- Giữ Y rot, reset X/Z
                Humanoid.PlatformStand = false
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
    print("Đã fix lỗi xoay CDK Z (chạy liên tục sau khi dùng)")
end

-- 6. FIX LỖI KHÔNG HIỆN VẬT PHẨM TRONG KHO ĐỒ
local function FixInventory()
    -- Refresh inventory GUI
    local inv = LocalPlayer.PlayerGui:FindFirstChild("Main"):FindFirstChild("Inventory")
    if inv then
        -- Fire remote to sync (common fix)
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
        end)
        -- Rejoin nếu cần (comment nếu không muốn)
        -- game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
    print("Đã fix inventory (refresh)")
end

-- CHẠY TẤT CẢ
ClearDecorations()
GrayGroundAndTransparentSea()
GrayNPC()
RemoveEffects()
FixSpin()
FixInventory()

-- Loop clear effects mỗi 5s (dư thừa)
spawn(function()
    while true do
        wait(5)
        RemoveEffects()
    end
end)

-- Update khi respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    wait(1)
    ClearDecorations()
    GrayGroundAndTransparentSea()
    FixSpin()
end)

print("Script hoàn tất! F9 để xem console.")
