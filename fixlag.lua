--// FULL EXTREME LAG FIX - BLOX FRUITS
--// Safe version (hạn chế lỗi CDK, Levi, map bug)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Settings
local REMOVE_EFFECTS = true
local GRAY_WORLD = true
local REMOVE_ACCESSORIES = true
local SIMPLIFY_MAP = true

-- Function: Convert to gray
local function toGray(obj)
    if obj:IsA("BasePart") then
        obj.Color = Color3.fromRGB(120,120,120)
        obj.Material = Enum.Material.SmoothPlastic
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    end
end

-- 1. REMOVE ALL EFFECTS (100%)
for _,v in pairs(game:GetDescendants()) do
    if REMOVE_EFFECTS then
        if v:IsA("ParticleEmitter") or
           v:IsA("Trail") or
           v:IsA("Beam") or
           v:IsA("Explosion") or
           v:IsA("Fire") or
           v:IsA("Smoke") or
           v:IsA("Sparkles") then
            v:Destroy()
        end
    end
end

-- Anti spawn new effects
game.DescendantAdded:Connect(function(v)
    if REMOVE_EFFECTS then
        if v:IsA("ParticleEmitter") or
           v:IsA("Trail") or
           v:IsA("Beam") or
           v:IsA("Explosion") or
           v:IsA("Fire") or
           v:IsA("Smoke") or
           v:IsA("Sparkles") then
            v:Destroy()
        end
    end
end)

-- 2. GRAY NPC + PLAYERS
local function grayCharacter(char)
    for _,v in pairs(char:GetDescendants()) do
        toGray(v)
    end
end

for _,plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then
        grayCharacter(plr.Character)
    end
    plr.CharacterAdded:Connect(grayCharacter)
end

-- 3. REMOVE ACCESSORIES (safe)
local function removeAccessories(char)
    for _,v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

for _,plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then
        removeAccessories(plr.Character)
    end
    plr.CharacterAdded:Connect(removeAccessories)
end

-- 4. SIMPLIFY MAP (KHÔNG xoá terrain để tránh lỗi Levi + biển)
for _,v in pairs(workspace:GetDescendants()) do
    if SIMPLIFY_MAP then
        if v:IsA("BasePart") then
            if v.Name ~= "HumanoidRootPart" then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
                if GRAY_WORLD then
                    v.Color = Color3.fromRGB(150,150,150)
                end
            end
        elseif v:IsA("UnionOperation") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            if GRAY_WORLD then
                v.Color = Color3.fromRGB(150,150,150)
            end
        end
    end
end

-- 5. LIGHTING OPTIMIZATION
local Lighting = game:GetService("Lighting")

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
Lighting.ClockTime = 12

for _,v in pairs(Lighting:GetDescendants()) do
    if v:IsA("BloomEffect") or
       v:IsA("BlurEffect") or
       v:IsA("SunRaysEffect") or
       v:IsA("ColorCorrectionEffect") or
       v:IsA("DepthOfFieldEffect") then
        v:Destroy()
    end
end

-- 6. REMOVE TREES / PROPS (mạnh)
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("Model") then
        local name = string.lower(v.Name)
        if string.find(name, "tree") or
           string.find(name, "bush") or
           string.find(name, "rock") then
            v:Destroy()
        end
    end
end

-- 7. SKY (giữ lại nhưng làm xám nhẹ)
local sky = Lighting:FindFirstChildOfClass("Sky")
if sky then
    sky.SkyboxBk = ""
    sky.SkyboxDn = ""
    sky.SkyboxFt = ""
    sky.SkyboxLf = ""
    sky.SkyboxRt = ""
    sky.SkyboxUp = ""
end

print("✅ FULL LAG FIX LOADED (SAFE MODE)")
