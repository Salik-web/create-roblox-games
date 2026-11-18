--!strict
-- Token-bucket rate limiter, one bucket per player. Server-side use.

local Players = game:GetService("Players")

local RateLimiter = {}
RateLimiter.__index = RateLimiter

type Bucket = { tokens: number, last: number }
export type RateLimiter = typeof(setmetatable(
	{} :: { max: number, refillPerSecond: number, buckets: { [Player]: Bucket } },
	RateLimiter
))

-- Allows `maxCalls` calls per `perSeconds` (burst up to maxCalls).
function RateLimiter.new(maxCalls: number, perSeconds: number): RateLimiter
	local self = setmetatable({
		max = maxCalls,
		refillPerSecond = maxCalls / perSeconds,
		buckets = {},
	}, RateLimiter)
	Players.PlayerRemoving:Connect(function(player)
		self.buckets[player] = nil
	end)
	return self
end

function RateLimiter.Check(self: RateLimiter, player: Player): boolean
	local now = os.clock()
	local bucket = self.buckets[player]
	if not bucket then
		bucket = { tokens = self.max, last = now }
		self.buckets[player] = bucket
	end
	bucket.tokens = math.min(self.max, bucket.tokens + (now - bucket.last) * self.refillPerSecond)
	bucket.last = now
	if bucket.tokens >= 1 then
		bucket.tokens -= 1
		return true
	end
	return false
end

return RateLimiter
