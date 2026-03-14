--// BLOX FRUITS ULTRA FIX LAG (DELTA)

pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- LIGHTING FIX
Lighting.GlobalShadows = false
Lighting.FogEnd = 1000000
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

-- EFFECT REMOVER
local function removeEffects(obj)

    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles") then
        obj:Destroy()
    end

    if obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end

end

-- MAP CLEAN (TREE / ACCESSORIES)
local TREE_KEYWORDS = {
"tree","plant","bush","grass","leaf"
}

local HOUSE_KEYWORDS = {
"house","hut","furniture","chair","table"
}

local function cleanMap(v)

    local name = string.lower(v.Name)

    for _,k in pairs(TREE_KEYWORDS) do
        if string.find(name,k) then
            v:Destroy()
        end
    end

    for _,k in pairs(HOUSE_KEYWORDS) do
        if string.find(name,k) then
            if math.random(1,3) == 1 then
                v:Destroy()
            end
        end
    end

end

-- GRAY PLAYER + NPC
local function grayCharacter(char)

    for _,v in pairs(char:GetDescendants()) do

        if v:IsA("BasePart") then
            v.Color = Color3.fromRGB(120,120,120)
            v.Material = Enum.Material.SmoothPlastic
        end

        if v:IsA("Accessory") then
            v:Destroy()
        end

    end

end

-- PROCESS OBJECTS
for _,v in pairs(game:GetDescendants()) do

    removeEffects(v)

    if v:IsA("Model") then
        cleanMap(v)
    end

end

-- CHARACTER APPLY
local function setupCharacter(char)
    grayCharacter(char)
end

for _,plr in pairs(Players:GetPlayers()) do
    if plr.Character then
        setupCharacter(plr.Character)
    end

    plr.CharacterAdded:Connect(setupCharacter)
end

-- AUTO REMOVE NEW EFFECTS
game.DescendantAdded:Connect(function(v)

    removeEffects(v)

end)
