-- =========================
-- ⚙️ ULTRA LOW GRAPHICS
-- =========================

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

local Lighting = game:GetService("Lighting")

Lighting.GlobalShadows = false
Lighting.FogEnd = 1000000
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _,v in pairs(Lighting:GetDescendants()) do
    if v:IsA("BloomEffect")
    or v:IsA("BlurEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("ColorCorrectionEffect")
    or v:IsA("DepthOfFieldEffect") then
        pcall(function() v:Destroy() end)
    end
end

-- =========================
-- 🎨 CONFIG
-- =========================

local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

-- hiệu ứng cần xoá
local Effects = {
    ParticleEmitter=true,
    Trail=true,
    Beam=true,
    Fire=true,
    Smoke=true,
    Sparkles=true,
    Explosion=true,
    Highlight=true,
    PointLight=true,
    SpotLight=true,
    SurfaceLight=true,
    Sound=true
}

-- 🌳 từ khoá cây
local TREE_KEYWORDS = {
    "tree","plant","bush","grass","leaf","wood"
}

-- 🏠 từ khoá nhà
local HOUSE_KEYWORDS = {
    "house","home","building","hut",
    "villa","castle","tower","room"
}

-- =========================
-- 🔍 CHECK SYSTEM
-- =========================

local function IsSystem(obj)
    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end
    if obj:IsA("BillboardGui") then return true end
    if obj:IsA("SurfaceGui") then return true end

    if obj:IsA("Humanoid") then return true end
    if obj:FindFirstChildOfClass("Humanoid") then return true end

    local name = string.lower(obj.Name)

    if string.find(name,"spawn")
    or string.find(name,"safe")
    or string.find(name,"zone")
    or string.find(name,"arena")
    or string.find(name,"boss") then
        return true
    end

    return false
end

-- =========================
-- 🔎 CHECK MODEL IMPORTANT
-- =========================

local function HasImportantInside(model)

    if model:FindFirstChildOfClass("Humanoid") then return true end

    for _,v in pairs(model:GetDescendants()) do
        if v:IsA("SpawnLocation") then return true end
        if v:FindFirstChildOfClass("Humanoid") then return true end

        local name = string.lower(v.Name)
        if string.find(name,"boss")
        or string.find(name,"safe")
        or string.find(name,"zone") then
            return true
        end
    end

    return false
end

-- =========================
-- 🌳🏠 CHECK XOÁ MAP
-- =========================

local function ShouldDeleteModel(obj)

    if not obj:IsA("Model") then return false end
    if IsSystem(obj) then return false end

    local name = string.lower(obj.Name)

    -- xoá cây 100%
    for _,word in pairs(TREE_KEYWORDS) do
        if string.find(name,word) then
            return true
        end
    end

    -- xoá nhà nếu không quan trọng
    for _,word in pairs(HOUSE_KEYWORDS) do
        if string.find(name,word) then
            if not HasImportantInside(obj) then
                return true
            end
        end
    end

    return false
end

-- =========================
-- 👤 PROCESS CHARACTER
-- =========================

local function ProcessCharacter(model)

    if not model:FindFirstChildOfClass("Humanoid") then return end

    for _,v in pairs(model:GetDescendants()) do

        -- xoá phụ kiện
        if v:IsA("Accessory") then
            pcall(function() v:Destroy() end)
        end

        -- body thành màu xám
        if v:IsA("BasePart") then
            v.Color = GRAY
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end

        -- xoá hiệu ứng
        if Effects[v.ClassName] then
            pcall(function()
                if v:IsA("ParticleEmitter")
                or v:IsA("Trail")
                or v:IsA("Beam") then
                    v.Enabled = false
                end
                v:Destroy()
            end)
        end
    end
end

-- =========================
-- ⚡ MAIN PROCESS
-- =========================

local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    -- xoá phụ kiện toàn map
    if obj:IsA("Accessory") then
        pcall(function() obj:Destroy() end)
        return
    end

    -- xoá cây / nhà
    if ShouldDeleteModel(obj) then
        pcall(function() obj:Destroy() end)
        return
    end

    -- xoá hiệu ứng
    if Effects[obj.ClassName] then
        pcall(function()
            if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam") then
                obj.Enabled = false
            end
            obj:Destroy()
        end)
        return
    end

    -- basepart thành xám
    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
    end

    -- npc + player
    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        ProcessCharacter(model)
    end
end

-- =========================
-- 🚀 RUN
-- =========================

for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)
