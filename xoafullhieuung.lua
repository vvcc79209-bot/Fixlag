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
    if obj:IsDescendantOf(game.Players) then return true end
    if obj:IsA("SpawnLocation") then return true end
    if obj.Name:lower():find("spawn") then return true end
    if obj.Name:lower():find("safe") then return true end
    if obj.Name:lower():find("teleport") then return true end
    return false
end

local function Clean(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end

    -- xoá phụ kiện
    if obj:IsA("Accessory") then
        obj:Destroy()
        return
    end

    -- xoá sound đánh
    if obj:IsA("Sound") then
        obj:Destroy()
        return
    end

    -- xoá animation effect
    if obj:IsA("Animation") then
        obj:Destroy()
        return
    end

    -- xoá toàn bộ class hiệu ứng
    if Effects[obj.ClassName] then
        obj:Destroy()
        return
    end

    -- xoá model effect
    if not IsSystem(obj) then
        local name = obj.Name:lower()
        if name:find("fx")
        or name:find("effect")
        or name:find("hit")
        or name:find("slash")
        or name:find("boom")
        or name:find("impact")
        or name:find("dash")
        or name:find("flash") then
            obj:Destroy()
            return
        end
    end

    -- map xám
    if obj:IsA("BasePart")
    and not IsSystem(obj)
    and obj.Transparency < 0.8
    and obj.CanCollide then

        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

for _,v in pairs(workspace:GetDescendants()) do
    pcall(Clean,v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(Clean,v)
end)
