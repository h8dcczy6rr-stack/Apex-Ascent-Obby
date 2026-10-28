--[[
APEX ASCENT - Complete Single Script Obby
Place this ONE Script in ServerScriptService

=====================================================
WORKSPACE SETUP (create these Folders/Parts):
=====================================================

Checkpoints          → Parts named "1", "2", "3"... (Anchored)
KillBricks           → Any parts that kill on touch
MovingPlatforms      → Sliding platforms
                       Attributes: Offset (Vector3), Time (number)
DisappearingPlatforms→ Platforms that vanish when touched
                       Attributes: Delay (number), RespawnTime (number)
SpinningPlatforms    → Platforms that spin
                       Attributes: Speed (number), Axis ("X"/"Y"/"Z")
JumpPads             → Launch pads
                       Attribute: Power (number)
FallingPlatforms     → Platforms that fall after standing on them
                       Attributes: Delay (number), RespawnTime (number)
Finish               → Single Part at the very end of the course

=====================================================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")

-- Safe waits for folders (they can be created later)
local function waitForFolder(name)
	return workspace:WaitForChild(name, 10) or Instance.new("Folder")
end

local checkpoints = waitForFolder("Checkpoints")
local killBricks = waitForFolder("KillBricks")
local movers = waitForFolder("MovingPlatforms")
local disappearing = waitForFolder("DisappearingPlatforms")
local spinning = waitForFolder("SpinningPlatforms")
local jumpPads = waitForFolder("JumpPads")
local falling = waitForFolder("FallingPlatforms")
local finish = workspace:WaitForChild("Finish", 10)

-- DataStores
local winsStore = DataStoreService:GetOrderedDataStore("ApexAscent_Wins")
local stageStore = DataStoreService:GetOrderedDataStore("ApexAscent_HighestStage")

local cooldown = {}

-- ========== PLAYER SETUP & LEADERSTATS ==========
local function setupPlayer(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = 1
	stage.Parent = stats

	local wins = Instance.new("IntValue")
	wins.Name = "Wins"
	wins.Value = 0
	wins.Parent = stats

	-- Load saved data
	local success, data = pcall(function()
		return {
			wins = winsStore:GetAsync(player.UserId),
			stage = stageStore:GetAsync(player.UserId)
		}
	end)

	if success and data then
		if typeof(data.wins) == "number" then wins.Value = data.wins end
		if typeof(data.stage) == "number" then stage.Value = data.stage end
	end

	player.CharacterAdded:Connect(function(character)
		task.wait(0.1)
		local cp = checkpoints:FindFirstChild(tostring(stage.Value))
		if cp and cp:IsA("BasePart") then
			character:PivotTo(cp.CFrame + Vector3.new(0, 4, 0))
		end
	end)
end

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(player)
	cooldown[player] = nil
	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	pcall(function()
		winsStore:SetAsync(player.UserId, stats.Wins.Value)
		stageStore:SetAsync(player.UserId, stats.Stage.Value)
	end)
end)

-- ========== CHECKPOINTS ==========
local function setupCheckpoints()
	for _, cp in checkpoints:GetChildren() do
		local number = tonumber(cp.Name)
		if number and cp:IsA("BasePart") then
			cp.Touched:Connect(function(hit)
				local player = Players:GetPlayerFromCharacter(hit.Parent)
				if not player then return end
				local stats = player:FindFirstChild("leaderstats")
				if stats and stats.Stage.Value < number then
					stats.Stage.Value = number
				end
			end)
		end
	end
end
setupCheckpoints()

-- ========== KILL BRICKS ==========
local function setupKillBricks()
	for _, brick in killBricks:GetChildren() do
		if brick:IsA("BasePart") then
			brick.Touched:Connect(function(hit)
				local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Health > 0 then
					humanoid.Health = 0
				end
			end)
		end
	end
end
setupKillBricks()

-- ========== MOVING PLATFORMS ==========
local function setupMovingPlatforms()
	for _, platform in movers:GetChildren() do
		if platform:IsA("BasePart") then
			platform.Anchored = true
			local offset = platform:GetAttribute("Offset") or Vector3.new(0, 0, 20)
			local duration = platform:GetAttribute("Time") or 3

			local info = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
			TweenService:Create(platform, info, {Position = platform.Position + offset}):Play()
		end
	end
end
setupMovingPlatforms()

-- ========== DISAPPEARING PLATFORMS ==========
local function setupDisappearingPlatforms()
	for _, platform in disappearing:GetChildren() do
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

				-- Warning phase
				local warnTween = TweenService:Create(platform, TweenInfo.new(delayTime), {Transparency = 0.6})
				warnTween:Play()
				warnTween.Completed:Wait()

				-- Disappear
				platform.CanCollide = false
				platform.Transparency = 1

				task.wait(respawnTime)

				-- Restore
				platform.Transparency = originalTransparency
				platform.CanCollide = originalCanCollide
				isActive = true
			end)
		end
	end
end
setupDisappearingPlatforms()

-- ========== SPINNING PLATFORMS ==========
local function setupSpinningPlatforms()
	for _, platform in spinning:GetChildren() do
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
end
setupSpinningPlatforms()

-- ========== JUMP PADS ==========
local function setupJumpPads()
	for _, pad in jumpPads:GetChildren() do
		if pad:IsA("BasePart") then
			pad.Anchored = true
			local power = pad:GetAttribute("Power") or 80

			pad.Touched:Connect(function(hit)
				local character = hit.Parent
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local root = character:FindFirstChild("HumanoidRootPart")

				if humanoid and root and humanoid.Health > 0 then
					root.AssemblyLinearVelocity = Vector3.new(
						root.AssemblyLinearVelocity.X,
						power,
						root.AssemblyLinearVelocity.Z
					)
				end
			end)
		end
	end
end
setupJumpPads()

-- ========== FALLING PLATFORMS ==========
local function setupFallingPlatforms()
	for _, platform in falling:GetChildren() do
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
end
setupFallingPlatforms()

-- ========== FINISH LINE ==========
if finish and finish:IsA("BasePart") then
	finish.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player or cooldown[player] then return end

		local stats = player:FindFirstChild("leaderstats")
		if not stats then return end

		cooldown[player] = true
		stats.Wins.Value += 1
		stats.Stage.Value = 1

		player:LoadCharacter()

		task.delay(2, function()
			cooldown[player] = nil
		end)
	end)
end

print("[Apex Ascent] All systems loaded successfully!")
