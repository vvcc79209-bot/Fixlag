--===== FIX LAG + TỐI ƯU HÓA =====--
-- Lưu ý: Chạy trong game Roblox (ưu tiên game có cơ chế tương tự Blox Fruits)

-- 1. Xoá cây cối + nhà không cần thiết (giữ mặt đất)
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsA("Terrain") then
        local name = v.Name:lower()
        if name:match("tree") or name:match("leaf") or name:match("house") or name:match("building") or name:match("roof") or name:match("door") or name:match("window") or name:match("fence") or name:match("plant") then
            v:Destroy()
        end
    end
end

-- 2. Biến biển + mặt đất thành màu xám (giữ nguyên mặt trời)
local terrain = workspace.Terrain
local waterMaterial = Enum.Material.SmoothPlastic
local grayColor = Color3.fromRGB(120, 120, 120)

-- Đổi màu mặt đất (nếu dùng Part)
for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") and not part:IsA("Terrain") then
        local yPos = part.Position.Y
        if yPos < 5 or part.Material == Enum.Material.Water then
            part.Color = grayColor
            part.Material = waterMaterial
            part.Reflectance = 0.2
        elseif part.Name:lower():match("ground") or part.Name:lower():match("floor") then
            part.Color = grayColor
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Đổi màu Terrain (mặt đất và biển)
if terrain then
    local waterRegion = Region3.new(Vector3.new(-10000, -100, -10000), Vector3.new(10000, 5, 10000))
    terrain:FillRegion(waterRegion, Enum.Material.Water, grayColor)
    
    local groundRegion = Region3.new(Vector3.new(-10000, -50, -10000), Vector3.new(10000, 100, 10000))
    terrain:FillRegion(groundRegion, Enum.Material.Ground, grayColor)
end

-- 3. Xoá 100% hiệu ứng skill, trái, võ, kiếm, súng, đánh thường
local effectTypes = {
    "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Beam", 
    "Decal", "Texture", "SelectionBox", "Highlight", "BillboardGui",
    "Effect", "AttackEffect", "SkillEffect", "DamageEffect"
}

local function removeEffects(obj)
    for _, effectType in pairs(effectTypes) do
        for _, effect in pairs(obj:GetDescendants()) do
            if effect:IsA(effectType) then
                effect:Destroy()
            end
        end
    end
end

-- Quét toàn bộ workspace và cả Player
removeEffects(workspace)
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character then
        removeEffects(player.Character)
    end
    if player.PlayerGui then
        for _, gui in pairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("Frame") or gui:IsA("ImageLabel") then
                if gui.Name:lower():match("effect") or gui.Name:lower():match("skill") then
                    gui:Destroy()
                end
            end
        end
    end
end

-- 4. Xoá âm thanh
for _, sound in pairs(workspace:GetDescendants()) do
    if sound:IsA("Sound") or sound:IsA("SoundGroup") then
        sound:Stop()
        sound:Destroy()
    end
end
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character then
        for _, sound in pairs(player.Character:GetDescendants()) do
            if sound:IsA("Sound") then sound:Destroy() end
        end
    end
end

-- 5. Ngăn tạo lại hiệu ứng (giữ nguyên skill nhưng không hiển thị effect)
local original = Instance.new
setreadonly(Instance, false)
Instance.new = function(self, className)
    if className:match("Effect") or className:match("Particle") or className:match("Sound") then
        return nil
    end
    return original(self, className)
end

print("✅ Đã fix lag: Xoá cây, nhà, hiệu ứng, âm thanh | Mặt đất + biển xám | Giữ mặt trời, không lỗi CDK")
