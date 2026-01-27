-- Blox Fruits Effect Optimizer (95%)
-- Remove effects, keep ground SAFE

local Workspace = game:GetService("Workspace")

local TRANSPARENT_LEVEL = 0.85

-- Kiểm tra có phải mặt đất / map không
local function isGround(obj)
    if not obj:IsA("BasePart") then return false end
    if obj:IsDescendantOf(Workspace.Terrain) then return true end
    local name = obj.Name:lower()
    if name:find("ground") or name:find("land") or name:find("floor") or name:find("island") then
        return true
    end
    return false
end

-- Xoá effect nặng
local function removeEffects(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles")
    or obj:IsA("Explosion") then
        obj:Destroy()
    end
end

-- Làm trong suốt effect part (KHÔNG phải mặt đất)
local function transparentEffectPart(obj)
    if obj:IsA("BasePart") and not isGround(obj) then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        if obj.Transparency < TRANSPARENT_LEVEL then
            obj.Transparency = TRANSPARENT_LEVEL
        end
    end
end

-- Quét map
for _,v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        removeEffects(v)
        transparentEffectPart(v)
    end)
end

-- Bắt effect mới sinh ra
Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(function()
        removeEffects(v)
        transparentEffectPart(v)
    end)
end)

print("✅ 95% effects removed | Ground SAFE")
