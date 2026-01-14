-- Blox Fruits ULTRA LOW EFFECTS (100% REMOVAL)
-- Fix: still seeing skill effects

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ================== CẤU HÌNH ==================
local UltraMode = true   -- true = xoá 100% hiệu ứng
-- ============================================

-- Tắt toàn bộ hiệu ứng ánh sáng
for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
    or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
        v:Destroy()
    end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 0

-- Hàm xoá hiệu ứng
local function RemoveEffects(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj:Destroy()
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    elseif obj:IsA("Highlight") then
        obj:Destroy()
    elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        obj:Destroy()
    elseif obj:IsA("Attachment") then
        -- Nhiều effect skill gắn vào Attachment
        for _,child in pairs(obj:GetChildren()) do
            RemoveEffects(child)
        end
    end
end

-- Quét toàn bộ game
for _,v in pairs(game:GetDescendants()) do
    RemoveEffects(v)
end

-- Theo dõi: bất cứ hiệu ứng mới sinh ra đều bị xoá ngay
game.DescendantAdded:Connect(function(v)
    task.wait()
    RemoveEffects(v)
end)

-- Giảm vật liệu cho mọi Part
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0
        v.CastShadow = false
    end
end

-- Chất lượng thấp nhất
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

print("🚀 ULTRA MODE FIXED: 100% skill effects removed (Fruit, Sword, Gun, Melee, Normal Attacks)")
