-- BLOX FRUITS FIX LAG SAFE

local workspace = game.Workspace
local players = game.Players
local lighting = game.Lighting
local runService = game:GetService("RunService")

math.randomseed(tick())

-- ======================
-- LIGHTING FIX
-- ======================

lighting.GlobalShadows = false
lighting.Brightness = 2
lighting.FogEnd = 100000

if workspace:FindFirstChild("Terrain") then
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterReflectance = 0
end

-- ======================
-- EFFECT OPTIMIZER
-- ======================

local safeEffects = {
    "Portal",
    "Leviathan",
    "Sea",
    "Water"
}

local function isSafe(obj)
    for _,v in pairs(safeEffects) do
        if string.find(obj.Name:lower(), v:lower()) then
            return true
        end
    end
end

local function optimizeEffects()

    for _,v in pairs(workspace:GetDescendants()) do

        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam")
        or v:IsA("Sparkles")
        or v:IsA("Smoke")
        or v:IsA("Fire") then

            if not isSafe(v) then

                local r = math.random(1,100)

                if r <= 90 then
                    v.Enabled = false
                elseif r <= 95 then
                    if v.Color then
                        v.Color = ColorSequence.new(
                            Color3.fromRGB(0,0,0),
                            Color3.fromRGB(255,255,255)
                        )
                    end
                end

            end
        end

    end

end

-- ======================
-- GRAY PLAYER + NPC
-- ======================

local function grayChar(char)

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

for _,p in pairs(players:GetPlayers()) do
    if p.Character then
        grayChar(p.Character)
    end
    p.CharacterAdded:Connect(grayChar)
end

-- ======================
-- MEDIUM MAP CLEAN
-- ======================

local removeNames = {
    "tree",
    "bush",
    "plant",
    "grass",
    "decoration"
}

for _,obj in pairs(workspace:GetDescendants()) do

    if obj:IsA("Model") or obj:IsA("BasePart") then

        local name = obj.Name:lower()

        for _,k in pairs(removeNames) do

            if string.find(name,k) then
                if math.random(1,2) == 1 then
                    obj:Destroy()
                end
            end

        end

    end
end

-- ======================
-- SAFE LOOP
-- ======================

task.spawn(function()

    while true do
        optimizeEffects()
        task.wait(5)
    end

end)

print("✔ BLOX FRUITS FIX LAG SAFE LOADED")
