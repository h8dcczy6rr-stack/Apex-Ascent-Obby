--[[
Spinning Platforms
Place this Script in ServerScriptService

How to use:
1. Create a Folder in Workspace called "SpinningPlatforms"
2. Put any BaseParts inside it
3. Optional Attributes:
   - Speed (number) → degrees per second (default 60)
   - Axis (string) → "Y" (default), "X", or "Z"
]]

local folder = workspace:WaitForChild("SpinningPlatforms")

for _, platform in folder:GetChildren() do
	if platform:IsA("BasePart") then
		platform.Anchored = true
		local speed = platform:GetAttribute("Speed") or 60
		local axis = (platform:GetAttribute("Axis") or "Y"):upper()

		task.spawn(function()
			while platform and platform.Parent do
				local dt = task.wait()
				local angle = math.rad(speed * dt)

				if axis == "X" then
					platform.CFrame = platform.CFrame * CFrame.Angles(angle, 0, 0)
				elseif axis == "Z" then
					platform.CFrame = platform.CFrame * CFrame.Angles(0, 0, angle)
				else
					platform.CFrame = platform.CFrame * CFrame.Angles(0, angle, 0)
				end
			end
		end)
	end
end
