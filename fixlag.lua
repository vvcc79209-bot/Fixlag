-- Blox Fruits Effect Reducer + Ultra Low Mode
-- Remove 90% effects: Fruit, Sword, Gun, Melee, Normal Attacks
-- By ChatGPT

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- ================== CẤU HÌNH ==================
local UltraMode = true   -- true = CỰC NHẸ (xoá gần 100% hiệu ứng)
                          -- false = chỉ giảm ~90%
-- ============================================

-- Tắt hiệu ứng ánh sáng
for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
    or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 0

-- Hàm xử lý hiệu ứng
local function ReduceEffects(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        if UltraMode then
            obj:Destroy()
        else
            obj.Enabled = false
        end
    elseif obj:IsA("Fire") or obj:IsA("Smoke") then
        if UltraMode then
            obj:Destroy()
        else
            obj.Enabled = false
        end
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end
end

-- Áp dụng toàn bộ map
for _,v in pairs(workspace:GetDescendants()) do
    ReduceEffects(v)
end

-- Tự động xoá hiệu ứng khi skill / chém / bắn / đánh thường sinh ra
workspace.DescendantAdded:Connect(function(v)
    task.wait(0.05)
    ReduceEffects(v)
end)

-- Giảm vật liệu để nhẹ máy hơn
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0
    end
end

-- Giảm chất lượng render
if UltraMode then
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    print("🚀 ULTRA MODE: Gần như toàn bộ hiệu ứng đã bị xoá!")
else
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level03
    print("✅ NORMAL MODE: Đã giảm ~90% hiệu ứng!")
end
