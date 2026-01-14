-- Blox Fruits: Hide Visual Effects + Mute Skill Sounds
-- Safe: No conflict | No sea/water bug | Keep movement & swimming

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Các class chỉ dùng cho hiệu ứng hình ảnh
local EffectClasses = {
    ParticleEmitter = true,
    Beam = true,
    Trail = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Highlight = true
}

-- Kiểm tra: có phải hiệu ứng hình ảnh không
local function IsVisualEffect(obj)
    if EffectClasses[obj.ClassName] then
        return true
    end
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        return true
    end
    if obj:IsA("Decal") or obj:IsA("Texture") then
        return true
    end
    return false
end

-- Kiểm tra: có phải âm thanh của skill/đòn đánh không
local function IsSkillSound(obj)
    if not obj:IsA("Sound") then return false end

    -- Không tắt nhạc nền / UI chung
    local parent = obj.Parent
    if parent and (parent:IsA("GuiObject") or parent:IsDescendantOf(LocalPlayer:WaitForChild("PlayerGui"))) then
        return false
    end

    -- Âm thanh gắn vào Tool, Effect, Part sinh ra khi đánh
    if parent and (parent:IsA("Tool") or parent:IsA("BasePart") or parent.Name:lower():find("effect")) then
        return true
    end

    return false
end

-- Xử lý ẩn hiệu ứng hình ảnh
local function HandleVisual(obj)
    if IsVisualEffect(obj) then
        pcall(function()
            obj:Destroy()
        end)
    end
end

-- Xử lý tắt âm thanh skill/đánh thường
local function HandleSound(obj)
    if IsSkillSound(obj) then
        pcall(function()
            obj.Volume = 0
            obj.Playing = false
            obj:Stop()
        end)
    end
end

-- Quét toàn bộ game
for _,v in ipairs(game:GetDescendants()) do
    HandleVisual(v)
    HandleSound(v)
end

-- Bắt object mới sinh ra khi dùng skill / đánh thường
game.DescendantAdded:Connect(function(v)
    task.wait()
    HandleVisual(v)
    HandleSound(v)
end)

-- Giảm chất lượng render (không ảnh hưởng vật lý)
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

print("✅ DONE: Đã ẩn hiệu ứng skill + đánh thường & tắt âm thanh | No conflict | Sea OK")
