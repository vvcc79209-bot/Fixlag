local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

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

local function IsSystem(obj)

if obj:IsA("SpawnLocation") then return true end
if obj:IsA("ProximityPrompt") then return true end
if obj:IsA("TouchTransmitter") then return true end
if obj:IsA("BillboardGui") then return true end
if obj:IsA("SurfaceGui") then return true end

local name = string.lower(obj.Name)
if string.find(name,"spawn")
or string.find(name,"teleport")
or string.find(name,"island")
or string.find(name,"safe") then
return true
end

local model = obj:FindFirstAncestorOfClass("Model")
if model and model:FindFirstChildOfClass("Humanoid") then
return true
end

return false

end

local function Process(obj)

if KEEP_SKY and obj:IsA("Sky") then return end
if IsSystem(obj) then return end

-- Thay vì xoá, đổi hiệu ứng thành xám
if Effects[obj.ClassName] then
pcall(function()

if obj:IsA("ParticleEmitter") then
obj.Color = ColorSequence.new(GRAY)
obj.LightEmission = 0
end

if obj:IsA("Beam") or obj:IsA("Trail") then
obj.Color = ColorSequence.new(GRAY)
obj.LightEmission = 0
end

if obj:IsA("PointLight")
or obj:IsA("SpotLight")
or obj:IsA("SurfaceLight") then
obj.Color = GRAY
obj.Brightness = 0
end

if obj:IsA("Highlight") then
obj.FillColor = GRAY
obj.OutlineColor = GRAY
end

end)
return
end

-- Nếu là part hiệu ứng (neon / không va chạm)
if obj:IsA("BasePart") then
if obj.Material == Enum.Material.Neon
or obj.CanCollide == false then
obj.Color = GRAY
obj.Material = Enum.Material.SmoothPlastic
obj.Reflectance = 0
return
end

-- map xám như cũ
obj.Color = GRAY
obj.Material = Enum.Material.SmoothPlastic
end

end

for _,v in pairs(game:GetDescendants()) do
Process(v)
end

game.DescendantAdded:Connect(function(v)
task.wait()
Process(v)
end)
