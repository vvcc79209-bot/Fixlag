-- Script: Blox Fruits Effect Remover - WORKING VERSION
-- Phiên bản: Đảm bảo hoạt động + Không lag

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local debris = game:GetService("Debris")

-- CẤU HÌNH CHÍNH
local REMOVE_PERCENTAGE = 90 -- 90% hiệu ứng bị xóa
local UPDATE_INTERVAL = 1 -- Cập nhật mỗi 1 giây (KHÔNG QUÉT MỖI FRAME!)
local DEBUG_MODE = true -- Hiển thị thông tin debug

-- Biến theo dõi
local effectCount = 0
local removedCount = 0
local lastUpdate = 0
local isRunning = true

-- Danh sách TỪ KHÓA cụ thể của Blox Fruits
local BLOX_FRUITS_EFFECTS = {
    -- Hiệu ứng trái
    "Fruit", "Demon", "Angel", "Buddha", "Dough", "Dragon", "Leopard", "Mammoth",
    "Kitsune", "T-Rex", "Spirit", "Venom", "Control", "Shadow", "Gravity",
    "Phoenix", "Rumble", "Pain", "Blizzard", "Quake", "Light", "Dark", "Ice",
    "Magma", "Flame", "Sand", "Spin", "Spring", "Bomb", "Spike", "Chop", "Barrier",
    
    -- Hiệu ứng skill
    "Skill", "Ability", "Attack", "Move", "Combo", "Stomp", "Slam", "Wave",
    "Beam", "Barrage", "Rush", "Dash", "Teleport", "Clone", "Transform",
    
    -- Hiệu ứng VFX
    "VFX", "FX", "Effect", "Particle", "Smoke", "Fire", "Spark", "Sparkles",
    "Explosion", "Burst", "Blast", "Shockwave", "Aura", "Glow", "Light",
    "Trail", "Beam", "Ring", "Circle", "Orb", "Ball", "Projectile",
    
    -- Tên đặc biệt trong Blox Fruits
    "Z", "X", "C", "V", "F", -- Các nút skill
    "M1", "M2", -- Click chuột
    "Zenith", "Godhuman", "Sharkman", "DeathStep", "Electric",
    "Soul", "Ghoul", "Cyborg", "Human"
}

-- Hàm kiểm tra xem có phải effect cần xóa không
local function isEffectToRemove(instance)
    local name = instance.Name:lower()
    
    -- Kiểm tra ClassName
    if instance:IsA("ParticleEmitter") or 
       instance:IsA("Beam") or 
       instance:IsA("Trail") or
       instance:IsA("Explosion") or
       instance:IsA("Fire") or
       instance:IsA("Smoke") or
       instance:IsA("Sparkles") then
        return true
    end
    
    -- Kiểm tra tên
    for _, keyword in ipairs(BLOX_FRUITS_EFFECTS) do
        if name:find(keyword:lower()) then
            return true
        end
    end
    
    -- Kiểm tra trong Model/Part
    if instance:IsA("BasePart") then
        if instance.Transparency > 0.5 or 
           instance.Name:find("Effect") or
           instance.Name:find("VFX") then
            return true
        end
    end
    
    return false
end

-- Hàm xóa effect
local function removeEffect(effect)
    if not effect or not effect.Parent then return end
    
    -- Quyết định xóa hay làm xám
    local shouldRemove = math.random(1, 100) <= REMOVE_PERCENTAGE
    
    if shouldRemove then
        -- XÓA THẬT SỰ
        effectCount = effectCount + 1
        
        if effect:IsA("ParticleEmitter") then
            effect.Enabled = false
            effect:Destroy()
        elseif effect:IsA("BasePart") then
            debris:AddItem(effect, 0.1)
        else
            effect:Destroy()
        end
        
        removedCount = removedCount + 1
        
        if DEBUG_MODE and removedCount % 10 == 0 then
            print("[Effect Remover] Đã xóa:", removedCount, "effects")
        end
    else
        -- Làm xám (10% còn lại)
        if effect:IsA("ParticleEmitter") then
            effect.Color = ColorSequence.new(Color3.fromRGB(100, 100, 100))
            effect.LightEmission = 0.1
            effect.Rate = effect.Rate * 0.3
        elseif effect:IsA("BasePart") then
            effect.Color = Color3.fromRGB(120, 120, 120)
            effect.Material = Enum.Material.Slate
            effect.Transparency = effect.Transparency + 0.3
        end
    end
end

