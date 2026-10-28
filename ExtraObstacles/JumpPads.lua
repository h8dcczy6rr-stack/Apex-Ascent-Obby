--[[
Jump Pads / Launchers
Place this Script in ServerScriptService

How to use:
1. Create a Folder in Workspace called "JumpPads"
2. Put parts inside it (these will launch the player)
3. Optional Attribute:
   - Power (number) → upward force (default 80)
]]

local folder = workspace:WaitForChild("JumpPads")

for _, pad in folder:GetChildren() do
	if pad:IsA("BasePart") then
		pad.Anchored = true
		local power = pad:GetAttribute("Power") or 80

		pad.Touched:Connect(function(hit)
			local character = hit.Parent
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local root = character:FindFirstChild("HumanoidRootPart")

			if humanoid and root and humanoid.Health > 0 then
				-- Simple upward velocity
				root.AssemblyLinearVelocity = Vector3.new(
					root.AssemblyLinearVelocity.X,
					power,
					root.AssemblyLinearVelocity.Z
				)
			end
		end)
	end
end
