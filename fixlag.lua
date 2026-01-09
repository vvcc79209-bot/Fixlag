-- BLOX FRUITS MAP CLEAN (NO RESPAWN)
-- Hide trees, houses, props (NO Destroy)

local Workspace = game:GetService("Workspace")

local REMOVE_SIZE = 20 -- objects smaller than this will be hidden

local function shouldHide(obj)
    if not obj:IsA("BasePart") then return false end
    if obj:IsDescendantOf(Workspace.Terrain) then return false end
    if obj.Parent and obj.Parent:FindFirstChild("Humanoid") then return false end

    if obj.Size.Magnitude <= REMOVE_SIZE then
        return true
    end

    return false
end

local function hide(obj)
    obj.Transparency = 1
    obj.CanCollide = false
    obj.CastShadow = false
    obj.Material = Enum.Material.SmoothPlastic
end

-- Initial clean
for _,obj in ipairs(Workspace:GetDescendants()) do
    if shouldHide(obj) then
        hide(obj)
    end
end

-- Anti respawn
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    if shouldHide(obj) then
        hide(obj)
    end
end)
