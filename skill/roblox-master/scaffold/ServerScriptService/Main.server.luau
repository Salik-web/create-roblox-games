--!strict
-- Server bootstrap: requires every ModuleScript in ServerScriptService.Services,
-- calls Init(registry) on all (in ORDER first), then Start() on all.

local ServerScriptService = game:GetService("ServerScriptService")

local ORDER = { "Telemetry", "DataService", "CurrencyService", "MonetizationService", "DailyRewardService" }

local servicesFolder = ServerScriptService:WaitForChild("Services")
local registry: { [string]: any } = {}
local loadOrder: { string } = {}

local function load(module: Instance)
	if not module:IsA("ModuleScript") or registry[module.Name] then
		return
	end
	local ok, service = pcall(require, module)
	if ok then
		registry[module.Name] = service
		table.insert(loadOrder, module.Name)
	else
		warn(`[Main] Failed to require {module.Name}: {service}`)
	end
end

for _, name in ORDER do
	local module = servicesFolder:FindFirstChild(name)
	if module then
		load(module)
	end
end

local others = servicesFolder:GetChildren()
table.sort(others, function(a, b)
	return a.Name < b.Name
end)
for _, module in others do
	load(module)
end

for _, name in loadOrder do
	local service = registry[name]
	if type(service) == "table" and type(service.Init) == "function" then
		local ok, err = pcall(service.Init, registry)
		if not ok then
			warn(`[Main] {name}.Init failed: {err}`)
		end
	end
end

for _, name in loadOrder do
	local service = registry[name]
	if type(service) == "table" and type(service.Start) == "function" then
		task.spawn(function()
			local ok, err = pcall(service.Start)
			if not ok then
				warn(`[Main] {name}.Start failed: {err}`)
			end
		end)
	end
end

print(`[Main] Server started with {#loadOrder} services`)
