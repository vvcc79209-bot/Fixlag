-- BLOX FRUITS FIX LAG - FULL & SAFE VERSION
-- FIX SWORD SPIN BUG
-- FIX INVENTORY BUG

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local RunService = game:GetService("RunService")

--------------------------------------------------
-- LIGHTING (GIỮ TRỜI / MẶT TRỜI)
--------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10

for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

--------------------------------------------------
-- SEA (XÁM)
--------------------------------------------------
Terrain.WaterColor = Color3.fromRGB(150,150,150)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

--------------------------------------------------
-- CHECK FUNCTIONS
--------------------------------------------------
local function IsCharacter(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid")
end

local function IsNPC(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid")
       and not Players:GetPlayerFromCharacter(m)
end

local function IsTool(obj)
    return obj:FindFirstAncestorOfClass("Tool") ~= nil
end

local function IsGround(part)
    return part:IsA("BasePart") and part.Size.Y >= 8
end

--------------------------------------------------
-- CORE FIX
--------------------------------------------------
local function Fix(v)
    -- ❌ KHÔNG ĐỤNG TOOL / INVENTORY
    if IsTool(v) then return end

    -- NPC MÀU XÁM
    if IsNPC(v) and v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(150,150,150)
        v.CastShadow = false
        return
    end

    -- PLAYER GIỮ NGUYÊN
    if IsCharacter(v) then return end

    -- NỀN ĐẤT
    if v:IsA("BasePart") and IsGround(v) then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(150,150,150)
        v.CastShadow = false
        return
    end

    -- CÂY / NHÀ / DECOR
    if v:IsA("BasePart") then
        v.Transparency = 1
        v.CanCollide = false
        v.CastShadow = false
    end

    -- XOÁ HIỆU ỨNG SKILL
    if v:IsA("ParticleEmitter")
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

    -- 🔧 FIX KIẾM XOAY (CỰC QUAN TRỌNG)
    if v:IsA("Trail") then
        pcall(function()
            v.Enabled = false
            v.Lifetime = 0
            v:Destroy()
        end)
    end

    if v:IsA("AngularVelocity")
    or v:IsA("BodyAngularVelocity")
    or v:IsA("Motor6D") then
        pcall(function()
            v:Destroy()
        end)
    end
end

--------------------------------------------------
-- APPLY BAN ĐẦU
--------------------------------------------------
for _,v in ipairs(workspace:GetDescendants()) do
    Fix(v)
end

--------------------------------------------------
-- CHẶN EFFECT MỚI (DRAGON / SKULL GUITAR / ALL)
--------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

--------------------------------------------------
-- FPS BOOST
--------------------------------------------------
settings().Rendering.QualityLevel = 1

print("✅ FIX LAG FULL ENABLED | SWORD BUG FIXED | INVENTORY OK")