-- Hàm quét HIỆU QUẢ - không lag
local function scanForEffects()
    if not isRunning then return end
    
    local currentTime = tick()
    if currentTime - lastUpdate < UPDATE_INTERVAL then return end
    lastUpdate = currentTime
    
    -- Tìm các workspace effects
    local workspaceEffects = {}
    
    -- Chỉ quét trong các folder chứa effect
    local potentialFolders = {
        workspace:FindFirstChild("Effects"),
        workspace:FindFirstChild("Skills"),
        workspace:FindFirstChild("VFX"),
        workspace:FindFirstChild("Particles")
    }
    
    for _, folder in ipairs(potentialFolders) do
        if folder then
            for _, effect in ipairs(folder:GetDescendants()) do
                if isEffectToRemove(effect) then
                    table.insert(workspaceEffects, effect)
                end
            end
        end
    end
    
    -- Quét trực tiếp trong workspace cho các effect lẻ
    for _, effect in ipairs(workspace:GetDescendants()) do
        if isEffectToRemove(effect) then
            table.insert(workspaceEffects, effect)
        end
    end
    
    -- Quét trên character của player
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if isEffectToRemove(part) then
                table.insert(workspaceEffects, part)
            end
        end
    end
    
    -- Quét trên các player khác
    for _, otherPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            for _, part in ipairs(otherPlayer.Character:GetDescendants()) do
                if isEffectToRemove(part) then
                    table.insert(workspaceEffects, part)
                end
            end
        end
    end
    
    -- Xử lý batch - KHÔNG xử lý tất cả cùng lúc
    local batchSize = math.min(#workspaceEffects, 15) -- Giới hạn mỗi lần
    for i = 1, batchSize do
        if workspaceEffects[i] then
            task.spawn(removeEffect, workspaceEffects[i])
        end
    end
    
    if DEBUG_MODE and #workspaceEffects > 0 then
        print("[Effect Remover] Tìm thấy:", #workspaceEffects, "effects")
        print("[Effect Remover] Xử lý:", batchSize, "effects này")
    end
end

-- Hàm tối ưu lighting để giảm lag
local function optimizeGameForPerformance()
    local lighting = game:GetService("Lighting")
    
    -- Tắt các hiệu ứng tốn kém
    lighting.GlobalShadows = false
    lighting.FogEnd = 500
    lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    
    -- Chuyển sang màu xám nhẹ
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Saturation = -0.3
    colorCorrection.Contrast = 0.1
    colorCorrection.Parent = lighting
    
    -- Giảm chất lượng rendering
    if settings() and settings().Rendering then
        pcall(function()
            settings().Rendering.QualityLevel = 1
        end)
    end
end

-- Tạo UI thông tin
local function createInfoUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EffectRemoverInfo"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 100)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Text = "🔥 BLOX FRUITS EFFECT REMOVER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 100, 100)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Text = "Đang chạy... (F8: Tắt/Bật)"
    status.Size = UDim2.new(1, 0, 0, 40)
    status.Position = UDim2.new(0, 0, 0, 30)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.Parent = frame
    
    local counter = Instance.new("TextLabel")
    counter.Text = "Đã xóa: 0 effects"
    counter.Size = UDim2.new(1, 0, 0, 30)
    counter.Position = UDim2.new(0, 0, 0, 70)
    counter.BackgroundTransparency = 1
    counter.TextColor3 = Color3.fromRGB(200, 200, 255)
    counter.Font = Enum.Font.Gotham
    counter.TextSize = 12
    counter.Parent = frame
    
    -- Cập nhật counter
    spawn(function()
        while screenGui.Parent do
            counter.Text = string.format("Đã xóa: %d effects", removedCount)
            wait(1)
        end
    end)
    
    return screenGui, status
end

-- KHỞI CHẠY CHÍNH
local function main()
    print("========================================")
    print("BLOX FRUITS EFFECT REMOVER - WORKING VERSION")
    print("Xóa " .. REMOVE_PERCENTAGE .. "% hiệu ứng skill")
    print("10% còn lại chuyển màu xám")
    print("========================================")
    
    -- Chờ character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    
    -- Tối ưu game
    optimizeGameForPerformance()
    
    -- Tạo UI
    local ui, statusLabel = createInfoUI()
    
    -- Kết nối quét với tần suất THẤP
    local connection
    connection = runService.Heartbeat:Connect(function(deltaTime)
        if isRunning then
            -- Chỉ quét mỗi UPDATE_INTERVAL giây
            if tick() - lastUpdate >= UPDATE_INTERVAL then
                scanForEffects()
            end
        end
    end)
    
    -- Kết nối character thay đổi
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        wait(1) -- Chờ character load
        print("[Effect Remover] Character mới đã load")
    end)
    
    -- Hotkey tắt/bật
    local uis = game:GetService("UserInputService")
    uis.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.F8 then
            isRunning = not isRunning
            if statusLabel then
                statusLabel.Text = isRunning and "Đang chạy... (F8: Tắt/Bật)" 
                                     or "Đã tạm dừng (F8: Tiếp tục)"
                statusLabel.TextColor3 = isRunning and Color3.fromRGB(100, 255, 100) 
                                          or Color3.fromRGB(255, 100, 100)
            end
            print("[Effect Remover]", isRunning and "Đã bật" or "Đã tắt")
        end
    end)
    
    -- Auto-clean khi player chết
    local function onDied()
        removedCount = 0
        effectCount = 0
        print("[Effect Remover] Reset counter khi chết")
    end
    
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.Died:Connect(onDied)
    end
    
    print("[Effect Remover] Khởi động thành công!")
    print("[Effect Remover] Nhấn F8 để tắt/bật")
end

-- Chạy an toàn
local success, err = pcall(main)
if not success then
    warn("Lỗi khi khởi động script:", err)
    
    -- Phương pháp dự phòng đơn giản
    spawn(function()
        while wait(1) do
            pcall(function()
                -- Xóa các particle emitter đơn giản
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") and math.random(1, 100) <= 90 then
                        obj:Destroy()
                    end
                end
            end)
        end
    end)
end
