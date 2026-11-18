--!nonstrict
-- Cleanup bag. Add connections, instances, functions, threads or objects with
-- Destroy/Disconnect; call :Clean() (or :Destroy()) to clean everything.
-- Use one per player, per round, per UI screen.

local Trove = {}
Trove.__index = Trove

function Trove.new()
	return setmetatable({ _objects = {} }, Trove)
end

function Trove:Add(object)
	table.insert(self._objects, object)
	return object
end

function Trove:Connect(signal, fn)
	return self:Add(signal:Connect(fn))
end

function Trove:Extend()
	return self:Add(Trove.new())
end

local function cleanup(object)
	local kind = typeof(object)
	if kind == "RBXScriptConnection" then
		object:Disconnect()
	elseif kind == "Instance" then
		object:Destroy()
	elseif kind == "function" then
		object()
	elseif kind == "thread" then
		pcall(task.cancel, object)
	elseif kind == "table" then
		if type(object.Destroy) == "function" then
			object:Destroy()
		elseif type(object.Disconnect) == "function" then
			object:Disconnect()
		end
	end
end

function Trove:Clean()
	local objects = self._objects
	self._objects = {}
	for i = #objects, 1, -1 do
		local ok, err = pcall(cleanup, objects[i])
		if not ok then
			warn("[Trove] cleanup error:", err)
		end
	end
end

Trove.Destroy = Trove.Clean

return Trove
