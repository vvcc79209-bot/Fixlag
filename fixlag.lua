-- BLOX FRUITS FIX LAG
-- HIDE TREE / HOUSE / DECOR
-- KEEP GROUND

local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-- ===== LIGHTING (XÁM) =====
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

-- ===== BIỂN =====
Terrain.WaterColor = Color3.fromRGB(140,140,140)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-- ===== TÊN ĐỐI TƯỢNG CẦN ẨN =====
local removeNames = {
    "tree","bush","leaf","house","home","building",
    "decor","prop","rock","stone","plant","grass",
    "lamp","wall","roof","window","door"
}

-- ===== CHECK NỀN =====
local function IsGround(part)
    if not part:IsA("BasePart") then return false end
    if part.Size.Y >= 7 then return true end -- nền rất dày
    return false
end

-- ===== CORE =====
local function Fix(v)
    -- ẨN CÂY / NHÀ / DECOR
    if v:IsA("BasePart") and not IsGround(v) then
        local n = string.lower(v.Name)
        for _,k in ipairs(removeNames) do
            if string.find(n,k) then
                v.Transparency = 1
                v.CanCollide = false
                v.CastShadow = false
                return
            end
        end
    end

    -- GIỮ NỀN (XÁM)
    if v:IsA("BasePart") and IsGround(v) then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(140,140,140)
        v.CastShadow = false
    end

    -- XOÁ HIỆU ỨNG SKILL
    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam")
    or v:IsA("Explosion")
    or v:IsA("Fire")
    or v:IsA("Smoke")
    or v:IsA("Sparkles") then
        v.Enabled = false
    end
end

-- ===== APPLY =====
for _,v in ipairs(workspace:GetDescendants()) do
    Fix(v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

settings().Rendering.QualityLevel = 1

print("✅ FIX LAG: TREE + HOUSE HIDDEN | GROUND KEPT")
