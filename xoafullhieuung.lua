--// CONFIG
local GRAY = Color3.fromRGB(120,120,120)

--// EFFECT VISUAL ONLY
local Effects = {
    ParticleEmitter=true,
    Trail=true,
    Beam=true,
    Fire=true,
    Smoke=true,
    Sparkles=true,
    Highlight=true,
    PointLight=true,
    SpotLight=true,
    SurfaceLight=true
}

--// CHECK NPC / SYSTEM
local function IsProtected(obj)

    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end
    if obj:IsA("BillboardGui") then return true end
    if obj:IsA("SurfaceGui") then return true end

    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return true
    end

    if obj:IsA("BasePart") and obj.Transparency == 1 then
        return true
    end

    return false
end

--// PROCESS MAP
local function Process(obj)

    if IsProtected(obj) then return end

    if Effects[obj.ClassName] then
        pcall(function() obj.Enabled=false obj:Destroy() end)
        return
    end

    if obj:IsA("SpecialMesh") then
        pcall(function() obj:Destroy() end)
    end

    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

--// CLEAN WORLD
for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)

--// REMOVE PLAYER ACCESSORIES
local player = game.Players.LocalPlayer

local function RemoveAccessories(char)
    for _,v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

local function SetupChar(char)
    task.wait(1)
    RemoveAccessories(char)
end

if player.Character then
    SetupChar(player.Character)
end

player.CharacterAdded:Connect(SetupChar)
