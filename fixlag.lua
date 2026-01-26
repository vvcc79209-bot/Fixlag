-- Script: Blox Fruits Effect Optimizer (Không lag)
-- Tác giả: Blox Fruits Modder
-- Phiên bản: Tối ưu hiệu suất

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local ts = game:GetService("TweenService")

-- Cấu hình hiệu suất
local PERFORMANCE_MODE = true -- Bật chế độ tiết kiệm
local SCAN_INTERVAL = 0.5 -- Quét mỗi 0.5 giây thay vì mỗi frame
local BATCH_SIZE = 20 -- Xử lý 20 effects mỗi lần
local EFFECT_CACHE = {} -- Cache để tránh xử lý trùng

-- Cấu hình hiệu ứng
local REMOVE_CHANCE = 0.9
local GRAYSCALE_INTENSITY = 0.8

-- Danh sách effects ưu tiên
local priorityEffects = {
    "SkillEffect", "AbilityEffect", "AttackEffect",
    "FruitEffect", "VFX", "ParticleEmitter"
}

-- Cache cho các effect đã xử lý
local processedEffects = {}
local lastScanTime = 0

-- Hàm chuyển màu sang xám (tối ưu)
local function toGrayscale(color)
    return Color3.new(0.5, 0.5, 0.5) -- Màu xám cố định để tiết kiệm tính toán
end

-- Hàm xử lý effect với debounce
local function processEffectOptimized(effect)
    if processedEffects[effect] then return end
    
    -- Đánh dấu đã xử lý
    processedEffects[effect] = true
    
    if math.random() < REMOVE_CHANCE then
        -- Xóa với delay để tránh freeze
        task.spawn(function()
            task.wait(math.random() * 0.1) -- Random delay
            if effect and effect.Parent then
                effect.Enabled = false
                task.wait(0.05)
                effect:Destroy()
            end
        end)
    else
        -- Chuyển sang màu xám (ít tốn kém)
        task.spawn(function()
            if effect:IsA("ParticleEmitter") then
                effect.Rate = effect.Rate * 0.5 -- Giảm số lượng particle
                effect.Lifetime = NumberRange.new(effect.Lifetime.Min * 0.7, effect.Lifetime.Max * 0.7)
            end
            
            if effect:IsA("BasePart") then
                effect.Material = Enum.Material.Slate
                effect.Transparency = math.min(effect.Transparency + 0.2, 0.8)
            end
        end)
    end
end

-- Quét hiệu ứng với tối ưu
local function optimizedScan()
    local currentTime = tick()
    if currentTime - lastScanTime < SCAN_INTERVAL then return end
    lastScanTime = currentTime
    
    -- Chỉ quét các effect mới
    local effectsFound = 0
    
    -- Quét character trước (quan trọng hơn)
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            for _, effectName in ipairs(priorityEffects) do
                if part.Name:find(effectName) then
                    processEffectOptimized(part)
                    effectsFound = effectsFound + 1
                    if effectsFound >= BATCH_SIZE then return end
                    break
                end
            end
        end
    end
    
    -- Quét workspace (giới hạn phạm vi)
    local nearbyRegion = workspace:FindFirstChild("Effects") or 
                         workspace:FindFirstChild("Skills") or
                         workspace
    
    for _, effect in ipairs(nearbyRegion:GetDescendants()) do
        if effectsFound >= BATCH_SIZE then break end
        
        for _, effectName in ipairs(priorityEffects) do
            if effect.Name:find(effectName) and not processedEffects[effect] then
                -- Kiểm tra khoảng cách (chỉ xử lý effects gần player)
                if character and effect:IsA("BasePart") then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local distance = (humanoidRootPart.Position - effect.Position).Magnitude
                        if distance > 500 then -- Chỉ xử lý trong 500 studs
                            continue
                        end
                    end
                end
                
                processEffectOptimized(effect)
                effectsFound = effectsFound + 1
                break
            end
        end
    end
end

-- Tối ưu lighting (chạy 1 lần)
local function optimizeLighting()
    -- Giảm chất lượng lighting để tăng FPS
    lighting.GlobalShadows = false
    lighting.FogEnd = 1000
    lighting.Brightness = 2
    lighting.ExposureCompensation = 0.5
    
    -- Thêm color correction để làm xám
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Saturation = -0.5
    colorCorrection.Contrast = 0.1
    colorCorrection.TintColor = Color3.fromRGB(128, 128, 128)
    colorCorrection.Enabled = PERFORMANCE_MODE
    colorCorrection.Parent = lighting
end

-- Hủy effects cũ
local function cleanupOldEffects()
    for effect, _ in pairs(processedEffects) do
        if not effect or not effect.Parent then
            processedEffects[effect] = nil
        end
    end
    
    -- Thu gom bộ nhớ
    if #table.keys(processedEffects) > 1000 then
        local newTable = {}
        local count = 0
        for effect, _ in pairs(processedEffects) do
            if effect and effect.Parent then
                newTable[effect] = true
                count = count + 1
                if count >= 500 then break end
            end
        end
        processedEffects = newTable
    end
end

-- Khởi tạo với FPS cao
local function initializeOptimized()
    print("=== Blox Fruits Performance Optimizer ===")
    print("Chế độ: " .. (PERFORMANCE_MODE and "Tiết kiệm FPS" or "Bình thường"))
    print("Quét mỗi: " .. SCAN_INTERVAL .. " giây")
    
    -- Chờ character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    
    -- Thiết lập ban đầu
    optimizeLighting()
    
    -- Lập lịch quét với interval
    local scanConnection
    scanConnection = runService.Heartbeat:Connect(function(deltaTime)
        -- Sử dụng deltaTime để điều chỉnh tần suất
        if PERFORMANCE_MODE then
            optimizedScan()
            
            -- Dọn dẹp mỗi 5 giây
            if tick() % 5 < deltaTime then
                cleanupOldEffects()
            end
        end
    end)
    
    -- Xử lý character mới
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        task.wait(2) -- Chờ character ổn định
        processedEffects = {} -- Reset cache
    end)
    
    print("Tối ưu hóa hoàn tất!")
    print("FPS sẽ được cải thiện đáng kể")
end

-- Giao diện nhẹ
local function createLightUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PerformanceUI"
    screenGui.DisplayOrder = 999
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local info = Instance.new("TextLabel")
    info.Text = "Performance Mode: ON"
    info.Size = UDim2.new(0, 150, 0, 30)
    info.Position = UDim2.new(1, -160, 1, -40)
    info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    info.BackgroundTransparency = 0.7
    info.TextColor3 = Color3.fromRGB(0, 255, 0)
    info.Font = Enum.Font.RobotoMono
    info.TextSize = 12
    info.Parent = screenGui
    
    -- Update FPS counter
    local lastTime = tick()
    local frames = 0
    
    runService.Heartbeat:Connect(function()
        frames = frames + 1
        if tick() - lastTime >= 1 then
            local fps = math.floor(frames / (tick() - lastTime))
            info.Text = "FPS: " .. fps .. " | Mode: ON"
            frames = 0
            lastTime = tick()
        end
    end)
    
    return screenGui
end

-- Chạy script tối ưu
task.spawn(function()
    initializeOptimized()
    createLightUI()
    
    -- Hotkey tắt/bật chế độ performance
    local uis = game:GetService("UserInputService")
    uis.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.F9 then
            PERFORMANCE_MODE = not PERFORMANCE_MODE
            print("Performance Mode: " .. (PERFORMANCE_MODE and "ON" or "OFF"))
        end
    end)
end)
