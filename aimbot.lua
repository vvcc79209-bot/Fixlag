-- AIMBOT + FIXLAG (MOBILE)
-- Player / NPC + Reduce Effect

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- STATE
--------------------------------------------------
getgenv().AimMode = "OFF" -- OFF / PLAYER / NPC
local AimPart = "Head"
local MaxDistance = 900

--------------------------------------------------
-- FIX LAG (SAFE)
--------------------------------------------------
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 1e9
    Lighting.Ambient = Color3.fromRGB(150,150,150)
    Lighting.OutdoorAmbient = Color3.fromRGB(150,150,150)

    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("BlurEffect")
        or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end
end)

-- Remove skill effects (particle / trail / beam)
task.spawn(function()
    while task.wait(3) do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Beam") then
                v.Enabled = false
            end
        end
    end
end)

--------------------------------------------------
-- GUI (MOBILE)
--------------------------------------------------
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "AimbotFixlag"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,180,0,160)
frame.Position = UDim2.new(0,20,0.5,-80)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "AIMBOT + FIXLAG"
title.TextColor3 = Color3.fromRGB(255,170,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local function btn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local bPlayer = btn("Aim Player",40)
local bNPC = btn("Aim NPC",80)
local bOff = btn("OFF",120)

bPlayer.MouseButton1Click:Connect(function()
    getgenv().AimMode = "PLAYER"
    bPlayer.BackgroundColor3 = Color3.fromRGB(0,170,0)
    bNPC.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

bNPC.MouseButton1Click:Connect(function()
    getgenv().AimMode = "NPC"
    bNPC.BackgroundColor3 = Color3.fromRGB(0,170,0)
    bPlayer.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

bOff.MouseButton1Click:Connect(function()
    getgenv().AimMode = "OFF"
    bPlayer.BackgroundColor3 = Color3.fromRGB(60,60,60)
    bNPC.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

--------------------------------------------------
-- TARGET CHECK
--------------------------------------------------
local function IsNPC(m)
    return m:FindFirstChildOfClass("Humanoid")
       and not Players:GetPlayerFromCharacter(m)
end

local function IsPlayer(m)
    local p = Players:GetPlayerFromCharacter(m)
    return p and p ~= LocalPlayer
end

local function GetClosestTarget()
    local closest, shortest = nil, MaxDistance
    for _,m in pairs(workspace:GetChildren()) do
        local hum = m:FindFirstChildOfClass("Humanoid")
        local part = m:FindFirstChild(AimPart)
        if hum and part and hum.Health > 0 then
            if getgenv().AimMode == "PLAYER" and not IsPlayer(m) then continue end
            if getgenv().AimMode == "NPC" and not IsNPC(m) then continue end

            local pos, on = Camera:WorldToViewportPoint(part.Position)
            if on then
                local dist = (Vector2.new(pos.X,pos.Y) - Camera.ViewportSize/2).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = part
                end
            end
        end
    end
    return closest
end

--------------------------------------------------
-- AIM LOOP
--------------------------------------------------
RunService.RenderStepped:Connect(function()
    if getgenv().AimMode == "OFF" then return end
    local t = GetClosestTarget()
    if t then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
    end
end)

print("✅ Aimbot + Fixlag loaded")
