-- BLOX FRUITS FIX LAG - REAL WORKING VERSION

local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local RunService = game:GetService("RunService")

-- ===== LIGHTING =====
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 1
Lighting.Ambient = Color3.fromRGB(130,130,130)
Lighting.OutdoorAmbient = Color3.fromRGB(130,130,130)

for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect") or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

-- ===== TERRAIN / SEA =====
Terrain.WaterColor = Color3.fromRGB(130,130,130)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-- ===== CORE FIX FUNCTION =====
local function FixObject(v)
    -- PART / MESHPART
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(130,130,130)
        v.CastShadow = false
        v.Reflectance = 0
    end

    -- REMOVE TEXTURE / DECAL
    if v:IsA("Texture") or v:IsA("Decal") then
        v:Destroy()
    end

    -- REMOVE MESH DETAIL
    if v:IsA("SpecialMesh") then
        v.TextureId = ""
    end

    -- REMOVE EFFECTS (SKILLS)
    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam")
    or v:IsA("Explosion")
    or v:IsA("Fire")
    or v:IsA("Smoke")
    or v:IsA("Sparkles") then
        v:Destroy()
    end
end

-- ===== APPLY ALL =====
for _,v in ipairs(workspace:GetDescendants()) do
    FixObject(v)
end

-- ===== BLOCK NEW EFFECTS =====
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    FixObject(v)
end)

-- ===== FPS BOOST =====
settings().Rendering.QualityLevel = 1
RunService:Set3dRenderingEnabled(true)

print("✅ BLOX FRUITS FIX LAG – GRAY MODE ENABLED")
