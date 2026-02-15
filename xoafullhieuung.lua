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

local function IsSystem(obj)

    if obj:IsA("SpawnLocation") then return true end
    if obj:IsA("ProximityPrompt") then return true end
    if obj:IsA("TouchTransmitter") then return true end
    if obj:IsA("BillboardGui") then return true end
    if obj:IsA("SurfaceGui") then return true end

    local name = string.lower(obj.Name)
    if string.find(name,"spawn")
    or string.find(name,"teleport")
    or string.find(name,"island")
    or string.find(name,"safe") then
        return true
    end

    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return true
    end

    return false
end

local function Process(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end
    if IsSystem(obj) then return end

    -- 🔥 Xoá hiệu ứng phụ nhưng không phá nhân vật
    if Effects[obj.ClassName] then

        local parentModel = obj:FindFirstAncestorOfClass("Model")

        if parentModel and parentModel:FindFirstChildOfClass("Humanoid") then
            -- nếu gắn vào nhân vật thì chỉ tắt
            pcall(function()
                if obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam")
                or obj:IsA("Fire")
                or obj:IsA("Smoke")
                or obj:IsA("Sparkles") then
                    obj.Enabled = false
                else
                    obj:Destroy()
                end
            end)
        else
            -- hiệu ứng ngoài map → xoá luôn
            pcall(function()
                obj:Destroy()
            end)
        end

        return
    end

    -- Giữ phần làm xám map
    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

-- xử lý object có sẵn
for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

-- xử lý object tạo mới
game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)

-- 🔥 Chặn hiệu ứng spawn lại liên tục
game:GetService("RunService").RenderStepped:Connect(function()
    for _,v in pairs(workspace:GetDescendants()) do
        if Effects[v.ClassName] then
            pcall(function()
                if v:IsA("ParticleEmitter")
                or v:IsA("Trail")
                or v:IsA("Beam")
                or v:IsA("Fire")
                or v:IsA("Smoke")
                or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end)
        end
    end
end)
