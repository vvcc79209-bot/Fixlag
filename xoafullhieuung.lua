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

local function IsPlayerChar(obj)
    local model = obj:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return true
    end
    return false
end

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

    -- xoá phụ kiện nhân vật
    if obj:IsA("Accessory") then
        obj:Destroy()
        return
    end

    -- xoá sound skill
    if obj:IsA("Sound") then
        obj:Destroy()
        return
    end

    -- xoá animation effect
    if obj:IsA("Animation") then
        obj:Destroy()
        return
    end

    -- xoá class hiệu ứng
    if Effects[obj.ClassName] then
        obj:Destroy()
        return
    end

    -- xoá model skill
    if not IsPlayerChar(obj) and IsSkillName(obj) then
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
