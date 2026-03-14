-- BLOX FRUITS FULL FIX LAG

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

math.randomseed(tick())

-- =====================
-- LIGHTING OPTIMIZE
-- =====================

Lighting.GlobalShadows = false
Lighting.FogEnd = 100000
Lighting.Brightness = 2
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _,v in pairs(Lighting:GetDescendants()) do
    if v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

-- =====================
-- EFFECT REDUCER
-- =====================

local function optimizeEffect(obj)

    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Sparkles")
    or obj:IsA("Smoke")
    or obj:IsA("Fire") then

        local r = math.random(1,100)

        if r <= 90 then
            obj.Enabled = false
        elseif r <= 95 then
            if obj.Color then
                obj.Color = ColorSequence.new(
                    Color3.fromRGB(0,0,0),
                    Color3.fromRGB(255,255,255)
                )
            end
        end

    end

end

for _,v in pairs(Workspace:GetDescendants()) do
    optimizeEffect(v)
end

Workspace.DescendantAdded:Connect(optimizeEffect)

-- =====================
-- PLAYER + NPC GRAY
-- =====================

local function grayCharacter(char)

    for _,v in pairs(char:GetDescendants()) do

        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Color = Color3.fromRGB(120,120,120)
            v.Material = Enum.Material.SmoothPlastic
        end

        if v:IsA("Accessory") then
            v:Destroy()
        end

    end

end

for _,p in pairs(Players:GetPlayers()) do

    if p.Character then
        grayCharacter(p.Character)
    end

    p.CharacterAdded:Connect(grayCharacter)

end

-- =====================
-- MAP CLEAN (MEDIUM)
-- =====================

local removeNames = {
    "tree","bush","plant","grass",
    "decoration","rock"
}

for _,obj in pairs(Workspace:GetDescendants()) do

    if obj:IsA("BasePart") or obj:IsA("Model") then

        local name = obj.Name:lower()

        for _,k in pairs(removeNames) do

            if string.find(name,k) then

                if math.random(1,2) == 1 then

                    obj.Transparency = 1
                    if obj:IsA("BasePart") then
                        obj.CanCollide = false
                    end

                end

            end

        end

    end

end

print("✔ BLOX FRUITS FULL FIX LAG LOADED")
