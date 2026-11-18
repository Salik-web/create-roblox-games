--!strict
-- Client bootstrap: requires every ModuleScript in Controllers,
-- calls Init(registry) on all, then Start() on all.

local controllersFolder = script.Parent:WaitForChild("Controllers")
local registry: { [string]: any } = {}
local loadOrder: { string } = {}

local modules = controllersFolder:GetChildren()
table.sort(modules, function(a, b)
	return a.Name < b.Name
end)

for _, module in modules do
	if module:IsA("ModuleScript") then
		local ok, controller = pcall(require, module)
		if ok then
			registry[module.Name] = controller
			table.insert(loadOrder, module.Name)
		else
			warn(`[Client] Failed to require {module.Name}: {controller}`)
		end
	end
end

for _, name in loadOrder do
	local controller = registry[name]
	if type(controller) == "table" and type(controller.Init) == "function" then
		local ok, err = pcall(controller.Init, registry)
		if not ok then
			warn(`[Client] {name}.Init failed: {err}`)
		end
	end
end

for _, name in loadOrder do
	local controller = registry[name]
	if type(controller) == "table" and type(controller.Start) == "function" then
		task.spawn(function()
			local ok, err = pcall(controller.Start)
			if not ok then
				warn(`[Client] {name}.Start failed: {err}`)
			end
		end)
	end
end
