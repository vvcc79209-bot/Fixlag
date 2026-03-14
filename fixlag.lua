-- =========================
-- ⚙️ BLOX FRUITS FIX LAG
-- =========================

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- =========================
-- REMOVE HEAVY GRAPHICS
-- =========================

Lighting.GlobalShadows = false
Lighting.FogEnd = 1000000
Lighting.Brightness = 2
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _,v in pairs(Lighting:GetDescendants()) do
    if v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("DepthOfFieldEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

-- =========================
-- REMOVE 90% SKILL EFFECTS
-- =========================

local EFFECTS = {
    "ParticleEmitter",
    "Trail",
    "Smoke",
    "Fire",
    "Sparkles",
    "Explosion"
}

local count = 0

Workspace.DescendantAdded:Connect(function(v)

    for _,name in pairs(EFFECTS) do
        if v:IsA(name) then

            count += 1

            if count % 20 ~= 0 then
                v.Enabled = false
            else
                -- 5% effect convert to black & white
                if v.Parent and v.Parent:IsA("BasePart") then
                    v.Parent.Color = Color3.fromRGB(120,120,120)
                    v.Parent.Material = Enum.Material.SmoothPlastic
                end
            end

        end
    end

end)

-- =========================
-- NPC + PLAYER GRAY
-- =========================

local function GrayCharacter(char)

    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Color = Color3.fromRGB(140,140,140)
            v.Material = Enum.Material.SmoothPlastic
        end

        if v:IsA("Accessory") then
            v:Destroy()
        end
    end

end

for _,p in pairs(Players:GetPlayers()) do
    if p.Character then
        GrayCharacter(p.Character)
    end
    p.CharacterAdded:Connect(GrayCharacter)
end

-- =========================
-- MEDIUM REMOVE TREES + HOUSES
-- =========================

local KEYWORDS = {
    "tree","plant","bush","grass",
    "house","hut","roof","wood",
    "accessory","decoration"
}

for _,v in pairs(Workspace:GetDescendants()) do

    if v:IsA("Model") or v:IsA("BasePart") then

        local name = string.lower(v.Name)

        for _,k in pairs(KEYWORDS) do
            if string.find(name,k) then
                v:Destroy()
                break
            end
        end

    end
end

-- =========================
-- SAFE REMOVE SMALL PARTS
-- =========================

for _,v in pairs(Workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        if v.Transparency > 0.7 and not v.Anchored then
            v:Destroy()
        end
    end
end

print("✔ Blox Fruits Fix Lag Loaded")
