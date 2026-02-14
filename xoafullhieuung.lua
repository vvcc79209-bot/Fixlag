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

local function IsSkill(obj)
    if obj:IsDescendantOf(workspace.Characters) then return false end

    if obj:IsA("Model")
    or obj:IsA("MeshPart")
    or obj:IsA("Part")
    or obj:IsA("Attachment") then

        local n = obj.Name:lower()

        if n:find("fx")
        or n:find("effect")
        or n:find("hit")
        or n:find("slash")
        or n:find("boom")
        or n:find("impact")
        or n:find("dash")
        or n:find("flash")
        or n:find("skill")
        or n:find("attack")
        or n:find("transform")
        or n:find("mode")
        or n:find("aura") then
            return true
        end
    end

    return false
end

local function Clean(obj)

    if KEEP_SKY and obj:IsA("Sky") then return end

    -- xoá phụ kiện
    if obj:IsA("Accessory") then
        obj:Destroy()
        return
    end

    -- xoá sound skill
    if obj:IsA("Sound") then
        obj:Destroy()
        return
    end

    -- xoá animation
    if obj:IsA("Animation") then
        obj:Destroy()
        return
    end

    -- xoá class hiệu ứng
    if Effects[obj.ClassName] then
        obj:Destroy()
        return
    end

    -- xoá mọi model skill
    if IsSkill(obj) and not IsSystem(obj) then
        obj:Destroy()
        return
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
