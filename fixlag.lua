-- REMOVE TREES / HOUSES / USELESS PROPS
-- KEEP TERRAIN SAFE (NO GROUND DELETE)
-- OPTIMIZED FOR LOW LAG

local Workspace = game:GetService("Workspace")

-- keywords to detect objects need to remove
local REMOVE_KEYWORDS = {
    "tree","leaf","leaves","bush","grass","plant",
    "house","building","wall","roof","door","window",
    "prop","decoration","decor","fence","rock","stone"
}

local function shouldRemove(obj)
    if obj:IsA("Terrain") then
        return false
    end

    if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("UnionOperation") then
        local name = string.lower(obj.Name)
        for _, keyword in pairs(REMOVE_KEYWORDS) do
            if string.find(name, keyword) then
                return true
            end
        end
    end

    return false
end

-- remove existing objects
for _, v in ipairs(Workspace:GetDescendants()) do
    if shouldRemove(v) then
        pcall(function()
            v:Destroy()
        end)
    end
end

-- auto remove when map loads new objects
Workspace.DescendantAdded:Connect(function(v)
    task.wait(0.2)
    if shouldRemove(v) then
        pcall(function()
            v:Destroy()
        end)
    end
end)
