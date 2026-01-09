-- BLOX FRUITS MAP CLEANER (ULTRA SAFE)
-- WILL NOT DELETE GROUND / ISLANDS

local Workspace = game:GetService("Workspace")

-- chỉ xoá các object có tên trang trí
local REMOVE_NAME = {
    "tree","palm","bush","leaf","leaves",
    "house","building","roof","wall",
    "prop","decor","decoration","fence",
    "rock","stone","lamp","light"
}

-- các folder TUYỆT ĐỐI KHÔNG ĐỤNG
local PROTECTED_FOLDERS = {
    "Island","Islands","Map","Terrain"
}

local function isProtected(obj)
    for _, name in pairs(PROTECTED_FOLDERS) do
        if obj:FindFirstAncestor(name) then
            return true
        end
    end
    return false
end

local function shouldRemove(obj)
    if not (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")) then
        return false
    end

    -- không bao giờ đụng map / island / terrain
    if isProtected(obj) then
        return false
    end

    local n = string.lower(obj.Name)
    for _, k in pairs(REMOVE_NAME) do
        if string.find(n, k) then
            return true
        end
    end

    return false
end

for _, v in ipairs(Workspace:GetDescendants()) do
    if shouldRemove(v) then
        pcall(function()
            v:Destroy()
        end)
    end
end
