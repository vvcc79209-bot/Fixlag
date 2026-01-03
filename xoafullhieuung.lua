-- Script Xóa Full Hiệu Ứng Melee/Kiếm/Súng Blox Fruits - Thay Bằng Hình Vuông Màu Giảm Mạnh
-- Paste vào executor như Synapse X, Krnl, Fluxus...
-- Tác dụng: Modify tất cả particle effects thành hình vuông (Block shape) nhỏ, mờ, tối, ít phát ra
-- Giảm lag mạnh, giữ visual minimal cho Melee, Sword, Gun (và tất cả effects khác)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Tối ưu Lighting để giảm lag thêm
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or 
           v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("Atmosphere") then
            v.Enabled = false
        end
    end
end)

-- Function modify effects thành vuông low
local function modifyEffect(obj)
    pcall(function()
        if obj:IsA("ParticleEmitter") then
            -- Hình vuông (Block shape)
            obj.Shape = Enum.ParticleEmitterShape.Block
            obj.Texture = ""  -- Không texture fancy
            -- Kích thước nhỏ
            obj.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(1, 0.05)
            })
            -- Mờ gần như invisible
            obj.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(0.5, 0.9),
                NumberSequenceKeypoint.new(1, 1)
            })
            -- Màu xám tối, giảm mạnh
            obj.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40))
            -- Thời gian sống ngắn
            obj.Lifetime = NumberRange.new(0.15, 0.3)
            -- Ít particle
            obj.Rate = 3
            obj.Speed = NumberRange.new(0.5, 1.5)
            obj.SpreadAngle = Vector2.new(360, 360)
            
        elseif obj:IsA("Trail") or obj:IsA("Beam") then
            -- Làm invisible
            obj.Transparency = NumberSequence.new(1)
            obj.Lifetime = 0.1
            
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Light") then
            obj.Enabled = false
        end
    end)
end

-- Scan và modify tất cả descendants
local function scan(parent)
    pcall(function()
        for _, obj in pairs(parent:GetDescendants()) do
            modifyEffect(obj)
        end
    end)
end

-- Scan ban đầu
scan(workspace)
if player.Character then
    scan(player.Character)
end

-- Monitor new effects liên tục (cho attacks spawn particles mới)
workspace.DescendantAdded:Connect(function(desc)
    Debris:AddItem(desc, 5)  -- Auto clean sau 5s nếu cần
    task.spawn(function()
        task.wait(0.05)  -- Chờ spawn xong
        modifyEffect(desc)
        scan(desc.Parent)
    end)
end)

-- Cho character và tools
local function onCharAdded(char)
    scan(char)
    char.DescendantAdded:Connect(function(desc)
        task.spawn(function()
            task.wait(0.1)
            modifyEffect(desc)
            if desc:IsA("Tool") then
                desc.DescendantAdded:Connect(function(toolDesc)
                    task.wait(0.05)
                    modifyEffect(toolDesc)
                end)
            end
        end)
    end)
end

if player.Character then
    onCharAdded(player.Character)
end
player.CharacterAdded:Connect(onCharAdded)

print("✅ Script Loaded! Hiệu ứng Melee/Kiếm/Súng đã thành vuông low effect 💀")
print("FPS boost mạnh - Test trong Blox Fruits PVP/Farm!")

-- Re-execute nếu cần: loadstring(game:HttpGet("pastebin-link"))()
