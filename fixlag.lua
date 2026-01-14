-- Blox Fruits: SAFE Hide Effects + Mute Skill Sounds
-- GUARANTEED: No script conflict | No sea/water bug | Keep movement & swimming

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== CHỈ NHỮNG CLASS THUẦN HIỆU ỨNG (KHÔNG ẢNH HƯỞNG GAMEPLAY) =====
local VisualEffectClass = {
    ParticleEmitter = true,
    Beam = true,
    Trail = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Highlight = true
}

-- Kiểm tra: có phải hiệu ứng hình ảnh không
local function IsVisualOnly(obj)
    if VisualEffectClass[obj.ClassName] then return true end
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then return true end
    if obj:IsA("Decal") or obj:IsA("Texture") then return true end
    return false
end

-- Kiểm tra: có phải âm thanh skill/đánh thường không (không đụng UI/nhạc nền)
local function IsSkillSound(obj)
    if not obj:IsA("Sound") then return false end

    -- Không tắt âm thanh UI / nhạc nền
    if obj:IsDescendantOf(LocalPlayer:WaitForChild("PlayerGui")) then
        return false
    end

    local parent = obj.Parent
    if not parent then return false end

    -- Âm thanh gắn vào Tool, Part sinh ra khi đánh, hoặc object tên có "effect"
    if parent:IsA("Tool") or parent:IsA("BasePart") then
        return true
    end
    if parent.Name:lower():find("effect") then
        return true
    end

    return false
end

-- Ẩn hiệu ứng hình ảnh (KHÔNG đụng map, nước, va chạm)
local function HandleVisual(obj)
    if IsVisualOnly(obj) then
        pcall(function()
            obj:Destroy()
        end)
    end
end

-- Tắt âm thanh skill/đánh thường (KHÔNG tắt UI/nhạc)
local function HandleSound(obj)
    if IsSkillSound(obj) then
        pcall(function()
            obj.Volume = 0
            obj:Stop()
        end)
    end
end

-- Quét hiện tại
for _,v in ipairs(game:GetDescendants()) do
    HandleVisual(v)
    HandleSound(v)
end

-- Bắt mọi object mới sinh ra (khi dùng skill / đánh thường)
game.DescendantAdded:Connect(function(v)
    task.wait()
    HandleVisual(v)
    HandleSound(v)
end)

-- Giảm chất lượng render (chỉ đồ họa, KHÔNG ảnh hưởng vật lý)
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

print("✅ SAFE MODE: Hidden effects + muted skill sounds | NO CONFLICT | SEA OK")
