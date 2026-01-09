-- Blox Fruits Extreme Lag Fix (SAFE VERSION)
-- No remote hook | No skill override | Compatible with other scripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- SETTINGS
-- =========================
local GRAY_COLOR = Color3.fromRGB(120,120,120)

local ProtectedKeywords = {
    "Mansion",
    "Cafe",
    "Café",
    "Turtle",
    "Tortle",
    "Hydra",
    "Fortress",
    "Castle"
}

-- =========================
-- UTILS
-- =========================
local function IsProtected(obj)
    local name = obj.Name:lower()
    for _,k in ipairs(ProtectedKeywords) do
        if string.find(name, k:lower()) then
            return true
        end
    end
    return false
end

-- =========================
-- REMOVE ALL EFFECTS (100%)
-- =========================
local function RemoveEffects(parent)
    for _,v in ipairs(parent:GetDescendants()) do
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam")
        or v:IsA("Fire")
        or v:IsA("Smoke")
        or v:IsA("Sparkles")
        or v:IsA("Explosion")
        or v:IsA("PointLight")
        or v:IsA("SurfaceLight")
        or v:IsA("SpotLight") then
            v:Destroy()
        end
    end
end

RemoveEffects(Workspace)

Workspace.DescendantAdded:Connect(function(v)
    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam")
    or v:IsA("Fire")
    or v:IsA("Smoke")
    or v:IsA("Sparkles")
    or v:IsA("Explosion")
    or v:IsA("PointLight")
    or v:IsA("SurfaceLight")
    or v:IsA("SpotLight") then
        task.wait()
        if v then v:Destroy() end
    end
end)

-- =========================
-- REMOVE TREES & NORMAL HOUSES
-- =========================
for _,obj in ipairs(Workspace:GetChildren()) do
    if obj:IsA("Model") or obj:IsA("Folder") then
        if not IsProtected(obj) then
            for _,p in ipairs(obj:GetDescendants()) do
                if p:IsA("Part") or p:IsA("MeshPart") then
                    if p.Material == Enum.Material.Grass
                    or p.Material == Enum.Material.LeafyGrass
                    or p.Material == Enum.Material.Wood
                    or p.Material == Enum.Material.WoodPlanks then
                        p:Destroy()
                    end
                end
            end
        end
    end
end

-- =========================
-- GRAY LAND & SEA (SAFE)
-- =========================
for _,v in ipairs(Workspace:GetDescendants()) do
    if v:IsA("Part") or v:IsA("MeshPart") then
        if v.Material == Enum.Material.Grass
        or v.Material == Enum.Material.Ground
        or v.Material == Enum.Material.Sand
        or v.Material == Enum.Material.Rock
        or v.Material == Enum.Material.Concrete then
            v.Color = GRAY_COLOR
            v.Material = Enum.Material.Concrete
        end

        if v.Material == Enum.Material.Water then
            v.Color = GRAY_COLOR
            v.Transparency = 0.35
        end
    end
end

-- =========================
-- CHARACTER EFFECT CLEAN
-- =========================
local function OnCharacter(char)
    RemoveEffects(char)
end

if LocalPlayer.Character then
    OnCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(OnCharacter)

-- =========================
-- FINAL GC BOOST
-- =========================
collectgarbage("collect")
setfpscap(60)
