-- BLOX FRUITS FIX LAG - FULL CUSTOM
-- HIDE TREE / HOUSE / DECOR
-- KEEP GROUND
-- GRAY GROUND + SEA
-- REMOVE ALL SKILL EFFECTS
-- FIX SWORD SPIN BUG
-- NPC GRAY
-- KEEP SKY / SUN NORMAL

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-------------------------------------------------
-- LIGHTING (GIỮ TRỜI / MẶT TRỜI BÌNH THƯỜNG)
-------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10

-- ❌ KHÔNG xoá Sky
for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

-------------------------------------------------
-- SEA (XÁM)
-------------------------------------------------
Terrain.WaterColor = Color3.fromRGB(145,145,145)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-------------------------------------------------
-- CHECK FUNCTIONS
-------------------------------------------------
local function IsCharacter(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid")
end

local function IsNPC(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(m)
end

local function IsGround(part)
    return part:IsA("BasePart") and part.Size.Y >= 8
end

-------------------------------------------------
-- CORE FIX
-------------------------------------------------
local function Fix(v)
    -- ===== NPC MÀU XÁM =====
    if IsNPC(v) and v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(145,145,145)
        v.CastShadow = false
        return
    end

    -- ===== GIỮ PLAYER =====
    if IsCharacter(v) then return end

    -- ===== NỀN ĐẤT =====
    if v:IsA("BasePart") and IsGround(v) then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(145,145,145)
        v.CastShadow = false
        return
    end

    -- ===== CÂY / NHÀ / DECOR =====
    if v:IsA("BasePart") then
        v.Transparency = 1
        v.CanCollide = false
        v.CastShadow = false
    end

    -- ===== XOÁ HIỆU ỨNG SKILL + FIX KIẾM XOAY =====
    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam")
    or v:IsA("Explosion")
    or v:IsA("Fire")
    or v:IsA("Smoke")
    or v:IsA("Sparkles")
    or v:IsA("Highlight")
    or v:IsA("PointLight")
    or v:IsA("SurfaceLight")
    or v:IsA("SpotLight") then
        pcall(function()
            v.Enabled = false
            v:Destroy()
        end)
    end
end

-------------------------------------------------
-- APPLY TO MAP
-------------------------------------------------
for _,v in ipairs(workspace:GetDescendants()) do
    Fix(v)
end

-------------------------------------------------
-- BLOCK NEW EFFECTS (DRAGON / SKULL GUITAR / ALL)
-------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

-------------------------------------------------
-- FPS BOOST
-------------------------------------------------
settings().Rendering.QualityLevel = 1

print("✅ FIX LAG FULL ENABLED")
