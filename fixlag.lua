-- Gray Ground & Gray Sea (SAFE)
-- No delete terrain | Low lag

local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- ===== CONFIG =====
local GRAY_COLOR = Color3.fromRGB(120, 120, 120)

-- ===== TERRAIN =====
if Terrain then
	-- Ground
	Terrain.MaterialColors = {
		[Enum.Material.Grass] = GRAY_COLOR,
		[Enum.Material.Sand] = GRAY_COLOR,
		[Enum.Material.Ground] = GRAY_COLOR,
		[Enum.Material.Rock] = GRAY_COLOR,
		[Enum.Material.Slate] = GRAY_COLOR,
		[Enum.Material.Mud] = GRAY_COLOR,
	}

	-- Sea
	Terrain.WaterColor = GRAY_COLOR
	Terrain.WaterTransparency = 0
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
end
