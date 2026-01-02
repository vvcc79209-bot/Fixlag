-- BLOX FRUITS FIX LAG - SAFE VERSION

local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-- LIGHTING
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
Lighting.Ambient = Color3.fromRGB(120,120,120)
Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)

for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("BloomEffect") 
    or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
        v:Destroy()
    end
end

-- TERRAIN / SEA
Terrain.WaterColor = Color3.fromRGB(120,120,120)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

-- FIX PARTS + REMOVE EFFECTS
local function Fix(v)
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(130,130,130)
        v.CastShadow = false
    end

    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam")
    or v:IsA("Explosion")
    or v:IsA("Fire")
    or v:IsA("Smoke") then
        v.Enabled = false
    end
end

for _,v in pairs(workspace:GetDescendants()) do
    Fix(v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

-- FPS BOOST
settings().Rendering.QualityLevel = 1

print("FIX LAG BLOX FRUITS: ON")
