local GRAY = Color3.fromRGB(120,120,120)

local Effects = {
    ParticleEmitter=true, Trail=true, Beam=true,
    Fire=true, Smoke=true, Sparkles=true,
    Highlight=true, PointLight=true,
    SpotLight=true, SurfaceLight=true
}

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

    -- không thay color nếu part *invisible*
    if obj:IsA("BasePart") and obj.Transparency >= 0.9 then
        return true
    end

    return false
end

local function Clean(obj)
    if IsProtected(obj) then return end

    if Effects[obj.ClassName] then
        pcall(function() obj:Destroy() end)
        return
    end

    if obj:IsA("SpecialMesh") then
        pcall(function() obj:Destroy() end)
    end

    -- chỉ đổi color nếu part có *Mesh/union/visual*
    if obj:IsA("BasePart") and obj:FindFirstChildWhichIsA("Mesh") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

for _,v in pairs(game:GetDescendants()) do
    Clean(v)
end

game.DescendantAdded:Connect(function(v)
    task.wait()
    Clean(v)
end)

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
