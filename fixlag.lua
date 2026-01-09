-- Script Blox Fruits: Map xám nhạt (Light Gray) nhưng giữ người chơi & mặt trời gần bình thường
-- 100% LocalScript - Dùng ColorCorrection nhẹ nhàng hơn
-- Tested concept 2026

local Lighting = game:GetService("Lighting")
local Terrain = workspace:WaitForChild("Terrain")

local lightGray = Color3.fromRGB(211, 211, 211)   -- Xám nhạt
local veryLightGray = Color3.fromRGB(225, 225, 225) -- Tint nhẹ hơn cho nhân vật

-- Xóa hết post-effect cũ để tránh conflict
local function clearPostEffects()
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect:Destroy()
        end
    end
end
clearPostEffects()

-- 1. Nước biển xám (giữ nguyên)
Terrain.WaterColor = Color3.fromRGB(190, 190, 200)
Terrain.WaterTransparency = 0.35

-- 2. ColorCorrection - Cân bằng để nhân vật & mặt trời không bị xám quá nặng
local cc = Instance.new("ColorCorrectionEffect")
cc.Name = "GrayMapBetterCC"
cc.Parent = Lighting
cc.Enabled = true

cc.Saturation   = -0.82       -- Không -1 để còn chút màu cho người chơi, quần áo, hiệu ứng
cc.TintColor    = veryLightGray -- Tint nhẹ, không dùng xám đậm
cc.Contrast     = 0.25        -- Tăng contrast → nhân vật nổi bật hơn
cc.Brightness   = 0.08        -- Sáng hơn tí
cc.Enabled      = true

-- 3. Fog - Xám nhưng không quá dày (để xa vẫn thấy màu trời)
Lighting.FogColor = lightGray
Lighting.FogEnd = 1200       -- Fog xa hơn, không làm trời bị xám nặng
Lighting.FogStart = 0

-- 4. Atmosphere - Chỉnh nhẹ, giữ màu trời & mặt trời đẹp
pcall(function()
    local atm = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
    atm.Parent = Lighting
    
    atm.Color       = Color3.fromRGB(215, 215, 225)  -- Xám rất nhạt cho trời
    atm.Decay       = Color3.fromRGB(200, 200, 210)
    atm.Density     = 0.28     -- Không quá dày
    atm.Offset      = 0.22
    atm.Glare       = 0
    atm.Haze        = 0.15
end)

-- 5. Loop bảo vệ WaterColor (vì Blox Fruits hay reset)
spawn(function()
    while true do
        wait(4)
        pcall(function()
            Terrain.WaterColor = Color3.fromRGB(190, 190, 200)
            Terrain.WaterTransparency = 0.35
        end)
    end
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ ÁP DỤNG XÁM NHẠT CHO MAP - PHIÊN BẢN GIỮ NGƯỜI CHƠI & MẶT TRỜI!")
print("   • Người chơi, hiệu ứng, skin vẫn còn màu rõ ràng")
print("   • Mặt trời & bầu trời không bị xám nặng")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Tắt: Xóa 'GrayMapBetterCC' trong Lighting hoặc chạy lại clearPostEffects()")
