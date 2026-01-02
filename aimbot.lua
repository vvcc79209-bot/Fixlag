-- MOBILE AIMBOT MENU (PLAYER / NPC)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- STATE
--------------------------------------------------
getgenv().AimMode = "OFF" -- OFF / PLAYER / NPC
local AimPart = "Head"
local MaxDistance = 900

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AimbotMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local function makeButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "AIMBOT"
title.TextColor3 = Color3.fromRGB(255,170,0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local btnPlayer = makeButton("Aim Player", 40)
local btnNPC    = makeButton("Aim NPC", 80)
local btnOff    = makeButton("OFF", 120)

--------------------------------------------------
-- BUTTON EVENTS
--------------------------------------------------
btnPlayer.MouseButton1Click:Connect(function()
    getgenv().AimMode = "PLAYER"
    btnPlayer.BackgroundColor3 = Color3.fromRGB(0,170,0)
    btnNPC.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

btnNPC.MouseButton1Click:Connect(function()
    getgenv().AimMode = "NPC"
    btnNPC.BackgroundColor3 = Color3.fromRGB(0,170,0)
    btnPlayer.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

btnOff.MouseButton1Click:Connect(function()
    getgenv().AimMode = "OFF"
    btnPlayer.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btnNPC.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

--------------------------------------------------
-- TARGET CHECK
--------------------------------------------------
local function IsNPC(model)
    return model:FindFirstChildOfClass("Humanoid")
       and not Players:GetPlayerFromCharacter(model)
end

local function IsPlayer(model)
    local plr = Players:GetPlayerFromCharacter(model)
    return plr and plr ~= LocalPlayer
end

--------------------------------------------------
-- GET CLOSEST TARGET
--------------------------------------------------
local function GetClosestTarget()
    local closest = nil
    local shortest = MaxDistance

    for _,model in ipairs(workspace:GetChildren()) do
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local part = model:FindFirstChild(AimPart)

        if humanoid and part and humanoid.Health > 0 then
            if getgenv().AimMode == "PLAYER" and not IsPlayer(model) then
                continue
            end
            if getgenv().AimMode == "NPC" and not IsNPC(model) then
                continue
            end

            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y)
                    - Camera.ViewportSize / 2).Magnitude

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

    local target = GetClosestTarget()
    if target then
        Camera.CFrame = CFrame.new(
            Camera.CFrame.Position,
            target.Position
        )
    end
end)

print("✅ Mobile Aimbot Menu Loaded")
