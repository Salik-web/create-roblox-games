--!strict
-- Number and time formatting for UI.

local Format = {}

local SUFFIXES = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

-- 999 -> "999", 1234 -> "1.2K", 15300000 -> "15.3M"
function Format.Abbreviate(n: number): string
	if n ~= n or n == math.huge or n == -math.huge then
		return "0"
	end
	local sign = if n < 0 then "-" else ""
	n = math.abs(n)
	if n < 1000 then
		return sign .. tostring(math.floor(n))
	end
	local tier = math.min(math.floor(math.log10(n) / 3), #SUFFIXES - 1)
	local value = n / 10 ^ (tier * 3)
	local text
	if value >= 100 then
		text = tostring(math.floor(value))
	else
		text = (string.format("%.1f", math.floor(value * 10) / 10):gsub("%.0$", ""))
	end
	return sign .. text .. SUFFIXES[tier + 1]
end

-- 1234567 -> "1,234,567"
function Format.Commas(n: number): string
	local text = tostring(math.floor(math.abs(n)))
	local formatted = text:reverse():gsub("(%d%d%d)", "%1,"):reverse()
	formatted = (formatted:gsub("^,", ""))
	return (if n < 0 then "-" else "") .. formatted
end

-- 75 -> "1:15", 3725 -> "1:02:05"
function Format.Time(seconds: number): string
	seconds = math.max(0, math.floor(seconds))
	local h = seconds // 3600
	local m = (seconds % 3600) // 60
	local s = seconds % 60
	if h > 0 then
		return string.format("%d:%02d:%02d", h, m, s)
	end
	return string.format("%d:%02d", m, s)
end

return Format
