-- SAFE MAP CLEANER (NO TERRAIN DELETE)
-- Remove trees, houses, props
-- KEEP GROUND & ISLAND SAFE

local Workspace = game:GetService("Workspace")

local function isTerrainRelated(obj)
    if obj:IsA("Terrain") then
        return true
    end
    if obj:FindFirstAncestorOfClass("Terrain") then
        return true
    end
    return false
end

local function shouldRemove(obj)
    -- chỉ xoá Part
    if not (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")) then
        return false
    end

    -- không bao giờ xoá terrain
    if isTerrainRelated(obj) then
        return false
    end

    -- không xoá part nhỏ (tránh xoá map nền)
    if obj.Size.Magnitude < 4 then
        return false
    end

    -- chỉ xoá vật thể cố định
    if obj.Anchored ~= true then
        return false
    end

    return true
end

-- remove existing map props
for _, v in ipairs(Workspace:GetDescendants()) do
    if shouldRemove(v) then
        pcall(function()
            v:Destroy()
        end)
    end
end

-- auto remove new loaded props
Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.2)
    if shouldRemove(v) then
        pcall(function()
            v:Destroy()
        end)
    end
end)
