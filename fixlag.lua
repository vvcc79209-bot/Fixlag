--// Ultimate Blox Fruits Lag Fix (Safe Version)
--// Giảm hiệu ứng, tránh bug CDK + Levi + FPS drop

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Settings
local REMOVE_EFFECT_PERCENT = 0.9
local GRAYSCALE_PLAYERS = true
local REMOVE_ACCESSORIES = true
local SIMPLIFY_MAP = true

-- Safe check
local function safe(pcallFunc)
    local success, err = pcall(pcallFunc)
    if not success then warn(err) end
end

-- Remove / simplify effects
local function handleEffect(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        if math.random() < REMOVE_EFFECT_PERCENT then
            obj.Enabled = false
        else
            obj.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(1,1,1))
        end
    end
    
    if obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end

    if obj:IsA("Light") then
        obj.Enabled = false
    end
end

-- Gray players/NPC
local function grayCharacter(char)
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Color = Color3.fromRGB(120,120,120)
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Remove accessories (safe)
local function removeAccessories(char)
    for _,v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

-- Optimize character
local function optimizeChar(char)
    safe(function()
        if GRAYSCALE_PLAYERS then
            grayCharacter(char)
        end

        if REMOVE_ACCESSORIES then
            removeAccessories(char)
        end
    end)
end

-- Apply to players
for _,plr in pairs(Players:GetPlayers()) do
    if plr.Character then
        optimizeChar(plr.Character)
    end
    plr.CharacterAdded:Connect(optimizeChar)
end

-- Map optimize (KHÔNG phá map để tránh lỗi Levi / biển)
if SIMPLIFY_MAP then
    for _,v in pairs(workspace:GetDescendants()) do
        safe(function()
            if v:IsA("BasePart") then
                if v.Name:lower():find("tree") or v.Name:lower():find("bush") then
                    v.Transparency = 0.8
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
end

-- Effect listener
workspace.DescendantAdded:Connect(function(obj)
    safe(function()
        handleEffect(obj)
    end)
end)

-- Initial scan
for _,obj in pairs(workspace:GetDescendants()) do
    handleEffect(obj)
end

-- Camera fix (tránh bug Levi / biển)
safe(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        workspace.CurrentCamera.FieldOfView = 70
    end)
end)

print("✅ Lag Fix Loaded (Stable Version)")
