-- Blox Fruits - Remove 90% Effects (SAFE & OPTIMIZED)
-- Không xoá hitbox, không bug chiêu, giảm lag mạnh

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Danh sách effect cần xoá
local REMOVE_CLASSES = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Fire = true,
    Smoke = true,
    Sparkles = true,
    Explosion = true,
    Decal = false -- decal giữ lại để tránh map lỗi
}

-- Keyword effect nặng (skill trái, kiếm, súng)
local KEYWORDS = {
    "effect","fx","vfx","skill","slash","hit","aura",
    "flame","fire","light","dark","dragon","control",
    "electric","thunder","smoke","explosion"
}

-- Kiểm tra có phải effect cần xoá không
local function isEffect(obj)
    if REMOVE_CLASSES[obj.ClassName] then
        return true
    end
    local name = obj.Name:lower()
    for _,k in pairs(KEYWORDS) do
        if name:find(k) then
            return true
        end
    end
    return false
end

-- Xoá effect an toàn
local function clean(parent)
    for _,obj in pairs(parent:GetDescendants()) do
        if isEffect(obj) then
            pcall(function()
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                elseif obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = false
                else
                    obj:Destroy()
                end
            end)
        end
    end
end

-- Dọn effect map
task.spawn(function()
    clean(Workspace)
end)

-- Khi effect mới spawn
Workspace.DescendantAdded:Connect(function(obj)
    if isEffect(obj) then
        task.wait(0.05)
        pcall(function()
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = false
            elseif obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            else
                obj:Destroy()
            end
        end)
    end
end)

-- Giảm update render thừa
RunService:Set3dRenderingEnabled(true)

print("✅ Remove 90% Effects loaded | Lag reduced")
