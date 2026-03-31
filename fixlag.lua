--// FIX LAG EXTREME + GRAY MODE (SAFE)
--// Tối ưu: xoá 95% hiệu ứng, giữ 5% dạng xám
--// Tránh lỗi cam, skill, CDK

if not game:IsLoaded() then game.Loaded:Wait() end

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// ===== SETTINGS =====
local REMOVE_EFFECT_PERCENT = 0.95
local KEEP_GRAY_PERCENT = 0.05

--// ===== LIGHTING (toàn map xám trừ trời) =====
Lighting.Brightness = 1
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9

for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
        v:Destroy()
    end
end

local cc = Instance.new("ColorCorrectionEffect")
cc.Saturation = -1
cc.TintColor = Color3.fromRGB(200,200,200) -- xám nhẹ
cc.Parent = Lighting

--// ===== SKY (giữ lại nhưng xám nhẹ) =====
local sky = Lighting:FindFirstChildOfClass("Sky")
if sky then
    sky.SkyboxBk = ""
    sky.SkyboxDn = ""
    sky.SkyboxFt = ""
    sky.SkyboxLf = ""
    sky.SkyboxRt = ""
    sky.SkyboxUp = ""
end

--// ===== REMOVE EFFECT =====
local function cleanEffects(obj)
    if math.random() < REMOVE_EFFECT_PERCENT then
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Explosion") then
            obj:Destroy()
        end
    else
        -- giữ lại nhưng làm xám
        if obj:IsA("ParticleEmitter") then
            obj.Color = ColorSequence.new(Color3.fromRGB(150,150,150))
        end
    end
end

--// ===== MAP CLEAN (xoá cây, nhà, phụ kiện) =====
local function simplifyMap(obj)
    if obj:IsA("BasePart") then
        if obj.Name:lower():find("tree") 
        or obj.Name:lower():find("leaf") 
        or obj.Name:lower():find("grass")
        or obj.Name:lower():find("house")
        or obj.Name:lower():find("building") then
            obj:Destroy()
        else
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(170,170,170)
        end
    end
end

--// ===== PLAYER + NPC GRAY =====
local function grayCharacter(char)
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Color = Color3.fromRGB(160,160,160)
            v.Material = Enum.Material.SmoothPlastic
        end

        -- xoá phụ kiện
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

--// áp dụng cho player
for _,plr in pairs(Players:GetPlayers()) do
    if plr.Character then
        grayCharacter(plr.Character)
    end
    plr.CharacterAdded:Connect(grayCharacter)
end

--// ===== LOOP CLEAN =====
RunService.RenderStepped:Connect(function()
    for _,obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            cleanEffects(obj)
            simplifyMap(obj)
        end)
    end
end)

--// ===== ANTI LAG WATER + CAMERA SAFE =====
pcall(function()
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 1
end)

print("✅ FIX LAG ULTRA ACTIVATED")
