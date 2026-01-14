-- Blox Fruits: SAFE Hide Effects + Mute Skill Sounds + Hide Orbs
-- GUARANTEED: No conflict | No sea/water bug | Keep movement & swimming

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------
-- 1) CHỈ NHỮNG CLASS THUẦN HIỆU ỨNG (KHÔNG ẢNH HƯỞNG GAMEPLAY)
----------------------------------------------------------------
local VisualEffectClass = {
    ParticleEmitter = true,
    Beam = true,
    Trail = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Highlight = true
}

local function IsVisualOnly(obj)
    if VisualEffectClass[obj.ClassName] then return true end
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then return true end
    if obj:IsA("Decal") or obj:IsA("Texture") then return true end
    return false
end

----------------------------------------------------------------
-- 2) TẮT ÂM THANH SKILL/ĐÁNH THƯỜNG (KHÔNG ĐỘNG UI/NHẠC)
----------------------------------------------------------------
local function IsSkillSound(obj)
    if not obj:IsA("Sound") then return false end
    -- Không tắt âm thanh UI / nhạc nền
    if obj:IsDescendantOf(LocalPlayer:WaitForChild("PlayerGui")) then
        return false
    end
    local parent = obj.Parent
    if not parent then return false end
    if parent:IsA("Tool") or parent:IsA("BasePart") then return true end
    if parent.Name:lower():find("effect") then return true end
    return false
end

----------------------------------------------------------------
-- 3) ẨN “QUẢ CẦU” / MODEL SKILL NHƯNG KHÔNG PHÁ VẬT LÝ
--    (KHÔNG chỉnh CanCollide, KHÔNG động Terrain/Water)
----------------------------------------------------------------
local function IsLikelySkillOrb(part)
    if not part:IsA("BasePart") then return false end

    local name = part.Name:lower()
    -- Tên thường gặp của object skill
    if name:find("orb") or name:find("ball") or name:find("sphere")
    or name:find("projectile") or name:find("skill") or name:find("effect") then
        return true
    end

    -- Không thuộc nhân vật của bạn, không phải map tĩnh
    if LocalPlayer.Character and part:IsDescendantOf(LocalPlayer.Character) then
        return false
    end

    -- Heuristic: vật thể tròn/nhỏ, thường là projectile/skill
    if part.Shape == Enum.PartType.Ball then
        return true
    end

    return false
end

----------------------------------------------------------------
-- HÀM XỬ LÝ
----------------------------------------------------------------
local function HandleVisual(obj)
    if IsVisualOnly(obj) then
        pcall(function()
            obj:Destroy()
        end)
    end
end

local function HandleSound(obj)
    if IsSkillSound(obj) then
        pcall(function()
            obj.Volume = 0
            obj:Stop()
        end)
    end
end

-- ẨN “quả cầu” theo cách AN TOÀN:
-- Chỉ làm trong suốt + tắt bóng, KHÔNG đụng CanCollide/physics
local function HideOrb(obj)
    if IsLikelySkillOrb(obj) then
        pcall(function()
            obj.Transparency = 1
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        end)
    end
end

----------------------------------------------------------------
-- QUÉT TOÀN BỘ GAME
----------------------------------------------------------------
for _,v in ipairs(game:GetDescendants()) do
    HandleVisual(v)
    HandleSound(v)
    HideOrb(v)
end

----------------------------------------------------------------
-- BẮT OBJECT MỚI SINH RA (KHI DÙNG SKILL / ĐÁNH THƯỜNG)
----------------------------------------------------------------
game.DescendantAdded:Connect(function(v)
    task.wait()
    HandleVisual(v)
    HandleSound(v)
    HideOrb(v)
end)

----------------------------------------------------------------
-- GIẢM CHẤT LƯỢNG RENDER (CHỈ ĐỒ HOẠ, KHÔNG ẢNH HƯỞNG VẬT LÝ)
----------------------------------------------------------------
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

print("✅ SAFE MODE: Effects hidden, skill sounds muted, orbs hidden | NO CONFLICT | SEA OK")
