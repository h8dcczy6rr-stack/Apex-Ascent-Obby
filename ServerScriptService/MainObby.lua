--[[
APEX ASCENT - Main Obby Server Script
Place this as a Script in ServerScriptService

WORKSPACE SETUP:
  Checkpoints     → Parts named "1", "2", "3"... (Anchored)
  KillBricks      → Any parts that should kill on touch
  MovingPlatforms → Parts that move. Attributes:
                      Offset (Vector3)  default (0, 0, 20)
                      Time (number)     default 3
  Finish          → Single Part at the very end
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")

local checkpoints = workspace:WaitForChild("Checkpoints")
local killBricks = workspace:WaitForChild("KillBricks")
local movers = workspace:WaitForChild("MovingPlatforms")
local finish = workspace:WaitForChild("Finish")

-- DataStores for permanent leaderboard
local winsStore = DataStoreService:GetOrderedDataStore("ApexAscent_Wins")
local stageStore = DataStoreService:GetOrderedDataStore("ApexAscent_HighestStage")

local cooldown = {}

-- ========== PLAYER SETUP ==========
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
		if data.wins then wins.Value = data.wins end
		if data.stage then stage.Value = data.stage end
	end

	player.CharacterAdded:Connect(function(character)
		task.wait(0.1)
		local cp = checkpoints:FindFirstChild(tostring(stage.Value))
		if cp then
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
for _, cp in checkpoints:GetChildren() do
	local number = tonumber(cp.Name)
	if number and cp:IsA("BasePart") then
		cp.Touched:Connect(function(hit)
			local character = hit.Parent
			local player = Players:GetPlayerFromCharacter(character)
			if not player then return end

			local stats = player:FindFirstChild("leaderstats")
			if stats and stats.Stage.Value < number then
				stats.Stage.Value = number
			end
		end)
	end
end

-- ========== KILL BRICKS ==========
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

-- ========== MOVING PLATFORMS ==========
for _, platform in movers:GetChildren() do
	if platform:IsA("BasePart") then
		platform.Anchored = true
		local offset = platform:GetAttribute("Offset") or Vector3.new(0, 0, 20)
		local duration = platform:GetAttribute("Time") or 3

		local info = TweenInfo.new(
			duration,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			-1,   -- infinite
			true  -- reverse
		)

		TweenService:Create(platform, info, {
			Position = platform.Position + offset
		}):Play()
	end
end

-- ========== FINISH LINE ==========
finish.Touched:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if not player or cooldown[player] then return end

	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	cooldown[player] = true
	stats.Wins.Value += 1
	stats.Stage.Value = 1

	-- Force respawn at checkpoint 1
	player:LoadCharacter()

	task.delay(2, function()
		cooldown[player] = nil
	end)
end)
