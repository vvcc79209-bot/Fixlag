--// CONFIG
local GRAY = Color3.fromRGB(120,120,120)
local KEEP_SKY = true

--// EFFECT CLASS
local Effects = {
    ParticleEmitter=true,
    Trail=true,
    Beam=true,
    Fire=true,
    Smoke=true,
    Sparkles=true,
    Explosion=true,
    Highlight=true,
    PointLight=true,
    SpotLight=true,
    SurfaceLight=true
}

--// CHECK SYSTEM (tránh lỗi đảo + NPC)
local function IsSystem(obj)

    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end

    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return true
    end

    return false
end

--// XOÁ PHỤ KIỆN PLAYER
local function RemoveAccessories(character)
    for _,v in pairs(character:GetChildren()) do
        if v:IsA("Accessory")
        or v:IsA("Hat")
        or v:IsA("HairAccessory")
        or v:IsA("FaceAccessory")
        or v:IsA("BackAccessory") then
            v:Destroy()
        end
    end
end

--// PROCESS OBJECT
local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    if Effects[obj.ClassName] then
        pcall(function() obj:Destroy() end)
        return
    end

    if obj:IsA("SpecialMesh") or obj:IsA("BlockMesh") then
        pcall(function() obj:Destroy() end)
    end

    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

--// CLEAN MAP
for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

--// AUTO CLEAN FX MỚI
game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)

--// XOÁ PHỤ KIỆN PLAYER
local player = game.Players.LocalPlayer

local function SetupChar(char)
    task.wait(1)
    RemoveAccessories(char)
end

if player.Character then
    SetupChar(player.Character)
end

player.CharacterAdded:Connect(SetupChar)
