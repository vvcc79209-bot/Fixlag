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
-- 🎨 GRAY + DELETE EFFECT
-- =========================

local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

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
    SurfaceLight=true
}

local function IsSystem(obj)

    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end
    if obj:IsA("BillboardGui") then return true end
    if obj:IsA("SurfaceGui") then return true end

    local name = string.lower(obj.Name)
    if string.find(name,"spawn")
    or string.find(name,"teleport")
    or string.find(name,"safe")
    or string.find(name,"zone") then
        return true
    end

    return false
end

local function ProcessCharacter(model)
    if not model:FindFirstChildOfClass("Humanoid") then return end

    for _,v in pairs(model:GetDescendants()) do
        
        if v:IsA("Accessory") then
            pcall(function() v:Destroy() end)
        end

        if v:IsA("BasePart") then
            v.Color = GRAY
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end

        if Effects[v.ClassName] then
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                end
                v:Destroy()
            end)
        end
    end
end

local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    if Effects[obj.ClassName] then
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            end
            obj:Destroy()
        end)
        return
    end

    if obj:IsA("Model") then
        local name = string.lower(obj.Name)
        if string.find(name,"tree")
        or string.find(name,"plant")
        or string.find(name,"bush")
        or string.find(name,"rock")
        or string.find(name,"decor") then
            pcall(function() obj:Destroy() end)
            return
        end
    end

    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
    end

    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        ProcessCharacter(model)
    end
end

for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)

-- =========================
-- 💨 REMOVE EXTRA SKILL VFX (THÊM VÀO)
-- =========================

local function RemoveExtraEffects(obj)

    local name = string.lower(obj.Name)

    if string.find(name,"portal")
    or string.find(name,"vortex")
    or string.find(name,"ring")
    or string.find(name,"shock")
    or string.find(name,"energy")
    or string.find(name,"slash")
    or string.find(name,"vfx")
    or string.find(name,"effect")
    or string.find(name,"aura") then
        pcall(function() obj:Destroy() end)
        return
    end

    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam") then
        pcall(function()
            obj.Enabled = false
            obj:Destroy()
        end)
        return
    end

    if obj:IsA("BasePart") and obj.Material == Enum.Material.Neon then
        obj.Transparency = 1
    end
end

for _,v in pairs(workspace:GetDescendants()) do
    RemoveExtraEffects(v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    RemoveExtraEffects(v)
end)
