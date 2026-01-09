-- Script Blox Fruits: Làm mặt đất, biển & TOÀN BỘ MAP thành màu XÁM NHẠT (Light Gray) - PHIÊN BẢN CẢI TIẾN
-- SỬ DỤNG POST-EFFECT (ColorCorrection) - 100% LOCAL, KHÔNG BỊ OVERRIDE, HOẠT ĐỘNG ỔN ĐỊNH!
-- Chạy bằng executor: Synapse X, Krnl, Fluxus,... (Tested 2026)

local Lighting = game:GetService("Lighting")
local Terrain = workspace:WaitForChild("Terrain")
local gray = Color3.fromRGB(211, 211, 211)  -- Xám nhạt

-- XÓA TẤT CẢ POST-EFFECT CŨ (tránh conflict)
local function clearPostEffects()
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect:Destroy()
        end
    end
end
clearPostEffects()

-- 1. THAY ĐỔI NƯỚC BIỂN (Water)
Terrain.WaterColor = gray
Terrain.WaterTransparency = 0.3  -- Làm đục để thấy rõ xám

-- 2. COLORCORRECTION: LÀM TOÀN BỘ MÀN HÌNH XÁM NHẠT (Grayscale + Tint)
local cc = Instance.new("ColorCorrectionEffect")
cc.Name = "GrayMapCC"
cc.Parent = Lighting
cc.Enabled = true
cc.Saturation = -1          -- Grayscale (xóa màu)
cc.TintColor = gray         -- Tô xám nhạt
cc.Contrast = 0.15          -- Tăng độ tương phản nhẹ
cc.Brightness = 0.05        -- Sáng hơn tí

-- 3. FOG (Sương mù xám)
Lighting.FogColor = gray
Lighting.FogEnd = 999999    -- Fog xa hết

-- 4. ATMOSPHERE (nếu có) - Làm bầu trời/sương xám
pcall(function()
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if atm then
        atm.Color = gray
        atm.Density = 0.4
        atm.Offset = 0.25
        atm.Decay = ColorSequence.new(gray)
        atm.Glare = 0
        atm.Haze = 0
    end
end)

-- 5. LOOP NHẸ để RE-APPLY WATER & TERRAIN (phòng trường hợp regenerate)
spawn(function()
    while true do
        wait(5)
        pcall(function()
            Terrain.WaterColor = gray
            Terrain.WaterTransparency = 0.3
        end)
    end
end)

print("✅ ĐÃ ÁP DỤNG XÁM NHẠT CHO TOÀN MAP! (Chỉ bạn thấy) 🌫️")
print("💡 Toggle OFF: Xóa 'GrayMapCC' trong Lighting hoặc re-execute script clearPostEffects()")
