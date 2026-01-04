-- Chế độ siêu tối ưu: Xám hóa thế giới & Fix lỗi xoay Skill Z
repeat wait() until game:IsLoaded()

local Lighting = game:GetService("Lighting")
local Terrain = game:GetService("Workspace").Terrain

-- 1. Xám hóa Mặt đất và Biển (Giữ nguyên mặt đất, không xóa)
Terrain.WaterColor = Color3.fromRGB(128, 128, 128)
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0
settings().Rendering.QualityLevel = 1

-- 2. Xám hóa NPC và xóa hiệu ứng dư thừa
task.spawn(function()
    while true do
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v:IsA("Model") then
                for _, part in pairs(v:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromRGB(100, 100, 100) -- NPC màu xám
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
        
        -- Xóa cây cối, nhà cửa (nhưng giữ Ground)
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("LeafSize") or obj.Name == "Tree" or obj.Name == "House" then
                obj:Destroy()
            end
            -- Xám hóa Texture mặt đất
            if obj:IsA("MeshPart") or obj:IsA("Part") then
                if obj.Parent.Name ~= "Map" then -- Tránh xóa nhầm đất ở Sea 2
                    obj.Color = Color3.fromRGB(120, 120, 120)
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
        end
        wait(10)
    end
end)

-- 3. Xóa hiệu ứng Skill (Soul Guitar, Dragon, Súng, Võ)
local function RemoveEffects(obj)
    local names = {"Explosion", "Particles", "Effect", "Emitter", "Fire", "Smoke", "DragonBreath", "SoulBeam"}
    for _, name in pairs(names) do
        if obj.Name:find(name) or obj:IsA("ParticleEmitter") or obj:IsA("Beam") then
            obj:Destroy()
        end
    end
end

game.Workspace.ChildAdded:Connect(function(child)
    RemoveEffects(child)
end)

-- 4. FIX LỖI XOAY CHIÊU Z SONG KIẾM (Cursed Dual Katana)
-- Cơ chế: Tự động reset lực xoay (BodyAngularVelocity) sau khi dùng chiêu
task.spawn(function()
    while wait(0.1) do
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Nếu phát hiện vật thể gây xoay kẹt trong người thì xóa ngay
            for _, force in pairs(character.HumanoidRootPart:GetChildren()) do
                if force:IsA("BodyAngularVelocity") or force:IsA("BodyVelocity") or force:IsA("Gyro") then
                    -- Kiểm tra nếu không phải đang trong lúc nhấn giữ thì xóa để fix lỗi kẹt xoay
                    task.wait(0.5) -- Đợi chiêu thực hiện xong một chút rồi xóa
                    force:Destroy()
                end
            end
        end
    end
end)

-- 5. Sửa lỗi không hiện vật phẩm trong kho đồ (Inventory Bug)
task.spawn(function()
    game:GetService("GuiService"):ClearError()
    -- Ép buộc Re-render lại UI Inventory
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main") then
        local inv = game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Inventory")
        if inv then inv.Visible = false; wait(0.1); inv.Visible = true end
    end
end)

-- Khử lag tức thời (No Shadows, No Bloom)
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
        v.Enabled = false
    end
end

print("Script đã kích hoạt: Fix xoay CDK, Xám hóa map, Tối ưu hiệu ứng!")
