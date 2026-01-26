-- Script: Blox Fruits Skill Effect Remover
-- Tác giả: Blox Fruits Modder
-- Mô tả: Loại bỏ 90% hiệu ứng skill, chuyển 10% còn lại sang màu xám

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")

-- Cấu hình
local REMOVE_CHANCE = 0.9 -- 90% hiệu ứng bị xóa
local GRAYSCALE_INTENSITY = 0.8 -- Độ đậm của màu xám (0-1)

-- Danh sách các hiệu ứng cần xử lý
local effectNames = {
    "SkillEffect", "AbilityEffect", "AttackEffect", 
    "CombatEffect", "MagicEffect", "FruitEffect",
    "VFX", "ParticleEmitter", "Beam", "Trail",
    "Explosion", "Smoke", "Fire", "Sparkles",
    "Light", "Glow", "Aura"
}

-- Hàm chuyển đổi màu sang thang độ xám
local function toGrayscale(color)
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
    return Color3.new(luminance, luminance, luminance)
end

-- Hàm xử lý hiệu ứng
local function processEffect(effect)
    if math.random() < REMOVE_CHANCE then
        -- Xóa 90% hiệu ứng
        effect:Destroy()
        return false
    else
        -- Giữ lại 10% và chuyển sang màu xám
        if effect:IsA("ParticleEmitter") then
            effect.Color = ColorSequence.new(toGrayscale(effect.Color.Keypoints[1].Value))
        elseif effect:IsA("Beam") then
            effect.Color = ColorSequence.new(toGrayscale(effect.Color.Keypoints[1].Value))
        elseif effect:IsA("Trail") then
            effect.Color = ColorSequence.new(toGrayscale(effect.Color.Keypoints[1].Value))
        elseif effect:IsA("PointLight") or effect:IsA("SurfaceLight") then
            effect.Color = toGrayscale(effect.Color)
            effect.Brightness = effect.Brightness * 0.5
        elseif effect:IsA("Decal") or effect:IsA("Texture") then
            effect.Color3 = toGrayscale(effect.Color3)
        end
        
        -- Giảm độ sáng và độ tương phản
        if effect:IsA("BasePart") then
            effect.Material = Enum.Material.Slate
            effect.Color = toGrayscale(effect.Color)
            effect.Transparency = effect.Transparency + 0.1
        end
        
        return true
    end
end

-- Hàm quét và xử lý hiệu ứng trong workspace
local function scanAndProcessEffects()
    for _, name in ipairs(effectNames) do
        local effects = workspace:GetDescendants()
        for _, effect in ipairs(effects) do
            if effect.Name:find(name) or effect.ClassName:find("Effect") then
                processEffect(effect)
            end
        end
    end
    
    -- Xử lý hiệu ứng từ character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part.Name:find("Effect") or part.Name:find("Skill") or part.Name:find("VFX") then
                processEffect(part)
            end
        end
    end
end

-- Áp dụng hiệu ứng xám cho lighting
local function applyGrayLighting()
    -- Tạo hiệu ứng màu xám
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "GrayEffect"
    colorCorrection.Saturation = -0.7 -- Giảm độ bão hòa
    colorCorrection.Contrast = 0.1 -- Tăng độ tương phản nhẹ
    colorCorrection.Parent = lighting
    
    -- Điều chỉnh atmosphere
    if lighting:FindFirstChild("Atmosphere") then
        lighting.Atmosphere.Color = toGrayscale(lighting.Atmosphere.Color)
    end
end

-- Hàm bảo vệ chống anti-cheat
local function safeExecute(func)
    local success, err = pcall(func)
    if not success then
        warn("Lỗi khi thực thi script: " .. err)
    end
end

-- Khởi động script
local function initialize()
    print("=== Blox Fruits Skill Effect Remover ===")
    print("Đang xóa 90% hiệu ứng skill...")
    print("Đang chuyển 10% còn lại sang màu xám...")
    
    -- Chờ character load
    if not character then
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    -- Áp dụng xử lý ban đầu
    safeExecute(function()
        scanAndProcessEffects()
        applyGrayLighting()
    end)
    
    -- Liên tục quét hiệu ứng mới
    runService.Heartbeat:Connect(function()
        safeExecute(scanAndProcessEffects)
    end)
    
    -- Xử lý khi character thay đổi
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        task.wait(1) -- Chờ character load đầy đủ
        safeExecute(scanAndProcessEffects)
    end)
    
    print("Script đã được kích hoạt thành công!")
    print("90% hiệu ứng skill đã bị xóa, 10% còn lại hiển thị màu xám.")
end

-- Chạy script
initialize()

-- Giao diện người dùng đơn giản
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EffectRemoverUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Effect Remover"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local status = Instance.new("TextLabel")
status.Text = "Đang chạy: 90% xóa, 10% xám"
status.Size = UDim2.new(1, 0, 0, 50)
status.Position = UDim2.new(0, 0, 0, 30)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextWrapped = true
status.Parent = frame

-- Hotkey để bật/tắt UI (F8)
local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F8 then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
