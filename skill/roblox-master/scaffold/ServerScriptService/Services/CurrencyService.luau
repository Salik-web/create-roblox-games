--!nonstrict
-- Server-authoritative currencies + leaderstats + multipliers.
-- Clients read balances from player attributes: "Currency_<Name>".

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Signal = require(ReplicatedStorage.Shared.Signal)

local CurrencyService = {}
CurrencyService.Changed = Signal.new() -- (player, currency, newBalance, delta)

local DataService
local Telemetry
local multipliers: { [string]: (Player) -> number } = {}

local function isValidCurrency(currency: string): boolean
	return table.find(Config.Currencies, currency) ~= nil
end

local function isValidAmount(amount: number): boolean
	return type(amount) == "number" and amount == amount and amount > 0 and amount < math.huge
end

local function sync(player: Player, currency: string, balance: number)
	player:SetAttribute(`Currency_{currency}`, balance)
	local leaderstats = player:FindFirstChild("leaderstats")
	local value = leaderstats and leaderstats:FindFirstChild(currency)
	if value then
		value.Value = balance
	end
end

local function setupLeaderstats(player: Player, data)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	for _, currency in Config.Leaderstats do
		local value = Instance.new("NumberValue")
		value.Name = currency
		value.Value = data.Currencies[currency] or 0
		value.Parent = leaderstats
	end
	leaderstats.Parent = player
	for _, currency in Config.Currencies do
		player:SetAttribute(`Currency_{currency}`, data.Currencies[currency] or 0)
	end
end

-- Register a multiplier source, e.g. pass perks, boosts, events. Return 1 for none.
function CurrencyService.RegisterMultiplier(name: string, fn: (Player) -> number)
	multipliers[name] = fn
end

function CurrencyService.GetMultiplier(player: Player): number
	local total = 1
	for name, fn in multipliers do
		local ok, value = pcall(fn, player)
		if ok and type(value) == "number" and value > 0 then
			total *= value
		elseif not ok then
			warn(`[CurrencyService] multiplier {name} error: {value}`)
		end
	end
	return total
end

function CurrencyService.Get(player: Player, currency: string): number
	local data = DataService.Get(player)
	return data and data.Currencies[currency] or 0
end

-- Raw add (no multipliers): purchases, daily rewards, refunds.
function CurrencyService.Add(player: Player, currency: string, amount: number, transactionType: string?, sku: string?): boolean
	if not isValidCurrency(currency) or not isValidAmount(amount) then
		return false
	end
	local data = DataService.Get(player)
	if not data then
		return false
	end
	amount = math.floor(amount)
	data.Currencies[currency] = (data.Currencies[currency] or 0) + amount
	local balance = data.Currencies[currency]
	sync(player, currency, balance)
	CurrencyService.Changed:Fire(player, currency, balance, amount)
	Telemetry.Economy(player, "Source", currency, amount, balance, transactionType or "Gameplay", sku)
	return true
end

-- Gameplay earning: applies all multipliers. Returns the amount actually granted.
function CurrencyService.Earn(player: Player, currency: string, baseAmount: number, sku: string?): number
	if not isValidAmount(baseAmount) then
		return 0
	end
	local amount = math.floor(baseAmount * CurrencyService.GetMultiplier(player))
	if amount <= 0 then
		return 0
	end
	return if CurrencyService.Add(player, currency, amount, "Gameplay", sku) then amount else 0
end

function CurrencyService.CanAfford(player: Player, currency: string, amount: number): boolean
	return CurrencyService.Get(player, currency) >= amount
end

-- Returns true if spent. Always check the price from Config/Catalog, never the client.
function CurrencyService.Spend(player: Player, currency: string, amount: number, sku: string?): boolean
	if not isValidCurrency(currency) or not isValidAmount(amount) then
		return false
	end
	local data = DataService.Get(player)
	if not data then
		return false
	end
	amount = math.floor(amount)
	local balance = data.Currencies[currency] or 0
	if balance < amount then
		return false
	end
	balance -= amount
	data.Currencies[currency] = balance
	sync(player, currency, balance)
	CurrencyService.Changed:Fire(player, currency, balance, -amount)
	Telemetry.Economy(player, "Sink", currency, amount, balance, "Shop", sku)
	return true
end

function CurrencyService.Init(registry)
	DataService = registry.DataService
	Telemetry = registry.Telemetry
end

function CurrencyService.Start()
	if Config.PremiumMultiplier and Config.PremiumMultiplier ~= 1 then
		CurrencyService.RegisterMultiplier("Premium", function(player)
			return if player.MembershipType == Enum.MembershipType.Premium then Config.PremiumMultiplier else 1
		end)
	end

	DataService.ProfileLoaded:Connect(setupLeaderstats)
	for player, profile in DataService.Profiles do
		if not player:FindFirstChild("leaderstats") then
			setupLeaderstats(player, profile.Data)
		end
	end
end

return CurrencyService
