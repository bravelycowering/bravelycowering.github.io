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
local maxtime = 24	*6

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

env(6) {
	sun =	"#ffffff",
	fog =	"#cbdbfc",
	sky =	"#7fb4ff",
	cloud =	"#ffffff",
}

env(12) {
	sun =	"#ffffff",
	fog =	"#9accff",
	sky =	"#639bff",
	cloud =	"#ffffff",
}

env(13) {
	sun =	"#888888",
	fog =	"#e7922c",
	sky =	"#306082",
	cloud =	"#ffcd47",
}

env(14) {
	sun =	"#555555",
	fog =	"#200E4B",
	sky =	"#242455",
	cloud =	"#7C2352",
}

env(15) {
	sun =	"#444444",
	fog =	"#000000",
	sky =	"#10102b",
	cloud =	"#2A2835",
}

env(20) {
	sun =	"#444444",
	fog =	"#000000",
	sky =	"#202038",
	cloud =	"#2F2D3B",
}

env(22) {
	sun =	"#666666",
	fog =	"#cc4945",
	sky =	"#4a0495",
	cloud =	"#8a266e",
}

env(23) {
	sun =	"#ffffff",
	fog =	"#a9b5ff",
	sky =	"#5b6ee1",
	cloud =	"#ffffff",
}

env(24) (envcycle[0])

return envcycle