-- Blox Fruits Effect Optimizer (95%)
-- Remove most effects + make remaining effects transparent
-- Stable version

local Workspace = game:GetService("Workspace")

-- Transparency level for remaining effects
local TRANSPARENT_LEVEL = 0.85 -- càng gần 1 càng vô hình

-- Remove heavy effects
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

-- Make remaining skill parts transparent
local function transparentPart(obj)
    if obj:IsA("BasePart") then
        -- Không đụng terrain
        if obj:IsDescendantOf(Workspace.Terrain) then return end

        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0

        if obj.Transparency < TRANSPARENT_LEVEL then
            obj.Transparency = TRANSPARENT_LEVEL
        end
    end
end

-- Scan toàn map
for _,v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        removeEffects(v)
        transparentPart(v)
    end)
end

-- Bắt effect mới sinh ra (skill)
Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(function()
        removeEffects(v)
        transparentPart(v)
    end)
end)

print("✅ 95% effects removed | Remaining effects transparent")
