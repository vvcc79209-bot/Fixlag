-- Script: Blox Fruits Mobile Optimizer
-- Tối ưu cho điện thoại, giảm hiệu ứng 90%, 10% còn lại màu xám
-- Phiên bản: Mobile Friendly - Không lag

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- CẤU HÌNH CHO ĐIỆN THOẠI
local isMobile = UserInputService.TouchEnabled
local REMOVE_CHANCE = 0.9 -- 90%
local UPDATE_RATE = 2 -- Giây (chậm hơn cho điện thoại)
local MAX_EFFECTS_PER_FRAME = 5 -- Giới hạn để không lag

-- Biến toàn cục
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local EffectsRemoved = 0
local LastUpdate = 0
local ScriptEnabled = true

-- Danh sách hiệu ứng đặc trưng Blox Fruits
local EFFECT_KEYWORDS = {
    -- Hiệu ứng trái
    "FruitEffect", "DevilFruit", "Awakening", 
    -- Kỹ năng
    "Skill", "Ability", "Move", "Attack", "Combat",
    -- VFX
    "VFX", "Effect", "Particle", "Smoke", "Fire", 
    "Sparkles", "Explosion", "Aura", "Glow", "Trail",
    -- Các nút
    "ZEffect", "XEffect", "CEffect", "VEffect", "FEffect",
    -- Đặc biệt
    "M1", "M2", "Slam", "Stomp", "Wave", "Beam", "Rush"
}

-- TỐI ƯU HÓA CHO ĐIỆN THOẠI
local function optimizeForMobile()
    if not isMobile then return end
    
    print("[Mobile] Đang tối ưu hóa cho điện thoại...")
    
    -- Giảm chất lượng đồ họa
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 300
    Lighting.Brightness = 2
    
    -- Tắt các hiệu ứng không cần thiết
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
    
    -- Chế độ màu xám nhẹ
    local grayEffect = Instance.new("ColorCorrectionEffect")
    grayEffect.Name = "MobileGrayEffect"
    grayEffect.Saturation = -0.4
    grayEffect.Contrast = 0.05
    grayEffect.Parent = Lighting
    
    -- Giảm physics
    settings().Physics.PhysicsEnvironmentalThrottle = 2
end

-- Hàm kiểm tra hiệu ứng cần xử lý
local function shouldProcess(obj)
    -- Kiểm tra ClassName
    if obj:IsA("ParticleEmitter") or 
       obj:IsA("Beam") or 
       obj:IsA("Trail") or
       obj:IsA("Fire") or
       obj:IsA("Smoke") or
       obj:IsA("Sparkles") then
        return true
    end
    
    -- Kiểm tra tên
    local objName = obj.Name:lower()
    for _, keyword in pairs(EFFECT_KEYWORDS) do
        if objName:find(keyword:lower()) then
            return true
        end
    end
    
    -- Kiểm tra thuộc tính
    if obj:IsA("BasePart") then
        if obj.Transparency > 0.6 or 
           obj.Material == Enum.Material.Neon or
           obj.Name:match("Effect") or
           obj.Name:match("VFX") then
            return true
        end
    end
    
    return false
end

-- Hàm xử lý hiệu ứng (nhẹ nhàng cho điện thoại)
local function processEffect(effect)
    if not effect or not effect.Parent then return false end
    
    local randomChance = math.random()
    
    if randomChance <= REMOVE_CHANCE then
        -- Xóa 90% hiệu ứng
        EffectsRemoved += 1
        
        if effect:IsA("ParticleEmitter") then
            -- Tắt từ từ để không giật
            effect.Enabled = false
            task.wait(0.05)
            effect:Destroy()
        elseif effect:IsA("BasePart") then
            effect.Transparency = 1
            task.wait(0.1)
            effect:Destroy()
        else
            effect:Destroy()
        end
        
        return true
    else
        -- 10% còn lại chuyển màu xám
        if effect:IsA("ParticleEmitter") then
            effect.Color = ColorSequence.new(
                Color3.fromRGB(150, 150, 150)
            )
            effect.LightEmission = 0.1
            effect.Rate = effect.Rate * 0.2 -- Giảm đáng kể
        elseif effect:IsA("BasePart") then
            effect.Color = Color3.fromRGB(120, 120, 120)
            effect.Material = Enum.Material.SmoothPlastic
            effect.Transparency = math.min(effect.Transparency + 0.3, 0.8)
        elseif effect:IsA("Beam") or effect:IsA("Trail") then
            effect.Color = ColorSequence.new(
                Color3.fromRGB(130, 130, 130)
            )
            effect.Width0 = effect.Width0 * 0.5
            effect.Width1 = effect.Width1 * 0.5
        end
        return false
    end
end

