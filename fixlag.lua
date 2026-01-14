-- Blox Fruits - Remove 90% Effects (SAFE & OPTIMIZED)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Danh sách tên hiệu ứng cần xoá (lag nặng)
local EFFECT_KEYWORDS = {
    "effect","fx","vfx","particle","trail","smoke","fire",
    "explosion","shock","spark","glow","ring","wave","beam"
}

-- Kiểm tra có phải hiệu ứng không
local function isEffect(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam") then
        return true
    end

    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        for _,k in ipairs(EFFECT_KEYWORDS) do
            if name:find(k) then
                return true
            end
        end
    end

    return false
end

-- Xoá hiệu ứng trong 1 model
local function clean(model)
    for _,v in ipairs(model:GetDescendants()) do
        if isEffect(v) then
            pcall(function()
                if v:IsA("BasePart") then
                    v.Transparency = 1
                    v.CanCollide = false
                else
                    v.Enabled = false
                end
            end)
        end
    end
end

-- Xoá hiệu ứng nhân vật
local function onCharacter(char)
    task.wait(1)
    clean(char)
end

-- Nhân vật
if LocalPlayer.Character then
    onCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacter)

-- Xoá hiệu ứng skill spawn ra (nhẹ, không loop liên tục)
Workspace.ChildAdded:Connect(function(obj)
    task.delay(0.3,function()
        if obj:IsA("Model") or obj:IsA("Folder") then
            clean(obj)
        end
    end)
end)

print("✅ Remove ~90% Effects loaded (SAFE)")
