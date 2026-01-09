-- FORCE GRAY GROUND & SEA (Blox Fruits WORKING)

local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local GRAY = Color3.fromRGB(130,130,130)

if not Terrain then return end

-- materials cần đổi
local Materials = {
	Enum.Material.Grass,
	Enum.Material.Ground,
	Enum.Material.Rock,
	Enum.Material.Sand,
	Enum.Material.Slate,
	Enum.Material.Mud,
	Enum.Material.Concrete
}

-- loop chống game reset
task.spawn(function()
	while true do
		pcall(function()
			for _,mat in ipairs(Materials) do
				Terrain:SetMaterialColor(mat, GRAY)
			end

			-- Sea
			Terrain.WaterColor = GRAY
			Terrain.WaterTransparency = 0
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
		end)
		task.wait(3)
	end
end)
