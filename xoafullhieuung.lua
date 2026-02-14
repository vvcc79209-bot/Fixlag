--// CONFIG
local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

--// FULL EFFECT CLASS
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

--// KEYWORD EFFECT SKILL
local SkillNames = {
    "fx","effect","vfx","hit","slash","punch","smoke",
    "dash","flash","shock","aura","haki","transform",
    "attack","skill","boom","impact"
}

--// SYSTEM CHECK (anti lỗi đảo)
local function IsSystem(obj)
    if obj:IsDescendantOf(game:GetService("Players")) then return true end
    if obj:IsA("SpawnLocation") then return true end
    if obj.Name:lower():find("spawn") then return true end
    if obj.Name:lower():find("safe") then return true end
    if obj.Name:lower():find("zone") then return true end
    if obj.Transparency >= 1 then return true end
    return false
end

--// CHECK SKILL OBJECT
local function IsSkillObject(obj)
    local name = obj.Name:lower()
    for _,k in pairs(SkillNames) do
        if name:find(k) then
            return true
        end
    end
    return false
end

--// CLEAN OBJECT
local function Clean(obj)

    -- giữ bầu trời
    if KEEP_SKY and obj:IsA("Sky") then return end

    -- xoá phụ kiện
    if obj:IsA("Accessory") then
        obj:Destroy()
        return
    end

    -- xoá sound skill
    if obj:IsA("Sound") and IsSkillObject(obj) then
        obj:Destroy()
        return
    end

    -- xoá animation rác
    if obj:IsA("Animation") then
        obj:Destroy()
        return
    end

    -- xoá toàn bộ class hiệu ứng
    if Effects[obj.ClassName] then
        obj:Destroy()
        return
    end

    -- xoá model skill
    if IsSkillObject(obj) and not IsSystem(obj) then
        obj:Destroy()
        return
    end

    -- đổi map xám an toàn
    if obj:IsA("BasePart")
    and not IsSystem(obj)
    and obj.Transparency < 0.8
    and obj.CanCollide == true then

        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

--// RUN FIRST
for _,v in pairs(workspace:GetDescendants()) do
    pcall(Clean,v)
end

--// RUN REALTIME
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(Clean,v)
end)

--// SKY REMOVE OPTION
if not KEEP_SKY then
    local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
end
