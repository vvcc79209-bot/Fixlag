-- BLOX FRUITS FIX LAG - GRAY MODE
-- HIDE TREE / HOUSE / DECOR
-- REMOVE ALL SKILL EFFECTS
-- KEEP PLAYER + NPC

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-- ===== LIGHTING (TRỜI XÁM) =====
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 1
Lighting.Ambient = Color3.fromRGB(140,140,140)
Lighting.OutdoorAmbient = Color3.fromRGB(140,140,140)

for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky")
    or v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

-- ===== BIỂN XÁM =====
Terrain.WaterColor = Color3.fromRGB(140,140,140)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-- ===== HÀM KIỂM TRA =====
local function IsCharacter(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid")
end

local function IsGround(part)
    return part:IsA("BasePart") and part.Size.Y >= 8
end

-- ===== CORE =====
local function Fix(v)
    -- BỎ QUA PLAYER + NPC
    if IsCharacter(v) then return end

    -- NỀN ĐẤT (GIỮ + XÁM)
    if v:IsA("BasePart") and IsGround(v) then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(140,140,140)
        v.CastShadow = false
        return
    end

    -- CÂY / NHÀ / DECOR → ẨN
    if v:IsA("BasePart") then
        v.Transparency = 1
        v.CanCollide = false
        v.CastShadow = false
    end

    -- XOÁ HIỆU ỨNG SKILL
    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam")
    or v:IsA("Explosion")
    or v:IsA("Fire")
    or v:IsA("Smoke")
    or v:IsA("Sparkles")
    or v:IsA("PointLight")
    or v:IsA("SurfaceLight")
    or v:IsA("SpotLight")
    or v:IsA("Highlight") then
        pcall(function()
            v.Enabled = false
            v:Destroy()
        end)
    end
end

-- ===== ÁP DỤNG CHO MAP =====
for _,v in ipairs(workspace:GetDescendants()) do
    Fix(v)
end

-- ===== CHẶN VẬT THỂ / SKILL MỚI =====
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

-- FPS BOOST
settings().Rendering.QualityLevel = 1

print("✅ FIX LAG ENABLED: MAP GRAY | TREE & HOUSE HIDDEN | SKILLS REMOVED")
