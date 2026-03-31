--// EXTREME FPS BOOST - BLOX FRUITS (SAFE MAX VERSION)

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- Safe call
local function safe(f)
    local s,e = pcall(f)
    if not s then warn(e) end
end

-- 1. XOÁ 100% HIỆU ỨNG (KHÔNG DESTROY)
local function removeEffects(obj)

    -- Particle / Trail / Beam
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
        obj.Lifetime = NumberRange.new(0)
        obj.Transparency = NumberSequence.new(1)
    end

    -- Light
    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj.Enabled = false
    end

    -- Explosion
    if obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end

    -- Effect Parts
    if obj:IsA("BasePart") then
        local n = obj.Name:lower()
        if n:find("effect") or n:find("fx") or n:find("skill") then
            obj.Transparency = 1
            obj.Material = Enum.Material.SmoothPlastic
        end
    end

    -- 2. XOÁ SOUND SKILL
    if obj:IsA("Sound") then
        if obj.Name:lower():find("skill") or obj.Volume > 0 then
            obj.Volume = 0
        end
    end
end

-- 3. XOÁ SKY + ÁNH SÁNG (KHÔNG GÂY BUG MAP)
safe(function()
    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then
            v:Destroy()
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
end)

-- 4. GIẢM TEXTURE MAP
local function optimizeMap(obj)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
    end

    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    end
end

-- 5. PLAYER + NPC
local function optimizeChar(char)
    safe(function()
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(120,120,120)
                v.Material = Enum.Material.SmoothPlastic
            end
        end

        -- xoá phụ kiện
        for _,v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end
    end)
end

-- APPLY BAN ĐẦU
for _,v in pairs(workspace:GetDescendants()) do
    removeEffects(v)
    optimizeMap(v)
end

-- LISTENER (hiệu ứng mới sinh ra)
workspace.DescendantAdded:Connect(function(v)
    safe(function()
        removeEffects(v)
        optimizeMap(v)
    end)
end)

-- APPLY PLAYER
for _,plr in pairs(Players:GetPlayers()) do
    if plr.Character then
        optimizeChar(plr.Character)
    end
    plr.CharacterAdded:Connect(optimizeChar)
end

-- FIX CAMERA (TRÁNH BUG LEVI/BIỂN)
safe(function()
    workspace.CurrentCamera.FieldOfView = 70
end)

print("🔥 EXTREME FPS BOOST LOADED")
