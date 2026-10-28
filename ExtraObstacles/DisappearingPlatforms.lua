--[[
Disappearing Platforms
Place this Script in ServerScriptService

How to use:
1. Create a Folder in Workspace called "DisappearingPlatforms"
2. Put any BaseParts inside it that should disappear when touched
3. Optional Attributes on each platform:
   - Delay (number) → seconds before it disappears (default 1.2)
   - RespawnTime (number) → seconds until it comes back (default 3)
]]

local TweenService = game:GetService("TweenService")

local folder = workspace:WaitForChild("DisappearingPlatforms")

for _, platform in folder:GetChildren() do
	if platform:IsA("BasePart") then
		platform.Anchored = true
		local originalTransparency = platform.Transparency
		local originalCanCollide = platform.CanCollide
		local delayTime = platform:GetAttribute("Delay") or 1.2
		local respawnTime = platform:GetAttribute("RespawnTime") or 3
		local isActive = true

		platform.Touched:Connect(function(hit)
			if not isActive then return end
			local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
			if not humanoid then return end

			isActive = false

			-- Warning phase (turn slightly transparent)
			local warnTween = TweenService:Create(platform, TweenInfo.new(delayTime), {
				Transparency = 0.6
			})
			warnTween:Play()
			warnTween.Completed:Wait()

			-- Disappear
			platform.CanCollide = false
			platform.Transparency = 1

			task.wait(respawnTime)

			-- Come back
			platform.Transparency = originalTransparency
			platform.CanCollide = originalCanCollide
			isActive = true
		end)
	end
end
