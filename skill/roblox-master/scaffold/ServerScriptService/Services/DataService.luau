--!nonstrict
-- Player data with ProfileStore (session locking, autosave, safe shutdown).
-- Requires ServerScriptService.Packages.ProfileStore (MadStudioRoblox/ProfileStore).
-- Read ProfileStore's header comments after installing to confirm the API below.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage.Shared.Config)
local Signal = require(ReplicatedStorage.Shared.Signal)
local ProfileStore = require(ServerScriptService:WaitForChild("Packages"):WaitForChild("ProfileStore"))

local SCHEMA_VERSION = 1

local function buildTemplate()
	local currencies = {}
	for _, name in Config.Currencies do
		currencies[name] = Config.StartingCurrency[name] or 0
	end
	return {
		Version = SCHEMA_VERSION,
		Currencies = currencies,
		Inventory = { Skins = { Default = true }, Items = {} },
		Equipped = { Skin = "Default" },
		Progress = { Level = 1, XP = 0 },
		Stats = { Joins = 0, PlaytimeSeconds = 0 },
		Daily = { LastClaimDay = 0, Streak = 0 },
		Quests = {},
		Purchases = { Receipts = {}, TotalRobuxSpent = 0 },
		Settings = { Music = 0.5, Sfx = 0.8 },
		Flags = {},
	}
end

-- Breaking schema changes: add a step here and bump SCHEMA_VERSION.
local MIGRATIONS: { [number]: (data: any) -> () } = {
	-- [2] = function(data) data.Progress.Chapter = data.Progress.Level end,
}

local function migrate(data)
	local version = data.Version or 1
	while version < SCHEMA_VERSION do
		version += 1
		local step = MIGRATIONS[version]
		if step then
			step(data)
		end
	end
	data.Version = SCHEMA_VERSION
end

local DataService = {}
DataService.ProfileLoaded = Signal.new() -- (player, data)
DataService.Profiles = {} :: { [Player]: any }

local store
local joinTimes: { [Player]: number } = {}

local function onPlayerAdded(player: Player)
	local profile = store:StartSessionAsync(`Player_{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile == nil then
		player:Kick("We couldn't load your data. Please rejoin in a moment.")
		return
	end

	profile:AddUserId(player.UserId) -- GDPR compliance
	profile:Reconcile() -- fills in fields added to the template later
	migrate(profile.Data)

	profile.OnSessionEnd:Connect(function()
		DataService.Profiles[player] = nil
		player:Kick("Your data was loaded on another server. Please rejoin.")
	end)

	if player.Parent ~= Players then
		profile:EndSession()
		return
	end

	DataService.Profiles[player] = profile
	joinTimes[player] = os.clock()
	profile.Data.Stats.Joins += 1
	player:SetAttribute("DataLoaded", true)
	DataService.ProfileLoaded:Fire(player, profile.Data)
end

function DataService.Init(registry)
	DataService.Registry = registry
	store = ProfileStore.New(Config.DataStoreName, buildTemplate())
	if Config.UseMockDataInStudio and RunService:IsStudio() then
		store = store.Mock
	end
end

function DataService.Start()
	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end

	Players.PlayerRemoving:Connect(function(player)
		local profile = DataService.Profiles[player]
		local joinedAt = joinTimes[player]
		joinTimes[player] = nil
		if profile then
			if joinedAt then
				profile.Data.Stats.PlaytimeSeconds += math.floor(os.clock() - joinedAt)
			end
			profile:EndSession()
		end
		DataService.Profiles[player] = nil
	end)
end

function DataService.GetProfile(player: Player)
	local profile = DataService.Profiles[player]
	if profile and profile:IsActive() then
		return profile
	end
	return nil
end

-- Returns the live data table (mutate it directly on the server) or nil.
function DataService.Get(player: Player)
	local profile = DataService.GetProfile(player)
	return profile and profile.Data
end

-- Yields until the player's data is loaded (or timeout / player left).
function DataService.WaitForData(player: Player, timeout: number?)
	local deadline = os.clock() + (timeout or 30)
	while player.Parent == Players and os.clock() < deadline do
		local data = DataService.Get(player)
		if data then
			return data
		end
		task.wait(0.1)
	end
	return nil
end

-- Requests an immediate save (use after valuable events like purchases).
function DataService.SaveNow(player: Player)
	local profile = DataService.GetProfile(player)
	if profile and type(profile.Save) == "function" then
		pcall(profile.Save, profile)
	end
end

return DataService
