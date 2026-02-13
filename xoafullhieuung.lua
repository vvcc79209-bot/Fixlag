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
    SurfaceLight=true
}

-- ✅ kiểm tra object hệ thống
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

    return false
end

-- ✅ xoá aura accessory
local function RemoveAuraAccessory(obj)

    if obj:IsA("Accessory") then
        
        local name = string.lower(obj.Name)

        if string.find(name,"aura")
        or string.find(name,"effect")
        or string.find(name,"fx")
        or string.find(name,"glow") then
            pcall(function() obj:Destroy() end)
            return true
        end

        for _,v in pairs(obj:GetDescendants()) do
            if Effects[v.ClassName] then
                pcall(function() obj:Destroy() end)
                return true
            end
        end
    end

    return false
end

-- ✅ xử lý object
local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    if RemoveAuraAccessory(obj) then return end

    if Effects[obj.ClassName] then
        pcall(function() obj:Destroy() end)
        return
    end

    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)