-- Quét và xử lý (tối ưu cho điện thoại)
local function mobileFriendlyScan()
    if not ScriptEnabled then return end
    if tick() - LastUpdate < UPDATE_RATE then return end
    
    LastUpdate = tick()
    
    local foundEffects = {}
    local processedCount = 0
    
    -- Ưu tiên quét character trước
    if Character and Character.Parent then
        for _, obj in pairs(Character:GetDescendants()) do
            if shouldProcess(obj) then
                table.insert(foundEffects, obj)
            end
        end
    end
    
    -- Quét workspace (giới hạn để không lag)
    local importantFolders = {
        workspace:FindFirstChild("Effects"),
        workspace:FindFirstChild("VFX"),
        workspace:FindFirstChild("Skills")
    }
    
    for _, folder in pairs(importantFolders) do
        if folder and processedCount < 20 then
            for _, obj in pairs(folder:GetDescendants()) do
                if shouldProcess(obj) then
                    table.insert(foundEffects, obj)
                    processedCount += 1
                    if processedCount >= 20 then break end
                end
            end
        end
        if processedCount >= 20 then break end
    end
    
    -- Xử lý từng effect với delay để không lag
    for i = 1, math.min(#foundEffects, MAX_EFFECTS_PER_FRAME) do
        task.spawn(function()
            processEffect(foundEffects[i])
        end)
        -- Delay nhỏ giữa các effect
        if i % 2 == 0 then
            task.wait(0.02)
        end
    end
    
    if #foundEffects > 0 and EffectsRemoved % 10 == 0 then
        print(string.format("[Mobile] Đã xử lý %d hiệu ứng", EffectsRemoved))
    end
end

-- UI ĐƠN GIẢN CHO ĐIỆN THOẠI
local function createMobileUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileEffectRemoverUI"
    ScreenGui.DisplayOrder = 999
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Frame chính
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 200, 0, 60)
    MainFrame.Position = UDim2.new(0.5, -100, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = "📱 MOBILE OPTIMIZER"
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(100, 200, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.Parent = MainFrame
    
    -- Status
    local Status = Instance.new("TextLabel")
    Status.Text = "Đang chạy..."
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 20)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.fromRGB(100, 255, 100)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 11
    Status.Parent = MainFrame
    
    -- Counter
    local Counter = Instance.new("TextLabel")
    Counter.Text = "Effects: 0"
    Counter.Size = UDim2.new(1, 0, 0, 20)
    Counter.Position = UDim2.new(0, 0, 0, 40)
    Counter.BackgroundTransparency = 1
    Counter.TextColor3 = Color3.fromRGB(200, 200, 255)
    Counter.Font = Enum.Font.Gotham
    Counter.TextSize = 11
    Counter.Parent = MainFrame
    
    -- Nút tắt/bật (cho điện thoại)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 40)
    ToggleButton.Position = UDim2.new(1, 5, 0, 10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleButton.Text = "ON"
    ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 12
    ToggleButton.Parent = MainFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        ScriptEnabled = not ScriptEnabled
        if ScriptEnabled then
            Status.Text = "Đang chạy..."
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
            ToggleButton.Text = "ON"
            ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            Status.Text = "Đã tắt"
            Status.TextColor3 = Color3.fromRGB(255, 100, 100)
            ToggleButton.Text = "OFF"
            ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    -- Cập nhật counter
    spawn(function()
        while ScreenGui.Parent do
            Counter.Text = string.format("Effects: %d", EffectsRemoved)
            task.wait(1)
        end
    end)
    
    -- Cho phép kéo frame
    local dragging = false
    local dragInput, dragStart, startPos
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return ScreenGui, Status
end

-- KHỞI ĐỘNG
local function initializeMobile()
    print("=================================")
    print("BLOX FRUITS MOBILE OPTIMIZER")
    print("Dành cho điện thoại")
    print("Xóa 90% hiệu ứng, 10% còn lại xám")
    print("=================================")
    
    -- Chờ character
    if not Character then
        Character = Player.CharacterAdded:Wait()
    end
    
    -- Tối ưu cho mobile
    optimizeForMobile()
    
    -- Tạo UI
    local ui, statusLabel = createMobileUI()
    
    -- Kết nối quét
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if ScriptEnabled then
            mobileFriendlyScan()
        end
    end)
    
    -- Xử lý character thay đổi
    Player.CharacterAdded:Connect(function(newChar)
        Character = newChar
        task.wait(2) -- Chờ lâu hơn cho mobile
        print("[Mobile] Character mới đã load")
    end)
    
    -- Auto-clean khi vào server
    task.wait(5)
    print("[Mobile] Đang dọn dẹp hiệu ứng cũ...")
    
    -- Clean mạnh khi mới vào game
    spawn(function()
        task.wait(10)
        for i = 1, 3 do
            mobileFriendlyScan()
            task.wait(1)
        end
        print("[Mobile] Dọn dẹp hoàn tất!")
    end)
    
    print("[Mobile] Script đã sẵn sàng!")
    print("[Mobile] Chạm vào nút ON/OFF để tắt bật")
end

-- PHƯƠNG PHÁP ĐƠN GIẢN HƠN (nếu vẫn lag)
local function simpleMobileMethod()
    -- Chỉ xóa particle emitters - cách nhẹ nhất
    spawn(function()
        while task.wait(2) do
            if not ScriptEnabled then continue end
            
            local count = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") and math.random() <= 0.9 then
                    obj.Enabled = false
                    task.wait(0.01)
                    obj:Destroy()
                    count += 1
                    
                    if count >= 10 then break end
                end
            end
            
            if count > 0 then
                EffectsRemoved += count
                print(string.format("[Simple] Đã xóa %d particles", count))
            end
        end
    end)
end

-- CHẠY AN TOÀN
local success, err = pcall(initializeMobile)
if not success then
    warn("[Mobile] Lỗi khởi động:", err)
    print("[Mobile] Đang chạy chế độ đơn giản...")
    pcall(simpleMobileMethod)
end

-- THÊM TÍNH NĂNG AUTO-CLOSE KHI FPS THẤP
if isMobile then
    spawn(function()
        local lastTime = tick()
        local frames = 0
        
        while task.wait(0.5) do
            frames += 1
            if tick() - lastTime >= 2 then
                local fps = frames / 2
                
                -- Nếu FPS quá thấp, tự động tắt
                if fps < 15 and ScriptEnabled then
                    print(string.format("[Mobile] FPS thấp (%d), đang tắt script...", fps))
                    ScriptEnabled = false
                    
                    -- Bật lại sau 30 giây
                    task.wait(30)
                    ScriptEnabled = true
                    print("[Mobile] Đã bật lại script")
                end
                
                frames = 0
                lastTime = tick()
            end
        end
    end)
end
