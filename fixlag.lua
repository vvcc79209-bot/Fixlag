-- Script Blox Fruits: Làm mặt đất và biển thành màu xám nhạt (Light Gray)
-- Chạy bằng executor như Synapse X, Krnl, Fluxus,...
-- Chỉ ảnh hưởng local (chỉ bạn thấy), không kick.

local terrain = workspace:WaitForChild("Terrain")
local gray = Color3.fromRGB(211, 211, 211)  -- Màu xám nhạt

-- Thay đổi màu nước biển
terrain.WaterColor = gray
terrain.WaterTransparency = 0.2  -- Làm nước đục hơn để thấy rõ màu xám

-- Danh sách các material mặt đất phổ biến trong Blox Fruits
local landMaterials = {
    Enum.Material.Grass,      -- Cỏ
    Enum.Material.Ground,     -- Đất
    Enum.Material.Rock,       -- Đá
    Enum.Material.Mud,        -- Bùn
    Enum.Material.Sand,       -- Cát
    Enum.Material.Basalt,     -- Đá bazan
    Enum.Material.Slate,      -- Đá phiến
    Enum.Material.Concrete,   -- Bê tông
    Enum.Material.Pavement,   -- Lát đường
    Enum.Material.Asphalt,    -- Nhựa đường
    Enum.Material.Cobblestone,-- Đá cuội
    Enum.Material.Limestone,  -- Đá vôi
    Enum.Material.Marble      -- Cẩm thạch
}

-- Áp dụng màu xám cho tất cả material đất
for _, material in ipairs(landMaterials) do
    pcall(function()
        terrain:SetMaterialColor(material, gray)
    end)
end

-- Tùy chọn: Set tất cả material khác (trừ nước/không khí) để chắc chắn
spawn(function()
    wait(1)  -- Đợi terrain load đầy đủ
    local allMaterials = Enum.Material:GetEnumItems()
    for _, mat in ipairs(allMaterials) do
        if mat ~= Enum.Material.Water and 
           mat ~= Enum.Material.Air and 
           mat ~= Enum.Material.ForceField and
           mat ~= Enum.Material.ForceField then
            pcall(function()
                terrain:SetMaterialColor(mat, gray)
            end)
        end
    end
end)

print("Đã áp dụng màu xám nhạt cho mặt đất và biển! 🌫️")
