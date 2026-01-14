-- Blox Fruits Effect Reducer (90%)
-- Remove most skill, sword, gun, melee, normal attack effects

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Tắt toàn bộ hiệu ứng ánh sáng
for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
    or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 0

-- Hàm xử lý xoá / tắt hiệu ứng
local function ReduceEffects(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
    elseif obj:IsA("Fire") or obj:IsA("Smoke") then
        obj.Enabled = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end
end

-- Áp dụng cho toàn map
for _,v in pairs(workspace:GetDescendants()) do
    ReduceEffects(v)
end

-- Tự động xoá hiệu ứng mới sinh ra (skill, chém kiếm, bắn súng, đánh thường)
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
settings().Rendering.QualityLevel = Enum.QualityLevel.Level03

print("✅ Blox Fruits: 90% skill effects removed (Fruit, Sword, Gun, Melee, Normal Attack)")
