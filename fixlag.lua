-- Blox Fruits Script: Xóa 100% Hiệu Ứng Skill Trái Ác Quỷ, Võ, Kiếm, Súng & Đánh Thường
-- Lag Reducer + No Effects 100% (Hoạt động mượt mà, FPS cao)
-- Copy toàn bộ code này paste vào Executor (Synapse X, Krnl, Fluxus, v.v.)
-- Không key, free, update 2026

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Cài đặt chất lượng thấp để tối ưu FPS
settings().Rendering.QualityLevel = Enum.SavedQualitySetting.QualityLevel1
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1

-- Hàm xóa hiệu ứng (Particles, Trails, Beams, Lights, v.v.)
local function ClearEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            -- Xóa tất cả hiệu ứng visual từ skill
            if obj:IsA("ParticleEmitter") or 
               obj:IsA("Trail") or 
               obj:IsA("Beam") or 
               obj:IsA("Fire") or 
               obj:IsA("Smoke") or 
               obj:IsA("Sparkles") or 
               obj:IsA("Explosion") then
                obj.Enabled = false
                obj.Lifetime = NumberSequence.new(0)
                -- obj:Destroy() -- Uncomment nếu muốn destroy hoàn toàn (mạnh hơn nhưng có thể gây bug nhỏ)
            elseif obj:IsA("PointLight") or 
                   obj:IsA("SpotLight") or 
                   obj:IsA("SurfaceLight") then
                obj.Brightness = 0
                obj.Range = 0
            elseif obj:IsA("Attachment") and #obj:GetChildren() == 0 then
                obj:Destroy()
            end
        end)
    end
end

-- Chạy liên tục mỗi frame để xóa effects mới spawn từ skill
RunService.Heartbeat:Connect(ClearEffects)

-- Clear ban đầu
ClearEffects()

-- Tùy chọn: Xóa textures/decals để FPS cao hơn (uncomment nếu máy yếu)
--[[
spawn(function()
    while true do
        wait(5)
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end)
        end
    end
end)
--]]

print("✅ Script No Effects Blox Fruits đã load! 100% xóa hiệu ứng skill (trái, võ, kiếm, súng, đánh thường)")
print("FPS sẽ tăng đáng kể, game mượt hơn!")

-- FullBright tùy chọn (bật nếu muốn sáng hơn)
--[[
Lighting.FogColor = Color3.new(1,1,1)
Lighting.FogStart = math.huge
Lighting.Ambient = Color3.new(1,1,1)
Lighting.OutdoorAmbient = Color3.new(1,1,1)
Lighting.Brightness = 2
--]]
