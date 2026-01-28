-- Blox Fruits Effect Optimizer FINAL (HITBOX SAFE)
-- Remove ~95% visual effects
-- FIX Kabucha Z circle | Map & Sea SAFE

local Workspace = game:GetService("Workspace")

-- ❌ TUYỆT ĐỐI KHÔNG ĐỤNG BasePart
-- ✅ CHỈ xử lý EFFECT HÌNH ẢNH

local function removeVisualEffect(obj)
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

-- Quét effect đang tồn tại
for _,v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        removeVisualEffect(v)
    end)
end

-- Bắt effect mới sinh ra (skill)
Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(function()
        removeVisualEffect(v)
    end)
end)

print("✅ 95% visual effects removed | Hitbox & Map SAFE")
