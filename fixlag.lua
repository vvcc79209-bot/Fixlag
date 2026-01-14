-- Blox Fruits: Hide Skill & Normal Attack Effects ONLY
-- Giữ map, nhà cửa, cây cối, NPC

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm kiểm tra: có phải part của map không?
local function IsMapPart(obj)
    if not obj:IsA("BasePart") then return false end
    -- Những thứ thuộc nhân vật, tool, effect, hoặc mới spawn thường là skill
    if obj:IsDescendantOf(LocalPlayer.Character) then return false end
    if obj.Parent and obj.Parent:IsA("Tool") then return false end
    if obj.Name:lower():find("effect") then return false end
    return true
end

-- Hàm ẩn hiệu ứng
local function HideSkill(obj)
    -- Xoá toàn bộ hiệu ứng hình ảnh
    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail")
    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj:Destroy()

    -- Xoá texture / decal của skill
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()

    -- Xoá viền sáng, GUI gắn vào skill
    elseif obj:IsA("Highlight") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        obj:Destroy()

    -- Với các vật thể skill (quả cầu, băng, slash, hitbox…)
    elseif obj:IsA("BasePart") then
        -- Không đụng vào map
        if not IsMapPart(obj) then
            obj.Transparency = 1
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            pcall(function()
                obj.CanCollide = false
            end)
        end

    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end
end

-- Quét toàn bộ game (chỉ ẩn skill)
for _,v in pairs(game:GetDescendants()) do
    HideSkill(v)
end

-- Bắt mọi hiệu ứng mới sinh ra (khi dùng skill, chém, bắn, đánh thường)
game.DescendantAdded:Connect(function(v)
    task.wait()
    HideSkill(v)
end)

-- Giảm đồ họa xuống mức thấp để tăng FPS
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

print("✅ DONE: Đã ẩn hiệu ứng skill + đánh thường, GIỮ NGUYÊN MAP")
