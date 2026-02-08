--// Anti Effect + Gray World (Client Only)
--// Giảm hiệu ứng + chuyển map sang màu xám
--// Không chỉnh Sky và Lighting chính

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LOCAL_PLAYER = Players.LocalPlayer

-- cấu hình
local EFFECT_REDUCTION = 0.95 -- giảm 95%
local GRAY_COLOR = Color3.fromRGB(120,120,120)

-- kiểm tra có phải sky không
local function isSky(obj)
	if obj:IsDescendantOf(game:GetService("Lighting")) then
		if obj.Name:lower():find("sky") then
			return true
		end
	end
	return false
end

-- giảm hiệu ứng nhưng không xoá
local function reduceEffects(obj)
	if obj:IsA("ParticleEmitter") then
		obj.Rate = obj.Rate * (1 - EFFECT_REDUCTION)
	elseif obj:IsA("Trail") then
		obj.Lifetime = NumberRange.new(0.05)
	elseif obj:IsA("Beam") then
		obj.Width0 = 0.05
		obj.Width1 = 0.05
	elseif obj:IsA("PointLight") or obj:IsA("SpotLight") then
		obj.Brightness = obj.Brightness * 0.05
	end
end

-- chuyển màu xám map
local function grayify(obj)
	if isSky(obj) then return end
	
	if obj:IsA("BasePart") then
		if not obj.Parent:FindFirstChildWhichIsA("Humanoid") then
			obj.Color = GRAY_COLOR
			obj.Material = Enum.Material.SmoothPlastic
		end
	end
end

-- scan object
local function process(obj)
	pcall(function()
		reduceEffects(obj)
		grayify(obj)
	end)
end

-- chạy lần đầu
for _,v in pairs(Workspace:GetDescendants()) do
	process(v)
end

-- theo dõi object mới
Workspace.DescendantAdded:Connect(function(obj)
	task.wait(0.1)
	process(obj)
end)

-- giảm hiệu ứng liên tục (skill spawn liên tục)
RunService.RenderStepped:Connect(function()
	for _,v in pairs(Workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
			reduceEffects(v)
		end
	end
end)
