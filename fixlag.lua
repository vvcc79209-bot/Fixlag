-- Blox Fruits Remove Map Props (WORKING VERSION)
-- Remove trees, houses, decorations
-- KEEP TERRAIN SAFE

local Workspace = game:GetService("Workspace")

-- folders thường chứa map rác
local TARGET_FOLDERS = {
    "Map",
    "Props",
    "Decorations",
    "Environment",
    "Buildings",
    "Trees"
}

-- kiểm tra folder theo tên
local function isTargetFolder(obj)
    for _, name in pairs(TARGET_FOLDERS) do
        if string.find(string.lower(obj.Name), string.lower(name)) then
            return true
        end
    end
    return false
end

-- xoá model/part KHÔNG PHẢI terrain
local function removeObject(obj)
    if obj:IsA("Terrain") then return end

    if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
        pcall(function()
            obj:Destroy()
        end)
    end
end

-- vòng 1: xoá theo folder map
for _, v in pairs(Workspace:GetChildren()) do
    if isTargetFolder(v) then
        for _, obj in pairs(v:GetDescendants()) do
            removeObject(obj)
        end
    end
end

-- vòng 2: xoá các part treo ngoài terrain
for _, v in pairs(Workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsDescendantOf(Workspace.Terrain) then
        if v.Anchored == true and v.Size.Magnitude > 8 then
            removeObject(v)
        end
    end
end

-- tự xoá khi map spawn thêm
Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.3)
    if v:IsA("BasePart") and v.Anchored and not v:IsDescendantOf(Workspace.Terrain) then
        removeObject(v)
    end
end)
