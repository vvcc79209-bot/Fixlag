-- BLOX FRUITS FIX LAG 90% (STABLE)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Root = Char:WaitForChild("HumanoidRootPart")

--------------------------------------------------
-- REMOVE 90% EFFECT (SAFE)
--------------------------------------------------
local function Reduce(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam") then
        obj.Enabled = false
        obj:Destroy()
    end

    if obj:IsA("Explosion") then
        obj.Visible = false
        obj.BlastPressure = 0
    end

    if obj:IsA("Sound") then
        obj.Volume = 0
    end
end

for _,v in pairs(Workspace:GetDescendants()) do
    pcall(function()
        Reduce(v)
    end)
end

Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(function()
        Reduce(v)
    end)
end)

--------------------------------------------------
-- FORCE SWIM (KHÔNG ĐI BỘ DƯỚI BIỂN)
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    if Root.Position.Y < 0 then
        if Hum:GetState() ~= Enum.HumanoidStateType.Swimming then
            Hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end
    end
end)

warn("✅ FIX LAG 90% + FIX SWIM ĐÃ CHẠY")
