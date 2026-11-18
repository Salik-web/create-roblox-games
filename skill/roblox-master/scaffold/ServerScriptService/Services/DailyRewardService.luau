--!nonstrict
-- 7-day streak daily rewards. Day boundary = UTC midnight.
-- Client reads attributes: "DailyCanClaim" (bool), "DailyStreak" (number),
-- "DailyNextIndex" (1..#Config.DailyRewards); claims with Net "ClaimDaily";
-- receives Net "DailyClaimed" (index, reward).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Net = require(ReplicatedStorage.Shared.Net)

local DailyRewardService = {}
local DataService, CurrencyService

local function today(): number
	return math.floor(os.time() / 86400)
end

local function nextStreak(daily): number
	local gap = today() - daily.LastClaimDay
	if daily.LastClaimDay == 0 or gap > 1 + Config.DailyStreakGraceDays then
		return 1
	end
	return daily.Streak + 1
end

local function rewardIndex(streak: number): number
	return ((streak - 1) % #Config.DailyRewards) + 1
end

local function refresh(player: Player)
	local data = DataService.Get(player)
	if not data then
		return
	end
	local daily = data.Daily
	local canClaim = daily.LastClaimDay < today()
	player:SetAttribute("DailyCanClaim", canClaim)
	player:SetAttribute("DailyStreak", daily.Streak)
	player:SetAttribute("DailyNextIndex", rewardIndex(if canClaim then nextStreak(daily) else daily.Streak + 1))
end

function DailyRewardService.Init(registry)
	DataService = registry.DataService
	CurrencyService = registry.CurrencyService
end

function DailyRewardService.Start()
	if not Config.Features.DailyRewards then
		return
	end
	local claimedEvent = Net.Event("DailyClaimed")

	Net.Handle("ClaimDaily", 1, function(player: Player)
		local data = DataService.Get(player)
		if not data then
			return
		end
		local daily = data.Daily
		if daily.LastClaimDay >= today() then
			return
		end
		local streak = nextStreak(daily)
		local index = rewardIndex(streak)
		local reward = Config.DailyRewards[index]
		if reward.Currency and reward.Amount then
			CurrencyService.Add(player, reward.Currency, reward.Amount, "TimedReward", `Daily_{index}`)
		end
		daily.Streak = streak
		daily.LastClaimDay = today()
		refresh(player)
		claimedEvent:FireClient(player, index, reward)
	end)

	DataService.ProfileLoaded:Connect(function(player)
		refresh(player)
	end)
	for player in DataService.Profiles do
		refresh(player)
	end

	-- Re-check every minute so players online across midnight can claim.
	task.spawn(function()
		while true do
			task.wait(60)
			for _, player in Players:GetPlayers() do
				refresh(player)
			end
		end
	end)
end

return DailyRewardService
