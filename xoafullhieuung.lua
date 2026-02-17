local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

local Effects = {
    ParticleEmitter=true,
    Trail=true,
    Beam=true,
    Fire=true,
    Smoke=true,
    Sparkles=true,
    Explosion=true,
    Highlight=true,
    PointLight=true,
    SpotLight=true,
    SurfaceLight=true
}

-- kiểm tra hệ thống
local function IsSystem(obj)

    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end
    if obj:IsA("BillboardGui") then return true end
    if obj:IsA("SurfaceGui") then return true end

    local name = string.lower(obj.Name)
    if string.find(name,"spawn")
    or string.find(name,"teleport")
    or string.find(name,"safe")
    or string.find(name,"zone") then
        return true
    end

    return false
end

-- xử lý model (npc + player)
local function ProcessCharacter(model)
    if not model:FindFirstChildOfClass("Humanoid") then return end

    for _,v in pairs(model:GetDescendants()) do
        
        -- xoá phụ kiện
        if v:IsA("Accessory") or v:IsA("Hat") then
            pcall(function() v:Destroy() end)
        end

        -- body thành màu xám
        if v:IsA("BasePart") then
            v.Color = GRAY
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end

        -- tắt hiệu ứng còn sót
        if Effects[v.ClassName] then
            pcall(function()
                v.Enabled = false
                v:Destroy()
            end)
        end
    end
end

-- xử lý object thường
local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    -- xoá hiệu ứng
    if Effects[obj.ClassName] then
        pcall(function()
            obj.Enabled = false
            obj:Destroy()
        end)
        return
    end

    -- xoá cây / nhà decor phụ
    if obj:IsA("Model") then
        local name = string.lower(obj.Name)
        if string.find(name,"tree")
        or string.find(name,"plant")
        or string.find(name,"house")
        or string.find(name,"building")
        or string.find(name,"rock") then
            pcall(function() obj:Destroy() end)
            return
        end
    end

    -- basepart thành xám
    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
    end

    -- npc + người chơi
    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        ProcessCharacter(model)
    end
end

-- chạy lần đầu
for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

-- xử lý object mới spawn
game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)
