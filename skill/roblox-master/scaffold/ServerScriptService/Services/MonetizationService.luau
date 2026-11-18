--!nonstrict
-- Game passes, developer products and the single ProcessReceipt handler.
-- Client asks via Net "RequestPurchase" (kind: "Pass" | "Product", key from Config).
-- Clients read ownership from player attributes: "Pass_<Key>" = true.

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Net = require(ReplicatedStorage.Shared.Net)
local Signal = require(ReplicatedStorage.Shared.Signal)

local MAX_RECEIPTS = 100

local MonetizationService = {}
MonetizationService.PassOwned = Signal.new() -- (player, key) fired on join-check and purchase
MonetizationService.ProductPurchased = Signal.new() -- (player, key)

local DataService, CurrencyService, Telemetry

local owned: { [Player]: { [string]: boolean } } = {}
local passIdToKey: { [number]: string } = {}
local productIdToKey: { [number]: string } = {}
local productHandlers: { [string]: (Player, any) -> boolean } = {}

local function grantPass(player: Player, key: string)
	owned[player] = owned[player] or {}
	if owned[player][key] then
		return
	end
	owned[player][key] = true
	player:SetAttribute(`Pass_{key}`, true)
	MonetizationService.PassOwned:Fire(player, key)
end

local function checkPasses(player: Player)
	for key, pass in Config.GamePasses do
		if pass.Id ~= 0 then
			task.spawn(function()
				for attempt = 1, 3 do
					local ok, has = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, pass.Id)
					if ok then
						if has then
							grantPass(player, key)
						end
						return
					end
					task.wait(attempt * 2)
				end
				warn(`[Monetization] Could not check pass {key} for {player.Name}`)
			end)
		end
	end
end

function MonetizationService.OwnsPass(player: Player, key: string): boolean
	return owned[player] ~= nil and owned[player][key] == true
end

-- handler(player, data) -> boolean (true = granted). Must be safe to run once per receipt.
function MonetizationService.RegisterProductHandler(key: string, handler: (Player, any) -> boolean)
	productHandlers[key] = handler
end

local function grantProduct(player: Player, key: string, data): boolean
	local product = Config.Products[key]
	if not product then
		return false
	end
	local custom = productHandlers[key]
	if custom then
		return custom(player, data) == true
	end
	if product.Grant then
		return CurrencyService.Add(player, product.Grant.Currency, product.Grant.Amount, "IAP", key)
	end
	warn(`[Monetization] Product {key} has no Grant and no registered handler`)
	return false
end

local function processReceipt(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local profile = DataService.GetProfile(player)
	if not profile then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local data = profile.Data
	local receipts = data.Purchases.Receipts
	if table.find(receipts, receiptInfo.PurchaseId) then
		return Enum.ProductPurchaseDecision.PurchaseGranted -- already granted before
	end

	local key = productIdToKey[receiptInfo.ProductId]
	if not key then
		warn(`[Monetization] Unknown product id {receiptInfo.ProductId}`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local ok, granted = pcall(grantProduct, player, key, data)
	if not ok or not granted then
		warn(`[Monetization] Grant failed for {key} ({player.Name}): {granted}`)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	table.insert(receipts, receiptInfo.PurchaseId)
	while #receipts > MAX_RECEIPTS do
		table.remove(receipts, 1)
	end
	data.Purchases.TotalRobuxSpent += receiptInfo.CurrencySpent or 0
	DataService.SaveNow(player)

	MonetizationService.ProductPurchased:Fire(player, key)
	Telemetry.Custom(player, `Purchase_{key}`, receiptInfo.CurrencySpent)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

function MonetizationService.Init(registry)
	DataService = registry.DataService
	CurrencyService = registry.CurrencyService
	Telemetry = registry.Telemetry
	for key, pass in Config.GamePasses do
		if pass.Id ~= 0 then
			passIdToKey[pass.Id] = key
		end
	end
	for key, product in Config.Products do
		if product.Id ~= 0 then
			productIdToKey[product.Id] = key
		end
	end
end

function MonetizationService.Start()
	MarketplaceService.ProcessReceipt = processReceipt

	-- Automatic currency multipliers from passes (Config.GamePasses[key].CurrencyMultiplier)
	for key, pass in Config.GamePasses do
		if pass.CurrencyMultiplier and pass.CurrencyMultiplier ~= 1 then
			CurrencyService.RegisterMultiplier(`Pass_{key}`, function(player)
				return if MonetizationService.OwnsPass(player, key) then pass.CurrencyMultiplier else 1
			end)
		end
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
		local key = passIdToKey[passId]
		if purchased and key then
			grantPass(player, key)
			Telemetry.Custom(player, `PassPurchase_{key}`)
		end
	end)

	Net.Handle("RequestPurchase", 2, function(player: Player, kind: any, key: any)
		if type(kind) ~= "string" or type(key) ~= "string" then
			return
		end
		if kind == "Pass" then
			local pass = Config.GamePasses[key]
			if not pass or pass.Id == 0 or MonetizationService.OwnsPass(player, key) then
				return
			end
			Telemetry.Custom(player, `PromptPass_{key}`)
			MarketplaceService:PromptGamePassPurchase(player, pass.Id)
		elseif kind == "Product" then
			local product = Config.Products[key]
			if not product or product.Id == 0 then
				return
			end
			Telemetry.Custom(player, `PromptProduct_{key}`)
			MarketplaceService:PromptProductPurchase(player, product.Id)
		end
	end)

	Players.PlayerAdded:Connect(checkPasses)
	for _, player in Players:GetPlayers() do
		checkPasses(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		owned[player] = nil
	end)
end

return MonetizationService
