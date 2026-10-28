--[[
Falling / Breaking Platforms
Place this Script in ServerScriptService

How to use:
1. Create a Folder in Workspace called "FallingPlatforms"
2. Put parts inside it
3. Optional Attributes:
   - Delay (number) → time before it falls (default 0.8)
   - RespawnTime (number) → time until it resets (default 4)
]]

local folder = workspace:WaitForChild("FallingPlatforms")

for _, platform in folder:GetChildren() do
	if platform:IsA("BasePart") then
		platform.Anchored = true
		local originalCFrame = platform.CFrame
		local delayTime = platform:GetAttribute("Delay") or 0.8
		local respawnTime = platform:GetAttribute("RespawnTime") or 4
		local isFalling = false

		platform.Touched:Connect(function(hit)
			if isFalling then return end
			local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
			if not humanoid then return end

			isFalling = true
			task.wait(delayTime)

			platform.Anchored = false

			task.wait(respawnTime)

			platform.Anchored = true
			platform.CFrame = originalCFrame
			platform.AssemblyLinearVelocity = Vector3.zero
			platform.AssemblyAngularVelocity = Vector3.zero
			isFalling = false
		end)
	end
end
