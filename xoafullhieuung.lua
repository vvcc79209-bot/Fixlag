--// TỶ LỆ XOÁ HIỆU ỨNG
local REMOVE_PERCENT = 0.98

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

local function IsSkillName(obj)
    local n = obj.Name:lower()
    if n:find("fx")
    or n:find("effect")
    or n:find("hit")
    or n:find("slash")
    or n:find("impact")
    or n:find("boom")
    or n:find("dash")
    or n:find("flash")
    or n:find("skill")
    or n:find("attack")
    or n:find("aura")
    or n:find("mode")
    or n:find("transform") then
        return true
    end
    return false
end

local function Clean(obj)

    -- random giữ lại ~2%
    local function ShouldRemove()
        return math.random() < REMOVE_PERCENT
    end

    -- xoá phụ kiện
    if obj:IsA("Accessory") and ShouldRemove() then
        obj:Destroy()
        return
    end

    -- xoá sound skill
    if obj:IsA("Sound") and ShouldRemove() then
        obj:Destroy()
        return
    end

    -- xoá animation effect
    if obj:IsA("Animation") and ShouldRemove() then
        obj:Destroy()
        return
    end

    -- xoá class hiệu ứng
    if Effects[obj.ClassName] and ShouldRemove() then
        obj:Destroy()
        return
    end

    -- xoá model skill
    if IsSkillName(obj) and ShouldRemove() then
        obj:Destroy()
        return
    end
end

for _,v in pairs(workspace:GetDescendants()) do
    pcall(Clean,v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(Clean,v)
end)
