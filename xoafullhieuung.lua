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
    Decal=true,
    Texture=true
}

local function IsNPC(obj)
    return obj:FindFirstChildOfClass("Humanoid")
end

local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then
        return
    end

    local model = obj:FindFirstAncestorOfClass("Model")
    if model and IsNPC(model) then
        return -- không xử lý NPC
    end

    if Effects[obj.ClassName] then
        pcall(function()
            obj:Destroy()
        end)
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
