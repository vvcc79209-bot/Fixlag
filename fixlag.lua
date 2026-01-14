-- Blox Fruits: HIDE EVERYTHING (ULTRA MODE)
-- Hide all skill effects + server skill objects

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm ẩn object
local function HideAll(obj)
    -- Ẩn mọi Part (vật thể)
    if obj:IsA("BasePart") then
        -- Không ẩn map và nhân vật
        if not obj:IsDescendantOf(LocalPlayer.Character) then
            obj.Transparency = 1
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            pcall(function()
                obj.CanCollide = false
            end)
        end

    -- Xoá mọi hiệu ứng
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail")
    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj:Destroy()

    -- Xoá texture / decal
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()

    -- Xoá GUI gắn trên vật thể
    elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        obj:Destroy()

    -- Xoá highlight / viền sáng
    elseif obj:IsA("Highlight") then
        obj:Destroy()

    -- Explosion
    elseif obj:IsA("Explosion") then
        obj.BlastPressure = 0
        obj.BlastRadius = 0
    end
end

-- Quét toàn bộ game
for _,v in pairs(game:GetDescendants()) do
    HideAll(v)
end

-- Theo dõi object mới sinh ra (skill, băng, cầu, tường, v.v.)
game.DescendantAdded:Connect(function(v)
    task.wait()
    HideAll(v)
end)

-- Giảm đồ họa về mức thấp nhất
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

print("🚀 ULTRA MODE: ĐÃ ẨN TẤT CẢ HIỆU ỨNG & VẬT THỂ SKILL!")
