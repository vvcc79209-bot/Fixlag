-- Blox Fruits Lag Fix (NO DELETE GROUND | SAFE)
-- Compatible with other scripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local GRAY = Color3.fromRGB(125,125,125)

-- =============================
-- PROTECTED STRUCTURES
-- =============================
local ProtectedNames = {
    "Mansion",
    "Cafe",
    "Café",
    "Turtle",
    "Tortle",
    "Hydra",
    "Fortress",
    "Castle"
}

local function IsProtected(obj)
    local n = obj.Name:lower()
    for _,k in ipairs(ProtectedNames) do
        if string.find(n, k:lower()) then
            return true
        end
    end
    return false
end

-- =============================
-- REMOVE 100% EFFECTS
-- =============================
local EffectClasses = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Explosion = true,
    PointLight = true,
    SurfaceLight = true,
    SpotLight = true
}

local function ClearEffects(parent)
    for _,v in ipairs(parent:GetDescendants()) do
        if EffectClasses[v.ClassName] then
            v:Destroy()
        end
    end
end

ClearEffects(Workspace)

Workspace.DescendantAdded:Connect(function(v)
    if EffectClasses[v.ClassName] then
        task.wait()
        if v then v:Destroy() end
    end
end)

-- =============================
-- REMOVE TREES & NORMAL HOUSES
-- (DO NOT TOUCH GROUND)
-- =============================
for _,obj in ipairs(Workspace:GetChildren()) do
    if (obj:IsA("Model") or obj:IsA("Folder")) and not IsProtected(obj) then
        for _,p in ipairs(obj:GetDescendants()) do
            if p:IsA("Part") or p:IsA("MeshPart") then
                -- ONLY REMOVE DECORATION
                if p.Material == Enum.Material.Wood
                or p.Material == Enum.Material.WoodPlanks
                or p.Material == Enum.Material.LeafyGrass then
                    p:Destroy()
                end
            end
        end
    end
end

-- =============================
-- GRAY LAND & SEA (NO DELETE)
-- =============================
for _,p in ipairs(Workspace:GetDescendants()) do
    if p:IsA("Part") or p:IsA("MeshPart") then

        -- LAND
        if p.Material == Enum.Material.Grass
        or p.Material == Enum.Material.Ground
        or p.Material == Enum.Material.Sand
        or p.Material == Enum.Material.Rock then
            p.Color = GRAY
            p.Material = Enum.Material.Concrete
        end

        -- SEA
        if p.Material == Enum.Material.Water then
            p.Color = GRAY
            p.Transparency = 0.35
        end
    end
end

-- =============================
-- CHARACTER EFFECT CLEAN
-- =============================
local function OnChar(char)
    ClearEffects(char)
end

if LocalPlayer.Character then
    OnChar(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(OnChar)

-- =============================
-- FINAL OPTIMIZE
-- =============================
collectgarbage("collect")
setfpscap(60)
