--// ULTRA LIGHT Anti Effect + Gray World
--// Client only - ít lag - ít conflict

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local GRAY = Color3.fromRGB(130,130,130)

local function isPlayerCharacter(obj)
	return obj:FindFirstChildOfClass("Humanoid") ~= nil
end

local function isSky(obj)
	return obj:IsDescendantOf(Lighting) and obj.Name:lower():find("sky")
end

local function reduceEffect(obj)
	if obj:IsA("ParticleEmitter") then
		obj.Enabled = false
	elseif obj:IsA("Trail") then
		obj.Enabled = false
	elseif obj:IsA("Beam") then
		obj.Enabled = false
	elseif obj:IsA("Explosion") then
		obj.BlastPressure = 0
		obj.BlastRadius = 0
	elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
		obj.Enabled = false
	elseif obj:IsA("PointLight") or obj:IsA("SpotLight") then
		obj.Enabled = false
	end
end

local function grayWorld(obj)
	if isSky(obj) then return end
	
	if obj:IsA("BasePart") then
		if not isPlayerCharacter(obj.Parent) then
			obj.Color = GRAY
			obj.Material = Enum.Material.SmoothPlastic
			
			if obj:FindFirstChildOfClass("Decal") then
				for _,d in pairs(obj:GetChildren()) do
					if d:IsA("Decal") or d:IsA("Texture") then
						d.Transparency = 1
					end
				end
			end
		end
	end
end

local function process(obj)
	pcall(function()
		reduceEffect(obj)
		grayWorld(obj)
	end)
end

-- xử lý map lần đầu
for _,v in ipairs(Workspace:GetDescendants()) do
	process(v)
end

-- chỉ xử lý object mới spawn
Workspace.DescendantAdded:Connect(function(obj)
	task.wait()
	process(obj)
end)
