-- BLOX FRUITS FIX LAG
-- HIDE TREE / HOUSE / DECOR
-- KEEP GROUND + KEEP CHARACTERS

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-- ===== LIGHTING =====
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.Brightness = 1
Lighting.Ambient = Color3.fromRGB(150,150,150)
Lighting.OutdoorAmbient = Color3.fromRGB(150,150,150)

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
Terrain.WaterColor = Color3.fromRGB(150,150,150)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-- ===== CHECK =====
local function IsCharacter(obj)
    local model = obj:FindFirstAncestorOfClass("Model")
    if not model then return false end
    return model:FindFirstChildOfClass("Humanoid") ~= nil
end

local function IsGround(part)
    return part:IsA("BasePart") and part.Size.Y >= 8
end

-- ===== CORE =====
local function Fix(v)
    -- BỎ QUA PLAYER + NPC
    if IsCharacter(v) then return end

    if v:IsA("BasePart") then
        if IsGround(v) then
            -- GIỮ NỀN
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(150,150,150)
            v.CastShadow = false
        else
            -- ẨN CÂY / NHÀ / DECOR
            v.Transparency = 1
            v.CanCollide = false
            v.CastShadow = false
        end
    end

    -- TẮT HIỆU ỨNG SKILL
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

print("✅ FIX LAG OK: KEEP CHARACTER | HIDE DECOR")
