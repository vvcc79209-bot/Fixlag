-- REMOVE MAP OBJECTS (OPTIMIZED & SAFE)
-- Remove trees, small houses, decorations, accessories
-- KEEP: terrain, important buildings, spawn, sea, ground

local Workspace = game:GetService("Workspace")

-- Keywords to remove
local REMOVE_KEYWORDS = {
    "tree","bush","grass","leaf","plant",
    "house","hut","home","building","roof","wall",
    "decor","decoration","prop","fence","rock",
    "lamp","pole","sign","statue",
    "accessory","hat","hair","cape","wing"
}

-- Keywords to keep (important places)
local KEEP_KEYWORDS = {
    "spawn","safe","shop","dealer","npc",
    "cafe","mansion","castle","fort","factory",
    "turtle","dungeon","raid","arena"
}

local function hasKeyword(name, keywords)
    name = name:lower()
    for _,k in ipairs(keywords) do
        if name:find(k) then
            return true
        end
    end
    return false
end

local function shouldRemove(obj)
    if not obj:IsA("BasePart") then return false end
    if obj:IsDescendantOf(Workspace.Terrain) then return false end

    local name = obj.Name

    -- keep important
    if hasKeyword(name, KEEP_KEYWORDS) then
        return false
    end

    -- remove unwanted
    if hasKeyword(name, REMOVE_KEYWORDS) then
        return true
    end

    -- remove small useless parts
    if obj.Size.Magnitude < 6 then
        return true
    end

    return false
end

-- MAIN CLEAN
for _,obj in ipairs(Workspace:GetDescendants()) do
    if shouldRemove(obj) then
        obj:Destroy()
    end
end

-- Auto clean objects spawned later (anti lag)
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.2)
    if shouldRemove(obj) then
        obj:Destroy()
    end
end)
