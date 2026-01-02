-- BLOX FRUITS REMOVE TREE + HOUSE SAFE
-- KHÔNG XOÁ MẶT ĐẤT | KHÔNG Ô VUÔNG | SEA 1-3 | ANDROID

local Workspace = game:GetService("Workspace")

------------------------------------------------
-- HÀM KIỂM TRA MODEL CÓ PHẢI ĐẤT / ĐẢO KHÔNG
------------------------------------------------
local function IsGroundModel(model)
	for _,v in ipairs(model:GetDescendants()) do
		if v:IsA("Terrain") then
			return true
		end
		if v:IsA("Part") or v:IsA("MeshPart") then
			if v.Size.Y > 20 then -- part to = nền / đảo
				return true
			end
		end
	end
	return false
end

------------------------------------------------
-- XOÁ CÂY + NHÀ KHÔNG CẦN THIẾT
------------------------------------------------
for _,v in ipairs(Workspace:GetDescendants()) do
	if v:IsA("Model") then
		local name = v.Name:lower()

		-- DANH SÁCH CÂY CỐI
		if name:find("tree")
		or name:find("bush")
		or name:find("grass")
		or name:find("leaf")
		or name:find("plant")
		or name:find("palm") then
			pcall(function()
				v:Destroy()
			end)
		end

		-- DANH SÁCH NHÀ / PROP
		if name:find("house")
		or name:find("hut")
		or name:find("home")
		or name:find("building")
		or name:find("shop")
		or name:find("prop")
		or name:find("decor") then

			-- ❗ KHÔNG XOÁ NẾU LÀ ĐẢO / NỀN
			if not IsGroundModel(v) then
				pcall(function()
					v:Destroy()
				end)
			end
		end
	end
end

print("✅ XOÁ CÂY + NHÀ (KHÔNG ĐỤNG MẶT ĐẤT)")
