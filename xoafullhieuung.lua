local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

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
    SurfaceLight=true,
    Sound=true
}

local function IsSystem(obj)

    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end
    if obj:IsA("BillboardGui") then return true end
    if obj:IsA("SurfaceGui") then return true end

    local name = string.lower(obj.Name)
    if string.find(name,"spawn")
    or string.find(name,"teleport")
    or string.find(name,"island")
    or string.find(name,"safe") then
        return true
    end

    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return true
    end

    if obj:IsA("BasePart") and obj.Transparency >= 0.9 then
        return true
    end

    return false
end

local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    -- xoá hiệu ứng chiêu
    if Effects[obj.ClassName] then
        pcall(function() obj:Destroy() end)
        return
    end

    if obj:IsA("SpecialMesh")
    or obj:IsA("BlockMesh")
    or obj:IsA("CylinderMesh") then
        pcall(function() obj:Destroy() end)
    end

    -- đổi màu xám part nhìn thấy
    if obj:IsA("BasePart") and obj.Transparency < 0.9 then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

-- clean world
for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)

--========================
-- XOÁ PHỤ KIỆN NHÂN VẬT
--========================
local player = game.Players.LocalPlayer

local function RemoveAccessories(char)
    for _,v in pairs(char:GetChildren()) do
        if v:IsA("Accessory")
        or v:IsA("Hat")
        or v:IsA("HairAccessory")
        or v:IsA("FaceAccessory")
        or v:IsA("BackAccessory") then
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
