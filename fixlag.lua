--[[ 
    BLOX FRUITS FIX LAG VFX
    Xoá hiệu ứng: Trái - Kiếm - Súng - Đánh thường
    Tác dụng: giảm lag cực mạnh (client-side)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Danh sách class hiệu ứng cần xoá
local REMOVE_CLASSES = {
    "ParticleEmitter",
    "Trail",
    "Beam",
    "Explosion",
    "Fire",
    "Smoke",
    "Sparkles",
    "Highlight",
    "PointLight",
    "SurfaceLight",
    "SpotLight"
}

-- Hàm kiểm tra class
local function isEffect(obj)
    for _, class in ipairs(REMOVE_CLASSES) do
        if obj:IsA(class) then
            return true
        end
    end
    return false
end

-- Xoá / vô hiệu hoá hiệu ứng
local function removeEffect(obj)
    if isEffect(obj) then
        pcall(function()
            obj.Enabled = false
            obj:Destroy()
        end)
    end

    -- Xoá mesh / decal skill
    if obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function()
            obj:Destroy()
        end)
    end

    -- Làm trong suốt hitbox / model skill
    if obj:IsA("BasePart") then
        pcall(function()
            obj.Transparency = 1
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
        end)
    end

    -- Giảm âm thanh skill
    if obj:IsA("Sound") then
        pcall(function()
            obj.Volume = 0
            obj:Destroy()
        end)
    end
end

-- Quét toàn bộ game lúc bật script
for _, v in ipairs(game:GetDescendants()) do
    removeEffect(v)
end

-- Tự động xoá hiệu ứng mới sinh ra
game.DescendantAdded:Connect(function(obj)
    task.wait()
    removeEffect(obj)
end)

-- Tối ưu thêm: giảm render
RunService:Set3dRenderingEnabled(true)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

-- Fix lag nhân vật
if player.Character then
    for _, v in ipairs(player.Character:GetDescendants()) do
        removeEffect(v)
    end
end

player.CharacterAdded:Connect(function(char)
    char.DescendantAdded:Connect(removeEffect)
end)

print("✅ FIX LAG BLOX FRUITS: Đã xoá tối đa hiệu ứng!")
