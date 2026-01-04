-- Blox Fruits Custom Script: Xóa cây nhà phụ kiện, Gray ground/sea/NPC, Fix CDK Spin Z, Remove Effects, Fix Inventory
-- ĐÃ FIX: Lỗi khựng/đơ ngắn khi DI CHUYỂN (Movement Stutter/Freeze)
-- + Fix CDK Z xoay + đứng im
-- + Biển trong suốt vẫn bơi/đi lại
-- + MÀU NHẠT + TRONG SUỐT (Faded Translucent Vibe) ĐÃ THÊM MỚI

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

-- 2. MẶT ĐẤT XÁM + BIỂN TRONG SUỐT
local function GrayGroundAndTransparentSea()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = string.lower(part.Name)
            if string.find(name, "ground") or string.find(name, "grass") or string.find(name, "dirt") or string.find(name, "sand") or
               string.find(name, "baseplate") or string.find(name, "floor") then
                part.Color = Color3.fromRGB(128, 128, 128)
                part.Material = Enum.Material.Concrete
            elseif string.find(name, "sea") or string.find(name, "water") then
                part.Transparency = 1
                part.Material = Enum.Material.Water
                part.CanCollide = true
            end
        end
    end
    print("Đã làm đất xám + biển trong suốt")
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

-- 4. XÓA HIỆU ỨNG (TỐI ƯU)
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
    print("Đã fix CDK Z (tối ưu mượt)")
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

-- 8. MÀU NHẠT + TRONG SUỐT (Faded Translucent Vibe) - MỚI NHẤT
local function ApplyFadedTranslucentEffect()
    -- Xóa effect cũ nếu tồn tại
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect.Name == "FadedTranslucent_CC" or effect.Name == "FadedTranslucent_Bloom" or effect.Name == "FadedTranslucent_DOF" then
            effect:Destroy()
        end
    end

    -- ColorCorrection: Màu cực nhạt + trong suốt vibe
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "FadedTranslucent_CC"
    cc.Enabled = true
    cc.Saturation = -0.8          -- Rất nhạt (có thể đổi -0.9 hoặc -1 nếu muốn nhạt hơn nữa)
    cc.Brightness = 0.08          -- Tăng sáng nhẹ
    cc.Contrast = 0.15
    cc.TintColor = Color3.fromRGB(220, 235, 255)  -- Tint nhẹ xanh nhạt/trắng cho cảm giác trong suốt mát mẻ
    cc.Parent = Lighting

    -- Bloom nhẹ: Phát sáng mờ, tăng vibe trong suốt
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "FadedTranslucent_Bloom"
    bloom.Enabled = true
    bloom.Intensity = 0.3
    bloom.Threshold = 1.8
    bloom.Size = 20
    bloom.Parent = Lighting

    -- DepthOfField nhẹ: Làm hậu cảnh mờ mơ màng (tăng cảm giác trong suốt)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Name = "FadedTranslucent_DOF"
    dof.Enabled = true
    dof.FocusDistance = 50
    dof.InFocusRadius = 30
    dof.NearIntensity = 0.4
    dof.FarIntensity = 0.3
    dof.Parent = Lighting

    print("Đã áp dụng màu NHẠT + TRONG SUỐT cực chill!")
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
ApplyFadedTranslucentEffect()  -- Thêm hiệu ứng màu nhạt + trong suốt

-- Loop xóa hiệu ứng
spawn(function()
    while true do
        wait(10)
        RemoveEffects()
    end
end)

-- Khi respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    wait(1)
    SetNetworkOwnership()
    ClearDecorations()
    GrayGroundAndTransparentSea()
    ApplyFadedTranslucentEffect()  -- Áp dụng lại hiệu ứng màu
    FixCDKIssues()
    FixMovementStutter()
end)

print("Script Blox Fruits HOÀN HẢO + MÀU NHẠT TRONG SUỐT + FIX TẤT CẢ LỖI! F9 xem console.")

