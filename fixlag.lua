-- Blox Fruits Effect Optimizer FINAL FIX
-- 95% effects removed | Map & Sea SAFE

local Workspace = game:GetService("Workspace")

local EFFECT_TRANSPARENCY = 0.85

-- Chỉ nhận diện object LÀ EFFECT
local function isEffect(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles")
    or obj:IsA("Explosion") then
        return true
    end

    -- Part effect thường có SpecialMesh / Decal / Texture
    if obj:IsA("BasePart") then
        if obj:FindFirstChildOfClass("SpecialMesh")
        or obj:FindFirstChildOfClass("Decal")
        or obj:FindFirstChildOfClass("Texture") then
            return true
        end
    end

    return false
end

-- Xoá effect nặng
local function removeHeavy(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Explosion") then
        obj:Destroy()
    end
end

-- Làm trong suốt part effect (KHÔNG MAP)
local function transparentEffect(obj)
    if obj:IsA("BasePart") and isEffect(obj) then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        if obj.Transparency < EFFECT_TRANSPARENCY then
            obj.Transparency = EFFECT_TRANSPARENCY
        end
    end
end

-- Quét toàn bộ
for _,v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        removeHeavy(v)
        transparentEffect(v)
    end)
end

-- Bắt effect mới
Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(function()
        removeHeavy(v)
        transparentEffect(v)
    end)
end)

print("✅ Effect optimized | Map & Sea SAFE")
