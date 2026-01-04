local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local function disableEffects()
    -- Disable Lighting PostEffects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
    -- Disable Camera PostEffects (quan trọng cho flash từ chiêu)
    local Camera = Workspace.CurrentCamera
    for _, effect in pairs(Camera:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
    -- Tối ưu thêm (tăng tầm nhìn, giảm lag)
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 0
    Lighting.Ambient = Color3.fromRGB(50, 50, 50)
end

-- Áp dụng ngay
disableEffects()

-- Loop mỗi frame (siêu mượt, không lag)
RunService.Heartbeat:Connect(disableEffects)
