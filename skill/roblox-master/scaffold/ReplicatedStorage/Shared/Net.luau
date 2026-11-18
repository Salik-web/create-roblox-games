--!strict
-- Remote helper. Server creates remotes on first use; client waits for them.
-- Server:  Net.Handle("RequestEquip", 5, function(player, itemId) ... end)
-- Client:  Net.Event("RequestEquip"):FireServer("Ninja")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local RateLimiter = require(script.Parent.RateLimiter)

local IS_SERVER = RunService:IsServer()
local FOLDER_NAME = "Remotes"
local CLIENT_TIMEOUT = 30

local Net = {}

local function getFolder(): Instance
	if IS_SERVER then
		local folder = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
		if not folder then
			folder = Instance.new("Folder")
			folder.Name = FOLDER_NAME
			folder.Parent = ReplicatedStorage
		end
		return folder :: Instance
	end
	local folder = ReplicatedStorage:WaitForChild(FOLDER_NAME, CLIENT_TIMEOUT)
	assert(folder, "[Net] Remotes folder not found (server not started?)")
	return folder
end

local function getRemote(className: string, name: string): Instance
	local folder = getFolder()
	local existing = folder:FindFirstChild(name)
	if existing then
		assert(existing.ClassName == className, `[Net] {name} exists as {existing.ClassName}, expected {className}`)
		return existing
	end
	if IS_SERVER then
		local remote = Instance.new(className)
		remote.Name = name
		remote.Parent = folder
		return remote
	end
	local remote = folder:WaitForChild(name, CLIENT_TIMEOUT)
	assert(remote, `[Net] Remote '{name}' not found. Is the server creating it?`)
	return remote
end

function Net.Event(name: string): RemoteEvent
	return getRemote("RemoteEvent", name) :: RemoteEvent
end

function Net.Unreliable(name: string): UnreliableRemoteEvent
	return getRemote("UnreliableRemoteEvent", name) :: UnreliableRemoteEvent
end

function Net.Function(name: string): RemoteFunction
	return getRemote("RemoteFunction", name) :: RemoteFunction
end

-- Server: rate-limited, error-isolated RemoteEvent handler.
function Net.Handle(name: string, maxPerSecond: number, handler: (Player, ...any) -> ()): RBXScriptConnection
	assert(IS_SERVER, "Net.Handle is server-only")
	local limiter = RateLimiter.new(maxPerSecond, 1)
	return Net.Event(name).OnServerEvent:Connect(function(player: Player, ...: any)
		if not limiter:Check(player) then
			return
		end
		local ok, err = pcall(handler, player, ...)
		if not ok then
			warn(`[Net] {name} handler error for {player.Name}: {err}`)
		end
	end)
end

-- Server: rate-limited RemoteFunction handler. Returns nil when limited or on error.
function Net.HandleFunction(name: string, maxPerSecond: number, handler: (Player, ...any) -> any)
	assert(IS_SERVER, "Net.HandleFunction is server-only")
	local limiter = RateLimiter.new(maxPerSecond, 1)
	Net.Function(name).OnServerInvoke = function(player: Player, ...: any)
		if not limiter:Check(player) then
			return nil
		end
		local ok, result = pcall(handler, player, ...)
		if not ok then
			warn(`[Net] {name} function error for {player.Name}: {result}`)
			return nil
		end
		return result
	end
end

return Net
