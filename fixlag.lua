-- Script tối ưu hóa Blox Fruits: Xóa hiệu ứng & Phụ kiện
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- 1. Xóa bỏ 95% hiệu ứng môi trường và hạt (Particles)
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("PostProcessEffect") then -- Xóa Blur, Bloom, v.v.
        v.Enabled = false
    end
end

-- 2. Xóa phụ kiện và chỉnh màu nhân vật thành xám/trắng
local function optimizeCharacter(char)
    task.wait(0.5) -- Đợi nhân vật load xong
    
    -- Xóa phụ kiện (mũ, áo choàng, kiếm treo...)
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            item:Destroy()
        end
    end
    
    -- Đổi màu cơ thể thành xám trắng (5% còn lại)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Color = Color3.fromRGB(200, 200, 200) -- Màu xám trắng
            part.Material = Enum.Material.SmoothPlastic -- Làm mượt bề mặt
        end
    end
end

-- Áp dụng cho người chơi hiện tại và người mới vào
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then optimizeCharacter(player.Character) end
    player.CharacterAdded:Connect(optimizeCharacter)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(optimizeCharacter)
end)

-- 3. Cài đặt Lighting để giảm lag tối đa
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
settings().Rendering.QualityLevel = 1

print("Đã tối ưu hóa 95% hiệu ứng và xóa phụ kiện thành công!")
