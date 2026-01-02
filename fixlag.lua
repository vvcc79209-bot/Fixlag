-- BLOX FRUITS FIX LAG
-- REMOVE TREE / HOUSE / DECOR
-- KEEP GROUND / TERRAIN

local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-- ===== LIGHTING =====
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 1
Lighting.Ambient = Color3.fromRGB(135,135,135)
Lighting.OutdoorAmbient = Color3.fromRGB(135,135,135)

for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky")
    or v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

-- ===== SEA =====
Terrain.WaterColor = Color3.fromRGB(135,135,135)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-- ===== CHECK GROUND =====
local function IsGround(part)
    if not part:IsA("BasePart") then return false end
    if part:IsDescendantOf(Terrain) then return true end
    if part.Size.Y >= 8 then return true end -- nền thường rất dày
    return false
end

-- ===== CORE FUNCTION =====
local function Fix(v)
    -- GIỮ NỀN
    if v:IsA("BasePart") then
        if IsGround(v) then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(135,135,135)
            v.CastShadow = false
        else
            -- XOÁ CÂY / NHÀ / DECOR
            if v.Parent:IsA("Model") then
                pcall(function()
                    v.Parent:Destroy()
                end)
            else
                pcall(function()
                    v:Destroy()
                end)
            end
        end
    end

    -- XOÁ HIỆU ỨNG SKILL
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

-- ===== APPLY =====
for _,v in ipairs(workspace:GetDescendants()) do
    Fix(v)
end

-- ===== BLOCK NEW OBJECTS =====
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

-- ===== FPS BOOST =====
settings().Rendering.QualityLevel = 1

print("✅ FIX LAG: TREE + HOUSE REMOVED | GROUND KEPT")
