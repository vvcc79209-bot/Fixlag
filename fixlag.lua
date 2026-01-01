-- ===============================
-- ROBLOX EXTREME FPS BOOST SCRIPT
-- ===============================

local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

-- Tắt toàn bộ hiệu ứng ánh sáng
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
Lighting.ExposureCompensation = 0
Lighting.ClockTime = 14
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)

-- Xóa các hiệu ứng nặng
for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect")
    or v:IsA("DepthOfFieldEffect") then
        v:Destroy()
    end
end

-- Giảm chất lượng terrain
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- Ép vật liệu về Plastic + xám (giảm GPU)
for _,obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow = false
        obj.Color = Color3.fromRGB(140,140,140)
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Smoke")
    or obj:IsA("Fire") then
        obj.Enabled = false
    end
end

-- Giảm render client
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.EagerBulkExecution = false
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01

print("✅ ROBLOX FIX LAG: FPS BOOST ON")
