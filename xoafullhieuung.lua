--// CONFIG
local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

--// EFFECT LIST
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

--// CHECK SYSTEM OBJECT
local function IsSystem(obj)
    if obj:IsDescendantOf(game:GetService("Players")) then return true end
    if obj:IsA("SpawnLocation") then return true end
    if obj.Name:lower():find("spawn") then return true end
    if obj.Name:lower():find("safe") then return true end
    if obj.Name:lower():find("zone") then return true end
    if obj.Transparency >= 1 then return true end
    return false
end

--// REMOVE EFFECT
local function Clean(obj)

    if Effects[obj.ClassName] then
        obj:Destroy()
        return
    end

    -- xoá phụ kiện nhân vật
    if obj:IsA("Accessory") then
        obj:Destroy()
        return
    end

    -- đổi map sang xám SAFE (không lỗi đảo)
    if obj:IsA("BasePart")
    and not IsSystem(obj)
    and obj.Transparency < 0.8
    and obj.CanCollide == true then

        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

--// RUN
for _,v in pairs(workspace:GetDescendants()) do
    pcall(Clean,v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(Clean,v)
end)

--// SKY
if not KEEP_SKY then
    local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
end
