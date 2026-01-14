-- Blox Fruits | Remove All Effects (Fruit, Melee, Sword, Gun, M1)
-- Anti-lag / No visual bug / No movement bug

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Danh sách tên hiệu ứng thường gặp
local effectKeywords = {
    "effect","fx","vfx","trail","beam","aura","particle","spark",
    "fire","light","glow","smoke","explosion","slash","wave","hit",
    "ring","flash","energy","skill","attack","impact","bullet","shot"
}

-- Hàm kiểm tra tên có phải hiệu ứng không
local function isEffect(obj)
    if not obj or not obj.Name then return false end
    local name = string.lower(obj.Name)
    for _, word in ipairs(effectKeywords) do
        if string.find(name, word) then
            return true
        end
    end
    return false
end

-- Xoá hiệu ứng an toàn
local function removeEffects(parent)
    for _, v in ipairs(parent:GetDescendants()) do
        -- Xoá particle / beam / trail / decal / texture
        if v:IsA("ParticleEmitter")
        or v:IsA("Beam")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles")
        or v:IsA("Decal")
        or v:IsA("Texture") then
            pcall(function()
                v.Enabled = false
                v:Destroy()
            end)
        end

        -- Xoá model / part hiệu ứng
        if (v:IsA("Model") or v:IsA("Part") or v:IsA("MeshPart")) and isEffect(v) then
            pcall(function()
                v:Destroy()
            end)
        end
    end
end

-- Chỉ xoá hiệu ứng, KHÔNG đụng map / nhân vật
local function safeClean()
    local char = player.Character
    if char then
        removeEffects(char)
    end

    if workspace:FindFirstChild("Effects") then
        removeEffects(workspace.Effects)
    end

    if workspace:FindFirstChild("Ignore") then
        removeEffects(workspace.Ignore)
    end

    -- Blox Fruits thường tạo hiệu ứng trong workspace
    removeEffects(workspace)
end

-- Lặp liên tục để xoá hiệu ứng mới sinh ra
RunService.Heartbeat:Connect(function()
    pcall(function()
        safeClean()
    end)
end)
