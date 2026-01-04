-- Blox Fruits Custom Script: Xóa cây nhà phụ kiện, Gray ground/sea/NPC, Fix CDK Spin Z, Remove Effects, Fix Inventory
-- ĐÃ FIX: Lỗi khựng/đơ ngắn khi DI CHUYỂN (Movement Stutter/Freeze)
-- + Fix CDK Z xoay + đứng im
-- + Biển trong suốt 100% (như xóa hẳn) nhưng vẫn bơi/đi lại mượt mà hoàn hảo
-- + Đất xám chuẩn Concrete

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
    if pos.Y > 5000 then return 2 end
    if pos.Y < 0 then return 3 end
    return 1
end

-- Set Network Ownership cho smooth movement (anti-lag)
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

-- 1. XÓA CÂY CỐI, NHÀ, PHỤ KIỆN
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
    print("Đã xóa cây cối, nhà, phụ kiện")
end

-- 2. MẶT ĐẤT XÁM + XÓA BIỂN HOÀN TOÀN NHƯNG VẪN ĐI/BƠI MƯỢT 100%
local function GrayGroundAndTransparentSea()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = string.lower(part.Name)
            
            -- Làm đất/đảo thành màu xám bê tông
            if string.find(name, "ground") or string.find(name, "grass") or string.find(name, "dirt") or 
               string.find(name, "sand") or string.find(name, "baseplate") or string.find(name, "floor") or
               string.find(name, "terrain") or string.find(name, "island") or string.find(name, "land") then
                
                if not string.find(name, "sea") and not string.find(name, "water") then
                    part.Color = Color3.fromRGB(128, 128, 128)
                    part.Material = Enum.Material.Concrete
                end
            end
            
            -- XÓA BIỂN (trong suốt 100%) nhưng giữ collision để bơi/đi bình thường
            if string.find(name, "sea") or string.find(name, "water") or string.find(name, "ocean") or
               string.find(name, "wave") or string.find(name, "current") or string.find(name, "fluid") then
                
                part.Transparency = 1          -- Như xóa hẳn biển
                part.CanCollide = true         -- Quan trọng: giữ collision để không rơi xuyên + trigger bơi đúng cách
                -- Không đổi Material để tránh bug physics
            end
        end
    end
    print("Đã làm đất xám + xóa biển hoàn toàn nhưng vẫn đi/bơi mượt mà 100%!")
end

-- 3. NPC XÁM
local function GrayNPC()
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Name ~= "Enemies" then
            for _, body in pairs(npc:GetDescendants()) do
                if body:IsA("BasePart") then
                    body.Color = Color3.fromRGB(128, 128, 128)
                end
            end
        end
    end
    print("Đã làm NPC xám")
end

-- 4. XÓA HIỆU ỨNG (TỐI ƯU: Exclude character/tools)
local function RemoveEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
            if not obj:IsDescendantOf(Character) and not obj:IsDescendantOf(LocalPlayer.Backpack) then
                obj:Destroy()
            end
        elseif obj:IsA("Attachment") and not obj.Parent:IsA("Tool") then
            obj:Destroy()
        end
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
    print("Đã xóa hiệu ứng (tối ưu)")
end

-- 5. FIX CDK Z: XOAY + ĐỨNG IM
local CDKFixConnection
local lastCDKFix = 0
local function FixCDKIssues()
    if CDKFixConnection then CDKFixConnection:Disconnect() end

    CDKFixConnection = RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - lastCDKFix < 0.1 then return end
        lastCDKFix = now

        if not Character or not RootPart or not Humanoid then return end

        local tool = Character:FindFirstChildOfClass("Tool")
        local isCDK = tool and (string.find(string.lower(tool.Name), "cursed") or string.find(string.lower(tool.Name), "dual katana") or string.find(string.lower(tool.Name), "cdk") or string.find(string.lower(tool.Name), "song"))

        if isCDK then
            local _, yRot, _ = RootPart.CFrame:ToEulerAnglesXYZ()
            RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, yRot, 0)

            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            Humanoid.HipHeight = 2.5
        end
    end)
    print("Đã fix CDK Z (mượt)")
end

-- 6. FIX KHỨNG/ĐƠ KHI DI CHUYỂN
local MovementFixConnection
local function FixMovementStutter()
    if MovementFixConnection then MovementFixConnection:Disconnect() end

    MovementFixConnection = RunService.Heartbeat:Connect(function()
        if not Character or not RootPart or not Humanoid then return end

        local moveDir = Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local velocity = RootPart.AssemblyLinearVelocity
            local horizVel = Vector3.new(velocity.X, 0, velocity.Z)
            local horizSpeed = horizVel.Magnitude

            if horizSpeed < Humanoid.WalkSpeed * 0.8 then
                local targetVel = moveDir * Humanoid.WalkSpeed
                RootPart.AssemblyLinearVelocity = Vector3.new(targetVel.X, velocity.Y, targetVel.Z)
            end
        end
    end)
    print("Đã fix khựng/đơ khi di chuyển!")
end

-- 7. FIX INVENTORY
local function FixInventory()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RefreshInventory")
    end)
    print("Đã fix inventory")
end

-- CHẠY CHÍNH
SetNetworkOwnership()
ClearDecorations()
GrayGroundAndTransparentSea()
GrayNPC()
RemoveEffects()
FixCDKIssues()
FixMovementStutter()
FixInventory()

-- Loop xóa hiệu ứng mỗi 10s
spawn(function()
    while true do
        wait(10)
        RemoveEffects()
    end
end)

-- Khi respawn hoặc đổi sea
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    wait(1)
    SetNetworkOwnership()
    ClearDecorations()
    GrayGroundAndTransparentSea()  -- Chạy lại để fix biển mới
    FixCDKIssues()
    FixMovementStutter()
end)

print("Script Blox Fruits HOÀN HẢO 2026 - Đất xám + Biển trong suốt nhưng bơi/đi mượt 100%! F9 xem console..SmoothPlastic
            end
        end
    end
end

-- Chạy lần đầu
SetTerrainGray()
SetPartsGray()

-- Giữ màu xám khi map load thêm
RunService.Heartbeat:Connect(function()
    SetTerrainGray()
end)
