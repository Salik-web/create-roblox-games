--!strict
-- Client purchase helpers for UI code.
--   PurchaseController.PromptPass("VIP")
--   PurchaseController.PromptProduct("Coins_Small")
--   PurchaseController.OwnsPass("VIP")
--   PurchaseController.IsAvailable("Pass", "VIP")  -- false while ID is 0 ("Coming soon")
--   PurchaseController.ClaimDaily()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))
local Net = require(ReplicatedStorage.Shared:WaitForChild("Net"))

local player = Players.LocalPlayer

local PurchaseController = {}

function PurchaseController.IsAvailable(kind: "Pass" | "Product", key: string): boolean
	local entry = if kind == "Pass" then Config.GamePasses[key] else Config.Products[key]
	return entry ~= nil and entry.Id ~= 0
end

function PurchaseController.OwnsPass(key: string): boolean
	return player:GetAttribute(`Pass_{key}`) == true
end

function PurchaseController.PromptPass(key: string)
	if PurchaseController.IsAvailable("Pass", key) and not PurchaseController.OwnsPass(key) then
		Net.Event("RequestPurchase"):FireServer("Pass", key)
	end
end

function PurchaseController.PromptProduct(key: string)
	if PurchaseController.IsAvailable("Product", key) then
		Net.Event("RequestPurchase"):FireServer("Product", key)
	end
end

function PurchaseController.Balance(currency: string): number
	local value = player:GetAttribute(`Currency_{currency}`)
	return if type(value) == "number" then value else 0
end

function PurchaseController.ClaimDaily()
	if player:GetAttribute("DailyCanClaim") == true then
		Net.Event("ClaimDaily"):FireServer()
	end
end

return PurchaseController
