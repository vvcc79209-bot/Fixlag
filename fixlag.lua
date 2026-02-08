--// BLOX FRUITS FIX LAG + CODEX ANTI SKILL
--// Gray Map nhẹ + giảm 95% hiệu ứng skill
--// Client only

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LOCAL_PLAYER = Players.LocalPlayer
local GRAY = Color3.fromRGB(140,140,140)

-- nhận diện nhân vật
local function isCharacter(model)
	return model and model:FindFirstChildOfClass("Humanoid")
end

-- nhận diện object skill (kiểu codex hay dùng)
local function isSkillObject(obj)
	local n = obj.Name:lower()
	return n:find("skill")
	or n:find("fx")
	or n:find("effect")
	or n:find("vfx")
	or n:find("hit")
	or n:find("slash")
	or n:find("explosion")
end

-- giảm hiệu ứng 95% (không disable hết để tránh bug)
local function reduceSkillEffect(obj)

	if obj:IsA("ParticleEmitter") then
		obj.Rate = obj.Rate * 0.05
		obj.Lifetime = NumberRange.new(0.05)

	elseif obj:IsA("Trail") then
		obj.Lifetime = 0.05

	elseif obj:IsA("Beam") then
		obj.Width0 = 0.03
		obj.Width1 = 0.03

	elseif obj:IsA("PointLight")
	or obj:IsA("SpotLight")
	or obj:IsA("SurfaceLight") then
		obj.Brightness = 0

	elseif obj:IsA("Explosion") then
		obj.BlastPressure = 0
		obj.BlastRadius = 0
	end
end

-- gray map 1 lần
for _,v in ipairs(Workspace:GetDescendants()) do
	if v:IsA("BasePart") and not isCharacter(v.Parent) then
		v.Material = Enum.Material.SmoothPlastic
		v.Color = GRAY

		for _,d in ipairs(v:GetChildren()) do
			if d:IsA("Decal") or d:IsA("Texture") then
				d.Transparency = 1
			end
		end
	end
end

-- chỉ xử lý skill mới spawn (rất nhẹ)
Workspace.DescendantAdded:Connect(function(obj)
	task.wait()

	pcall(function()

		if isSkillObject(obj) then
			reduceSkillEffect(obj)
		end

		if obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Explosion")
		or obj:IsA("PointLight")
		or obj:IsA("SpotLight") then

			if obj.Parent and isSkillObject(obj.Parent) then
				reduceSkillEffect(obj)
			end
		end

	end)
end)