-- Script Blox Fruits: Biến đất thành màu xám (Grayscale toàn thế giới), xóa biển (invisible water/fog) nhưng vẫn bơi/đi lại bình thường
-- Tác giả: Grok (dựa trên Roblox API)
-- Cách dùng: Copy toàn bộ code này paste vào Executor (Krnl, Synapse X, Fluxus, Script-Ware PC | Mobile: Delta, Codex, Arceus X)
-- Chạy trong Blox Fruits. Toggle bằng Insert key.
-- Lưu ý: Client-side, không ảnh hưởng server. Có thể bị detect nếu abuse, dùng acc phụ.

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Enabled = true

-- Tạo GUI toggle (optional)
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Grayscale + No Sea: ON (Insert to toggle)"
ToggleButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Effects
local ColorCorrection = nil
local Atmosphere = nil

local function ApplyEffects()
    if not Enabled then return end
    
    -- Grayscale toàn bộ (đất, mobs, items thành xám)
    if not ColorCorrection then
        ColorCorrection = Instance.new("ColorCorrectionEffect")
        ColorCorrection.Parent = Lighting
    end
    ColorCorrection.Saturation = -1  -- Desaturate hoàn toàn
    ColorCorrection.Contrast = 0.1   -- Tăng contrast cho xám đẹp
    ColorCorrection.Brightness = -0.05
    ColorCorrection.TintColor = Color3.fromRGB(128, 128, 128) / 255  -- Bias xám trung tính
    
    -- Xóa biển: Transparent water terrain global
    Terrain.WaterTransparency = 1
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    
    -- No fog (xóa sương mù biển)
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    
    -- No atmosphere (nếu có, clear sky/water haze)
    Atmosphere = Lighting:FindFirstChild("Atmosphere")
    if Atmosphere then
        Atmosphere.Density = 0
        Atmosphere.Offset = 999
        Atmosphere.Color = Color3.new(1,1,1)
        Atmosphere.Decay = Color3.new(0,0,0)
        Atmosphere.Glare = 0
        Atmosphere.Haze = 0
    end
end

local function RemoveEffects()
    if ColorCorrection then
        ColorCorrection:Destroy()
        ColorCorrection = nil
    end
    Terrain.WaterTransparency = 0
    Terrain.WaterWaveSize = 0.15  -- Default Roblox
    Terrain.WaterWaveSpeed = 35
    Lighting.FogEnd = 100000  -- Default-ish
    Lighting.FogStart = 0
    if Atmosphere then
        Atmosphere.Density = 0.25  -- Restore if possible
    end
end

-- Loop transparent water parts (pools ở islands, respawn)
spawn(function()
    while true do
        if Enabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Material == Enum.Material.Water or string.lower(obj.Name):find("water") or string.lower(obj.Name):find("sea")) then
                    obj.Transparency = 1
                    obj.CanCollide = true  -- Giữ collision nếu có
                end
            end
        end
        wait(2)  -- Check mỗi 2s, không lag
    end
end)

-- Toggle
ToggleButton.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ApplyEffects()
        ToggleButton.Text = "Grayscale + No Sea: ON (Insert to toggle)"
        ToggleButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
    else
        RemoveEffects()
        ToggleButton.Text = "Grayscale + No Sea: OFF"
        ToggleButton.BackgroundColor3 = Color3.new(0.5, 0, 0)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        Enabled = not Enabled
        if Enabled then ApplyEffects() else RemoveEffects() end
        ToggleButton.Text = "Grayscale + No Sea: " .. (Enabled and "ON" or "OFF") .. " (Insert to toggle)"
        ToggleButton.BackgroundColor3 = Enabled and Color3.new(0,0.5,0) or Color3.new(0.5,0,0)
    end
end)

-- Áp dụng ngay
ApplyEffects()
print("Script loaded! Nhấn Insert để toggle. Đất xám, biển biến mất nhưng vẫn bơi bình thường!")
