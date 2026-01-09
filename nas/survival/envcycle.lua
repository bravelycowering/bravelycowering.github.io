local envcycle = {}

---@alias color {r:number, g:number, b:number}

---@param hex string
---@return color
local function fromHex(hex)
	return {
		r = tonumber(string.sub(hex, 2, 3), 16),
		g = tonumber(string.sub(hex, 4, 5), 16),
		b = tonumber(string.sub(hex, 6, 7), 16),
	}
end

---@param color color
---@return string
local function toHex(color)
	return string.format("#%02x%02x%02x", math.floor(color.r), math.floor(color.g), math.floor(color.b))
end

local function blendHex(hex1, hex2, p)
	local col1 = fromHex(hex1)
	local col2 = fromHex(hex2)
	local ip = 1-p
	return toHex {
		r = col1.r*ip + col2.r*p,
		g = col1.g*ip + col2.g*p,
		b = col1.b*ip + col2.b*p,
	}
end

local last
local maxtime = 6

local function env(hour)
	local time = math.floor(hour*6)
	return function(obj)
		obj.time = time
		if not last then
			last = obj
		end
		-- blend
		local dist = obj.time - last.time
		local start = 0
		local offset = last.time
		if dist < 1 then
			dist = 1
			start = 1
		end
		for i = start, dist, 1 do
			local p = i/dist
			local envv = {
				sun = blendHex(last.sun, obj.sun, p),
				fog = blendHex(last.fog, obj.fog, p),
				sky = blendHex(last.sky, obj.sky, p),
				cloud = blendHex(last.cloud, obj.cloud, p),
			}
			envcycle[offset] = envv
			offset = (offset + 1)%maxtime
		end
		last = obj
	end
end

env(0) {
	sun =	"#ffffff",
	fog =	"#ffffff",
	sky =	"#9accff",
	cloud =	"#ffffff",
}

env(0.5) {
	sun =	"#444444",
	fog =	"#000000",
	sky =	"#000000",
	cloud =	"#444444",
}

env(1) {
	sun =	"#ffffff",
	fog =	"#ffffff",
	sky =	"#9accff",
	cloud =	"#ffffff",
}

return envcycle