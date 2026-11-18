--!strict
-- Central configuration. Every tunable number, ID and price lives here.
-- ID 0 = not created yet in Creator Hub (UI shows "Coming soon", grants are skipped).

local RunService = game:GetService("RunService")

local Config = {
	GameName = "Untitled Game",
	Version = "0.1.0",

	-- Change per game so data never mixes between games/variants.
	DataStoreName = "PlayerData_untitled_v1",
	-- true = use ProfileStore's mock store in Studio (no real data touched).
	UseMockDataInStudio = false,
	Debug = RunService:IsStudio(),

	Currencies = { "Coins" },
	StartingCurrency = { Coins = 0 } :: { [string]: number },
	Leaderstats = { "Coins" }, -- which currencies show on the player list
	PremiumMultiplier = 1.1, -- bonus for Roblox Premium members (1 = off)

	GamePasses = {
		VIP = {
			Id = 0,
			Name = "VIP",
			Price = 299,
			CurrencyMultiplier = 1.5, -- optional perk handled automatically
		},
		DoubleCoins = {
			Id = 0,
			Name = "2x Coins",
			Price = 199,
			CurrencyMultiplier = 2,
		},
	} :: { [string]: { Id: number, Name: string, Price: number, CurrencyMultiplier: number? } },

	Products = {
		Coins_Small = { Id = 0, Name = "Pile of Coins", Price = 25, Grant = { Currency = "Coins", Amount = 500 } },
		Coins_Medium = { Id = 0, Name = "Bag of Coins", Price = 99, Grant = { Currency = "Coins", Amount = 2500 } },
		Coins_Large = { Id = 0, Name = "Chest of Coins", Price = 249, Grant = { Currency = "Coins", Amount = 7500 } },
		-- Custom products (revive, skip, boost) have no Grant; register a handler in a service.
	} :: { [string]: { Id: number, Name: string, Price: number, Grant: { Currency: string, Amount: number }? } },

	DailyRewards = {
		{ Currency = "Coins", Amount = 100 },
		{ Currency = "Coins", Amount = 150 },
		{ Currency = "Coins", Amount = 200 },
		{ Currency = "Coins", Amount = 300 },
		{ Currency = "Coins", Amount = 400 },
		{ Currency = "Coins", Amount = 500 },
		{ Currency = "Coins", Amount = 1000 }, -- day 7: make this special (cosmetic) per game
	},
	DailyStreakGraceDays = 1, -- missed days allowed before the streak resets

	Features = {
		DailyRewards = true,
	},

	-- UI theme (read by UI builders on the client)
	Theme = {
		Font = Enum.Font.FredokaOne,
		BodyFont = Enum.Font.Gotham,
		Colors = {
			Background = Color3.fromRGB(20, 20, 28),
			Panel = Color3.fromRGB(34, 34, 46),
			Primary = Color3.fromRGB(255, 196, 0),
			Accent = Color3.fromRGB(0, 200, 255),
			Success = Color3.fromRGB(70, 210, 110),
			Danger = Color3.fromRGB(235, 70, 70),
			Text = Color3.fromRGB(245, 245, 250),
		},
		CornerRadius = UDim.new(0, 12),
	},
}

local function deepFreeze(t: any)
	for _, v in t do
		if type(v) == "table" and not table.isfrozen(v) then
			deepFreeze(v)
		end
	end
	table.freeze(t)
end
deepFreeze(Config)

return Config
