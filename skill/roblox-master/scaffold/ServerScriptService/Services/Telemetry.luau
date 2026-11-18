--!strict
-- Thin, safe wrapper over AnalyticsService. Every call is pcall'd so analytics can
-- never break gameplay. Verify signatures in the AnalyticsService docs if Roblox
-- changes them.

local AnalyticsService = game:GetService("AnalyticsService")
local Players = game:GetService("Players")

local Telemetry = {}

local onboardingDone: { [Player]: { [number]: boolean } } = {}

local function safe(fn: () -> ())
	local ok, err = pcall(fn)
	if not ok then
		warn("[Telemetry]", err)
	end
end

-- flow: "Source" (earned) or "Sink" (spent)
-- transactionType: an Enum.AnalyticsEconomyTransactionType name, e.g. "Gameplay",
-- "Shop", "IAP", "TimedReward", "Onboarding", "ContextualPurchase"
function Telemetry.Economy(
	player: Player,
	flow: "Source" | "Sink",
	currency: string,
	amount: number,
	balanceAfter: number,
	transactionType: string,
	itemSku: string?
)
	safe(function()
		local flowType = if flow == "Source"
			then Enum.AnalyticsEconomyFlowType.Source
			else Enum.AnalyticsEconomyFlowType.Sink
		AnalyticsService:LogEconomyEvent(player, flowType, currency, amount, balanceAfter, transactionType, itemSku)
	end)
end

-- Logs each onboarding step only once per player session. Steps must be 1, 2, 3...
function Telemetry.Onboarding(player: Player, step: number, stepName: string)
	local done = onboardingDone[player]
	if not done then
		done = {}
		onboardingDone[player] = done
	end
	if done[step] then
		return
	end
	done[step] = true
	safe(function()
		AnalyticsService:LogOnboardingFunnelStepEvent(player, step, stepName)
	end)
end

function Telemetry.Funnel(player: Player, funnelName: string, funnelSessionId: string?, step: number, stepName: string)
	safe(function()
		AnalyticsService:LogFunnelStepEvent(player, funnelName, funnelSessionId, step, stepName)
	end)
end

-- status: "Start" | "Complete" | "Fail"
function Telemetry.Progression(player: Player, pathName: string, status: string, level: number, levelName: string?)
	safe(function()
		local progressionType = (Enum.AnalyticsProgressionType :: any)[status]
		AnalyticsService:LogProgressionEvent(player, pathName, progressionType, level, levelName)
	end)
end

function Telemetry.Custom(player: Player, eventName: string, value: number?)
	safe(function()
		AnalyticsService:LogCustomEvent(player, eventName, value or 1)
	end)
end

function Telemetry.Start()
	Players.PlayerRemoving:Connect(function(player)
		onboardingDone[player] = nil
	end)
end

return Telemetry
